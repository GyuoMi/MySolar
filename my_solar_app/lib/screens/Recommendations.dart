import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:my_solar_app/models/logged_in_user.dart';
import 'package:my_solar_app/screens/devices.dart';
import '../../API\'s/LoadSheddingAPI.dart';



import '../cloud_functions/database/database_api.dart';
import '../cloud_functions/database/interfaces/database_functions_interface.dart';
import '../widgets/drawer.dart';
enum RecommendationType {
  UserRecommendations1,
  EnvironmentalRecommendations1,
  FinancialRecommendations1,
  AIRecommendations1,
  DeviceRecommendations1,
}

class Recommendation extends StatefulWidget {
  @override
  _RecommendationState createState() => _RecommendationState();
}

class _RecommendationState extends State<Recommendation> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  int userId = LoggedInUser.userId;
  late Map<dynamic, dynamic> totals;
  String jsonData = '';
  Map<String, dynamic>? data;
  List<dynamic> days = [];

  String _outputText = '';

  Future<void> getTotals() async {
    final databaseReturn = await database.calculateAllTimeTotals(
        LoggedInUser.getUserId()); // Get the weather info

    // When you have the weatherInfo, update the URL and trigger a UI update
    setState(() {
      totals = databaseReturn;
    });
    //  uiCalculations();
  }

  void _submitForm(RecommendationType selectedRecommendation) async {
    String name = _nameController.text;
    String age = _ageController.text;

    // Fetch recommendations based on the selected type
    Map<String, dynamic> recommendations = await AIRecommendations("abc");

    if (selectedRecommendation == RecommendationType.UserRecommendations1) {
      recommendations = await UserRecommendations(_nameController.text);
    } else if (selectedRecommendation ==
        RecommendationType.EnvironmentalRecommendations1) {
      recommendations = await EnvironmentalRecommendations();
    } else if (selectedRecommendation ==
        RecommendationType.FinancialRecommendations1) {
      recommendations = await FinancialRecommendations();
    } else
    if (selectedRecommendation == RecommendationType.AIRecommendations1) {
      recommendations = await AIRecommendations(_nameController.text);
    } else
    if (selectedRecommendation == RecommendationType.DeviceRecommendations1) {
      recommendations = await DeviceRecommendations();
    }

    setState(() {
      // Update _outputText with the recommendations
      _outputText = '';

      // Display recommendations in the _outputText
      recommendations.forEach((key, value) {
        _outputText += '$value\n';
      });
    });
  }


  @override
  void initState() {
    super.initState();
    getTotals();
    getTotals1();
    fetchData();
    getLoadshedding();
    // getWeatherIcon();

    // loadSheddingStatus = fetchLoadSheddingStatus();
  }

  Future<void> fetchData() async {
    //print("fetched data");
    final url = Uri.https('developer.sepush.co.za', '/business/2.0/area', {
      'id':
      'eskde-3-universityofthewitwatersrandresearchsiteandsportscityofjohannesburggauteng',
      'test': 'current'
    });
    final headers = {
      'Token': 'F294A5CF-965A40F4-A8515DE0-DA856EDD',
    };
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        setState(() {
          data = json.decode(response.body);
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error:$e');
    }
  }

  int loadSheddingStatus = 1000;
  LoadSheddingService service = LoadSheddingService();

  Future<int> fetchLoadSheddingStatus() async {
    // Fetch the load shedding status using your API service
    // Replace 'loadSheddingService' with your actual instance of the LoadSheddingService class

    return service.getStatus();
  }

  Future<void> getLoadshedding() async {
    final loadshedding =
    await fetchLoadSheddingStatus(); // Get the weather info

    // When you have the weatherInfo, update the URL and trigger a UI update
    setState(() {
      loadSheddingStatus = loadshedding - 1;
    });
  }


  List<dynamic> dayTimes(int stageNo, int dayNo) {
    List<dynamic> scheduleDays = data!['schedule']['days'];
    List<dynamic> times = [];
    int count = 0;
    for (var day in scheduleDays) {
      count += 1;
      if (dayNo == count) {
        List<dynamic> stages = day['stages'];
        var s_length = 0;
        if (dayNo == 0) {
          days.add(day['name'] + " - Today");
        } else {
          days.add(day['name'] + " - " + day['date']);
        }
        for (var stage in stages) {
          s_length += 1;
          if (s_length == stageNo) {
            for (var timeSlot in stage) {
              times.add(timeSlot);
            }
            //return times;
          }
        }
        break;
      }
    }
    return times;
  }

  Future<List<Device>> createDevicesList(int userId) async {
    // Step 1: Get a list of device IDs for the given userId
    final deviceIdsResponse = await devicePersistence.getUserDeviceIds(userId);

    // Step 2: Extract device IDs from the response
    var deviceIds = (deviceIdsResponse as List<dynamic>)
        .map((item) =>
    item[devicePersistence.deviceId] as int) // Extract device_id
        .toList();

    // Step 3: Initialize an empty list to store devices
    List<Device> devices = [];

    // Step 4: Loop through the device IDs and fetch device details for each ID
    for (var deviceId in deviceIds) {
      var deviceData = await devicePersistence.getDevice(deviceId);


      // Create a Device object from deviceData and add it to the list
      var device = Device(
        id: deviceData[0][devicePersistence.deviceId] as dynamic,
        name: deviceData[0][devicePersistence.deviceName] as String,
        usage: deviceData[0][devicePersistence.deviceUsage] as bool,
        wattage: deviceData[0][devicePersistence.deviceWattage] +
            0.0 as dynamic,
        voltage: deviceData[0][devicePersistence.deviceVoltage] +
            0.0 as dynamic,
        loadshedding: deviceData[0][devicePersistence
            .deviceLoadSheddingSetting] as bool,
        normal: deviceData[0][devicePersistence.deviceNormalSetting] as bool,
      );

      devices.add(device);
    }
    //  print(12);
    if (devices.isNotEmpty) {
      print(devices[0].name);
    }
    print(34);
    // Step 6: Return the list of devices
    return devices;
  }

  late Map<String, dynamic> allTimeTotal;
  late Map<String, dynamic> dailyTotal;
  late Map<String, dynamic> weeklyTotal;
  late Map<String, dynamic> monthlyTotal;
  late Map<String, dynamic> hourlyTotal;

  IDatabaseFunctions database = DatabaseApi();

  Future<void> getTotals1() async {
    final databaseReturnAll =
    await database.calculateAllTimeTotals(LoggedInUser.getUserId());
    final databaseReturnWeek =
    await database.calculateWeeklyTotals(LoggedInUser.getUserId());
    final databaseReturnMonth =
    await database.calculateMonthlyTotals(LoggedInUser.getUserId());
    final databaseReturnDay =
    await database.calculateDailyTotals(LoggedInUser.getUserId());
    //final databaseReturnHr = await database.getHourlyTotals(LoggedInUser.getUserId());
    // When you have the weatherInfo, update the URL and trigger a UI update
    setState(() {
      allTimeTotal = databaseReturnAll;
      dailyTotal = databaseReturnDay;
      weeklyTotal = databaseReturnWeek;
      monthlyTotal = databaseReturnMonth;
      //hourlyTotal=databaseReturnHr;
    });
    // roundChartData();
  }

  Future<Map<String, dynamic>> DeviceRecommendations() async {
    print(1);
    List<Device> _Devices = await createDevicesList(userId);
    print(_Devices[0].name);
    // dynamic id;
    // String name;
    // bool usage;
    // dynamic wattage;
    // dynamic voltage;
    // bool loadshedding;
    // bool normal;
    // Accessing the name of the first device
    String firstDeviceName = _Devices.isNotEmpty ? _Devices[0].name : '';
    //print(firstDeviceName);
    final random = Random();
    final randomNumber = 15 + random.nextInt(45 - 15 + 1);

    double solarT = allTimeTotal['total_solar'] / 1000;
    double gridT = allTimeTotal['total_grid'] / 1000;
    double calcT = gridT * (randomNumber / 100);
    gridT -= calcT;
    double batT = calcT;
    print(batT);
// Creating a list of device names
    //List<dynamic> _ids = _Devices.map((device) => device.id).toList();
    List<String> _names = _Devices.map((device) => device.name).toList();
    List<bool> _usages = _Devices.map((device) => device.usage).toList();
    List<dynamic> _wattages = _Devices.map((device) => device.wattage).toList();
    // List<dynamic> _voltages = _Devices.map((device) => device.voltage).toList();
    List<bool> _battery = _Devices.map((device) => device.loadshedding)
        .toList();
    List<bool> _normals = _Devices.map((device) => device.normal).toList();
    List<dynamic> firstDay = dayTimes(loadSheddingStatus, 1);
    String dayZero = days[0];
    print(days[0]);
    print(firstDay);
// Assuming Quest and Answ are defined somewhere in your code
    String prompt = 'I want suggestions on devices that can be switched from normal grid power to battery power supplied by solar panels. These are the lists: $_names,$_normals,$_battery,$_usages,$_wattages based on $batT, $solarT, $gridT. where $solarT is the amount of electricity the solor pannels create, $batT is the amount drawing from the battery, $gridT amount drawing from the grid.Assume battery percentage remaing is a random number between 30 and 70% based on these load shedding times and dates $dayZero and $firstDay. I only want you to return a A list of Names of devices that have been changed in the form [deviccename1, devicename2, devicenamen] and their best optimal times so solar can recharge.';

    final response = await sendChatGPTRequest(utf8.decode(utf8.encode(prompt)));
    print(response);
    final choices = response['choices'];
    if (choices != null && choices.isNotEmpty) {
      final completion = choices[0];
      final message = completion['message'];
      if (message != null && message['content'] != null) {
        final content = message['content'] as String;
        List<String> sentencesList = content.split('.');

        // Create a Map<String, dynamic> from the list of sentences
        Map<String, dynamic> sentences = {};

        for (int i = 0; i < sentencesList.length; i++) {
          sentences['sentence${i + 1}'] = sentencesList[i].trim() + '.';
        }

        return sentences;
      }
    }
    return {};
  }

  Future<Map<String, dynamic>> sendChatGPTRequest(String message) async {
    final String apiUrl = 'https://api.openai.com/v1/chat/completions';
    final apikey = 'sk-API KEY';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apikey',
        'Accept': 'application/json', // Add this line
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {'role': 'system', 'content': 'You are a helpful assistant.'},
          {'role': 'user', 'content': message},
        ],
        'max_tokens': 2000,
      }),
    );

    return jsonDecode(
        utf8.decode(response.bodyBytes)); // Decode response using utf8.decode
  }

  Future<Map<String, dynamic>> AIRecommendations(String Language) async {
    final response = await sendChatGPTRequest(utf8.decode(utf8.encode(
        'I want you to give  3 possible reasons for why switching from grid to solar is better, Aswell as 4 possible reasons and names of devices i can reduce in order to reduce the amount of power being used, and give 3 possible why swiching some devices to solar all the time may save more power and avoid loadshedding. I want the Output to be in the form of a list and thats all thats meant in the output. Only the output withput any headings')));

    final choices = response['choices'];
    if (choices != null && choices.isNotEmpty) {
      final completion = choices[0];
      final message = completion['message'];
      if (message != null && message['content'] != null) {
        final content = message['content'] as String;
        List<String> sentencesList = content.split('.');

        // Create a Map<String, dynamic> from the list of sentences
        Map<String, dynamic> sentences = {};

        for (int i = 0; i < sentencesList.length; i++) {
          sentences['sentence${i + 1}'] = sentencesList[i].trim() + '.';
        }

        return sentences;
      }
    }
    return {};
  }

  Future<Map<String, dynamic>> FinancialRecommendations() async {
    final response = await sendChatGPTRequest(utf8.decode(utf8.encode(
        'I want you to give  5 possible  financial benefits of using solar power, considering savings over time.Provide estimates on return on investment for solar installations.the financial benefits of using solar power, considering savings over time.•	Provide estimates on return on investment for solar installations.I want the Output to be in the form of a list and thats all thats meant in the output. Only the output withput any headings')));
    print(response);
    final choices = response['choices'];
    if (choices != null && choices.isNotEmpty) {
      final completion = choices[0];
      final message = completion['message'];
      if (message != null && message['content'] != null) {
        final content = message['content'] as String;
        List<String> sentencesList = content.split('.');

        // Create a Map<String, dynamic> from the list of sentences
        Map<String, dynamic> sentences = {};

        for (int i = 0; i < sentencesList.length; i++) {
          sentences['sentence${i + 1}'] = sentencesList[i].trim() + '.';
        }

        return sentences;
      }
    }
    return {};
  }

  Future<Map<String, dynamic>> EnvironmentalRecommendations() async {
    final response = await sendChatGPTRequest(utf8.decode(utf8.encode(
        'I want you to give  5 possible  Environmental benefits of using solar power, considering savings over time.Provide estimates on return on investment for solar installations.the financial benefits of using solar power, considering savings over time.•	Provide estimates on return on investment for solar installations.I want the Output to be in the form of a list and thats all thats meant in the output. Only the output withput any headings')));
    print(response);
    final choices = response['choices'];
    if (choices != null && choices.isNotEmpty) {
      final completion = choices[0];
      final message = completion['message'];
      if (message != null && message['content'] != null) {
        final content = message['content'] as String;
        List<String> sentencesList = content.split('.');

        // Create a Map<String, dynamic> from the list of sentences
        Map<String, dynamic> sentences = {};

        for (int i = 0; i < sentencesList.length; i++) {
          sentences['sentence${i + 1}'] = sentencesList[i].trim() + '.';
        }

        return sentences;
      }
    }
    return {};
  }

  Future<Map<String, dynamic>> UserRecommendations(String Language) async {
    final response = await sendChatGPTRequest(utf8.decode(utf8.encode(
        'Solar Power recommendation based on the given input()$Language. Only the output withput any headings')));
    print(response);
    final choices = response['choices'];
    if (choices != null && choices.isNotEmpty) {
      final completion = choices[0];
      final message = completion['message'];
      if (message != null && message['content'] != null) {
        final content = message['content'] as String;
        List<String> sentencesList = content.split('.');

        // Create a Map<String, dynamic> from the list of sentences
        Map<String, dynamic> sentences = {};

        for (int i = 0; i < sentencesList.length; i++) {
          sentences['sentence${i + 1}'] = sentencesList[i].trim() + '.';
        }

        return sentences;
      }
    }
    return {};
  }


  RecommendationType _selectedRecommendation = RecommendationType
      .UserRecommendations1;
  TextEditingController _name1Controller = TextEditingController();
  String _output1Text = '';

  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text('Recommendation '),
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButton<RecommendationType>(
                value: _selectedRecommendation,
                onChanged: (value) {
                  setState(() {
                    _selectedRecommendation = value!;
                  });
                },
                items: RecommendationType.values
                    .map<DropdownMenuItem<RecommendationType>>(
                      (type) =>
                      DropdownMenuItem<RecommendationType>(
                        value: type,
                        child: Text(type
                            .toString()
                            .split('.')
                            .last),
                      ),
                )
                    .toList(),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: _nameController,
                // ... rest of your text field code
              ),
              SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: () {
                  // Assuming _submitForm requires the selected recommendation type
                  _submitForm(_selectedRecommendation);
                },
                child: Text('Get Recomendations'),
              ),
              SizedBox(height: 8.0),
              Text(
                _outputText,
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              // Add some space between the existing button and the new one
              ElevatedButton(
                onPressed: () {
                  // Call a function or perform actions to implement the changes
                  //implementChanges();
                  Navigator.of(context).pushReplacementNamed('/devices');
                },
                child: Text('Review Devices'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class Device {
  dynamic id;
  String name;
  bool usage;
  dynamic wattage;
  dynamic voltage;
  bool loadshedding;
  bool normal;

  Device({
    required this.id,
    required this.name,
    required this.usage,
    required this.wattage,
    required this.voltage,
    required this.loadshedding,
    required this.normal,
  });
}
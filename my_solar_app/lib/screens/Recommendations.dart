import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:my_solar_app/models/logged_in_user.dart';
import 'package:my_solar_app/screens/devices.dart';

import '../cloud_functions/database/database_api.dart';
import '../cloud_functions/database/interfaces/database_functions_interface.dart';
class Recommendation extends StatefulWidget {
  @override
  _RecommendationState createState() => _RecommendationState();
}

class _RecommendationState extends State<Recommendation> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  int userId = LoggedInUser.userId;
  late Map<dynamic, dynamic> totals;

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

  void _submitForm() async {
    String name = _nameController.text;
    String age = _ageController.text;

    // Fetch AI recommendations
    Map<String, dynamic> recommendations = await DeviceRecommendations();

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
   // getWeatherIcon();

    // loadSheddingStatus = fetchLoadSheddingStatus();
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
        wattage: deviceData[0][devicePersistence.deviceWattage] + 0.0 as dynamic,
        voltage: deviceData[0][devicePersistence.deviceVoltage] + 0.0 as dynamic,
        loadshedding: deviceData[0][devicePersistence.deviceLoadSheddingSetting] as bool,
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
    List<bool> _battery = _Devices.map((device) => device.loadshedding).toList();
    List<bool> _normals = _Devices.map((device) => device.normal).toList();

// Assuming Quest and Answ are defined somewhere in your code
    String prompt = 'I want suggestions on devices that can be switched from normal grid power to battery power supplied by solar panels. These are the lists: $_names,$_normals,$_battery,$_usages,$_wattages based on $batT, $solarT, $gridT. where $solarT is the amount of electricity the solor pannels create, $batT is the amount drawing from the battery, $gridT amount drawing from the grid. I only want you to return a A list of Names of devices that have been changed in the form [deviccename1, devicename2, devicenamen]. Also print out the input varibles as well as $_names,$_normals,$_battery,$_usages,$_wattages';

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
    return{};
  }
  Future<Map<String, dynamic>> sendChatGPTRequest(String message) async {
    final String apiUrl = 'https://api.openai.com/v1/chat/completions';
    final apikey = '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';

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

    return jsonDecode(utf8.decode(response.bodyBytes)); // Decode response using utf8.decode
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
    return{};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recommendation '),
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _nameController,
                // ... rest of your text field code
              ),
              SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Implement these recommendations'),
              ),
              SizedBox(height: 8.0),
              Text(
                _outputText,
                style: TextStyle(fontSize: 16.0),
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
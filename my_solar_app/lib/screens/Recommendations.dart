import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:my_solar_app/models/logged_in_user.dart';
import 'package:my_solar_app/screens/devices.dart';
class Recommendation extends StatefulWidget {
  @override
  _RecommendationState createState() => _RecommendationState();
}

class _RecommendationState extends State<Recommendation> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  int userId = LoggedInUser.userId;

  String _outputText = '';

  void _submitForm() {
    String name = _nameController.text;
    String age = _ageController.text;

    setState(() {
      //   _outputText = 'Hello, $name! You are $age years old.';
    });
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
    print(12);
    if (devices.isNotEmpty) {
      print(devices[1].name);
    }
    print(34);
    // Step 6: Return the list of devices
    return devices;
  }
  Future<Map<String, dynamic>> sendChatGPTRequest(String message) async {
    final String apiUrl = 'https://api.openai.com/v1/chat/completions';
    final apikey = 'Your Api key';

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
        'max_tokens': 1000,
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
          title: Text('Reccommendation And Suggestion'),
        ),
        body:
        FutureBuilder<List<Device>>(
          future: createDevicesList(userId),
          builder: (BuildContext context, AsyncSnapshot<List<Device>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // If the Future is still running, show a loading indicator
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // If the Future throws an error, display the error message
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              // If the Future is complete and data is available, display the UI
              return Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _nameController,
                      // ... rest of your text field code
                    ),
                    SizedBox(height: 12.0),
                    ElevatedButton(
                      onPressed:  _submitForm,
                      child: Text('Implement these recommendations'),
                    ),
                    SizedBox(height: 24.0),
                    Text(
                      _outputText,
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ],
                ),
              );
            } else {
              // If there is no data, display a message indicating no devices found
              return Text('No devices found.');
            }
          },
        )
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
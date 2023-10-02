import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey; // Your WeatherAPI.com API key

  WeatherService(this.apiKey);

  Future<Map<String, dynamic>> getWeather(String location) async {
    final String apiUrl = 'https://api.weatherapi.com/v1/current.json';

    final response = await http.get(
      Uri.parse('$apiUrl?key=$apiKey&q=$location'),
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      final Map<String, dynamic> weatherData = jsonDecode(response.body);

      // Extract the desired information
      final double temperatureCelsius = weatherData['current']['temp_c'];
      final String conditionText = weatherData['current']['condition']['text'];
      final String conditionICON = weatherData['current']['condition']['icon'];
      final String conditioncode= weatherData['current']['condition']['code'];


      final int cloudCoverPercentage = weatherData['current']['cloud'];

      // Create a map to hold the extracted information
      final Map<String, dynamic> extractedInfo = {
        'Temperature in Celsius': temperatureCelsius,
        'Condition': conditionText,
        'Cloud Cover Percentage': cloudCoverPercentage,
        "ConditionICON": conditionICON,
        "conditioncode":conditioncode,
      };

      return extractedInfo;
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to fetch weather data');
    }
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoadSheddingService {
  final String baseUrl = 'https://loadshedding.eskom.co.za/LoadShedding';

  Future<int> getStatus() async {
    final response = await http.get(Uri.parse('$baseUrl/GetStatus'));
    if (response.statusCode == 200) {
      return int.tryParse(response.body) ?? 0;
    } else {
      throw Exception('Failed to fetch load shedding status');
    }
  }

  Future<List<Municipality>> getMunicipalities(int provinceId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/GetMunicipalities/?Id=$provinceId'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Municipality.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch municipalities');
    }
  }

  Future<List<Schedule>> getLoadSheddingSchedule(
      int suburbId, int stage, int provinceId, int municipalityTotal) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/GetScheduleM/$suburbId/$stage/$provinceId/$municipalityTotal'));
    if (response.statusCode == 200) {
      final List<String> data = response.body.split('\n');
      return Schedule.parse(data);
    } else {
      throw Exception('Failed to fetch load shedding schedule');
    }
  }
}

class Municipality {
  final bool selected;
  final String text;
  final String value;

  Municipality({required this.selected, required this.text, required this.value});

  factory Municipality.fromJson(Map<String, dynamic> json) {
    return Municipality(
      selected: json['Selected'] ?? false,
      text: json['Text'] ?? '',
      value: json['Value'] ?? '',
    );
  }
}

class Schedule {
  final String day;
  final List<String> times;

  Schedule({required this.day, required this.times});

  static List<Schedule> parse(List<String> data) {
    final List<Schedule> schedules = [];
    String currentDay = '';
    List<String> currentTimes = [];

    for (final line in data) {
      if (line.contains(',')) {
        if (currentDay.isNotEmpty) {
          schedules.add(Schedule(day: currentDay, times: currentTimes));
        }
        final parts = line.split(',');
        currentDay = parts[0].trim();
        currentTimes = [parts[1].trim()];
      } else {
        currentTimes.add(line.trim());
      }
    }

    if (currentDay.isNotEmpty) {
      schedules.add(Schedule(day: currentDay, times: currentTimes));
    }

    return schedules;
  }
}

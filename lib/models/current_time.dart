import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CurrentTime {
  // late String cityName;
  late String currentTime; // Replace with the desired city name
  // String currentTime = 'Fetching...';
  Future<String> fetchWeatherData(String cityName) async {
    final apiKey = 'f0ac2cbb0d79f7fda52aa06206617830';
    final url =
        'http://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      final currentTimeMillis = decodedData['dt'] * 1000;
      final currentTime =
          DateTime.fromMillisecondsSinceEpoch(currentTimeMillis);
      // print('ggg');
      // print(currentTime.toString());
      return currentTime.toString();
    } else {
      return Future.error('Error fetching data');
    }
  }
}

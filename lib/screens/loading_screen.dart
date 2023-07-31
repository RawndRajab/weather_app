import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app_assignment/screens/weather_screen.dart';
import 'package:weather_app_assignment/models/current_weather.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  LoadingScreenState createState() => LoadingScreenState();
}

class LoadingScreenState extends State<LoadingScreen> {
  Future<void> getWeatherDate() async {
    WeatherModel weatherInfo = WeatherModel();
    await weatherInfo.getCurrentLocationWeather();
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return WeatherScreen(
              weatherInfo: weatherInfo,
            );
          },
        ),
      );
    }
  }

  @override
  void initState() {
// TODO: implement initState
    super.initState();
    getWeatherDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/weather.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                backgroundColor: Color.fromARGB(255, 98, 195, 240),
                strokeWidth: 5,
                color: Color.fromARGB(255, 233, 225, 225),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

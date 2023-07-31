import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app_assignment/models/city_weather.dart';
import 'package:weather_app_assignment/models/current_time.dart';
import 'package:weather_app_assignment/models/current_weather.dart';
import '../services/network.dart';

class WeatherScreen extends StatefulWidget {
  final WeatherModel weatherInfo;
  const WeatherScreen({
    Key? key,
    required this.weatherInfo,
  }) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final cityModel wea = cityModel();
  TextEditingController cityname = TextEditingController();
  num temp = 0;
  int weatherId = 0;
  String cityName = "";
  String desc = "";
  String icon = "";
  var currentTime = "00:00";
  late Map<String, dynamic> weatherDataAboutCity;

  void update(var res) {
    if (res != null) {
      setState(() {
        temp = res['main']['temp'];
        weatherId = res['weather'][0]['id'];
        cityName = res['name'];
        desc = wea.getMessage(temp.toInt(), cityName);
        icon = wea.getWeatherIcon(weatherId);
        print("updatee");
        getTime();
      });
    }
  }

  Future<void> getTime() async {
    currentTime = await CurrentTime().fetchWeatherData(cityName);
    setState(() {
      currentTime = currentTime.substring(10, 16);
    });
    print("$currentTime currentTime");
  }

  @override
  void initState() {
    // TODO: implement initState
    temp = widget.weatherInfo.temp;
    weatherId = widget.weatherInfo.weatherId;
    cityName = widget.weatherInfo.cityName;
    getTime();
    desc = widget.weatherInfo.getMessage(cityName);
    icon = widget.weatherInfo.getWeatherIcon(weatherId);

    print("$currentTime currentTime init");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/weather.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 400),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              temp = widget.weatherInfo.temp;
                              weatherId = widget.weatherInfo.weatherId;
                              cityName = widget.weatherInfo.cityName;
                              getTime();
                              desc = widget.weatherInfo.getMessage(cityName);
                              icon =
                                  widget.weatherInfo.getWeatherIcon(weatherId);
                            });
                          },
                          child: const Icon(
                            Icons.near_me,
                            size: 32.0,
                            color: Color.fromARGB(255, 98, 195, 240),
                          ),
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        Expanded(
                          child: Text(
                            cityName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            currentTime,
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Color.fromARGB(255, 98, 195, 240),
                              fontSize: 24,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 45,
                    ),
                    const Center(
                      child: Text(
                        "Today's Weather",
                        style: TextStyle(
                          color: Color.fromARGB(255, 98, 195, 240),
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          temp.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        CustomPaint(
                          size: const Size(10, 10),
                          painter: CirclePainter(),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Text(
                          icon,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 45,
                    ),
                    Center(
                      child: Text(
                        desc,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    TextField(
                      controller: cityname,
                      onChanged: (value) {
                        cityName = value;
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Enter City Name',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (cityName != null) {
                          weatherDataAboutCity = await NetworkHelper(
                                  url:
                                      "https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=f0ac2cbb0d79f7fda52aa06206617830&units=metric")
                              .getDataByCityName(cityName);

                          setState(() {
                            update(weatherDataAboutCity);
                          });
                        }
                      },
                      child: const Center(
                        child: Text(
                          'Get City Weather',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }
}

class CirclePainter extends CustomPainter {
  final _paint = Paint()
    ..color = Colors.white
    ..strokeWidth = 3
    // Use [PaintingStyle.fill] if you want the circle to be filled.
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawOval(
      Rect.fromLTWH(0, 0, size.width, size.height),
      _paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

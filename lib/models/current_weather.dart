import 'package:weather_app_assignment/services/Location.dart';
import 'package:weather_app_assignment/services/network.dart';

class WeatherModel {
  late double temp;
  late int weatherId;
  late String cityName;

  Future<void> getCurrentLocationWeather() async {
    Location location = Location();
    await location.getCurrentLocation();
    Map<String, dynamic> weatherInfo = await NetworkHelper(
      url:
          'https://api.openweathermap.org/data/2.5/weather?lat=${location.lat}&lon=${location.long}&appid=f0ac2cbb0d79f7fda52aa06206617830&units=metric',
    ).getData(location.lat, location.long);

    temp = weatherInfo['main']['temp'];
    weatherId = weatherInfo['weather'][0]['id'];
    cityName = weatherInfo['name'];
  }

  String getWeatherIcon(weatherId) {
    if (weatherId < 300) {
      return '🌩';
    } else if (weatherId < 400) {
      return '🌧';
    } else if (weatherId < 600) {
      return '☔️';
    } else if (weatherId < 700) {
      return '☃️';
    } else if (weatherId < 800) {
      return '🌫';
    } else if (weatherId == 800) {
      return '☀️';
    } else if (weatherId <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(String cityName) {
    if (temp > 25) {
      return 'It\'s 🍦 time in $cityName';
    } else if (temp > 20) {
      return 'Time for shorts and 👕 in $cityName';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤 in $cityName';
    } else {
      return 'Bring a 🧥 in $cityName';
    }
  }
}

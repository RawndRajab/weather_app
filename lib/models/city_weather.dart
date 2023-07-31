import '../services/network.dart';
import '../services/Location.dart';

class cityModel {
  late num temp;
  late int weatherId;
  late String cityName;
  Future<void> getCurrentLocationWeatherByCityName(String cityName) async {
    Location location = Location();
    await location.getCurrentLocation();
    Map<String, dynamic> weatherInfoByCityName = await NetworkHelper(
            url:
                "https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=f0ac2cbb0d79f7fda52aa06206617830&units=metric")
        .getDataByCityName(cityName);
    temp = weatherInfoByCityName['main']['temp'];
    weatherId = weatherInfoByCityName['weather'][0]['id'];
    cityName = weatherInfoByCityName['name'];
  }

  String getWeatherIcon(int weatherId) {
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

  String getMessage(num temp, String cityName) {
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

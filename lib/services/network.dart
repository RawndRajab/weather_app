import 'dart:convert';

import 'package:http/http.dart' as http;

class NetworkHelper {
  final String url;

  NetworkHelper({required this.url});
  Future<Map<String, dynamic>> getData(double lat, double long) async {
    http.Response response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> currentWeather = jsonDecode(response.body);
      print(currentWeather['main']['temp']);
      return currentWeather;
    } else
      return Future.error('error');
  }

  Future<Map<String, dynamic>> getDataByCityName(String cityName) async {
    http.Response response = await http.get(
      Uri.parse(url),
    );
    if (response.statusCode == 200) {
      // print("getDataCityyyy====${response.body}");
      return jsonDecode(response.body);
    }
    return Future.error("Something wrong");
  }
}

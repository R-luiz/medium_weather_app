import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../models/weather_model.dart';

class WeatherService {
  // Replace with your API key from OpenWeatherMap
  static const String _apiKey = 'YOUR_OPENWEATHERMAP_API_KEY';
  static const String _baseUrl =
      'https://api.openweathermap.org/data/2.5/weather';

  // Get weather by city name
  Future<WeatherData> getWeatherByCity(String city) async {
    final response = await http.get(
      Uri.parse('$_baseUrl?q=$city&units=metric&appid=$_apiKey'),
    );

    if (response.statusCode == 200) {
      return WeatherData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data: ${response.statusCode}');
    }
  }

  // Get weather by current location
  Future<WeatherData> getWeatherByLocation() async {
    // Check and request location permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied');
      }
    }

    // Get current position
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Get weather data based on coordinates
    final response = await http.get(
      Uri.parse(
        '$_baseUrl?lat=${position.latitude}&lon=${position.longitude}&units=metric&appid=$_apiKey',
      ),
    );

    if (response.statusCode == 200) {
      return WeatherData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data: ${response.statusCode}');
    }
  }
}

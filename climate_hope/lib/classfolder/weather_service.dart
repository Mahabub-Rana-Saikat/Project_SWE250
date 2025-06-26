import 'package:shared_preferences/shared_preferences.dart'; 
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:climate_hope/classfolder/weather.dart';

class WeatherService {
  static const String _apiKey = 'f732afe13d05b405edcf79992ad0e1bc';
  static const String _baseUrl =
      'https://api.openweathermap.org/data/2.5/weather';
  static const String _cachedWeatherKey = 'cachedWeather';

  Future<Weather> getWeather(double latitude, double longitude) async {
    final uri = Uri.parse(
      '$_baseUrl?lat=$latitude&lon=$longitude&appid=$_apiKey&units=metric',
    );

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final weather = Weather.fromJson(jsonDecode(response.body));
        _cacheWeather(weather); 
        return weather;
      } else {
        throw Exception(
          'Failed to load weather: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching weather: $e');
    }
  }

  Future<Weather?> getCachedWeather() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString(_cachedWeatherKey);
    if (cachedData != null) {
      return Weather.fromJson(jsonDecode(cachedData));
    }
    return null;
  }

  Future<void> _cacheWeather(Weather weather) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cachedWeatherKey, jsonEncode(weather.toJson()));
  }

  String getWeatherIconUrl(String iconCode) {
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }
}

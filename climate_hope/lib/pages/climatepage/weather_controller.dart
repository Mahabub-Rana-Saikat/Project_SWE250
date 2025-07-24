import 'package:climate_hope/classfolder/weather_service.dart';
import 'package:climate_hope/classfolder/weather.dart';
import 'package:climate_hope/pages/climatepage/location_service.dart';

class WeatherController {
  final WeatherService _weatherService;
  final LocationService _locationService;

  WeatherController({
    required WeatherService weatherService,
    required LocationService locationService,
  })  : _weatherService = weatherService,
        _locationService = locationService;

  Future<Weather?> loadWeather() async {
    final cached = await _weatherService.getCachedWeather();
    if (cached != null) return cached;

    final position = await _locationService.getUserLocation();
    return await _weatherService.getWeather(position.latitude, position.longitude);
  }

  String getSuggestions(Weather weather) {
    final buffer = StringBuffer("Here are some general weather tips:\n\n");

    final temp = weather.temperature;
    final cond = weather.mainCondition.toLowerCase();
    final humidity = weather.humidity;
    final wind = weather.windSpeed;

    if (temp > 30) {
      buffer.writeln("☀️ It's very hot! Stay hydrated, avoid peak sun hours.");
    } else if (temp > 20) {
      buffer.writeln("🌡️ Warm and pleasant. Enjoy your day!");
    } else if (temp < 10) {
      buffer.writeln("🥶 Quite cold. Wear warm clothing.");
    } else {
      buffer.writeln("☁️ Mild temperature. A light jacket might help.");
    }

    if (cond.contains("rain") || cond.contains("drizzle")) {
      buffer.writeln("☔ Rainy. Carry an umbrella.");
    } else if (cond.contains("thunderstorm")) {
      buffer.writeln("⚡ Thunderstorms. Stay indoors.");
    } else if (cond.contains("snow")) {
      buffer.writeln("❄️ Snowing. Dress warm and waterproof.");
    } else if (cond.contains("clear") || cond.contains("sun")) {
      buffer.writeln("🌞 Clear skies. Wear sunscreen.");
    }

    if (humidity > 80) buffer.writeln("💧 High humidity. Stay hydrated.");
    if (humidity < 30) buffer.writeln("🌬️ Dry air. Use moisturizers.");
    if (wind > 10) buffer.writeln("💨 Windy. Secure outdoor items.");

    return buffer.toString();
  }
}

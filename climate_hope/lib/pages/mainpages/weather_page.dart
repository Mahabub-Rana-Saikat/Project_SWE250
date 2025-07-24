import 'package:climate_hope/classfolder/weather.dart';
import 'package:climate_hope/classfolder/weather_service.dart';
import 'package:climate_hope/pages/climatepage/location_service.dart';
import 'package:climate_hope/pages/climatepage/weather_controller.dart';
import 'package:climate_hope/pages/climatepage/weather_details_card.dart';
import 'package:climate_hope/pages/climatepage/weather_suggestion_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';


class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final controller = WeatherController(
    weatherService: WeatherService(),
    locationService: LocationService(),
  );

  Weather? _weather;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final weather = await controller.loadWeather();
      setState(() => _weather = weather);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  void _showSuggestions() {
    if (_weather == null) return;

    final text = controller.getSuggestions(_weather!);
    showDialog(
      context: context,
      builder: (_) => WeatherSuggestionDialog(suggestion: text),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Text(_error!, style: GoogleFonts.lato(color: Colors.red)),
        ),
      );
    }

    if (_weather == null) {
      return Scaffold(
        body: Center(
          child: Text('No weather data.', style: GoogleFonts.lato()),
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Text(_weather!.cityName, style: GoogleFonts.lato(fontSize: 42, color: Colors.black)),
            Text(DateFormat('EEEE, MMM d, h:mm a').format(DateTime.now())),
            Image.network(
              WeatherService().getWeatherIconUrl(_weather!.iconCode),
              height: 100,
              errorBuilder: (_, __, ___) => const Icon(Icons.cloud, size: 100),
            ),
            Text(_weather!.mainCondition, style: GoogleFonts.lato(fontSize: 24)),
            Text('${_weather!.temperature.round()}°C', style: GoogleFonts.lato(fontSize: 60)),
            Text('Feels like ${_weather!.feelsLike.round()}°C'),
            const SizedBox(height: 20),
            WeatherDetailsCard(
              humidity: _weather!.humidity,
              wind: _weather!.windSpeed,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _showSuggestions,
              icon: const Icon(Icons.tips_and_updates),
              label: const Text("Get Weather Suggestions"),
            ),
          ],
        ),
      ),
    );
  }
}

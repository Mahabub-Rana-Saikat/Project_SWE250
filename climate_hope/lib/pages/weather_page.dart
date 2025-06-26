import 'package:climate_hope/classfolder/weather.dart';
import 'package:climate_hope/classfolder/weather_service.dart';
import 'package:climate_hope/widget/build_detail_column.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final WeatherService _weatherService = WeatherService();
  Weather? _weather;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final cachedWeather = await _weatherService.getCachedWeather();
    if (mounted && cachedWeather != null) {
      setState(() {
        _weather = cachedWeather;
        _isLoading = false;
      });
    }

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!mounted) return;

      if (!serviceEnabled) {
        throw Exception('Location services are disabled. Please enable them.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (!mounted) return;

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (!mounted) return;
        if (permission == LocationPermission.denied) {
          throw Exception(
            'Location permissions are denied. Please grant permission in settings.',
          );
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception(
          'Location permissions are permanently denied. We cannot request permissions.',
        );
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      if (!mounted) return;

      final weather = await _weatherService.getWeather(
        position.latitude,
        position.longitude,
      );
      if (!mounted) return;

      setState(() {
        _weather = weather;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Failed to get weather: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Weather Report",
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 62, 218, 134),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadWeather,
          ),
        ],
      ),

      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/signin_img.png'),
            fit: BoxFit.cover,
          ),
        ),
        child:
            _isLoading && _weather == null
                ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                : _errorMessage != null
                ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 50,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: _loadWeather,
                          icon: const Icon(
                            Icons.refresh,
                            color: Color.fromARGB(255, 1, 39, 2),
                          ),
                          label: Text(
                            'Try Again',
                            style: GoogleFonts.lato(
                              color: Color.fromARGB(255, 1, 39, 2),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                : _weather == null
                ? Center(
                  child: Text(
                    "No weather data available.",
                    style: GoogleFonts.lato(color: Colors.white, fontSize: 18),
                  ),
                )
                : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30),
                        Text(
                          _weather!.cityName,
                          style: GoogleFonts.lato(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 5.0,
                                color: Colors.black,
                                offset: const Offset(2.0, 2.0),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          DateFormat(
                            'EEEE, MMM d, h:mm a',
                          ).format(DateTime.now()),
                          style: GoogleFonts.lato(
                            fontSize: 18,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 30),
                        // Weather Icon
                        Image.network(
                          _weatherService.getWeatherIconUrl(_weather!.iconCode),
                          height: 120,
                          width: 120,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.cloud,
                              size: 120,
                              color: Colors.white,
                            );
                          },
                        ),
                        Text(
                          _weather!.mainCondition,
                          style: GoogleFonts.lato(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          '${_weather!.temperature.round()}°C',
                          style: GoogleFonts.lato(
                            fontSize: 80,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.black,
                                offset: const Offset(3.0, 3.0),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'Feels like: ${_weather!.feelsLike.round()}°C',
                          style: GoogleFonts.lato(
                            fontSize: 18,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.white),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              buildDetailColumn(
                                Icons.opacity,
                                '${_weather!.humidity}%',
                                'Humidity',
                              ),
                              buildDetailColumn(
                                Icons.speed,
                                '${_weather!.windSpeed} m/s',
                                'Wind',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

// --- Weather Data Model ---
class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;
  final String iconCode;
  final double feelsLike;
  final int humidity;
  final double windSpeed;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
    required this.iconCode,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: (json['main']['temp'] as num).toDouble(),
      mainCondition: json['weather'][0]['main'],
      iconCode: json['weather'][0]['icon'],
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      humidity: json['main']['humidity'],
      windSpeed: (json['wind']['speed'] as num).toDouble(),
    );
  }
}

class WeatherService {

  static const String _apiKey = 'f732afe13d05b405edcf79992ad0e1bc';
  static const String _baseUrl =
      'https://api.openweathermap.org/data/2.5/weather';

  Future<Weather> getWeather(double latitude, double longitude) async {
    final uri = Uri.parse(
      '$_baseUrl?lat=$latitude&lon=$longitude&appid=$_apiKey&units=metric',
    );

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return Weather.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          'Failed to load weather: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching weather: $e');
    }
  }

 
  String getWeatherIconUrl(String iconCode) {
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }
}

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
    _getCurrentLocationAndWeather();
  }

  Future<void> _getCurrentLocationAndWeather() async {
    // Initial setState is safe because initState guarantees mounted.
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!mounted) return; // Crucial check after an async operation

      if (!serviceEnabled) {
        throw Exception('Location services are disabled. Please enable them.');
      }

      // Request location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (!mounted) return; // Crucial check after an async operation

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (!mounted) return; // Crucial check after an async operation
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

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      if (!mounted) return; // Crucial check after an async operation

      // Fetch weather data using coordinates
      final weather = await _weatherService.getWeather(
        position.latitude,
        position.longitude,
      );
      if (!mounted) return; // Crucial check after an async operation

      setState(() {
        _weather = weather;
      });
    } catch (e) {
      if (!mounted) return; // Crucial check before setState in catch
      setState(() {
        _errorMessage = 'Failed to get weather: ${e.toString()}';
      });
    } finally {
      if (mounted) { // Crucial check before setState in finally
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
            onPressed: _getCurrentLocationAndWeather, // Refresh weather on tap
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 120, 230, 180), // Lighter green
              Color.fromARGB(255, 62, 218, 134), // Main green
              Color.fromARGB(255, 1, 89, 46), // Darker green
            ],
          ),
        ),
        child:
            _isLoading
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
                          const Icon(Icons.error_outline, color: Colors.red, size: 50),
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
                            onPressed: _getCurrentLocationAndWeather,
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
                              border: Border.all(
                                color: Colors.white,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildDetailColumn(
                                  Icons.opacity,
                                  '${_weather!.humidity}%',
                                  'Humidity',
                                ),
                                _buildDetailColumn(
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

  // Helper method for building weather detail columns
  Widget _buildDetailColumn(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 30),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.lato(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.lato(fontSize: 14, color: Colors.white70),
        ),
      ],
    );
  }
}
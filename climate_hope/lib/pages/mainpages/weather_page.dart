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

  
  void _getWeatherSuggestions() {
    if (_weather == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No weather data to provide suggestions.')),
      );
      return;
    }

    String suggestion = "Here are some general weather tips:\n\n";

    final tempCelsius = _weather!.temperature;
    final condition = _weather!.mainCondition.toLowerCase();
    final humidity = _weather!.humidity;
    final windSpeed = _weather!.windSpeed; 

   
    if (tempCelsius > 30) {
      suggestion += "☀️ It's very hot! Stay hydrated, seek shade, and avoid strenuous outdoor activities during peak heat hours.\n";
    } else if (tempCelsius > 20) {
      suggestion += "🌡️ The weather is warm and pleasant. Enjoy your day! Don't forget sunscreen if you're going out.\n";
    } else if (tempCelsius < 10) {
      suggestion += "🥶 It's quite cold! Dress in layers, wear warm clothing, and consider staying indoors if possible.\n";
    } else {
      suggestion += "☁️ The temperature is mild. A light jacket might be comfortable.\n";
    }

    
    if (condition.contains('rain') || condition.contains('drizzle')) {
      suggestion += "☔ Rain is expected! Carry an umbrella or raincoat and be mindful of slippery surfaces.\n";
    } else if (condition.contains('thunderstorm')) {
      suggestion += "⚡ Thunderstorms are active! Stay indoors, avoid open fields and tall objects.\n";
    } else if (condition.contains('snow')) {
      suggestion += "❄️ Snow is falling! Wear warm, waterproof clothing and be careful on slippery roads.\n";
    } else if (condition.contains('clear') || condition.contains('sun')) {
      suggestion += "🌞 Clear skies! Great day for outdoor activities. Remember your sunglasses!\n";
    } else if (condition.contains('cloud') || condition.contains('overcast')) {
      suggestion += "☁️ Cloudy skies. Perfect weather for a comfortable walk.\n";
    } else if (condition.contains('fog') || condition.contains('mist')) {
      suggestion += "🌫️ Foggy conditions. Drive carefully and use low beam headlights.\n";
    }

    
    if (humidity > 80) {
      suggestion += "💧 High humidity might make it feel muggier. Stay cool and drink plenty of fluids.\n";
    } else if (humidity < 30) {
      suggestion += "🌬️ Low humidity. Keep yourself moisturized.\n";
    }

    if (windSpeed > 10) { 
      suggestion += "💨 It's windy outside! Secure loose objects and be cautious if driving high-sided vehicles.\n";
    }

    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Colors.green.shade50,
          title: Text(
            "Weather-Based Suggestions",
            style: GoogleFonts.lato(
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 1, 39, 2),
            ),
          ),
          content: SingleChildScrollView(
            child: Text(
              suggestion,
              style: GoogleFonts.lato(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Got it!",
                style: GoogleFonts.lato(
                  color: const Color.fromARGB(255, 1, 39, 2),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/signin_img.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: _isLoading && _weather == null
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

                              // NEW: AI-based suggestions button
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton.icon(
                                  onPressed: _isLoading ? null : _getWeatherSuggestions,
                                  icon: const Icon(
                                    Icons.tips_and_updates,
                                    color: Color.fromARGB(255, 1, 39, 2),
                                  ),
                                  label: Text(
                                    'Get Weather Suggestions',
                                    style: GoogleFonts.lato(
                                      color: const Color.fromARGB(255, 1, 39, 2),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      side: const BorderSide(
                                        color: Colors.black,
                                        width: 1.5,
                                      ),
                                    ),
                                    elevation: 2,
                                    shadowColor: Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20), // Add some space below the button
                            ],
                          ),
                        ),
                      ),
      ),
    );
  }
}
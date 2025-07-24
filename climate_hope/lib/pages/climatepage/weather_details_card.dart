import 'package:flutter/material.dart';
import 'package:climate_hope/widget/build_detail_column.dart';

class WeatherDetailsCard extends StatelessWidget {
  final int humidity;
  final double wind;

  const WeatherDetailsCard({super.key, required this.humidity, required this.wind});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildDetailColumn(Icons.opacity, '$humidity%', 'Humidity'),
          buildDetailColumn(Icons.speed, '$wind m/s', 'Wind'),
        ],
      ),
    );
  }
}

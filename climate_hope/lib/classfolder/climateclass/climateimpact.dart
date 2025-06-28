import 'package:flutter/material.dart';
class ClimateImpactCategory {
  final String id;
  final String title;
  final String description;
  final IconData icon; 
  final String? learnMoreUrl;

  ClimateImpactCategory({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.learnMoreUrl,
  });

  factory ClimateImpactCategory.fromJson(Map<String, dynamic> json) {
    return ClimateImpactCategory(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      icon: _getIconData(json['iconName']), 
      learnMoreUrl: json['learnMoreUrl'],
    );
  }

  
  static IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'thermostat': return Icons.thermostat;
      case 'water_level': return Icons.water_drop; 
      case 'thunderstorm': return Icons.thunderstorm;
      case 'forest': return Icons.forest;
      case 'science': return Icons.science;
      case 'public_health': return Icons.public_outlined;
      default: return Icons.info_outline;
    }
  }
}
import 'package:climate_hope/authpages/signin.dart';
import 'package:climate_hope/pages/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:climate_hope/pages/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

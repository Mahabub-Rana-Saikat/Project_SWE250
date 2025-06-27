import 'package:flutter/material.dart';
import 'screens/falling_item_game.dart';

class EcoGameApp extends StatelessWidget {
  const EcoGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Eco Catcher Game",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: Color(0xFF04180A),
        ),
        body: const FallingItemGame(),
      ),
    );
  }
}

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

          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {

              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
              }
            },
          ),
          title: const Text(
            "Eco Catcher Game",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color(0xFF04180A),
        ),
        body: const FallingItemGame(),
      ),
    );
  }
}
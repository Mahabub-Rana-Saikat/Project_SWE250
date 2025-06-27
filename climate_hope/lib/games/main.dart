import 'package:flutter/material.dart';
import 'screens/falling_item_game.dart';

void main() => runApp(const EcoGameApp());

class EcoGameApp extends StatelessWidget {
  const EcoGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eco Catcher Game',
      debugShowCheckedModeBanner: false,
      home: const FallingItemGame(),
    );
  }
}
import 'package:flutter/material.dart';
import '../models/game_item.dart';

class GameObject extends StatelessWidget {
  final GameItem item;
  final bool colorless;

  const GameObject({Key? key, required this.item, this.colorless = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildItemWidget();
  }

  Widget _buildItemWidget() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: colorless ? Colors.grey.shade300 : (item.isGood ? Colors.green : Colors.red),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        item.name,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
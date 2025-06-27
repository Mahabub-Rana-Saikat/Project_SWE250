import 'dart:math';
import 'package:flutter/material.dart';
import '../models/game_item.dart';
import '../data/items.dart';

class FallingItemGame extends StatefulWidget {
  const FallingItemGame({Key? key}) : super(key: key);

  @override
  State<FallingItemGame> createState() => _FallingItemGameState();
}

class _FallingItemGameState extends State<FallingItemGame> {
  final List<GameItem> gameItems = items; // from items.dart

  late GameItem currentItem;
  int score = 0;
  final Random random = Random();

  bool isBoxHighlighted = false;
  bool isDustbinHighlighted = false;

  @override
  void initState() {
    super.initState();
    spawnNewItem();
  }

  void spawnNewItem() {
    if (gameItems.isEmpty) {
      print('Error: items list is empty!');
      return;
    }
    setState(() {
      currentItem = gameItems[random.nextInt(gameItems.length)];
      print('Spawned new item: ${currentItem.name}');
    });
  }

  void handleDrop(GameItem droppedItem, bool isBox) {
    bool correct = (isBox && droppedItem.isGood) || (!isBox && !droppedItem.isGood);
    setState(() {
      score += correct ? 1 : -1;
      // Reset highlights after drop
      isBoxHighlighted = false;
      isDustbinHighlighted = false;
    });
    spawnNewItem();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Eco Catcher Game')),
      body: Stack(
        children: [
          // Score display at top-left
          Positioned(
            top: 16,
            left: 16,
            child: Text('Score: $score', style: const TextStyle(fontSize: 24)),
          ),

          // Draggable item at the top center
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Draggable<GameItem>(
                data: currentItem,
                feedback: Material(
                  color: Colors.transparent,
                  child: Transform.scale(
                    scale: 1.2,
                    child: _buildItem(currentItem, shadow: true),
                  ),
                ),
                childWhenDragging: const SizedBox(),
                child: _buildItem(currentItem),
              ),
            ),
          ),

          // Left target (Box)
          Align(
            alignment: Alignment.bottomLeft,
            child: DragTarget<GameItem>(
              builder: (context, candidateData, rejectedData) => _buildTarget(
                'Box',
                Colors.green,
                isHighlighted: isBoxHighlighted,
              ),
              onWillAccept: (item) {
                setState(() {
                  isBoxHighlighted = true;
                });
                return true;
              },
              onLeave: (item) {
                setState(() {
                  isBoxHighlighted = false;
                });
              },
              onAccept: (droppedItem) => handleDrop(droppedItem, true),
            ),
          ),

          // Right target (Dustbin)
          Align(
            alignment: Alignment.bottomRight,
            child: DragTarget<GameItem>(
              builder: (context, candidateData, rejectedData) => _buildTarget(
                'Dustbin',
                Colors.red,
                isHighlighted: isDustbinHighlighted,
              ),
              onWillAccept: (item) {
                setState(() {
                  isDustbinHighlighted = true;
                });
                return true;
              },
              onLeave: (item) {
                setState(() {
                  isDustbinHighlighted = false;
                });
              },
              onAccept: (droppedItem) => handleDrop(droppedItem, false),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(GameItem item, {bool shadow = false}) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: item.isGood ? Colors.green : Colors.red,
        shape: BoxShape.circle,
        boxShadow: shadow
            ? [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ]
            : null,
      ),
      alignment: Alignment.center,
      child: Text(
        item.name,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTarget(String label, Color color, {bool isHighlighted = false}) {
    return Container(
      margin: const EdgeInsets.all(32),
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: isHighlighted ? color.withOpacity(0.7) : color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isHighlighted
            ? [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 12,
            offset: Offset(0, 6),
          )
        ]
            : null,
      ),
      alignment: Alignment.center,
      child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
    );
  }
}
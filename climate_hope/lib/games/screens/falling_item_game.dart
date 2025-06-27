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
  final List<GameItem> gameItems = items;

  late GameItem currentItem;
  int score = 0;
  final Random random = Random();
 
 //Initial phase //

  bool isRecycleBinHighlighted = false;
  bool isTrashBinHighlighted = false;

  @override
  void initState() {
    super.initState();
    spawnNewItem();
  }

  void spawnNewItem() {
    if (gameItems.isEmpty) {
      return;
    }
    setState(() {
      currentItem = gameItems[random.nextInt(gameItems.length)];
    });
  }

  void handleDrop(GameItem droppedItem, bool isRecycleBin) {
    bool correct = (isRecycleBin && droppedItem.isGood) || (!isRecycleBin && !droppedItem.isGood);
    setState(() {
      score += correct ? 5 : -10;
      isRecycleBinHighlighted = false;
      isTrashBinHighlighted = false;
    });
    spawnNewItem();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eco Catcher Game', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 3, 45, 25),
        elevation: 0, 
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal, Colors.lightGreen],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 30, 
              left: 20, 
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white, 
                  borderRadius: BorderRadius.circular(20), 
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 14, 62, 18), 
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  'Score: $score', 
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal, 
                  ),
                ),
              ),
            ),

           
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
                  childWhenDragging: const SizedBox(width: 80, height: 80), 
                  child: _buildItem(currentItem), 
                ),
              ),
            ),

           
            Align(
              alignment: Alignment.bottomLeft,
              child: DragTarget<GameItem>(
                builder: (context, candidateData, rejectedData) => _buildTarget(
                  '♻️', 
                  'Recycle', 
                  Colors.green.shade700, 
                  isHighlighted: isRecycleBinHighlighted, 
                ),
                onWillAccept: (item) {
                  setState(() {
                    isRecycleBinHighlighted = true; 
                  });
                  return true; 
                },
                onLeave: (item) {
                  setState(() {
                    isRecycleBinHighlighted = false; 
                  });
                },
                onAccept: (droppedItem) => handleDrop(droppedItem, true), 
              ),
            ),

           
            Align(
              alignment: Alignment.bottomRight,
              child: DragTarget<GameItem>(
                builder: (context, candidateData, rejectedData) => _buildTarget(
                  '🗑️', 
                  'Trash', 
                  Colors.red.shade700, 
                  isHighlighted: isTrashBinHighlighted, 
                ),
                onWillAccept: (item) {
                  
                  setState(() {
                    isTrashBinHighlighted = true; 
                  });
                  return true;
                },
                onLeave: (item) {
                 
                  setState(() {
                    isTrashBinHighlighted = false; 
                  });
                },
                onAccept: (droppedItem) => handleDrop(droppedItem, false), 
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildItem(GameItem item, {bool shadow = false}) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: item.isGood ? Colors.lightGreenAccent : Colors.deepOrangeAccent, 
        shape: BoxShape.circle, 
        boxShadow: shadow
            ? [
                BoxShadow(
                  color: Colors.black, 
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                )
              ]
            : [], 
        border: Border.all(
          color: item.isGood ? Colors.green.shade800 : Colors.red.shade800, 
          width: 3,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        item.name,
        style: const TextStyle(
          fontSize: 40, 
          color: Colors.black87, 
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }


  Widget _buildTarget(String icon, String label, Color color, {bool isHighlighted = false}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 100.0, left: 32.0, right: 32.0), 
      width: isHighlighted ? 120 : 100, 
      height: isHighlighted ? 120 : 100,
      decoration: BoxDecoration(
        border: Border.all(
          color: isHighlighted ? Colors.white : color, 
          width: isHighlighted ? 4 : 2, 
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black, 
            blurRadius: isHighlighted ? 15 : 8,
            offset: Offset(0, isHighlighted ? 8 : 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, 
        children: [
          Text(
            icon, 
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
          const SizedBox(height: 4), 
          Text(
            label, 
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
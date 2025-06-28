import 'dart:async'; // Import for Timer
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

  // Game state variables
  bool isRecycleBinHighlighted = false;
  bool isTrashBinHighlighted = false;
  bool gameEnded = false;
  Timer? gameTimer;
  int timeLeft = 60; // 1 minute in seconds

  @override
  void initState() {
    super.initState();
    spawnNewItem();
    startGameTimer();
  }

  @override
  void dispose() {
    gameTimer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  void startGameTimer() {
    gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft > 0 && !gameEnded) {
        setState(() {
          timeLeft--;
        });
      } else {
        endGame(false); // Game ends when time runs out
      }
    });
  }

  void spawnNewItem() {
    if (gameItems.isEmpty || gameEnded) {
      return;
    }
    setState(() {
      currentItem = gameItems[random.nextInt(gameItems.length)];
    });
  }

  void handleDrop(GameItem droppedItem, bool isRecycleBin) {
    if (gameEnded) return; // Prevent interaction after game ends

    bool correct =
        (isRecycleBin && droppedItem.isGood) || (!isRecycleBin && !droppedItem.isGood);
    setState(() {
      score += correct ? 5 : -10;
      isRecycleBinHighlighted = false;
      isTrashBinHighlighted = false;
    });

    if (score >= 30) {
      endGame(true); // Game ends with a win
    } else {
      spawnNewItem();
    }
  }

  void endGame(bool won) {
    setState(() {
      gameEnded = true;
    });
    gameTimer?.cancel(); // Stop the timer

    String message = won ? 'Congratulations! You reached 30 points!' : 'Time\'s up! Game Over.';
    Color bgColor = won ? Colors.green : Colors.red;
    String title = won ? 'Victory!' : 'Game Over!';

    // Show a dialog to display the game result
    showDialog(
      context: context,
      barrierDismissible: false, // User must tap button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: TextStyle(color: bgColor)),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Play Again'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss dialog
                resetGame();
              },
            ),
          ],
        );
      },
    );
  }

  void resetGame() {
    setState(() {
      score = 0;
      timeLeft = 60;
      gameEnded = false;
      isRecycleBinHighlighted = false;
      isTrashBinHighlighted = false;
    });
    spawnNewItem();
    startGameTimer(); // Restart the timer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            // Score Display
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

            // Timer Display
            Positioned(
              top: 30,
              right: 20,
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
                  'Time: ${timeLeft ~/ 60}:${(timeLeft % 60).toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
            ),

            // Draggable Item
            if (!gameEnded) // Only show the draggable item if the game hasn't ended
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

            // Recycle Bin Target
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
                  if (gameEnded) return false;
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

            // Trash Bin Target
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
                  if (gameEnded) return false;
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

  Widget _buildTarget(String icon, String label, Color color,
      {bool isHighlighted = false}) {
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
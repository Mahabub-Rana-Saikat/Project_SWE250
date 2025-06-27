import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import '../models/game_item.dart';

class SlowCatchGame extends StatefulWidget {
  const SlowCatchGame({Key? key}) : super(key: key);

  @override
  State<SlowCatchGame> createState() => _SlowCatchGameState();
}

class _SlowCatchGameState extends State<SlowCatchGame> {
  final List<GameItem> items = [
    GameItem(name: 'Tree', isGood: true),
    GameItem(name: 'Factory', isGood: false),
    GameItem(name: 'Clean Road', isGood: true),
    GameItem(name: 'Oil Spill', isGood: false),
  ];

  GameItem? currentItem;
  double itemY = 0;
  late Timer fallTimer;
  late Timer pauseTimer;
  int score = 0;
  final double middleY = 0.5; // Middle of screen in percentage
  final int pauseSeconds = 5;

  bool isPaused = false;
  int pauseCountdown = 5;

  final Random random = Random();

  @override
  void initState() {
    super.initState();
    startNextItem();
  }

  void startNextItem() {
    setState(() {
      currentItem = items[random.nextInt(items.length)];
      itemY = 0;
      isPaused = false;
      pauseCountdown = pauseSeconds;
    });

    fallTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!isPaused) {
        setState(() {
          itemY += 0.01;
          if (itemY >= middleY) {
            isPaused = true;
            pauseTimer = Timer.periodic(const Duration(seconds: 1), (ptimer) {
              setState(() {
                pauseCountdown--;
                if (pauseCountdown <= 0) {
                  ptimer.cancel();
                  fallTimer.cancel();
                  score--; // penalty for no answer
                  startNextItem();
                }
              });
            });
          }
        });
      }
    });
  }

  void answer(bool pickedBox) {
    if (!isPaused) return; // ignore taps unless paused
    fallTimer.cancel();
    pauseTimer.cancel();

    bool correct = (pickedBox && currentItem!.isGood) || (!pickedBox && !currentItem!.isGood);

    setState(() {
      score += correct ? 1 : -1;
    });

    startNextItem();
  }

  @override
  void dispose() {
    fallTimer.cancel();
    if (pauseTimer.isActive) pauseTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: const Text('Slow Catch Game')),
      body: Stack(
        children: [
          // Falling item
          if (currentItem != null)
            Positioned(
              top: itemY * screenHeight,
              left: MediaQuery.of(context).size.width / 2 - 30,
              child: _buildItemWidget(currentItem!),
            ),

          // Box (fixed left)
          Positioned(
            bottom: 40,
            left: 50,
            child: GestureDetector(
              onTap: () => answer(true),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: const Text('Box', style: TextStyle(color: Colors.white, fontSize: 24)),
              ),
            ),
          ),

          // Dustbin (fixed right)
          Positioned(
            bottom: 40,
            right: 50,
            child: GestureDetector(
              onTap: () => answer(false),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: const Text('Dustbin', style: TextStyle(color: Colors.white, fontSize: 24)),
              ),
            ),
          ),

          // Score display
          Positioned(
            top: 20,
            left: 20,
            child: Text('Score: $score', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),

          // Countdown timer display
          if (isPaused)
            Positioned(
              top: itemY * screenHeight + 70,
              left: MediaQuery.of(context).size.width / 2 - 10,
              child: Text(
                '$pauseCountdown',
                style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildItemWidget(GameItem item) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: item.isGood ? Colors.green : Colors.red,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        item.name,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
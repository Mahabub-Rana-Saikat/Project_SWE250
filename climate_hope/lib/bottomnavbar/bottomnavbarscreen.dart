import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final Function(int) onTap;
  final int selectedIndex;

  const BottomNavBar({
    super.key,
    required this.onTap,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF041305),
      selectedItemColor: Colors.white,
      unselectedItemColor: const Color.fromARGB(255, 86, 175, 9),
      type: BottomNavigationBarType.fixed,
      currentIndex: selectedIndex,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.public),
          label: 'GC Hub',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.health_and_safety_outlined),
          label: 'Weather',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.monitor_heart),
          label: 'Climate',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'profile',
        ),
      ],
      onTap: onTap,
    );
  }
}

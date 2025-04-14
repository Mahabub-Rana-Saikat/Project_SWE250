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
      backgroundColor: Colors.teal,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.tealAccent,
      type: BottomNavigationBarType.fixed,
      currentIndex: selectedIndex,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
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
      ],
      onTap: onTap,
    );
  }
}

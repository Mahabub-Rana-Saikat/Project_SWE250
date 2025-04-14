import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/search_page.dart';
import '../pages/gc_hub_page.dart';
import '../pages/weather_page.dart';
import '../pages/climate_page.dart';
import '../pages/quick_access_page.dart';
import 'package:climate_hope/bottomnavbar/bottomnavbarscreen.dart';



class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    HomePage(),
    SearchPage(),
    GCHubPage(),
    WeatherPage(),
    ClimatePage(),
  ];


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(getPageIcon(_selectedIndex), size: 28),
            const SizedBox(width: 8),
            Text(getTitle(_selectedIndex)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const QuickAccessPage()),
              );
            },
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        children: _pages,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  String getTitle(int index) {
    switch (index) {
      case 0:
        return "Home Page";
      case 1:
        return "Search Page";
      case 2:
        return "Global Climate Hub";
      case 3:
        return "Weather Watch";
      case 4:
        return "Climate Champion";
      default:
        return "Home Page";
    }
  }

  IconData getPageIcon(int index) {
    switch (index) {
      case 0:
        return Icons.home;
      case 1:
        return Icons.search;
      case 2:
        return Icons.public;
      case 3:
        return Icons.cloud;
      case 4:
        return Icons.eco;
      default:
        return Icons.home;
    }
  }
}

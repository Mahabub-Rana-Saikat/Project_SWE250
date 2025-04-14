import 'package:flutter/material.dart';

class GCHubPage extends StatelessWidget {
  const GCHubPage({super.key});


  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> options = [
      {"title": "Resources", "icon": Icons.menu_book, "route": "/resources"},
      {"title": "Initiatives", "icon": Icons.handshake, "route": "/initiatives"},
      {"title": "Impact", "icon": Icons.eco, "route": "/impact"},
      {"title": "Overview", "icon": Icons.dashboard, "route": "/overview"},
      {"title": "Map", "icon": Icons.map, "route": "/map"},
      {"title": "News", "icon": Icons.article, "route": "/news"},
    ];



    return Scaffold(
      appBar: AppBar(
        title: const Text("Explore"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 columns
            childAspectRatio: 1.2, // Adjusts box size
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: options.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("${options[index]['title']} Clicked")),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(options[index]['icon'], size: 50, color: Colors.teal),
                    const SizedBox(height: 10),
                    Text(
                      options[index]['title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

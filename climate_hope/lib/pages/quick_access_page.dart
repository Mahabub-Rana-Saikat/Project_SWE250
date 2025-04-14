import 'package:flutter/material.dart';

class QuickAccessPage extends StatelessWidget {
  const QuickAccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> quickAccessOptions = [
      {"title": "Volunteer Opportunities", "icon": Icons.volunteer_activism},
      {"title": "Problems", "icon": Icons.report_problem},
      {"title": "Climate Solutions", "icon": Icons.solar_power},
      {"title": "Recent Topics", "icon": Icons.trending_up},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Quick Access"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: quickAccessOptions.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("${quickAccessOptions[index]['title']} clicked")),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(quickAccessOptions[index]['icon'], color: Colors.white, size: 40),
                    const SizedBox(width: 15),
                    Text(
                      quickAccessOptions[index]['title'],
                      style: const TextStyle(
                        color: Colors.white,
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

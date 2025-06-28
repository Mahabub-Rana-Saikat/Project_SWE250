import 'package:climate_hope/pages/OverviewPage.dart';
import 'package:climate_hope/pages/climate_initiatives_page.dart';
import 'package:climate_hope/pages/impact_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GCHubPage extends StatelessWidget {
  const GCHubPage({super.key});


  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> options = [
      {"title": "Resources", "icon": Icons.menu_book, "route": "/resources"},
      {"title": "Initiatives", "icon": Icons.handshake, "route": "/initiatives"},
      {"title": "Impact", "icon": Icons.eco, "route": "/impact"},
      {"title": "Overview", "icon": Icons.dashboard, "route": "/overview"},
    ];



    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Explore"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, 
            childAspectRatio: 1.2, 
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: options.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () async {
                final String title = options[index]['title'];
                if (title == "Resources") {
                  final Uri url = Uri.parse("https://www.climate-resource.com");
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }

                  else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Could not launch URL")),
                    );
                  }
                } 
                else if(title == "Initiatives"){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ClimateInitiativesPage(),
                      ),
                    );
                  } 
                else if(title =="Impact"){
                  Navigator.push(context, MaterialPageRoute(
                        builder: (context) => const ImpactPage(),
                      ),);
                }
                 else if(title =="Overview"){
                  Navigator.push(context, MaterialPageRoute(
                        builder: (context) => const OverviewPage(),
                      ),);
                }
                else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("$title Clicked")),
                  );
                }
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(options[index]['icon'], size: 50, color:const Color.fromARGB(255, 17, 112, 25)),
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

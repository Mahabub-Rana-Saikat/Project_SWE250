
import 'package:climate_hope/pages/ClimateEducationPage.dart';
import 'package:climate_hope/pages/mainpages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:climate_hope/pages/climate_initiatives_page.dart'; 
import 'package:climate_hope/pages/impact_page.dart'; 


class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});


  Widget _buildOverviewSection({
    required IconData icon,
    required String title,
    required String content,
    required Color iconColor,
    required BuildContext context, 
    String? buttonText,
    Widget? navigateToPage,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20.0),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      color: Colors.white, 
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 35, color: iconColor),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.lato(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 1, 39, 2), 
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              content,
              style: GoogleFonts.lato(
                fontSize: 16,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
            if (buttonText != null && navigateToPage != null) ...[
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => navigateToPage),
                    );
                  },
                  icon: Icon(Icons.arrow_forward_ios, size: 20, color: const Color.fromARGB(255, 1, 89, 46)),
                  label: Text(
                    buttonText,
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 1, 89, 46),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 200, 240, 220), // Light green button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 4,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Climate Overview",
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor:const Color.fromARGB(255, 1, 39, 2), 
        elevation: 0,
      ),
      body: Container(
         decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/signin_img.png'),
                  fit: BoxFit.cover,
                ),
              ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Center the main elements
            children: [
              // --- App's Mission/Welcome ---
              Icon(
                Icons.public, // Global icon
                size: 100,
                color: Colors.white.withOpacity(0.9),
                shadows: const [
                  Shadow(blurRadius: 10.0, color: Colors.black38, offset: Offset(3.0, 3.0)),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                "Your Gateway to Global Climate Knowledge",
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: const [
                    Shadow(blurRadius: 5.0, color: Colors.black45, offset: Offset(2.0, 2.0)),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "Gain quick insights into Earth's climate health, recent changes, and actionable solutions.",
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  fontSize: 18,
                  color: Colors.white70,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 40),

              // --- Section: What is Climate Change? ---
              _buildOverviewSection(
                context: context,
                icon: Icons.lightbulb_outline,
                title: "What is Climate Change?",
                content:
                    "Climate change refers to significant and lasting changes in global or regional climate patterns. It's largely attributed to the increased levels of atmospheric carbon dioxide produced by the use of fossil fuels.",
                iconColor: Colors.orange,
                buttonText: "Learn More (Education)",
                navigateToPage:  ClimateEducationPage(),
              ),

              // --- Section: Why It Matters (Impact) ---
              _buildOverviewSection(
                context: context,
                icon: Icons.warning_amber_outlined,
                title: "Why It Matters: Global Impacts",
                content:
                    "From rising sea levels to extreme weather events, climate change profoundly impacts ecosystems, economies, and human societies worldwide. Understanding these effects is crucial.",
                iconColor: Colors.redAccent,
                buttonText: "Explore Impacts",
                navigateToPage: const ImpactPage(),
              ),

              // --- Section: What's Being Done (Initiatives) ---
              _buildOverviewSection(
                context: context,
                icon: Icons.campaign,
                title: "Global Actions & Initiatives",
                content:
                    "Around the world, governments, organizations, and communities are implementing diverse initiatives to mitigate emissions, adapt to changes, and foster sustainability. Discover inspiring efforts.",
                iconColor: Colors.blueAccent,
                buttonText: "View Initiatives",
                navigateToPage: const ClimateInitiativesPage(),
              ),

              // --- Section: Real-time Weather & News ---
              _buildOverviewSection(
                context: context,
                icon: Icons.bar_chart,
                title: "Live Data & Latest News",
                content:
                    "Stay updated with current weather conditions globally and access the latest climate-related news from around the world to keep pace with developments.",
                iconColor: Colors.purpleAccent,
                buttonText: "Check Weather & News",
                navigateToPage: const HomePage(), 
              ),

              const SizedBox(height: 30),
              Text(
                "Knowledge is the first step towards action.",
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  fontSize: 16,
                  color: Colors.white70,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Data from OpenWeatherMap & NewsAPI.org",
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
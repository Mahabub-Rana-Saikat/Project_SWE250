import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClimatePage extends StatelessWidget {
  const ClimatePage({super.key});

  // Helper method for building informative cards
  Widget _buildClimateInfoCard({
    required IconData icon,
    required String title,
    required String content,
    Color iconColor = Colors.white,
    Color textColor = const Color.fromARGB(255, 1, 39, 2), // Dark green text
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white, // White background for readability
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 30, color: iconColor),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.lato(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              content,
              style: GoogleFonts.lato(
                fontSize: 16,
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method for building action items
  Widget _buildClimateActionItem({
    required IconData icon,
    required String title,
    required String description,
    Color iconColor = const Color.fromARGB(255, 62, 218, 134), // Main green
    Color textColor = const Color.fromARGB(255, 1, 39, 2),
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 28, color: iconColor),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.lato(
                    fontSize: 15,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section 1: Introduction to Climate Change
              _buildClimateInfoCard(
                icon: Icons.lightbulb_outline,
                title: "Understanding Climate Change",
                content:
                    "Climate change refers to long-term shifts in temperatures and weather patterns. These shifts may be natural, but since the 1800s, human activities have been the main driver of climate change, primarily due to the burning of fossil fuels.",
                iconColor: Colors.orange,
                textColor: const Color.fromARGB(255, 1, 39, 2),
              ),
              const SizedBox(height: 20),

              // Section 2: Key Global Indicators
              Text(
                "Key Global Indicators",
                style: GoogleFonts.lato(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: const [
                    Shadow(blurRadius: 5.0, color: Colors.black38, offset: Offset(1.0, 1.0)),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              _buildClimateInfoCard(
                icon: Icons.thermostat,
                title: "Global Temperature Rise",
                content:
                    "The planet's average surface temperature has risen about 1.18° Celsius (2.12° Fahrenheit) since the late 19th century, driven by increased CO2 emissions into the atmosphere.",
                iconColor: Colors.red,
                textColor: const Color.fromARGB(255, 1, 39, 2),
              ),
              _buildClimateInfoCard(
                icon: Icons.cloud_upload,
                title: "CO2 Concentration",
                content:
                    "Atmospheric carbon dioxide (CO2) levels are higher than they have been at any point in the last 800,000 years, currently exceeding 420 parts per million (ppm).",
                iconColor: Colors.blueGrey,
                textColor: const Color.fromARGB(255, 1, 39, 2),
              ),
              _buildClimateInfoCard(
                icon: Icons.waves,
                title: "Sea Level Rise",
                content:
                    "Global sea level has risen by about 20 centimeters (8 inches) in the last century, and the rate is accelerating. This is primarily due to thermal expansion of water and melting ice sheets.",
                iconColor: Colors.lightBlue,
                textColor: const Color.fromARGB(255, 1, 39, 2),
              ),
              const SizedBox(height: 20),

              // Section 3: Impacts of Climate Change
              Text(
                "Impacts & Challenges",
                style: GoogleFonts.lato(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: const [
                    Shadow(blurRadius: 5.0, color: Colors.black38, offset: Offset(1.0, 1.0)),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              _buildClimateInfoCard(
                icon: Icons.thunderstorm,
                title: "Extreme Weather Events",
                content:
                    "Climate change intensifies extreme weather, leading to more frequent and severe heatwaves, droughts, wildfires, and intense storms.",
                iconColor: Colors.deepPurple,
                textColor: const Color.fromARGB(255, 1, 39, 2),
              ),
              _buildClimateInfoCard(
                icon: Icons.forest,
                title: "Ecosystems & Biodiversity",
                content:
                    "Rising temperatures and changing precipitation patterns threaten ecosystems, leading to habitat loss, species extinction, and disruption of natural cycles.",
                iconColor: Colors.brown,
                textColor: const Color.fromARGB(255, 1, 39, 2),
              ),
              _buildClimateInfoCard(
                icon: Icons.medical_services,
                title: "Human Health Concerns",
                content:
                    "Impacts include respiratory problems from air pollution, heat-related illnesses, spread of vector-borne diseases, and mental health challenges from climate disasters.",
                iconColor: Colors.pink,
                textColor: const Color.fromARGB(255, 1, 39, 2),
              ),
              const SizedBox(height: 20),

              // Section 4: What You Can Do (Call to Action)
              Text(
                "Become a Climate Champion!",
                style: GoogleFonts.lato(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: const [
                    Shadow(blurRadius: 5.0, color: Colors.black38, offset: Offset(1.0, 1.0)),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildClimateActionItem(
                        icon: Icons.power_outlined,
                        title: "Reduce Your Carbon Footprint",
                        description:
                            "Opt for public transport, bike, walk, or choose electric vehicles. Reduce energy consumption at home.",
                      ),
                      _buildClimateActionItem(
                        icon: Icons.solar_power,
                        title: "Support Renewable Energy",
                        description:
                            "Choose energy providers that prioritize renewables, or consider solar panels if feasible.",
                      ),
                      _buildClimateActionItem(
                        icon: Icons.recycling,
                        title: "Practice the 3 Rs: Reduce, Reuse, Recycle",
                        description:
                            "Minimize waste generation and support a circular economy.",
                      ),
                      _buildClimateActionItem(
                        icon: Icons.local_florist,
                        title: "Eat Sustainably",
                        description:
                            "Consider a plant-rich diet, reduce food waste, and choose locally sourced produce.",
                      ),
                      _buildClimateActionItem(
                        icon: Icons.campaign,
                        title: "Educate & Advocate",
                        description:
                            "Learn more, share knowledge, and support policies and leaders committed to climate action.",
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: Text(
                  "Every action, big or small, makes a difference.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    color: Colors.white70,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
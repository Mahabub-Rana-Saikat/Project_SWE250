import 'package:climate_hope/games/echogame.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:climate_hope/widget/build_action_button.dart';
import 'package:climate_hope/pages/climate_page.dart';
import 'package:climate_hope/pages/mainpages/weather_page.dart';

Widget buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quick Actions",
          style: GoogleFonts.lato(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: const [
              Shadow(
                blurRadius: 5.0,
                color: Colors.black38,
                offset: Offset(1.0, 1.0),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildActionButton(
              context,
              icon: Icons.cloud,
              label: "Echo Game",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EcoGameApp()),
                );
              },
            ),
            buildActionButton(
              context,
              icon: Icons.eco,
              label: "Climate Learn",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ClimatePage()),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
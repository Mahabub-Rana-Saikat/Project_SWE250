import 'package:climate_hope/games/echogame.dart';
import 'package:climate_hope/quezz/mcq_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:climate_hope/widget/build_action_button.dart';


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
              icon: Icons.sports_esports,
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
              icon: Icons.psychology,
              label: "Test Yourself",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ExamScreen()),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
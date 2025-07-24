import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WeatherSuggestionDialog extends StatelessWidget {
  final String suggestion;

  const WeatherSuggestionDialog({super.key, required this.suggestion});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      backgroundColor: Colors.green.shade50,
      title: Text(
        "Weather-Based Suggestions",
        style: GoogleFonts.lato(
          fontWeight: FontWeight.bold,
          color: const Color.fromARGB(255, 1, 39, 2),
        ),
      ),
      content: SingleChildScrollView(
        child: Text(
          suggestion,
          style: GoogleFonts.lato(fontSize: 16, color: Colors.black87),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            "Got it!",
            style: GoogleFonts.lato(
              color: const Color.fromARGB(255, 1, 39, 2),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

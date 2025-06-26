import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildDetailColumn(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.green, size: 30),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.lato(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.lato(fontSize: 14, color: Colors.green),
        ),
      ],
    );
}

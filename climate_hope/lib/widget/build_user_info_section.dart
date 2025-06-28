import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildUserInfoSection() {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: Colors.white54),
    ),
    child: Row(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundColor: Colors.white,
          child: Icon(Icons.person, size: 40, color: Colors.green[800]),
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello, Climate Explorer!\nWelcome to Climate Hope",
              style: GoogleFonts.lato(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 6, 6, 6),
                shadows: const [
                  Shadow(
                    blurRadius: 3.0,
                    color: Colors.black38,
                    offset: Offset(1.0, 1.0),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "Today: ${DateFormat('MMMM d, y').format(DateTime.now())}",
              style: GoogleFonts.lato(fontSize: 16, color: const Color.fromARGB(179, 23, 23, 23)),
            ),
          ],
        ),
      ],
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Hello Climate Hope",
      style: GoogleFonts.pacifico(
        fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black,
      )),
    );
  }
}

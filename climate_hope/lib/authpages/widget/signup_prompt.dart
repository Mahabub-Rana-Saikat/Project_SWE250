import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:climate_hope/authpages/signup.dart';

class SignupPrompt extends StatelessWidget {
  const SignupPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: GoogleFonts.lato(fontSize: 16, color: Colors.white),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Signup())),
          child: Text(
            "Sign Up",
            style: GoogleFonts.lato(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
              decoration: TextDecoration.underline,
              decorationColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

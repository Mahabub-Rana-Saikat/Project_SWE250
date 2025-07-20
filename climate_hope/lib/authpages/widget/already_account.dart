import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:climate_hope/authpages/signin.dart';

class AlreadyHaveAccount extends StatelessWidget {
  const AlreadyHaveAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: GoogleFonts.lato(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 5),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Signin(),
              ),
            );
          },
          child: Text(
            "Sign In",
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

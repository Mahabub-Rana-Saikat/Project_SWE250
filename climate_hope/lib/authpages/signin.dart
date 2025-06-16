import 'dart:convert';
import 'package:climate_hope/authpages/signup.dart';
import 'package:climate_hope/pages/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscureText = true; 

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    try {
      final res = await http
          .post(
            Uri.parse('http://10.0.2.2:5000/signin'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': _emailController.text.trim(),
              'password': _passwordController.text.trim(),
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (res.statusCode == 200) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Dashboard()),
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Login failed: ${res.body}')));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/signin_bg.png'), // Assuming you have a background image for foliage
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 300), 
                  Container(
                    // This creates the white rounded card
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: Colors.white, // Slightly transparent white card
                      borderRadius: BorderRadius.circular(25), // Rounded corners for the card
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min, 
                        children: [
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(color: Colors.white), // White text input
                            decoration: _inputDecoration(
                              'username', // Changed hint to 'username' as per image
                              Icons.person_outline, // Changed to person icon
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your username or email';
                              }
                              // Simplified validation for username/email
                              return null;
                            },
                          ),
                          const SizedBox(height: 16), // Spacing between fields
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscureText,
                            style: const TextStyle(color: Colors.white), // White text input
                            decoration: _inputDecoration(
                              'password', // Changed hint to 'password'
                              Icons.lock_outline,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.white, // White icon
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 5) { // Password length from original code
                                return 'Password must be at least 5 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24), // Spacing before button
                          SizedBox(
                            height: 50,
                            width: double.infinity, // Button takes full width
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : save,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white, // White button
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15), // Softer corners
                                  side: const BorderSide(color: Colors.black, width: 1.5), // Black border
                                ),
                                elevation: 2, // Subtle shadow for depth
                                shadowColor: Colors.black.withOpacity(0.2),
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black), // Black loading spinner
                                    )
                                  : Text(
                                      "LOGIN", // All caps as per image
                                      style: GoogleFonts.lato( // Using Lato as it's readable
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.black, // Black text for contrast
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30), // Spacing below card
                  // "Don't have an account?" section
                  Text(
                    "don't have an account ?", // Matches image text
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8), // Slightly transparent white for background text
                    ),
                  ),
                  const SizedBox(height: 8), // Spacing
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Signup(),
                        ),
                      );
                    },
                    child: Text(
                      "create a new account", // Matches image text
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white, // White text for the link
                        decoration: TextDecoration.underline, // Underline for link
                        decorationColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper function for consistent input decoration
  InputDecoration _inputDecoration(String hint, IconData icon,
      {Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white70), // White hint text
      prefixIcon: Icon(icon, color: Colors.white), // White prefix icon
      suffixIcon: suffixIcon, // For password visibility toggle
      filled: true,
      fillColor: const Color(0xFF222222), // Dark background for input fields
      contentPadding:
          const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15), // Rounded corners
        borderSide: const BorderSide(color: Colors.white, width: 1.5), // White border
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
            color: Color.fromARGB(255, 62, 218, 134), // Green highlight on focus
            width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.red, width: 1.5), // Red for errors
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.red, width: 2.0),
      ),
      errorStyle: const TextStyle(color: Colors.redAccent), // Error text color
    );
  }
}

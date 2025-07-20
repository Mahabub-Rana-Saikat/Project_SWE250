import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:climate_hope/decoration/input_decoration.dart';
import 'package:climate_hope/authpages/validetor/validetors.dart';


class SignInFormBox extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscureText;
  final VoidCallback toggleObscureText;
  final VoidCallback onSubmit;
  final bool isLoading;

  const SignInFormBox({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.obscureText,
    required this.toggleObscureText,
    required this.onSubmit,
    required this.isLoading,
  });

   @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.white),
              decoration: inputDecoration('Enter Your Email', Icons.email_outlined),
              validator: Validators.validateEmail,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: passwordController,
              obscureText: obscureText,
              style: const TextStyle(color: Colors.white),
              decoration: inputDecoration(
                'Enter Your Password',
                Icons.lock_outline,
                suffixIcon: IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: const Color.fromARGB(255, 1, 39, 2),
                  ),
                  onPressed: toggleObscureText,
                ),
              ),
              validator: Validators.validatePassword,
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: const BorderSide(color: Colors.black, width: 1.5),
                  ),
                  elevation: 2,
                  shadowColor: Colors.black,
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Text(
                        "SignIn",
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.black,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

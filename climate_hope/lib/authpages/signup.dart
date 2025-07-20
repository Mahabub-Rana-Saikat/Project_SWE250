import 'package:climate_hope/app_asset/Assets.dart';
import 'package:climate_hope/authpages/widget/already_account.dart';
import 'package:climate_hope/authpages/widget/signup_button.dart';
import 'package:flutter/material.dart';
import 'package:climate_hope/authpages/widget/signup_from_box.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscureText = true;

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _mobileNumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });
      });
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
                  image: AssetImage(AppAssets.signinImage),
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
                  const SizedBox(height: 150),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        SignupFormBox(
                          formKey: _formKey,
                          nameController: _nameController,
                          addressController: _addressController,
                          mobileNumberController: _mobileNumberController,
                          emailController: _emailController,
                          passwordController: _passwordController,
                          obscurePassword: _obscureText,
                          togglePasswordVisibility: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        SignupButton(
                        isLoading: _isLoading,
                        text: "Sign Up",
                        onPressed: _submitForm,
                      ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                 AlreadyHaveAccount(),
                  ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

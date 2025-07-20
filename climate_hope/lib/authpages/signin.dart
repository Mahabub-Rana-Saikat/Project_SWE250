import 'package:climate_hope/app_asset/Assets.dart';
import 'package:climate_hope/authpages/services/auth_signin_service.dart'
    show AuthService;
import 'package:flutter/material.dart';
import 'package:climate_hope/authpages/widget/signin_form_box.dart';
import 'package:climate_hope/authpages/widget/signup_prompt.dart';
import 'package:climate_hope/authpages/constaint/api_constaints.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
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

    await AuthService.loginUser(
      context: context,
      url: ApiConstants.signinUrl,
      email: _emailController.text,
      password: _passwordController.text,
      onLoading: (value) => setState(() => _isLoading = value),
    );
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
                  const SizedBox(height: 200),
                  SignInFormBox(
                    formKey: _formKey,
                    emailController: _emailController,
                    passwordController: _passwordController,
                    obscureText: _obscureText,
                    toggleObscureText:
                        () => setState(() => _obscureText = !_obscureText),
                    onSubmit: save,
                    isLoading: _isLoading,
                  ),
                  const SizedBox(height: 30),
                  const SignupPrompt(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

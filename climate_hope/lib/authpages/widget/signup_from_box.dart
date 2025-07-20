import 'package:flutter/material.dart';
import 'package:climate_hope/decoration/input_decoration.dart';
import 'package:climate_hope/authpages/validetor/validetors.dart';

class SignupFormBox extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController addressController;
  final TextEditingController mobileNumberController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback togglePasswordVisibility;

  const SignupFormBox({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.addressController,
    required this.mobileNumberController,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.togglePasswordVisibility,
  });

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white),
        decoration: inputDecoration(
          label,
          icon,
          suffixIcon: suffixIcon,
        ),
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          _buildTextFormField(
            controller: nameController,
            label: 'Enter Your Name',
            icon: Icons.person,
            validator: Validators.validateName,
          ),
          _buildTextFormField(
            controller: addressController,
            label: 'Enter Your Address',
            icon: Icons.home,
            validator: Validators.validateAddress,
          ),
          _buildTextFormField(
            controller: mobileNumberController,
            label: 'Enter Your Mobile Number',
            icon: Icons.phone_android,
            keyboardType: TextInputType.phone,
            validator: Validators.validateMobile,
          ),
          _buildTextFormField(
            controller: emailController,
            label: 'Enter Your Email',
            icon: Icons.email,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.validateEmail,
          ),
          _buildTextFormField(
            controller: passwordController,
            label: 'Enter Your Password',
            icon: Icons.lock,
            obscureText: obscurePassword,
            validator: Validators.validatePassword,
            suffixIcon: IconButton(
              icon: Icon(
                obscurePassword ? Icons.visibility : Icons.visibility_off,
                color: Colors.white,
              ),
              onPressed: togglePasswordVisibility,
            ),
          ),
        ],
      ),
    );
  }
}

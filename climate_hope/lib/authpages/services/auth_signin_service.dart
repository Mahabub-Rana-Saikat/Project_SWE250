import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:climate_hope/authpages/alert_message.dart';
import 'package:climate_hope/pages/topbar/dashboard.dart';
import 'package:climate_hope/provider/user_provider.dart';

class AuthService {
  static Future<void> loginUser({
    required BuildContext context,
    required Uri url,
    required String email,
    required String password,
    required void Function(bool isLoading) onLoading,
  }) async {
    try {
      onLoading(true);

      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'email': email.trim(),
          'password': password.trim(),
        }),
      );

      if (!context.mounted) return;

      if (res.statusCode == 200) {
        final userData = jsonDecode(res.body)['user'];
        Provider.of<UserProvider>(context, listen: false).setUser(userData);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login successful!")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Dashboard()),
        );
      } else {
        final msg = jsonDecode(res.body)['message'] ?? "Login failed: ${res.statusCode}";
        Alertmessage.show(context, msg);
      }
    } catch (e) {
      if (context.mounted) {
        Alertmessage.show(context, "Network error: $e");
      }
    } finally {
      if (context.mounted) onLoading(false);
    }
  }
}

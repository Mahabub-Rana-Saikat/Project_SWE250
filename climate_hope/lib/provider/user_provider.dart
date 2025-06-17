import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  Map<String, dynamic>? _currentUser;

  Map<String, dynamic>? get currentUser => _currentUser;

  void setUser(Map<String, dynamic> userData) {
    _currentUser = userData;
    notifyListeners(); 
  }

  void clearUser() {
    _currentUser = null;
    notifyListeners(); 
  }
}
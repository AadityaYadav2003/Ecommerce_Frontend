import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  String? _email;
  String? _password;

  String? get email => _email;
  String? get password => _password;

  Future<void> setUser(String email, String password) async {
    _email = email;
    _password = password;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }

  Future<void> loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _email = prefs.getString('email');
    _password = prefs.getString('password');
    notifyListeners();
  }

  Future<void> clearUser() async {
    _email = null;
    _password = null;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');
  }
}

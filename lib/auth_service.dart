import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _username;
  String? _role;
  String? _name;

  bool get isLoggedIn => _isLoggedIn;
  String? get username => _username;
  String? get role => _role;
  String? get name => _name;

  AuthService() {
    _loadAuthStatus();
  }

  Future<void> _loadAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _username = prefs.getString('username');
    _role = prefs.getString('role');
    _name = prefs.getString('name');
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    // In a real app, you would validate credentials against a backend.
    // For local storage, we'll just simulate a successful login.
    // For this example, we'll assume a successful login implies the user was previously registered.
    if (username.isNotEmpty && password.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      // In a real app, you'd fetch user details from a backend after successful login.
      // Here, we'll just load the last registered user's details.
      _isLoggedIn = true;
      _username = prefs.getString('username'); // Load from stored registration
      _role = prefs.getString('role'); // Load from stored registration
      _name = prefs.getString('name'); // Load from stored registration
      await prefs.setBool('isLoggedIn', true);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('username');
    await prefs.remove('role');
    await prefs.remove('name');
    _isLoggedIn = false;
    _username = null;
    _role = null;
    _name = null;
    notifyListeners();
  }

  Future<bool> register(String name, String username, String password, String role) async {
    // In a real app, you would send registration data to a backend.
    // For local storage, we'll store the last registered user's details.
    if (name.isNotEmpty && username.isNotEmpty && password.isNotEmpty && role.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', name);
      await prefs.setString('username', username);
      await prefs.setString('role', role);
      // For simplicity, we are not storing the password in shared_preferences.
      return true;
    }
    return false;
  }

  Future<void> updateUser(String newName, String newUsername, String newPassword, String newRole) async {
    final prefs = await SharedPreferences.getInstance();
    if (newName.isNotEmpty) {
      await prefs.setString('name', newName);
      _name = newName;
    }
    if (newUsername.isNotEmpty) {
      await prefs.setString('username', newUsername);
      _username = newUsername;
    }
    if (newRole.isNotEmpty) {
      await prefs.setString('role', newRole);
      _role = newRole;
    }
    // In a real app, you would hash and store the new password securely.
    // For this example, we are not storing the password in shared_preferences.
    // If you were, you would update it here.
    notifyListeners();
  }
}
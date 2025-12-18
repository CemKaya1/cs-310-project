import 'package:flutter/material.dart';
import 'package:cs_310_project/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginRegisterProvider extends ChangeNotifier {
  final AuthService _auth = AuthService();

  bool _loading = false;
  String? _error;

  bool get loading => _loading;
  String? get error => _error;

  Future<void> _setLoading(bool v) async {
    _loading = v;
    notifyListeners();
  }

  Future<void> _saveLastEmail(String email) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString('last_email', email);
  }

  Future<String?> loadLastEmail() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString('last_email');
  }

  Future<bool> login(String email, String password) async {
    await _setLoading(true);
    _error = null;
    try {
      await _auth.login(email, password);
      await _saveLastEmail(email);
      return true;
    } on Exception catch (e) {
      _error = e.toString();
      return false;
    } finally {
      await _setLoading(false);
    }
  }

  Future<bool> register(String email, String password) async {
    await _setLoading(true);
    _error = null;
    try {
      await _auth.register(email, password);
      await _saveLastEmail(email);
      return true;
    } on Exception catch (e) {
      _error = e.toString();
      return false;
    } finally {
      await _setLoading(false);
    }
  }

  // --- Auth helpers (moved from separate AuthProvider) ---
  User? get currentUser => FirebaseAuth.instance.currentUser;

  Stream<User?> get authStateChanges => _auth.userStream;

  bool get isLoggedIn => currentUser != null && !(currentUser?.isAnonymous ?? true);

  Future<void> logout() async {
    await _auth.logout();
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cs_310_project/services/mock_seed_service.dart';

class LoginRegisterProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final MockSeedService _seed = MockSeedService();

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
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await _saveLastEmail(email);
      return true;
    } on FirebaseAuthException catch (e) {
      _error = e.message ?? e.code;
      return false;
    } catch (e) {
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
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _saveLastEmail(email);
      await _seed.seedIfEmpty();
      return true;
    } on FirebaseAuthException catch (e) {
      _error = e.message ?? e.code;
      return false;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      await _setLoading(false);
    }
  }

  // --- Auth helpers (moved from separate AuthProvider) ---
  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  bool get isLoggedIn => currentUser != null && !(currentUser?.isAnonymous ?? true);

  Future<void> logout() async {
    await _auth.signOut();
    notifyListeners();
  }
}

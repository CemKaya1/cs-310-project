import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cs_310_project/services/mock_seed_service.dart';

/// Manages authentication state, user registration, and local persistence 
/// of the last used email for a smoother login experience.
class LoginRegisterProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final MockSeedService _seed = MockSeedService();

  bool _loading = false;
  String? _error;

  bool get loading => _loading;
  String? get error => _error;

  /// Updates the loading state and notifies UI listeners to show/hide progress indicators.
  Future<void> _setLoading(bool v) async {
    _loading = v;
    notifyListeners();
  }

  /// Persists the email locally so it can be pre-filled on the next app launch.
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
      // Initialize default user data/mock data for new accounts.
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

  // --- Auth helpers ---
  User? get currentUser => _auth.currentUser;

  /// Exposes the auth stream for top-level navigation (e.g., StreamBuilder in main.dart).
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Returns true only if a real user (non-anonymous) is authenticated.
  bool get isLoggedIn => currentUser != null && !(currentUser?.isAnonymous ?? true);

  Future<void> logout() async {
    await _auth.signOut();
    notifyListeners(); // Ensure UI reacts to the identity change
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cs_310_project/views/login_register/login_register_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  // --------------------------------------------
  // RUNTIME USER LIST 
  // --------------------------------------------
  final List<Map<String, String>> _users = [];

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  // --------------------------------------------
  // EMAIL VALIDATION: en az "@" ve "." içermeli
  // --------------------------------------------
  bool _isValidEmail(String email) {
    // Minimal kontrol: "@" içermeli
    return email.contains("@");
  }
  void _showAlert(String message) {
    final scheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Invalid Input"),
        content: Text(message),
        backgroundColor: scheme.surface,
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 16,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK", style: TextStyle(color: scheme.primary)),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------
  // LOGIN
  // --------------------------------------------
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      _showAlert("Please fix the form errors before logging in.");
      return;
    }

    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text.trim();
  // MODIFIED START: delegate authentication to LoginRegisterProvider (Firebase)
  final provider = context.read<LoginRegisterProvider>();
  final success = await provider.login(email, password);
  // MODIFIED END

    if (!success) {
      final msg = provider.error ?? 'Login failed';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
      return;
    }
  }


  // --------------------------------------------
  // REGISTER
  // --------------------------------------------
  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      _showAlert("Please fix the form errors before registering.");
      return;
    }

    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text.trim();

  // MODIFIED START: delegate registration to LoginRegisterProvider (Firebase)
  final provider = context.read<LoginRegisterProvider>();
  final success = await provider.register(email, password);
  // MODIFIED END

    bool alreadyExists = _users.any((u) => u["email"] == email);

    if (!success) {
      final msg = provider.error ?? 'Registration failed';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Registration successful! Logging in...")),
    );
  }


  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: scheme.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: scheme.shadow.withOpacity(0.2),
                    offset: Offset(0, 16),
                    blurRadius: 32,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Outfitly",
                        textAlign: TextAlign.center,
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: scheme.primary,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // -----------------------------------------
                      // EMAIL FIELD
                      // -----------------------------------------
                      Text(
                        "Email",
                        style: TextStyle(
                          fontSize: 14,
                          color: scheme.onSurface.withOpacity(0.7),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),

                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(color: scheme.onSurface),
                        validator: (v) {
                          if (v == null || v.isEmpty) return "Email required";
                          if (!_isValidEmail(v)) return "Email should contain @ character";
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Enter your email",
                          hintStyle: TextStyle(color: scheme.onSurface.withOpacity(0.6)),
                          filled: true,
                          fillColor: scheme.surfaceVariant,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 18,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: scheme.outline),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                            BorderSide(color: scheme.primary, width: 2),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // -----------------------------------------
                      // PASSWORD FIELD
                      // -----------------------------------------
                      Text(
                        "Password",
                        style: TextStyle(
                          fontSize: 14,
                          color: scheme.onSurface.withOpacity(0.7),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),

                      TextFormField(
                        controller: _passwordCtrl,
                        obscureText: true,
                        style: TextStyle(color: scheme.onSurface),
                        validator: (v) {
                          if (v == null || v.isEmpty) return "Password required";
                          if (v.length < 6) return "Password must have at least 6 characters";
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Enter your password",
                          hintStyle: TextStyle(color: scheme.onSurface.withOpacity(0.6)),
                          filled: true,
                          fillColor: scheme.surfaceVariant,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 18,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: scheme.outline),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                            BorderSide(color: scheme.primary, width: 2),
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // -----------------------------------------
                      // BUTTONS
                      // -----------------------------------------
                      // MODIFIED START: login/register buttons now observe provider's loading state
                      Consumer<LoginRegisterProvider>(
                        builder: (context, provider, _) {
                          return Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: provider.loading ? null : _register,
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    side: BorderSide(color: scheme.primary),
                                    foregroundColor: scheme.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: provider.loading
                                      ? const SizedBox(
                                          height: 16,
                                          width: 16,
                                          child: CircularProgressIndicator(strokeWidth: 2),
                                        )
                                      : const Text("Register"),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: provider.loading ? null : _login,
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    backgroundColor: scheme.primary,
                                    foregroundColor: scheme.onPrimary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: provider.loading
                                      ? const SizedBox(
                                          height: 16,
                                          width: 16,
                                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                        )
                                      : const Text("Log In"),
                                ),
                              ),
                            ],
                          );
                        },
                      )
                      // MODIFIED END,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

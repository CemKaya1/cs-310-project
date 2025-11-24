import 'package:flutter/material.dart';
import 'package:cs_310_project/main.dart';

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
    return email.contains("@") ;
  }

  // --------------------------------------------
  // LOGIN
  // --------------------------------------------
  void _login() {
    if (_formKey.currentState!.validate()) {
      final email = _emailCtrl.text.trim();
      final password = _passwordCtrl.text.trim();

      // email-password eşleşen kayıt var mı?
      final exists = _users.any(
            (u) => u["email"] == email && u["password"] == password,
      );

      if (!exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid email or password")),
        );
        return;
      }

      Navigator.pushReplacementNamed(context, "/");


    }
  }

  // --------------------------------------------
  // REGISTER
  // --------------------------------------------
  void _register() {
    if (_formKey.currentState!.validate()) {
      final email = _emailCtrl.text.trim();
      final password = _passwordCtrl.text.trim();

      // email zaten kayıtlı mı?
      bool alreadyExists = _users.any((u) => u["email"] == email);

      if (alreadyExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email already registered")),
        );
        return;
      }

      // Yeni kullanıcı ekleniyor
      _users.add({
        "email": email,
        "password": password,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration successful! Logging in...")),
      );

      Navigator.pushReplacementNamed(context, "/");

    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
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
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: scheme.primary,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // -----------------------------------------
                      // EMAIL FIELD
                      // -----------------------------------------
                      const Text(
                        "Email",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),

                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.isEmpty) return "Email required";
                          if (!_isValidEmail(v)) return "Email should contain @ character";
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Enter your email",
                          filled: true,
                          fillColor: Colors.grey[200],
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 18,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.grey),
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
                      const Text(
                        "Password",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),

                      TextFormField(
                        controller: _passwordCtrl,
                        obscureText: true,
                        validator: (v) {
                          if (v == null || v.isEmpty) return "Password required";
                          if (v.length < 4) return "Password must has at least 4 characters";
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Enter your password",
                          filled: true,
                          fillColor: Colors.grey[200],
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 18,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.grey),
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
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _register,
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                side: BorderSide(color: scheme.primary),
                                foregroundColor: scheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text("Register"),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: scheme.primary,
                                foregroundColor: scheme.onPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: const Text("Log In"),
                            ),
                          ),
                        ],
                      )
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

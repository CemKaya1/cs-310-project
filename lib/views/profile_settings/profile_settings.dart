import 'package:flutter/material.dart';

void main() {
  runApp(const ProfileApp());
}

class ProfileApp extends StatefulWidget {
  const ProfileApp({super.key});

  @override
  State<ProfileApp> createState() => _ProfileAppState();
}

class _ProfileAppState extends State<ProfileApp> {
  bool _isDarkModeEnabled = false;

  ThemeData get _lightTheme => ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade100,
    cardColor: Colors.white,
    colorScheme: ColorScheme.light(
      primary: Colors.blueGrey.shade900,
      onPrimary: Colors.white,
      surface: Colors.white,
      onSurface: Colors.blueGrey.shade900,
    ),
    dividerColor: Colors.blueGrey.shade100,
    useMaterial3: true,
  );

  ThemeData get _darkTheme => ThemeData(
    scaffoldBackgroundColor: Colors.blueGrey.shade900,
    cardColor: Colors.blueGrey.shade800,
    colorScheme: ColorScheme.dark(
      primary: Colors.lightBlueAccent.shade100,
      onPrimary: Colors.black,
      surface: Colors.blueGrey.shade800,
      onSurface: Colors.white,
    ),
    dividerColor: Colors.blueGrey.shade700,
    useMaterial3: true,
  );

  void _onDarkModeChanged(bool value) {
    setState(() {
      _isDarkModeEnabled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Profile Settings',
      theme: _lightTheme,
      darkTheme: _darkTheme,
      themeMode: _isDarkModeEnabled ? ThemeMode.dark : ThemeMode.light,
      home: ProfileSettingsPage(
        isDarkModeEnabled: _isDarkModeEnabled,
        onDarkModeChanged: _onDarkModeChanged,
      ),
    );
  }
}

class ProfileSettingsPage extends StatelessWidget {
  const ProfileSettingsPage({
    super.key,
    required this.isDarkModeEnabled,
    required this.onDarkModeChanged,
  });

  final bool isDarkModeEnabled;
  final ValueChanged<bool> onDarkModeChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color primaryTextColor = theme.colorScheme.onSurface;
    final Color subTextColor = theme.colorScheme.onSurface.withOpacity(0.7);
    final Color borderColor = theme.dividerColor;
    final bool isDarkTheme = theme.brightness == Brightness.dark;

    void showSnackBar(String message) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(message),
            behavior: SnackBarBehavior.floating,
          ),
        );
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (Navigator.canPop(context)) {
                        Navigator.of(context).maybePop();
                      } else {
                        showSnackBar('Back button tapped');
                      }
                    },
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Back',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: primaryTextColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Profile Settings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: primaryTextColor,
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.blue.shade400,
                      child: Icon(
                        Icons.person_rounded,
                        size: 60,
                        color: Colors.blueGrey.shade50,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Fashion Enthusiast',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Displays user information with options to edit profile, toggle dark mode, and log out.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: subTextColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 160,
                      height: 44,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: primaryTextColor,
                          side: BorderSide(color: borderColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          backgroundColor: theme.cardColor,
                        ),
                        onPressed: () => showSnackBar('Edit profile tapped'),
                        child: const Text(
                          'Edit Profile',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDarkTheme ? 0.2 : 0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isDarkTheme
                            ? Colors.blueGrey.shade700
                            : Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.nightlight_round,
                        color: isDarkTheme
                            ? Colors.lightBlueAccent.shade100
                            : Colors.blueGrey.shade900,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dark Mode',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: primaryTextColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Toggle the theme between light and dark modes.',
                            style: TextStyle(fontSize: 13, color: subTextColor),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: isDarkModeEnabled,
                      activeColor: isDarkTheme
                          ? Colors.blueGrey.shade900
                          : Colors.white,
                      activeTrackColor: Colors.lightBlueAccent.shade100,
                      inactiveThumbColor: Colors.blueGrey.shade50,
                      inactiveTrackColor: Colors.blueGrey.shade200,
                      onChanged: onDarkModeChanged,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade400,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () => showSnackBar('Logged out successfully'),
                  child: const Text(
                    'Log Out',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

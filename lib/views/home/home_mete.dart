import 'package:flutter/material.dart';

void main() {
  runApp(const OutfitlyApp());
}

const _seedColor = Colors.indigo;
const _lightBackground = Color(0xFFF5F5F7);
const _darkBackground = Color(0xFF0F0F0F);
const _lightSurface = Colors.white;
const _darkSurface = Color(0xFF1C1C1E);

class OutfitlyApp extends StatefulWidget {
  const OutfitlyApp({super.key});

  @override
  State<OutfitlyApp> createState() => _OutfitlyAppState();
}

class _OutfitlyAppState extends State<OutfitlyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _handleDarkModeChanged(bool isEnabled) {
    setState(() {
      _themeMode = isEnabled ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Outfitly',
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: _themeMode,
      home: OutfitlyHomePage(
        isDarkModeEnabled: _themeMode == ThemeMode.dark,
        onDarkModeChanged: _handleDarkModeChanged,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

ThemeData _buildTheme(Brightness brightness) {
  final base = brightness == Brightness.dark
      ? ThemeData.dark(useMaterial3: true)
      : ThemeData.light(useMaterial3: true);

  final isDark = brightness == Brightness.dark;
  final colorScheme = ColorScheme.fromSeed(
    seedColor: _seedColor,
    brightness: brightness,
    background: isDark ? _darkBackground : _lightBackground,
    surface: isDark ? _darkSurface : _lightSurface,
  );

  return base.copyWith(
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colorScheme.background,
    textTheme: base.textTheme.apply(
      bodyColor: colorScheme.onBackground,
      displayColor: colorScheme.onBackground,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: colorScheme.onBackground,
      elevation: 0,
      centerTitle: true,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith(
            (states) => colorScheme.primary,
      ),
      trackColor: MaterialStateProperty.resolveWith(
            (states) => colorScheme.primary.withOpacity(0.4),
      ),
    ),
  );
}

class OutfitlyHomePage extends StatelessWidget {
  const OutfitlyHomePage({
    super.key,
    required this.isDarkModeEnabled,
    required this.onDarkModeChanged,
  });

  final bool isDarkModeEnabled;
  final ValueChanged<bool> onDarkModeChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () => _openScreen(
                context,
                ProfileScreen(
                  isDarkModeEnabled: isDarkModeEnabled,
                  onDarkModeChanged: onDarkModeChanged,
                ),
              ),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(
                  Icons.person_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Outfitly',
                    textAlign: TextAlign.center,
                    style: textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Welcome Back!',
                    textAlign: TextAlign.center,
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Organize your wardrobe and plan your perfect outfits',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _BottomNavRow(
              onMyClosetTap: () => _openScreen(
                context,
                const MyClosetScreen(),
              ),
              onMyOutfitsTap: () => _openScreen(
                context,
                const MyOutfitsScreen(),
              ),
              onPlannerTap: () => _openScreen(
                context,
                const PlannerScreen(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _openScreen(BuildContext context, Widget screen) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => screen),
  );
}

class _BottomNavRow extends StatelessWidget {
  const _BottomNavRow({
    required this.onMyClosetTap,
    required this.onMyOutfitsTap,
    required this.onPlannerTap,
  });

  final VoidCallback onMyClosetTap;
  final VoidCallback onMyOutfitsTap;
  final VoidCallback onPlannerTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const _NavButton(
            label: 'Home',
            icon: Icons.home,
            isActive: true,
          ),
          _NavButton(
            label: 'My Closet',
            icon: Icons.checkroom_outlined,
            onTap: onMyClosetTap,
          ),
          _NavButton(
            label: 'My Outfits',
            icon: Icons.style_outlined,
            onTap: onMyOutfitsTap,
          ),
          _NavButton(
            label: 'Planner',
            icon: Icons.calendar_month_outlined,
            onTap: onPlannerTap,
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.label,
    required this.icon,
    this.isActive = false,
    this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = isActive ? scheme.primary : scheme.outline;

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyClosetScreen extends StatelessWidget {
  const MyClosetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SimpleDestinationScaffold(
      title: 'My Closet',
      description: 'Browse and edit everything you\'ve saved in your closet.',
    );
  }
}

class MyOutfitsScreen extends StatelessWidget {
  const MyOutfitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SimpleDestinationScaffold(
      title: 'My Outfits',
      description: 'Review and manage your curated outfit combinations.',
    );
  }
}

class PlannerScreen extends StatelessWidget {
  const PlannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SimpleDestinationScaffold(
      title: 'Planner',
      description: 'Plan upcoming looks on the calendar.',
    );
  }
}

class _SimpleDestinationScaffold extends StatelessWidget {
  const _SimpleDestinationScaffold({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                description,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.isDarkModeEnabled,
    required this.onDarkModeChanged,
  });

  final bool isDarkModeEnabled;
  final ValueChanged<bool> onDarkModeChanged;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late bool _isDarkModeEnabled;

  @override
  void initState() {
    super.initState();
    _isDarkModeEnabled = widget.isDarkModeEnabled;
  }

  @override
  void didUpdateWidget(covariant ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isDarkModeEnabled != widget.isDarkModeEnabled) {
      setState(() {
        _isDarkModeEnabled = widget.isDarkModeEnabled;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Profile Settings',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            CircleAvatar(
              radius: 48,
              backgroundColor: scheme.primaryContainer,
              child: Icon(
                Icons.person,
                size: 48,
                color: scheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Fashion Enthusiast',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: scheme.onBackground,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 180,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  side: BorderSide(color: scheme.primary, width: 2),
                ),
                child: Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: scheme.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.nights_stay_outlined,
                    color: scheme.onSurface,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Dark Mode',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: scheme.onSurface,
                      ),
                    ),
                  ),
                  Switch(
                    value: _isDarkModeEnabled,
                    activeColor: scheme.primary,
                    onChanged: (value) {
                      setState(() {
                        _isDarkModeEnabled = value;
                      });
                      widget.onDarkModeChanged(value);
                    },
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () => _navigateToLogin(context),
                child: const Text(
                  'Log Out',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _navigateToLogin(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const LoginRegisterScreen(),
      ),
    );
  }
}

class LoginRegisterScreen extends StatelessWidget {
  const LoginRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login / Register'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.login,
                size: 64,
                color: Colors.indigo,
              ),
              const SizedBox(height: 16),
              const Text(
                'This is where users would sign in or create an account.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Back to Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

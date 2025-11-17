import 'package:flutter/material.dart';

void main() {
  runApp(const OutfitlyApp());
}

class OutfitlyApp extends StatelessWidget {
  const OutfitlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Outfitly',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5D61F4),
          background: const Color(0xFFF8F8FB),
        ),
        useMaterial3: true,
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: const Color(0xFF1A1E2C),
          displayColor: const Color(0xFF1A1E2C),
        ),
      ),
      home: const OutfitlyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class OutfitlyHomePage extends StatelessWidget {
  const OutfitlyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Home',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1E2C),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () => _openScreen(
                context,
                const ProfileScreen(),
              ),
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: Color(0xFFF1F2FF),
                child: Icon(
                  Icons.person_outline,
                  color: Color(0xFF5D61F4),
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
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Organize your wardrobe and plan your perfect outfits',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyLarge?.copyWith(
                      color: const Color(0xFF6C728B),
                    ),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 12,
            offset: Offset(0, 6),
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
    final color = isActive ? const Color(0xFF5D61F4) : const Color(0xFFB3B6D3);

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

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isDarkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Profile Settings',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1E2C),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            const CircleAvatar(
              radius: 48,
              backgroundColor: Color(0xFFE5E7FB),
              child: Icon(
                Icons.person,
                size: 48,
                color: Color(0xFF5D61F4),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Fashion Enthusiast',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1E2C),
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
                  side: const BorderSide(color: Color(0xFF5D61F4), width: 2),
                ),
                child: const Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF5D61F4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.nights_stay_outlined,
                    color: Color(0xFF1A1E2C),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Dark Mode',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Switch(
                    value: _isDarkModeEnabled,
                    activeColor: const Color(0xFF5D61F4),
                    onChanged: (value) {
                      setState(() {
                        _isDarkModeEnabled = value;
                      });
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
                  backgroundColor: const Color(0xFFFF4E4E),
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
                color: Color(0xFF5D61F4),
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

class _SimpleDestinationScaffold extends StatelessWidget {
  const _SimpleDestinationScaffold({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
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
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                description,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
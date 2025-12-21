import 'firebase_options.dart';
import 'package:cs_310_project/views/my_closet/closet_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cs_310_project/views/planner/planner_provider.dart';
import 'package:cs_310_project/views/my_outfits/outfits_provider.dart';

import 'package:cs_310_project/views/login_register/login_register_provider.dart';
import 'package:cs_310_project/views/item_creator/item_creator_provider.dart';

// MAIN SCREENS
import 'package:cs_310_project/views/login_register/login_register.dart';
import 'package:cs_310_project/views/home/home.dart';
import 'package:cs_310_project/views/profile/profile.dart';

// CLOSET
import 'package:cs_310_project/views/my_closet/my_closet_page.dart';
import 'package:cs_310_project/views/item_detail/item_detail_page.dart';
import 'package:cs_310_project/views/item_creator/item_creator.dart';

// OUTFITS
import 'package:cs_310_project/views/my_outfits/my_outfit_page.dart';
import 'package:cs_310_project/views/outfit_creator/outfit_creator_page.dart';
import 'package:cs_310_project/views/outfit_detail/outfit_detail_page.dart';

// PLANNER
import 'package:cs_310_project/views/planner/planner_page.dart';

// BOTTOM NAV
import 'package:cs_310_project/widgets/bottom_nav_bar.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginRegisterProvider()),
        ChangeNotifierProvider(create: (_) => ItemCreatorProvider()),
        ChangeNotifierProvider(create: (_) => PlannerProvider()),
        ChangeNotifierProvider(create: (_) => ClosetProvider()),
        ChangeNotifierProvider(create: (_) => OutfitsProvider()),
      ],
      child: const OutfitlyApp(),
    ),
  );
}

class OutfitlyApp extends StatefulWidget {
  const OutfitlyApp({super.key});

  @override
  State<OutfitlyApp> createState() => _OutfitlyAppState();
}

class _OutfitlyAppState extends State<OutfitlyApp> {
  // ---------- Dark Mode ----------
  ThemeMode _themeMode = ThemeMode.light;
  static const _prefKey = "isDarkMode";

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_prefKey) ?? false;
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void _toggleDarkMode(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, enabled);

    setState(() {
      _themeMode = enabled ? ThemeMode.dark : ThemeMode.light;
    });
  }

  // ---------- Bottom Nav ----------
  int _selectedIndex = 0;

  final List<Widget> widgetOptions = const [
    OutfitlyHomePage(),
    MyClosetPage(),
    MyOutfitPage(),
    PlannerPage(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Outfitly',

      themeMode: _themeMode,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),

      routes: {
        "/login": (context) => const LoginPage(),
        "/profile": (context) => ProfileScreen(
          isDarkModeEnabled: _themeMode == ThemeMode.dark,
          onDarkModeChanged: _toggleDarkMode,
        ),
        "/my_closet": (context) => const MyClosetPage(),
        "/item_creator": (context) => const ItemCreatorPage(),
        "/item_detail": (context) => const ItemDetailPage(),
        "/my_outfits": (context) => const MyOutfitPage(),
        "/outfit_creator": (context) => const OutfitCreatorPage(),
        "/outfit_detail": (context) => const OutfitDetailPage(),
        "/planner": (context) => const PlannerPage(),
      },

      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.data == null) {
            return const LoginPage();
          }

          return Scaffold(
            bottomNavigationBar: OutfitlyBottomNavBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            ),
            body: widgetOptions[_selectedIndex],
          );
        },
      ),
    );
  }
}

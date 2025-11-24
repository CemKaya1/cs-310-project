import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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


void main() {
  runApp(const OutfitlyApp());
}

class OutfitlyApp extends StatefulWidget {
  const OutfitlyApp({super.key});

  @override
  State<OutfitlyApp> createState() => _OutfitlyAppState();
}

class _OutfitlyAppState extends State<OutfitlyApp> {

  // ---------- Dark Mode ----------
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleDarkMode(bool enabled) {
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

      // ---------- Themes ----------
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

      // ---------- Start Page ----------
      initialRoute: "/login",

      // ---------- Named Routes ----------
      routes: {
        "/login": (context) => const LoginPage(),

        //  HOME route'u YOK artık — eskisi gibi widgetOptions üzerinden gidiyoruz

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

      // ---------- ROOT: Bottom Nav + Main Pages ----------
      home: Scaffold(
        bottomNavigationBar: OutfitlyBottomNavBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
        body: widgetOptions[_selectedIndex],
      ),
    );
  }
}

import 'package:cs_310_project/views/my_outfits/my_outfit_page.dart';
import 'package:cs_310_project/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cs_310_project/views/home/home.dart';
import 'package:cs_310_project/views/my_closet/my_closet_page.dart';
import 'package:cs_310_project/views/item_detail/item_detail_page.dart';
import 'package:cs_310_project/views/planner/planner_page.dart';
import 'package:cs_310_project/views/outfit_detail/outfit_detail_page.dart';
import 'package:cs_310_project/views/outfit_creator/outfit_creator_page.dart';


void main() {
  runApp(const OutfitlyApp());
}

class OutfitlyApp extends StatefulWidget {
  const OutfitlyApp({super.key});

  @override
  State<OutfitlyApp> createState() => _OutfitlyAppState();
}

class _OutfitlyAppState extends State<OutfitlyApp> {
  
  int _selectedIndex = 0;
  final List<Widget> widgetOptions = const [
    OutlifyHome(),
    MyClosetPage(),
    MyOutfitPage(),
    PlannerPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Outfitly',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        "/home": (context) => const OutlifyHome(),
        "/my_closet": (context) => const MyClosetPage(),
        "/item_detail": (context) => const ItemDetailPage(),
        "/planner": (context) => const PlannerPage(),
        "/outfit_detail": (context) => const OutfitDetailPage(),
        "/my_outfits": (context) => const MyOutfitPage(),
        "/outfit_creator": (context) => const OutfitCreatorPage(),

      },
      home: Scaffold(bottomNavigationBar: OutfitlyBottomNavBar(currentIndex: _selectedIndex,
        onTap: _onItemTapped,),
        body: widgetOptions.elementAt(_selectedIndex),


      ),
    );
  }
}

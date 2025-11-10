import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cs_310_project/views/home/home.dart';
import 'package:cs_310_project/views/my_closet/my_closet_page.dart';
import 'package:cs_310_project/views/item_detail/item_detail_page.dart';
import 'package:cs_310_project/views/planner/planner_page.dart';
import 'package:cs_310_project/views/outfit_detail/outfit_detail_page.dart';

void main() {
  runApp(const OutfitlyApp());
}

class OutfitlyApp extends StatelessWidget {
  const OutfitlyApp({super.key});

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
      initialRoute: "/home",
      routes: {
        "/home": (context) => const OutlifyHome(),
        "/my_closet": (context) => const MyClosetPage(),
        "/item_detail": (context) => const ItemDetailPage(),
        "/planner": (context) => const PlannerPage(),
        "/outfit_detail": (context) => const OutfitDetailPage(),
      },
    );
  }
}

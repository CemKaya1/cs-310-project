import 'package:cs_310_project/views/home/home.dart';
import 'package:cs_310_project/views/item_detail/item_detail_page.dart';
import 'package:cs_310_project/views/my_closet/my_closet_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const OutlifyApp());
}

class OutlifyApp extends StatelessWidget {
  const OutlifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/home",
      routes: {"/home" : (context) => const OutlifyHome(),
      "/my_closet" : (context) => const MyClosetPage(),
      "/item_detail" : (context) => const ItemDetailPage(),
      
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const OutlifyAppPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class OutlifyAppPage extends StatefulWidget {
  const OutlifyAppPage({super.key, required this.title});
  final String title;
  @override
  State<OutlifyAppPage> createState() => _OutlifyAppPage();
}

class _OutlifyAppPage extends State<OutlifyAppPage> {
  @override
  Widget build(BuildContext context) {
    return OutlifyHome();
  }
}

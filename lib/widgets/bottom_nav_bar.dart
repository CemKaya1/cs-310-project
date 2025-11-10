import 'package:flutter/material.dart';

class OutfitlyBottomNavBar extends StatelessWidget {
  final int currentIndex;
  const OutfitlyBottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: Colors.deepPurple,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        if (index == 0) Navigator.pushNamed(context, "/home");
        if (index == 1) Navigator.pushNamed(context, "/my_closet");
        if (index == 2) Navigator.pushNamed(context, "/planner");
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.checkroom), label: "My Closet"),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: "Planner"),
      ],
    );
  }
}

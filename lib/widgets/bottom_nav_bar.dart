import 'package:flutter/material.dart';

class OutfitlyBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  const OutfitlyBottomNavBar({super.key, required this.currentIndex,required this.onTap,});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showUnselectedLabels: true,
      currentIndex: currentIndex,
      selectedItemColor: Colors.deepPurple,
      unselectedItemColor: Colors.grey,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home",),
        BottomNavigationBarItem(icon: Icon(Icons.checkroom), label: "My Closet"),
        BottomNavigationBarItem(icon: Icon(Icons.palette), label: "My Outfits"),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: "Planner"),
      ],
    );
  }
}

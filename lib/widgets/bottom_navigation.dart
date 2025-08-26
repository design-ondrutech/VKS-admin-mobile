import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final String selectedTab;
  final Function(String) onTabChange;

  const CustomBottomNav({
    super.key,
    required this.selectedTab,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _getIndex(selectedTab),
      onTap: (index) {
        String tab = _getTab(index);
        onTabChange(tab);
      },
      type: BottomNavigationBarType.fixed, 
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Overview"),
        BottomNavigationBarItem(icon: Icon(Icons.layers), label: "Schemes"),
        BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: "Goldrate"),
        BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Notifications"),
      ],
    );
  }

  int _getIndex(String tab) {
    switch (tab) {
      case "Schemes":
        return 1;
      case "GoldAdd":
        return 2;
      case "Notifications":
        return 3;
      default:
        return 0; // Overview
    }
  }

  String _getTab(int index) {
    switch (index) {
      case 1:
        return "Schemes";
      case 2:
        return "GoldAdd";
      case 3:
        return "Notifications";
      default:
        return "Overview";
    }
  }
}

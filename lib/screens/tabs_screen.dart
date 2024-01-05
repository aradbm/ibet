import 'package:flutter/material.dart';
import 'package:ibet/screens/bets/bets.dart';
import 'package:ibet/screens/profile.dart';

class TabsNav extends StatefulWidget {
  const TabsNav({super.key});
  @override
  State<TabsNav> createState() => _TabsNavState();
}

// 2 tabs

class _TabsNavState extends State<TabsNav> {
  int _selectedPageIndex = 0;
  void _selectPage(int index) {
    setState(() => _selectedPageIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = const BetsScreen();

    activePage = switch (_selectedPageIndex) {
      0 => const BetsScreen(),
      1 => const ProfileScreen(),
      _ => const ProfileScreen()
    };

    return Scaffold(
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Bets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

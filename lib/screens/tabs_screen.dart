import 'package:flutter/material.dart';
import 'package:ibet/screens/bets/joined_bets.dart';
import 'package:ibet/screens/bets/my_bets.dart';
import 'package:ibet/screens/profile.dart';

class TabsNav extends StatefulWidget {
  const TabsNav({super.key});
  @override
  State<TabsNav> createState() => _TabsNavState();
}

class _TabsNavState extends State<TabsNav> {
  int _selectedPageIndex = 1;
  void _selectPage(int index) {
    setState(() => _selectedPageIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage;

    activePage = switch (_selectedPageIndex) {
      0 => const MyBetsScreen(),
      1 => const JoinedBetsScreen(),
      2 => const ProfileScreen(),
      _ => const JoinedBetsScreen()
    };

    return Scaffold(
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.onPrimary,
        unselectedItemColor: Theme.of(context).colorScheme.onPrimaryContainer,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Created Bets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Joined Bets',
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

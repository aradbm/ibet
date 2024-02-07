import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
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
        // bottomNavigationBar: BottomNavigationBar(
        //   backgroundColor: Colors.red,
        //   onTap: _selectPage,
        //   currentIndex: _selectedPageIndex,
        //   type: BottomNavigationBarType.shifting,
        //   showUnselectedLabels: true,
        //   selectedItemColor: Theme.of(context).colorScheme.primary,
        //   unselectedItemColor: Theme.of(context).colorScheme.secondary,
        //   items: const [
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.list),
        //       label: 'Created Bets',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.money),
        //       label: 'Joined Bets',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.person),
        //       label: 'Profile',
        //     ),
        //   ],
        // ),
        bottomNavigationBar: Container(
          // I want to have a little shadow to the bottom nav bar
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, -1),
              ),
            ],
            color: Theme.of(context).colorScheme.primary.withOpacity(0.97),
          ),
          height: 95,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: GNav(
            // colors:
            color: Colors.grey[500],
            // use lighter version of the primary
            activeColor: Theme.of(context).colorScheme.primary,
            tabBackgroundColor: Theme.of(context).colorScheme.surface,
            textStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            // settings:
            curve: Curves.fastOutSlowIn,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            gap: 10,
            // iconSize: 30,
            tabBorderRadius: 25,
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(16),
            tabs: const [
              GButton(
                icon: Icons.list,
                text: 'Created Bets',
              ),
              GButton(
                icon: Icons.money,
                text: 'Joined Bets',
              ),
              GButton(
                icon: Icons.person,
                text: 'Profile',
              ),
            ],
            selectedIndex: _selectedPageIndex,
            onTabChange: _selectPage,
          ),
        ));
  }
}

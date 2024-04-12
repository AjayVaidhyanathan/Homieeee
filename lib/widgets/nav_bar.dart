import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:homieeee/screens/home_screen.dart';
import 'package:homieeee/screens/profile_screen.dart';

class AppBottomNavigationBar extends StatefulWidget {
  const AppBottomNavigationBar({super.key, this.email});

  final String? email;

  @override
  State<AppBottomNavigationBar> createState() => _AppBottomNavigationBarState();
}

class _AppBottomNavigationBarState extends State<AppBottomNavigationBar> {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);

  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const Text('Likes', style: optionStyle),
    const Text('Search', style: optionStyle),
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: GNav(
          gap: 8,
          activeColor: const Color.fromRGBO(0, 0, 0, 1),
          iconSize: 24,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
          duration: const Duration(milliseconds: 400),
          color: Colors.black,
          tabs: const [
            GButton(icon: Icons.home, text: 'Home'),
            GButton(
              icon: Icons.favorite_border,
              text: 'Explore',
            ),
            GButton(
              icon: Icons.search,
              text: 'Search',
            ),
            GButton(
              icon: Icons.settings,
              text: 'Settings',
            ),
          ],
          selectedIndex: _selectedIndex,
          onTabChange: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
        body: _widgetOptions.elementAtOrNull(_selectedIndex));
  }
}

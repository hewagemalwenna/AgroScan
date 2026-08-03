import 'package:agroscan/screens/home_screen.dart';
import 'package:agroscan/screens/settings.dart';
import 'package:flutter/material.dart';

class NavBarRoots extends StatefulWidget {
  const NavBarRoots({super.key});

  @override
  State<NavBarRoots> createState() => _NavBarRootsState();
}

class _NavBarRootsState extends State<NavBarRoots> {
  int _selectedIndex = 0;
  final _screens = [
    const HomeScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background color for the scaffold
      backgroundColor: Colors.white,
      // Display the selected screen
      body: _screens[_selectedIndex],
      // Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        // Background color for the navigation bar
        backgroundColor: const Color(0xFFE6E6FA),
        // Fixed type to show all labels
        type: BottomNavigationBarType.fixed,
        // Color for selected item
        selectedItemColor: Colors.black,
        // Color for unselected items
        unselectedItemColor: Colors.blueGrey,
        // Style for selected label
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        currentIndex: _selectedIndex, // Current selected index
        onTap: (index) {
          setState(() {
            _selectedIndex = index; // Update selected index on tap
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}

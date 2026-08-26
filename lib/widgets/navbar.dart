import 'package:agroscan/screens/home_screen.dart';
import 'package:agroscan/screens/settings.dart';
import 'package:agroscan/tools/app_theme.dart';
import 'package:flutter/material.dart';

class NavBarRoots extends StatefulWidget {
  const NavBarRoots({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<NavBarRoots> createState() => _NavBarRootsState();
}

class _NavBarRootsState extends State<NavBarRoots> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  static const _screens = [HomeScreen(), SettingsScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AgroScanTheme.surface,
          border: Border(top: BorderSide(color: AgroScanTheme.border)),
          boxShadow: [
            BoxShadow(
              color: AgroScanTheme.cardShadow.withAlpha(60),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: NavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          height: 68,
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() => _selectedIndex = index);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings_rounded),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}

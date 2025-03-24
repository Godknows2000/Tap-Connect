import 'package:flutter/material.dart';
import 'package:tapconnect/pages/bottom_navigations_pages.dart/activity_page.dart';
import 'package:tapconnect/pages/bottom_navigations_pages.dart/notification_page.dart';
import 'package:tapconnect/pages/bottom_navigations_pages.dart/profile_page.dart';
import 'package:tapconnect/pages/bottom_navigations_pages.dart/shop_page.dart';
import 'package:tapconnect/pages/homeScreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 2; // Default to Discover tab

  // List of pages for each tab
  final List<Widget> _pages = [
    const ActivityScreen(),
    const ShopScreen(),
    const HomeScreen(),
    const NotificationsScreen(),
    const ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1A1A1A),
        selectedItemColor: const Color(0xFFFFD700), // Golden for selected
        unselectedItemColor: Colors.black,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: _onTabTapped,
      ),
    );
  }
}

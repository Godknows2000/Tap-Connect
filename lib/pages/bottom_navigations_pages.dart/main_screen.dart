import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tapconnect/constants.dart';
import 'package:tapconnect/contollers/firebase_controller.dart';
import 'package:tapconnect/pages/bottom_navigations_pages.dart/activity_page.dart';
import 'package:tapconnect/pages/bottom_navigations_pages.dart/profile_page.dart';
import 'package:tapconnect/pages/bottom_navigations_pages.dart/shop_page.dart';
import 'package:tapconnect/pages/homeScreen.dart';
import 'package:tapconnect/pages/authentication/loginScreen.dart';
import 'package:tapconnect/pages/messages_screen/messages_screen.dart';

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
    const MessagesScreen(), // Replaced NotificationsScreen with MessagesScreen
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Check auth state
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        Get.offAll(() => LoginScreen());
      }
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      // Redirect to LoginScreen if no user is logged in
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAll(() => LoginScreen());
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: _pages[_currentIndex],
      backgroundColor: const Color(0x800B21B4), // Dark background
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1A1A1A),
        selectedItemColor: Colors.white, // Golden for selected
        unselectedItemColor: Colors.white,
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
            backgroundColor: Color(0xFF024CC8),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
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

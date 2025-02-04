import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hr_app/dashboard.dart';
import 'package:hr_app/social_module/chatting_module/example.dart';
import 'package:hr_app/staff_HRM_module/Screen/Staff%20HR%20Screens/profile_Screen.dart';
import 'Inquiry_Management/Inquiry_Management_Screen.dart';

class BottomNavScreen extends StatefulWidget {
  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    Dashboard(),
    InquiryManagementScreen(),
    // TestScreen(),
    ExampleTabbar(),
    profileScreen(),
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 8),
        child: GNav(
          backgroundColor: Colors.transparent,
          color: Colors.grey[600],
          activeColor: Colors.white,
          tabBackgroundColor: Colors.black,
          tabBorderRadius: 15, // Less rounded shape
          gap: 8,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          tabs: const [
            GButton(icon: Icons.home),
            GButton(icon: Icons.leaderboard_outlined),
            GButton(icon: Icons.access_time),
            GButton(icon: Icons.person),
          ],
          selectedIndex: _selectedIndex,
          onTabChange: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}




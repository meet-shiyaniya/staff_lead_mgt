import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hr_app/Inquiry_Management/test.dart';
import 'package:hr_app/dashboard.dart';
import 'package:hr_app/social_module/chatting_module/example.dart';
import 'package:hr_app/social_module/colors/colors.dart';
import 'package:hr_app/social_module/custom_widget/appbar_button.dart';
import 'package:hr_app/staff_HRM_module/Screen/Staff%20HR%20Screens/Profile/staff_Profile_Screen.dart';
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
    ExampleTabbar(),
    profileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: _selectedIndex == 2
            ? AppColors.primaryColor.withOpacity(0.7)
            : Colors.white, // Default color
        actions: [
          CustomAppBarButton(
            icon: Icons.notifications_rounded,
            color: Colors.grey.shade100,
          ),
          SizedBox(width: 15,),
        ],
        flexibleSpace: Container(color: Colors.white,),
      ),
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
          tabBorderRadius: 15,
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

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hr_app/Inquiry_Management/Inquiry_Management_Screen.dart';
import 'package:hr_app/dashboard.dart';
import 'package:hr_app/social_module/chatting_module/example.dart';
import 'package:hr_app/social_module/colors/colors.dart';
import 'package:hr_app/social_module/custom_widget/appbar_button.dart';
import 'package:hr_app/staff_HRM_module/Screen/Staff%20HR%20Screens/profile_Screen.dart';
// import 'package:hr_app/staff_HRM_module/Screen/Staff%20HR%20Screens/profile_Screen.dart';
// import 'package:hr_app/staff_HRM_module/staff_HRM_module/Screen/Staff%20HR%20Screens/profile_Screen.dart';
import 'package:lottie/lottie.dart';

// import 'dashboard_ui/main_dashboard/calender.dart'; // ✅ Import Lottie

class BottomNavScreen extends StatefulWidget {
  final bool showSuccessAnimation;
  const BottomNavScreen({Key? key, this.showSuccessAnimation = false}) : super(key: key);

  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    Dashboard(),
    InquiryManagementScreen(),
    // ExampleTabbar(),
    profileScreen(),
  ];

  bool _showAnimation = false;

  @override
  void initState() {
    super.initState();
    if (widget.showSuccessAnimation) {
      _triggerAnimation();
    }
  }

  void _triggerAnimation() async {
    setState(() {
      _showAnimation = true;
    });

    await Future.delayed(Duration(seconds: 3)); // ⏱ Animation duration

    setState(() {
      _showAnimation = false; // Hide animation after 5 seconds
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            leadingWidth: 0,
            toolbarHeight: 50,
            title: Row(
              children: [
                if (_selectedIndex == 0)
                  Image.asset("asset/appbarImage.png", height: 20),
                if (_selectedIndex == 0) const SizedBox(width: 8),
                if (_selectedIndex == 0)
                  const Text(
                    "Dashboard",
                    style: TextStyle(fontFamily: "poppins_thin", fontSize: 22),
                  ),
              ],
            ),
            backgroundColor: _selectedIndex == 2&&_selectedIndex==3
                ? AppColors.primaryColor.withOpacity(0.7)
                : Colors.white,
            actions: [
              if (_selectedIndex == 0)
              //   GestureDetector(
              //       onTap: (){
              //         // Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfessionalCalendar()));
              //       },
              //       child: Image.asset("asset/Dashboard/booking.png",height: 25,width: 25,)),
              // SizedBox(width: 10,),

              CustomAppBarButton(
                icon: Icons.notifications_rounded,
                color: Colors.grey.shade100,
              ),
            ],
            elevation: 0,
            flexibleSpace: Container(
              color: _selectedIndex == 2
                  ? AppColors.primaryColor.withOpacity(0.0)
                  : Colors.white,
            ),
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
                // GButton(icon: Icons.access_time),
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
        ),

        // ✅ Full-Screen Success Animation Overlay
        if (_showAnimation)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.7), // Semi-transparent background
              child: Center(
                child: Lottie.asset(
                  "asset/attandance_done.json", // ✅ Add your Lottie animation file
                  width: 250,
                  height: 250,
                  repeat: false,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

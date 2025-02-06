import 'package:flutter/material.dart';
import 'package:hr_app/social_module/login_screen/login_screen.dart';
import 'package:hr_app/staff_Attendance_Screen.dart';
import 'bottom_navigation.dart';


void main() {

  runApp(MaterialApp(

    debugShowCheckedModeBanner: false,
    home: StaffAttendanceScreen(),
    routes: {
      '/dashboard': (context) => BottomNavScreen(),
      '/login': (context) => LoginScreen(),
    },
  )
  );

}
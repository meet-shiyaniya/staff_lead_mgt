import 'package:flutter/material.dart';
import 'package:hr_app/Inquiry_Management/Inquiry_Management_Screen.dart';
import 'package:hr_app/social_module/chatting_module/example.dart';
import 'package:hr_app/social_module/login_screen/login_screen.dart';


import 'bottom_navigation.dart';
import 'dashboard.dart';


void main() {

  runApp(MaterialApp(

    debugShowCheckedModeBanner: false,
    // home: staffDashScreen(),
    // home:InquiryManagementScreen()
    home: BottomNavScreen(),
  )
  );

}
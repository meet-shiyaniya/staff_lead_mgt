import 'package:flutter/material.dart';
import 'package:hr_app/social_module/login_screen/login_screen.dart';
import 'bottom_navigation.dart';
import 'face_onboarding.dart';


void main() {

  runApp(MaterialApp(

    debugShowCheckedModeBanner: false,
    // home: staffDashScreen(),
    // home:InquiryManagementScreen()
    home: LoginScreen(),
  )
  );

}
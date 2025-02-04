import 'package:flutter/material.dart';
import 'package:hr_app/Inquiry_Management/Inquiry_Management_Screen.dart';
import 'package:hr_app/Inquiry_Management/test.dart';
import 'package:hr_app/social_module/login_screen/login_screen.dart';
// import 'package:hr_app/staff_HRM_module/Screen/Staff%20HR%20Screens/staff_Dash_Screen.dart';

import 'bottom_navigation.dart';
import 'dashboard.dart';


void main() {

  runApp(MaterialApp(

    debugShowCheckedModeBanner: false,
    // home: staffDashScreen(),
    // home:InquiryManagementScreen()
    home: TestScreen(),
  )
  );

}
import 'package:flutter/material.dart';
import 'package:hr_app/staff_HRM_module/Screen/Staff%20HR%20Screens/Notification/notification_Screen.dart';
import 'Inquiry_Management/test.dart';
import 'bottom_navigation.dart';


void main() {

  runApp(MaterialApp(

    debugShowCheckedModeBanner: false,
    // home: staffDashScreen(),
    // home:InquiryManagementScreen()
    home: BottomNavScreen(),
  )
  );

}
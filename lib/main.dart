import 'package:flutter/material.dart';
import 'package:hr_app/All%20Reports/test.dart';
import 'package:hr_app/Provider/UserProvider.dart';
import 'package:hr_app/Staff%20Attendance%20Options/Selfie%20Punch%20Attendance/staff_Attendance_Screen.dart';
import 'package:hr_app/social_module/login_screen/login_screen.dart';
import 'package:hr_app/splash_screen/splash_screen.dart';
import 'package:provider/provider.dart';
import 'bottom_navigation.dart';

void main() {

  runApp(

    ChangeNotifierProvider(
      create: (_)=>UserProvider(),
      child:MaterialApp(
        theme: ThemeData(
          fontFamily: 'poppins_thin',
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        title: "RealtoSmart",
        initialRoute: "/",
        routes: {
           // "/":(context)=> BottomNavScreen(),
          "/":(context)=> LoginScreen(),
          '/login': (context) => LoginScreen(),
          '/dashboard': (context) => BottomNavScreen(),
          '/attandance':(context)=>StaffAttendanceScreen()
        },
      ),

    )
// MaterialApp(
//   home: BookingScreen(),
// )
  );

}
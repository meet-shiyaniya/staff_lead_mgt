import 'package:flutter/material.dart';
import 'package:hr_app/Inquiry_Management/Inquiry%20Management%20Screens/Filters/inquiry_Filter_Screen.dart';
import 'package:hr_app/Inquiry_Management/Utils/Custom%20widgets/booking_Screen.dart';
import 'package:hr_app/Provider/UserProvider.dart';
import 'package:hr_app/Staff%20Attendance%20Options/Selfie%20Punch%20Attendance/staff_Attendance_Screen.dart';
import 'package:hr_app/Week%20Off%20Or%20Holiday/week_Off_Screen.dart';
import 'package:hr_app/social_module/login_screen/login_screen.dart';
import 'package:hr_app/splash_screen/splash_screen.dart';
import 'package:provider/provider.dart';
import 'Inquiry_Management/Inquiry_Management_Screen.dart';
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
          "/":(context)=> SplashScreen(),
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
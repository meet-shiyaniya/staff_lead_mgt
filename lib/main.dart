import 'package:flutter/material.dart';
import 'package:hr_app/Provider/UserProvider.dart';
import 'package:hr_app/social_module/login_screen/login_screen.dart';
import 'package:hr_app/splash_screen/splash_screen.dart';
import 'package:hr_app/staff_Attendance_Screen.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'bottom_navigation.dart';
import "package:http/http.dart" as https;
import 'package:path_provider/path_provider.dart';
import 'face_onboarding.dart';



void main() {

  runApp(
    ChangeNotifierProvider(
        create: (_)=>UserProvider(),
      child:MaterialApp(
        debugShowCheckedModeBanner: false,
        // home: SplashScreen(),
        title: "RealtoSmart",
        initialRoute: "/",
        routes: {
          "/":(context)=>SplashScreen(),
          '/login': (context) => LoginScreen(),
          '/dashboard': (context) => FaceOnboarding(),
        },
      ),

    )



  );

}
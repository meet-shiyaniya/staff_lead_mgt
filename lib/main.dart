import 'package:flutter/material.dart';
import 'package:hr_app/social_module/login_screen/login_screen.dart';
import 'package:hr_app/splash_screen/splash_screen.dart';
import 'bottom_navigation.dart';


void main() {

  runApp(MaterialApp(

    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
    routes: {
      '/dashboard': (context) => BottomNavScreen(),
      '/login': (context) => LoginScreen(),
    },
  )
  );

}
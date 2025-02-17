import 'package:flutter/material.dart';
import 'package:hr_app/Provider/UserProvider.dart';
import 'package:hr_app/social_module/login_screen/login_screen.dart';
import 'package:hr_app/splash_screen/splash_screen.dart';
import 'package:provider/provider.dart';
import 'bottom_navigation.dart';



void main() {

  runApp(

    ChangeNotifierProvider(
        create: (_)=>UserProvider(),
      child:MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "RealtoSmart",
        initialRoute: "/",
        routes: {
          "/":(context)=> SplashScreen(),
          '/login': (context) => LoginScreen(),
          '/dashboard': (context) => BottomNavScreen(),
        },
      ),

    )

  );

  // MaterialApp(
  //
  //   debugShowCheckedModeBanner: false,
  //   home: SplashScreen(),
  //   routes: {
  //     '/login': (context) => LoginScreen(),
  //     '/dashboard': (context) => Dashboard(),
  //   },
  //
  // ),

}
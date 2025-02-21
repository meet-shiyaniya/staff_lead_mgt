import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_app/staff_HRM_module/Screen/Color/app_Color.dart';

class mannualAttendanceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: appColor.primaryColor,
        title: Text(
          "Mark Attendance",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "poppins_thin",
            fontSize: 18,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(height: 10,),
            Container(
              height: 340,
              width: double.infinity,
              child: Image.asset("asset/Attendance Animations/manAttendance.png", height: 350,)
            ),

            SizedBox(height: 10,),
            Text("Begin Your Workday", style: TextStyle(color: Colors.black, fontSize: 17, fontFamily: "poppins_thin"),),
            SizedBox(height: 2,),
            Text("Tap the button to mark your attendance and start your day.", style: TextStyle(color: Colors.grey.shade600, fontSize: 15, fontFamily: "poppins_thin"),),

            SizedBox(height: 50,),
            // Day Start Button
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Add functionality to mark attendance
                      Fluttertoast.showToast(msg: "✅ Attendance marked: Present");
                    },
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue, Colors.purple],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.3),
                            spreadRadius: 5,
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Day", style: TextStyle(color: Colors.white, fontFamily: "poppins_thin", fontSize: 15),),
                          Text("Start", style: TextStyle(color: Colors.white, fontFamily: "poppins_thin", fontSize: 15),),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text("Tap to Start Your Day", style: TextStyle(color: Colors.grey[600], fontSize: 15, fontFamily: "poppins_thin"),),
                  ),
                ],
              ),

            ),
          ],
        ),
      ),
    );
  }
}
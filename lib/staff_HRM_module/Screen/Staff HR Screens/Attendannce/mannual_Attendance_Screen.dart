import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../../../bottom_navigation.dart';
import '../../Color/app_Color.dart';
// import '../../../../Screen/Color/app_Color.dart';
// import 'package:realtosmart/staff_HRM_module/Screen/Color/app_Color.dart';
//
// import '../../../../bottom_navigation.dart';

class mannualAttendanceScreen extends StatefulWidget {
  @override
  State<mannualAttendanceScreen> createState() => _mannualAttendanceScreenState();
}

class _mannualAttendanceScreenState extends State<mannualAttendanceScreen> {

  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  static const String baseUrl = 'https://admin.dev.ajasys.com/api';

  Future<bool> _sendMemberAttendanceData () async {

    String editBioStatus = "0";
    String createdAtDateTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()).toString();
    String entryDateTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()).toString();

    final url = Uri.parse('$baseUrl/insert_attendance_newday');

    try {

      String? token = await _secureStorage.read(key: 'token');

      if (token == null) {

        return false;

      }

      Map<String, String> bodyData = {

        "token": token,
        "edit_bio": editBioStatus,
        "created_at": createdAtDateTime,
        "entry_date_time": entryDateTime,

      };

      final response = await http.post(

        url,
        headers: {

          'Content-Type': 'application/json'

        },
        body: jsonEncode(bodyData)

      );

      if (response.statusCode == 200) {

        // final data = jsonDecode(response.body);

        Fluttertoast.showToast(msg: "✅ Attendance marked: Present");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavScreen()));
        return true;

      } else {

        Fluttertoast.showToast(msg: "Failed to send attendance data!");
        return false;

      }

    } catch (e) {

      Fluttertoast.showToast(msg: "Something Went Wrong!");
      return false;

    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        centerTitle: true,

        backgroundColor: appColor.primaryColor,

        title: Text("Mark Attendance", style: TextStyle(color: Colors.white, fontFamily: "poppins_thin", fontSize: 18,),),

      ),

      backgroundColor: Colors.white,

      body: Padding(

        padding: const EdgeInsets.symmetric(horizontal: 15.0),

        child: Column(

          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            SizedBox(height: 25,),

            Container(

              height: 340,
              width: double.infinity,
              child: Image.asset("asset/Attendance Animations/manAttendance.png", height: 350,)

            ),

            SizedBox(height: 15,),

            Text("Begin Your Workday", style: TextStyle(color: Colors.black, fontSize: 17, fontFamily: "poppins_thin"),),

            SizedBox(height: 2,),

            Text("Tap the button to mark your attendance and start your day.", style: TextStyle(color: Colors.grey.shade600, fontSize: 15, fontFamily: "poppins_thin"),),

            // Day Start Button
            Expanded(

              child: Column(

                mainAxisAlignment: MainAxisAlignment.center,

                children: [

                  GestureDetector(

                    onTap: () {

                      _sendMemberAttendanceData();

                    },

                    child: Container(

                      width: 90,
                      height: 90,

                      decoration: BoxDecoration(

                        gradient: LinearGradient(

                          colors: [Colors.purple.shade700, Colors.deepPurple.shade700],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,

                        ),

                        shape: BoxShape.circle,

                        boxShadow: [BoxShadow(color: Colors.indigo.shade100, spreadRadius: 4, blurRadius: 8, offset: Offset(0, 3),),],

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
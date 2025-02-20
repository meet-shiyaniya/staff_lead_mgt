import 'package:flutter/material.dart';
import 'package:hr_app/Staff%20Attendance%20Options/Selfie%20Punch%20Attendance/staff_Attendance_Screen.dart';
import 'package:lottie/lottie.dart';

class qrOnboardingScreen extends StatefulWidget {
  const qrOnboardingScreen({Key? key}) : super(key: key);

  @override
  State<qrOnboardingScreen> createState() => _qrOnboardingScreenState();
}

class _qrOnboardingScreenState extends State<qrOnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body:Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset('asset/qrScanner.json', fit: BoxFit.contain, width: 300, height: 300),
                Text("Scan Your QR Code",style:TextStyle(fontFamily:"poppins_thin",fontWeight: FontWeight.bold, fontSize: 17)),
                SizedBox(height: 4,),
                Text("Align the QR code within the frame",style:TextStyle(fontFamily:"poppins_light",fontWeight: FontWeight.bold,color: Colors.grey.shade600, fontSize: 13)),
                Text("to mark your attendance.",style:TextStyle(fontFamily:"poppins_light",fontWeight: FontWeight.bold,color: Colors.grey.shade600, fontSize: 13)),
              ],
            ),
            GestureDetector(
              onTap: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>StaffAttendanceScreen()));
              },
              child: Container(
                height:50,
                width: double.infinity,
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.deepPurple.shade300
                ),
                child: Center(
                  child:Text("Make Your Attendance ",style: TextStyle(fontFamily: "poppins_thin",color: Colors.white),),
                ),
              ),
            )

          ],
        )
    );
  }
}
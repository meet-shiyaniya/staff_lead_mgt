import 'package:flutter/material.dart';
import 'package:hr_app/staff_Attendance_Screen.dart';
import 'package:hr_app/staff_HRM_module/Screen/Color/app_Color.dart';
import 'package:lottie/lottie.dart';

class FaceOnboarding extends StatefulWidget {
  const FaceOnboarding({Key? key}) : super(key: key);

  @override
  State<FaceOnboarding> createState() => _FaceOnboardingState();
}

class _FaceOnboardingState extends State<FaceOnboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(),
          Column(
            children: [
              Lottie.asset('asset/faceScanner.json', fit: BoxFit.contain, width: 200, height: 200),
              SizedBox(height:25),
              Text("Face Recognition & Location Check",style:TextStyle(fontFamily:"poppins_thin", fontSize: 17, color: Colors.black)),
              SizedBox(height: 5,),
              Text("Enable location services and make sure\nyou are within the office premises.",style:TextStyle(fontFamily:"poppins_thin",fontWeight: FontWeight.w100,color: Colors.grey.shade500, fontSize: 13), textAlign: TextAlign.center,)
            ],
          ),
          GestureDetector(
            onTap: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => staffAttendanceScreen()));
            },
            child: Container(
              height:50,
              width: double.infinity,
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: appColor.primaryColor,
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

import 'package:flutter/material.dart';
import 'package:hr_app/social_module/colors/colors.dart';
import 'package:hr_app/staff_Attendance_Screen.dart';
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
              SizedBox(height:20),
              Text("Verify your Identity",style:TextStyle(fontFamily:"poppins_thin",fontWeight: FontWeight.bold)),
              Align(
                  alignment: Alignment.center,
                  child: Text("We've sent a password recover\ninstruction to your emails",style:TextStyle(fontFamily:"poppins",fontWeight: FontWeight.bold,color: Colors.grey.shade600)))
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
                color: AppColors.primaryColor.withOpacity(0.6)
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

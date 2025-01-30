import 'package:flutter/material.dart';
import 'package:hr_app/Model/HR%20Screen%20Models/hr_Option_Model.dart';
import 'package:hr_app/Screen/Color/app_Color.dart';
import 'package:hr_app/Screen/Staff%20HR%20Screens/Attendannce/attendance_Screen.dart';
import 'package:hr_app/Screen/Staff%20HR%20Screens/Profile/staff_Profile_Screen.dart';
import 'package:hr_app/Screen/Staff%20HR%20Screens/Staff%20Leave/staff_Leave_Home_Screen.dart';

class staffDashScreen extends StatefulWidget {
  const staffDashScreen({super.key});

  @override
  State<staffDashScreen> createState() => _staffDashScreenState();
}

class _staffDashScreenState extends State<staffDashScreen> {

  List<hrOptionModel> hrOptionList = [

    hrOptionModel("Attendance", "attendance.png"),
    hrOptionModel("Staff Profile", "staff.png"),
    hrOptionModel("Leave", "leave.png"),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: appColor.backgroundColor,

      appBar: AppBar(

        backgroundColor: appColor.primaryColor,

        title: Text("Staff Management", style: TextStyle(color: appColor.appbarTxtColor, fontSize: 17, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),),

        centerTitle: true,

        foregroundColor: appColor.appbarTxtColor,

      ),

      body: Padding(

        padding: const EdgeInsets.symmetric(horizontal: 18.0),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            SizedBox(height: 35,),

            Text("Staff Management", style: TextStyle(color: appColor.bodymainTxtColor, fontWeight: FontWeight.bold, fontSize: 22, fontFamily: "poppins_thin"),),

            SizedBox(height: 25,),

            Expanded(

              child: GridView.builder(

                itemCount: hrOptionList.length,

                physics: NeverScrollableScrollPhysics(),

                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(

                  crossAxisCount: 2,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 20,
                  mainAxisExtent: 160,

                ),

                itemBuilder: (context, index) {

                  final option = hrOptionList[index];

                  return GestureDetector(

                    onTap: () {

                      Navigator.push(context, MaterialPageRoute(builder: (context) => index == 0 ? attendanceScreen() : index == 1 ? staffProfileScreen() : staffLeaveHomeScreen()));

                    },

                    child: Container(

                      decoration: BoxDecoration(

                        color: appColor.subPrimaryColor,

                        boxShadow: [

                          BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 3, blurRadius: 8, offset: Offset(3, 3),),

                        ],

                        borderRadius: BorderRadius.circular(10),

                        border: Border.all(color: appColor.primaryColor),

                      ),

                      child: Column(
                        children: [

                          SizedBox(height: 24,),

                          Container(

                            height: 80,

                            child: Image.asset("asset/HR Screen Images/${option.img}", fit: BoxFit.cover,),

                          ),

                          Spacer(),

                          Text(option.title, style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: "thin"),),

                          SizedBox(height: 16,),

                        ],
                      ),

                    ),
                  );

                },

              ),

            ),

          ],

        ),

      ),

    );

  }

}
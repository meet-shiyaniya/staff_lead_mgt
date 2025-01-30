import 'package:flutter/material.dart';
import 'package:hr_app/Screen/HR%20Screens/Leave/Leave%20Menu%20Screens/Leave/show_Leave_Details_Screen.dart';
import 'package:hr_app/Screen/HR%20Screens/Leave/Leave%20Menu%20Screens/Request/request_Screen.dart';

import '../../Color/app_Color.dart';

class leaveHomeScreen extends StatefulWidget {
  const leaveHomeScreen({super.key});

  @override
  State<leaveHomeScreen> createState() => _leaveHomeScreenState();
}

class _leaveHomeScreenState extends State<leaveHomeScreen> {

  bool isSelected = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: appColor.backgroundColor,

      appBar: AppBar(

        backgroundColor: appColor.primaryColor,

        title: Text("Leave Form", style: TextStyle(color: appColor.appbarTxtColor, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),),

        centerTitle: true,

        foregroundColor: Colors.transparent,

        leading: IconButton(

          onPressed: (){
            Navigator.pop(context);
          },

          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20,),

        ),

      ),

      body: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Container(

            height: 60,
            width: MediaQuery.of(context).size.width.toDouble(),
            color: Colors.grey.shade100,

            child: Padding(

              padding: const EdgeInsets.symmetric(horizontal: 16.0),

              child: Row(

                mainAxisAlignment: MainAxisAlignment.spaceAround,

                children: [

                  Center(

                    child: GestureDetector(

                      onTap: () {

                        setState(() {

                          isSelected = false;

                        });

                      },

                      child: Container(

                       height: 40,
                       width: 174,

                        decoration: BoxDecoration(

                          color: isSelected ? Colors.transparent : appColor.primaryColor,

                          borderRadius: BorderRadius.circular(20),

                          border: Border.all(color: isSelected ? appColor.primaryColor : Colors.transparent, width: 1.5),

                        ),

                        child: Row(
                          children: [

                            SizedBox(width: 2.1,),

                            Container(

                              height: 34,
                              width: 34,

                              decoration: BoxDecoration(

                                shape: BoxShape.circle,
                                color: isSelected ? appColor.boxColor : Colors.white,

                              ),

                              child: Center(

                                child: Icon(Icons.request_page_rounded, color: Colors.black, size: 20,),

                              ),

                            ),

                            SizedBox(width: 10,),

                            Text("Request", style: TextStyle(color: isSelected ? Colors.black : Colors.white, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 14),),

                          ],
                        ),

                      ),

                    ),

                  ),

                  // Spacer(),

                  Center(

                    child: GestureDetector(

                      onTap: () {

                        setState(() {

                          isSelected = true;

                        });

                      },

                      child: Container(

                        height: 40,
                        width: 174,

                        decoration: BoxDecoration(

                          color: isSelected ? appColor.primaryColor : Colors.transparent,

                          borderRadius: BorderRadius.circular(20),

                          border: Border.all(color: isSelected ? Colors.transparent : appColor.primaryColor, width: 1.5),

                        ),

                        child: Row(
                          children: [

                            SizedBox(width: 2.1,),

                            Container(

                              height: 34,
                              width: 34,

                              decoration: BoxDecoration(

                                  shape: BoxShape.circle,
                                  color: isSelected ? Colors.white : appColor.boxColor,

                              ),

                              child: Center(

                                child: Icon(Icons.leave_bags_at_home_rounded, color: Colors.black, size: 20,),

                              ),

                            ),

                            SizedBox(width: 10,),

                            Text("Leave", style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 14),),

                          ],
                        ),

                      ),

                    ),

                  ),

                ],

              ),

            ),

          ),

          Expanded(

            child: isSelected ? showLeaveDetailsScreen() : requestScreen(),

          ),

          SizedBox(height: 5,),

        ],

      ),

    );
  }
}
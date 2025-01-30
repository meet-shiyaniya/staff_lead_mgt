import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_app/Model/HR%20Screen%20Models/HR%20Master%20Models/HR%20Master%20Menu%20Models/shift_Model.dart';
import 'package:hr_app/Screen/Color/app_Color.dart';
import 'package:hr_app/Screen/HR%20Screens/HR%20Master/HR%20Master%20Menu%20Screens/Shift%20Management/add_Shift_Screen.dart';
import 'package:hr_app/Screen/HR%20Screens/HR%20Master/HR%20Master%20Menu%20Screens/Shift%20Management/edit_Shift_Screen.dart';

class shiftManagementScreen extends StatefulWidget {
  const shiftManagementScreen({super.key});

  @override
  State<shiftManagementScreen> createState() => _shiftManagementScreenState();
}

class _shiftManagementScreenState extends State<shiftManagementScreen> {

  List<shiftModel> shiftList = [

    shiftModel(no: 1, shiftName: "Morning Shift", inTime: "08:00 AM",outTime: "04:00 PM", totalWorkingHours: "8 hrs",),

    shiftModel(no: 2, shiftName: "Afternoon Shift", inTime: "12:00 PM", outTime: "08:00 PM", totalWorkingHours: "8 hrs",),

    shiftModel(no: 3, shiftName: "Night Shift", inTime: "10:00 PM", outTime: "06:00 AM", totalWorkingHours: "8 hrs",),

    shiftModel(no: 4, shiftName: "Flexible Shift", inTime: "09:00 AM", outTime: "05:00 PM", totalWorkingHours: "8 hrs",),

    shiftModel(no: 5, shiftName: "Split Shift", inTime: "06:00 AM", outTime: "02:00 PM", totalWorkingHours: "8 hrs",),

  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.white,

      body: Padding(

        padding: const EdgeInsets.symmetric(horizontal: 16.0),

        child: Column(
          children: [

            SizedBox(height: 35,),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Icon(Icons.cases_sharp, size: 22, color: appColor.bodymainTxtColor,),

                SizedBox(width: 10,),

                Text("Shift Management", style: TextStyle(color: appColor.bodymainTxtColor, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),),

              ],
            ),

            SizedBox(height: 25,),

            Expanded(

              child: ListView.builder(

                // shrinkWrap: true,

                itemCount: shiftList.length,

                itemBuilder: (context, index) {

                  final shift = shiftList[index];

                  return Padding(

                    padding: const EdgeInsets.symmetric(vertical: 10.0),

                    child: Container(

                      height: 100,
                      width: MediaQuery.of(context).size.width.toDouble(),

                      decoration: BoxDecoration(

                        color: appColor.subPrimaryColor,

                        borderRadius: BorderRadius.circular(15),

                        boxShadow: [

                          BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 4, offset: Offset(1, 1),),

                        ],

                      ),

                      child: Center(
                        child: ListTile(

                          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),

                          leading: Container(

                            // height: 100,
                            width: 44,

                            decoration: BoxDecoration(

                              borderRadius: BorderRadius.circular(10),

                              color: appColor.primaryColor,

                            ),

                            child: Center(

                              child: Text(shift.no.toString(), style: TextStyle(color: Colors.white, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 12),),

                            ),

                          ),

                          isThreeLine: true,

                          title: Text(shift.shiftName, style: TextStyle(color: appColor.bodymainTxtColor, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),),

                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [

                                  Icon(Icons.share_arrival_time, size: 18, color: appColor.primaryColor,),

                                  SizedBox(width: 5,),

                                  Text(shift.inTime, style: TextStyle(color: Colors.grey.shade600, fontFamily: "poppins_thin", fontWeight: FontWeight.w500, fontSize: 11.5),),

                                  SizedBox(width: 14,),

                                  Icon(Icons.timer_off_rounded, size: 15, color: appColor.primaryColor,),

                                  SizedBox(width: 5,),

                                  Text(shift.outTime, style: TextStyle(color: Colors.grey.shade600, fontFamily: "poppins_thin", fontWeight: FontWeight.w500, fontSize: 11.5),),

                                ],
                              ),

                              SizedBox(height: 3,),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [

                                  Icon(Icons.access_time_filled_rounded, size: 15.5, color: appColor.primaryColor,),

                                  SizedBox(width: 5,),

                                  Text(shift.totalWorkingHours, style: TextStyle(color: Colors.grey.shade600, fontFamily: "poppins_thin", fontWeight: FontWeight.w500, fontSize: 11.5),),

                                ],
                              ),

                            ],
                          ),

                          trailing: PopupMenuButton<String>(

                            color: Colors.grey.shade100,

                            position: PopupMenuPosition.values[0],

                            shape: RoundedRectangleBorder(

                              borderRadius: BorderRadius.circular(8),

                              // side: BorderSide(color: appColor.favColor),

                            ),

                            icon: Icon(Icons.more_vert_rounded, size: 20, color: appColor.primaryColor,),

                            onSelected: (value) {

                              if (value == 'edit') {

                                print("Edit clicked");

                              } else if (value == 'delete') {

                                print("Delete clicked");

                              }

                            },

                            itemBuilder: (BuildContext context) {

                              return [

                                PopupMenuItem<String>(

                                  value: 'edit',

                                  child: Row(
                                    children: [

                                      Icon(Icons.edit_off_rounded, size: 18, color: Colors.yellow.shade800,),

                                      SizedBox(width: 6,),

                                      Text("Edit", style: TextStyle(color: Colors.yellow.shade800, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 13),),

                                    ],
                                  ),

                                  onTap: () {

                                    Navigator.push(context, MaterialPageRoute(builder: (context) => editShiftScreen(

                                      shift: shift,

                                    )));

                                  },

                                ),

                                PopupMenuItem<String>(

                                  value: 'delete',

                                  child: Row(
                                    children: [

                                      Icon(Icons.delete_forever_rounded, size: 18, color: Colors.red.shade600,),

                                      SizedBox(width: 6,),

                                      Text("Delete", style: TextStyle(color: Colors.red.shade600, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 13),),

                                    ],
                                  ),

                                  onTap: () {

                                    Fluttertoast.showToast(msg: "Shift Deleted Successfully");

                                  },

                                ),

                              ];

                            },

                          ),

                        ),
                      ),

                    ),
                  );

                },

              ),

            ),

          ],
        ),

      ),

      floatingActionButton: FloatingActionButton(

        backgroundColor: appColor.primaryColor,

        child: Icon(Icons.add, color: appColor.appbarTxtColor, size: 26,),

        onPressed: () {

          Navigator.push(context, MaterialPageRoute(builder: (context) => addShiftScreen()));

        },

        shape: RoundedRectangleBorder(

          borderRadius: BorderRadius.circular(30),

        ),

        elevation: 4,

      ),

    );

  }

}
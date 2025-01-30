import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_app/Model/HR%20Screen%20Models/HR%20Master%20Models/HR%20Master%20Menu%20Models/leave_Model.dart';
import 'package:hr_app/Screen/HR%20Screens/HR%20Master/HR%20Master%20Menu%20Screens/Leave%20Screens/add_Leave_Screen.dart';
import 'package:hr_app/Screen/HR%20Screens/HR%20Master/HR%20Master%20Menu%20Screens/Leave%20Screens/edit_Leave_Screen.dart';

import '../../../../Color/app_Color.dart';

class leaveScreen extends StatefulWidget {
  const leaveScreen({super.key});

  @override
  State<leaveScreen> createState() => _leaveScreenState();
}

class _leaveScreenState extends State<leaveScreen> {

  final List<leaveModel> leaveHolidayList = [

    leaveModel(no: 1, leaveName: 'Casual Leave', leaveType: 'Personal', paidType: 'UnPaid', annualLimit: 12),
    leaveModel(no: 2, leaveName: 'Sick Leave', leaveType: 'Medical', paidType: 'Paid', annualLimit: 10),
    leaveModel(no: 3, leaveName: 'Maternity Leave', leaveType: 'Special', paidType: 'Paid', annualLimit: 26),
    leaveModel(no: 4, leaveName: 'Paternity Leave', leaveType: 'Special', paidType: 'Unpaid', annualLimit: 10),
    leaveModel(no: 5, leaveName: 'Unpaid Leave', leaveType: 'Personal', paidType: 'Unpaid', annualLimit: 0),
    leaveModel(no: 6, leaveName: 'Study Leave', leaveType: 'Professional', paidType: 'Paid', annualLimit: 30),
    leaveModel(no: 7, leaveName: 'Bereavement Leave', leaveType: 'Special', paidType: 'Paid', annualLimit: 5),
    leaveModel(no: 8, leaveName: 'Compensatory Leave', leaveType: 'Work', paidType: 'Unpaid', annualLimit: 0),

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

                Icon(Icons.home_work, size: 22, color: appColor.bodymainTxtColor,),

                SizedBox(width: 10,),

                Text("Leave Management", style: TextStyle(color: appColor.bodymainTxtColor, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),),

              ],
            ),

            SizedBox(height: 25,),

            Expanded(

              child: ListView.builder(

                itemCount: leaveHolidayList.length,

                itemBuilder: (context, index) {

                  final leave = leaveHolidayList[index];

                  return Padding(

                    padding: const EdgeInsets.only(bottom: 15.0),

                    child: Container(

                      height: 180,
                      width: MediaQuery.of(context).size.width.toDouble(),

                      decoration: BoxDecoration(

                        color: appColor.subPrimaryColor,

                        borderRadius: BorderRadius.circular(15),

                        boxShadow: [

                          BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1.6, blurRadius: 4, offset: Offset(2, 2),),

                        ],

                      ),

                      child: Column(

                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [

                          SizedBox(height: 16,),

                          ListTile(

                            leading: Container(

                              height: 40,
                              width: 40,

                              decoration: BoxDecoration(

                                shape: BoxShape.circle,

                                color: appColor.primaryColor,

                              ),

                              child: Center(

                                child: Text(leave.no.toString(), style: TextStyle(color: appColor.appbarTxtColor, fontSize: 13.5, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),),

                              ),

                            ),

                            title: Text(leave.leaveName, style: TextStyle(color: appColor.bodymainTxtColor, fontSize: 14.5, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),),

                            subtitle: Text(leave.leaveType, style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w600, fontFamily: "poppins_thin"),),

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

                                      Navigator.push(context, MaterialPageRoute(builder: (context) => editLeaveScreen(

                                        leave: leave,

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

                                      Fluttertoast.showToast(msg: "Leave Deleted Successfully");

                                    },

                                  ),

                                ];

                              },

                            ),

                          ),

                          Padding(

                            padding: const EdgeInsets.symmetric(horizontal: 16.0),

                            child: Divider(color: Colors.grey.shade400,),

                          ),

                          Padding(

                            padding: const EdgeInsets.symmetric(horizontal: 16.0),

                            child: Row(

                              children: [

                                Column(

                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [

                                    SizedBox(height: 4,),

                                    Text("Paid Type", style: TextStyle(color: Colors.grey.shade700, fontSize: 12.6, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),),

                                    SizedBox(height: 10,),

                                    Container(

                                      height: 28,
                                      width: 100,

                                      decoration: BoxDecoration(

                                        color: leave.paidType == "Paid" ? Colors.green.shade100 : Colors.red.shade100,

                                        borderRadius: BorderRadius.circular(20),

                                        border: Border.all(color: leave.paidType == "Paid" ? Colors.green.shade600 : Colors.red.shade600,),

                                      ),

                                      child: Center(

                                        child: Text(leave.paidType, style: TextStyle(color: leave.paidType == "Paid" ? Colors.green.shade600 : Colors.red.shade600, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),)

                                      ),

                                    ),

                                  ],
                                ),

                                Spacer(),

                                Column(

                                  crossAxisAlignment: CrossAxisAlignment.end,

                                  children: [

                                    SizedBox(height: 4,),

                                    Text("Annual Limit", style: TextStyle(color: Colors.grey.shade700, fontSize: 12.6, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),),

                                    SizedBox(height: 9,),

                                    Container(

                                      height: 28,
                                      width: 28,

                                      decoration: BoxDecoration(

                                        color: appColor.boxColor,

                                        shape: BoxShape.circle,

                                        border: Border.all(color: appColor.primaryColor),

                                      ),

                                      child: Center(

                                          child: Text(leave.annualLimit.toString(), style: TextStyle(color: appColor.primaryColor, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),)

                                      ),

                                    ),

                                  ],
                                ),

                              ],
                            ),
                          ),

                        ],
                      ),

                    ),

                  );

                },

              ),

            ),

            SizedBox(height: 2,),

          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(

        backgroundColor: appColor.primaryColor,

        child: Icon(Icons.add, color: appColor.appbarTxtColor, size: 26,),

        onPressed: () {

          Navigator.push(context, MaterialPageRoute(builder: (context) => addLeaveScreen()));

        },

        shape: RoundedRectangleBorder(

          borderRadius: BorderRadius.circular(30),

        ),

        elevation: 4,

      ),

    );
  }
}
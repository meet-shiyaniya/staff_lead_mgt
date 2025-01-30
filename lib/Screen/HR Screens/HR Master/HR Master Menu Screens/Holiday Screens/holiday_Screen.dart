import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_app/Model/HR%20Screen%20Models/HR%20Master%20Models/HR%20Master%20Menu%20Models/holiday_Model.dart';
import 'package:hr_app/Screen/HR%20Screens/HR%20Master/HR%20Master%20Menu%20Screens/Holiday%20Screens/add_Holiday_Screen.dart';
import 'package:hr_app/Screen/HR%20Screens/HR%20Master/HR%20Master%20Menu%20Screens/Holiday%20Screens/edit_Holiday_Screen.dart';
import '../../../../Color/app_Color.dart';

class holidayScreen extends StatefulWidget {
  const holidayScreen({super.key});

  @override
  State<holidayScreen> createState() => _holidayScreenState();
}

class _holidayScreenState extends State<holidayScreen> {

  List<holidayModel> holidayList = [

    holidayModel(no: 1, holidayName: "New Year's Celebration", type: "Public Holiday", paidType: "Paid", startHolidayDate: "31-01-2025", endHolidayDate: "31-03-2025",),

    holidayModel(no: 2, holidayName: "Republic Day", type: "National Holiday", paidType: "Unpaid", startHolidayDate: "26-01-2025", endHolidayDate: "28-01-2025",),

    holidayModel(no: 3, holidayName: "Eid-al-Fitr", type: "Religious Holiday", paidType: "Unpaid", startHolidayDate: "20-04-2025", endHolidayDate: "21-04-2025",),

    holidayModel(no: 4, holidayName: "Independence Day", type: "National Holiday", paidType: "Paid", startHolidayDate: "15-08-2025", endHolidayDate: "20-08-2025",),

    holidayModel(no: 5, holidayName: "Diwali", type: "Cultural Holiday", paidType: "Unpaid", startHolidayDate: "09-11-2025", endHolidayDate: "11-11-2025",),

  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.white,

      body: Padding(

        padding: const EdgeInsets.symmetric(horizontal: 16.0),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            SizedBox(height: 35,),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Icon(Icons.wallet_giftcard_rounded, size: 22, color: appColor.bodymainTxtColor,),

                SizedBox(width: 10,),

                Text("Holiday Management", style: TextStyle(color: appColor.bodymainTxtColor, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),),

              ],
            ),

            SizedBox(height: 25,),

            Expanded(

              child: ListView.builder(

                itemCount: holidayList.length,

                itemBuilder: (context, index) {

                  final holiday = holidayList[index];

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

                                child: Text(holiday.no.toString(), style: TextStyle(color: appColor.appbarTxtColor, fontSize: 13.5, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),),

                              ),

                            ),

                            title: Text(holiday.holidayName, style: TextStyle(color: appColor.bodymainTxtColor, fontSize: 14.5, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),),

                            subtitle: Text(holiday.type, style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w600, fontFamily: "poppins_thin"),),

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

                                      Navigator.push(context, MaterialPageRoute(builder: (context) => editHolidayScreen(

                                        holiday: holiday,

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

                                      Fluttertoast.showToast(msg: "Holiday Plan Deleted Successfully");

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

                                        color: holiday.paidType == "Paid" ? Colors.green.shade100 : Colors.red.shade100,

                                        borderRadius: BorderRadius.circular(20),

                                        border: Border.all(color: holiday.paidType == "Paid" ? Colors.green.shade600 : Colors.red.shade600,),

                                      ),

                                      child: Center(

                                          child: Text(holiday.paidType, style: TextStyle(color: holiday.paidType == "Paid" ? Colors.green.shade600 : Colors.red.shade600, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),)

                                      ),

                                    ),

                                  ],
                                ),

                                Spacer(),

                                Column(

                                  crossAxisAlignment: CrossAxisAlignment.end,

                                  children: [

                                    SizedBox(height: 4,),

                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [

                                        Icon(Icons.flight_rounded, size: 16, color: appColor.primaryColor,),

                                        SizedBox(width: 6,),

                                        Text(holiday.startHolidayDate, style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w500, fontSize: 11),),

                                      ],
                                    ),

                                    SizedBox(height: 9,),

                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [

                                        Icon(Icons.flight_land_rounded, size: 16, color: appColor.primaryColor,),

                                        SizedBox(width: 6,),

                                        Text(holiday.endHolidayDate, style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w500, fontSize: 11),),

                                      ],
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

          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(

        backgroundColor: appColor.primaryColor,

        child: Icon(Icons.add, color: appColor.appbarTxtColor, size: 26,),

        onPressed: () {

          Navigator.push(context, MaterialPageRoute(builder: (context) => addHolidayScreen()));

        },

        shape: RoundedRectangleBorder(

          borderRadius: BorderRadius.circular(30),

        ),

        elevation: 4,

      ),

    );

  }

}
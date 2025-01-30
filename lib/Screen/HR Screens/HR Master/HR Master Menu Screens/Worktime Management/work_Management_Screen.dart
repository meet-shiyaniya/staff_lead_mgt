import 'package:flutter/material.dart';
import 'package:hr_app/Screen/HR%20Screens/HR%20Master/HR%20Master%20Menu%20Screens/Worktime%20Management/edit_Work_Screen.dart';
import '../../../../../Model/HR Screen Models/HR Master Models/HR Master Menu Models/work_Model.dart';
import '../../../../Color/app_Color.dart';

class workManagementScreen extends StatefulWidget {
  const workManagementScreen({super.key});

  @override
  State<workManagementScreen> createState() => _workManagementScreenState();
}

class _workManagementScreenState extends State<workManagementScreen> {

  List<workModel> workList = [

    workModel(no: 1, departmentName: "Telecaller Department", fullDayTime: "08:00", halfDayTime: "04:00", maxOTAllow: "02:00", maxLateNumber: 3, color: Colors.blue.shade100, subColor: Colors.blue.shade400),

    workModel(no: 2, departmentName: "Marketing Daparment", fullDayTime: "09:00", halfDayTime: "04:30", maxOTAllow: "03:00", maxLateNumber: 2, color: Colors.red.shade100, subColor: Colors.red.shade400),

    workModel(no: 3, departmentName: "Site Sales Department", fullDayTime: "08:30", halfDayTime: "04:15", maxOTAllow: "04:00", maxLateNumber: 1, color: Colors.green.shade100, subColor: Colors.green.shade400),

    workModel(no: 4, departmentName: "Admin Department", fullDayTime: "07:45", halfDayTime: "03:52", maxOTAllow: "01:30", maxLateNumber: 0, color: Colors.cyan.shade100, subColor: Colors.cyan.shade400),

    workModel(no: 5, departmentName: "Membership Director 2", fullDayTime: "10:00", halfDayTime: "05:00", maxOTAllow: "03:30", maxLateNumber: 5, color: Colors.purple.shade100, subColor: Colors.purple.shade400),

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

                Icon(Icons.calendar_month_rounded, size: 22, color: appColor.bodymainTxtColor,),

                SizedBox(width: 10,),

                Text("Worktime Management", style: TextStyle(color: appColor.bodymainTxtColor, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),),

              ],
            ),

            SizedBox(height: 25,),

            Expanded(

              child: ListView.builder(

                itemCount: workList.length,

                itemBuilder: (context, index) {

                  final dept = workList[index];

                  return Padding(

                    padding: const EdgeInsets.only(bottom: 20.0),

                    child: Container(

                      height: 170,

                      width: MediaQuery.of(context).size.width.toDouble(),

                      child: Stack(

                        children: [

                          Container(

                            height: 170,
                            width: MediaQuery.of(context).size.width.toDouble(),

                            decoration: BoxDecoration(

                              color: dept.color,

                              borderRadius: BorderRadius.circular(15),

                              // border: Border.all(color: appColor.primaryColor, width: 1.3),

                            ),

                            child: Column(

                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [

                                SizedBox(height: 16,),

                                Row(

                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,

                                  children: [

                                    SizedBox(width: 70,),

                                    Text(dept.departmentName, style: TextStyle(color: appColor.bodymainTxtColor, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),),

                                    Spacer(),

                                    GestureDetector(

                                      onTap: () {

                                        Navigator.push(context, MaterialPageRoute(builder: (context) => editWorkScreen(

                                          dept: dept,

                                        )));

                                      },

                                      child: Container(

                                        height: 20,
                                        width: 20,

                                        child: Center(

                                          child: Image.network("https://cdn-icons-png.flaticon.com/512/84/84380.png", color: Colors.black, fit: BoxFit.cover,),

                                        ),

                                      ),

                                    ),

                                    SizedBox(width: 15,),

                                  ],
                                ),
                                
                                SizedBox(height: 38,),

                                Padding(

                                  padding: const EdgeInsets.symmetric(horizontal: 15.0),

                                  child: Row(

                                    children: [

                                      Icon(Icons.access_time, color: Colors.green.shade900, size: 17.5,),

                                      SizedBox(width: 2,),

                                      Text("full day time : ", style: TextStyle(color: Colors.grey.shade800, fontSize: 12.5, fontWeight: FontWeight.w500, fontFamily: "poppins_thin"),),

                                      Text(dept.fullDayTime, style: TextStyle(color: appColor.bodymainTxtColor, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),),

                                      Spacer(),

                                      Icon(Icons.access_time, color: Colors.red.shade900, size: 17.5,),

                                      SizedBox(width: 2,),

                                      Text("half day time : ", style: TextStyle(color: Colors.grey.shade800, fontSize: 12.5, fontWeight: FontWeight.w500, fontFamily: "poppins_thin"),),

                                      Text(dept.halfDayTime, style: TextStyle(color: appColor.bodymainTxtColor, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),),

                                    ],

                                  ),

                                ),

                                SizedBox(height: 22,),

                                Padding(

                                  padding: const EdgeInsets.symmetric(horizontal: 17.0),

                                  child: Row(

                                    crossAxisAlignment: CrossAxisAlignment.center,

                                    children: [

                                      Column(

                                        crossAxisAlignment: CrossAxisAlignment.start,

                                        children: [

                                          Text("Max OT Allow", style: TextStyle(color: Colors.grey.shade800, fontSize: 13, fontWeight: FontWeight.w500, fontFamily: "poppins_thin"),),

                                          Text(dept.maxOTAllow, style: TextStyle(color: appColor.bodymainTxtColor, fontSize: 13.5, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),),

                                        ],

                                      ),

                                      Spacer(),

                                      Column(

                                        crossAxisAlignment: CrossAxisAlignment.end,

                                        children: [

                                          Text("Max Late Number", style: TextStyle(color: Colors.grey.shade800, fontSize: 13, fontWeight: FontWeight.w500, fontFamily: "poppins_thin"),),

                                          Text(dept.maxLateNumber.toString(), style: TextStyle(color: appColor.bodymainTxtColor, fontSize: 13.5, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),),

                                        ],

                                      ),

                                    ],

                                  ),

                                ),

                              ],

                            ),

                          ),

                          Positioned(

                            left: -10,
                            top: -10,

                            child: Container(

                              height: 70,
                              width: 70,

                              decoration: BoxDecoration(

                                shape: BoxShape.circle,

                                color: Colors.white,

                              ),

                              child: Center(

                                child: Container(

                                  height: 50,
                                  width: 50,

                                  decoration: BoxDecoration(

                                    shape: BoxShape.circle,

                                    color: dept.subColor,

                                  ),

                                  child: Center(

                                    child: Text(dept.no.toString(), style: TextStyle(color: appColor.appbarTxtColor, fontSize: 13.5, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),),

                                  ),

                                ),

                              ),

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

    );

  }
}
import 'package:flutter/material.dart';
import 'package:hr_app/IVR%20View/ivr_View_inDetail_Screen.dart';
import 'package:hr_app/staff_HRM_module/Screen/Color/app_Color.dart';
import 'Models/ivr_Data_Model.dart';

class ivrViewScreen extends StatefulWidget {
  const ivrViewScreen({super.key});

  @override
  State<ivrViewScreen> createState() => _ivrViewScreenState();
}

class _ivrViewScreenState extends State<ivrViewScreen> {

  bool _isPlaying = false; // Add this state variable to track play/pause status

  List<UserAppointment> userAppointmentsList = [
    UserAppointment(id: 185751, name: "Sagar More", date: "01-04-2025", time: "09:30:00 AM", status: "Today", type: "Qualified"),
    UserAppointment(id: 196294, name: "Aakash Kanani", date: "01-04-2025", time: "09:46:00 AM", status: "Today", type: "Appointment"),
    UserAppointment(id: 201254, name: "Ganpat Joshi", date: "01-04-2025", time: "09:38:00 AM", status: "Cnr", type: "Qualified"),
    UserAppointment(id: 201508, name: "pareshbhai", date: "01-04-2025", time: "09:00:00 AM", status: "Today", type: "Qualified"),
    UserAppointment(id: 202551, name: "Sanjay singade", date: "01-04-2025", time: "09:34:00 AM", status: "Cnr", type: "Qualified"),
    UserAppointment(id: 205824, name: "Ok", date: "01-04-2025", time: "09:42:00 AM", status: "Cnr", type: "Qualified"),
    UserAppointment(id: 206214, name: "sourbhbhai", date: "01-04-2025", time: "09:05:00 AM", status: "Today", type: "Appointment"),
    UserAppointment(id: 179365, name: "Aashif22675", date: "28-03-2025", time: "11:00:00 AM", status: "Pending", type: "Appointment"),
    UserAppointment(id: 181456, name: "Madanlal shaivardhan", date: "31-03-2025", time: "02:00:00 PM", status: "Pending", type: "Appointment"),
    UserAppointment(id: 185667, name: "Asif Gora", date: "31-03-2025", time: "01:41:00 PM", status: "Pending", type: "Appointment"),
  ];

  void _showPauseAlertDialog() {

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(

          backgroundColor: appColor.subFavColor,
          title: Text("Pause Follow up!", style: TextStyle(color: Colors.black, fontFamily: "poppins_thin", fontSize: 18),),
          elevation: 3,
          content: Text("Are you sure you want\nto pause the follow-up process?", style: TextStyle(color: Colors.black38, fontFamily: "poppins_thin", fontSize: 13),),
          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel", style: TextStyle(color: appColor.primaryColor, fontSize: 14, fontFamily: "poppins_thin"),)
            ),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isPlaying = false;
                });
                Navigator.pop(context);
              },
              child: Text("Pause", style: TextStyle(color: Colors.white, fontFamily: "poppins_thin", fontSize: 14),),
              style: ElevatedButton.styleFrom(

                backgroundColor: appColor.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                fixedSize: Size(100, 40),

              ),
            ),

          ],

        );
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(

        backgroundColor: appColor.primaryColor,
        centerTitle: true,
        title: Text("Followups And Queue", style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: "poppins_thin"),),
        foregroundColor: Colors.white,
        leading: IconButton(

          onPressed: (){
            // Navigator.pop(context);
          },

          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20,),

        ),

      ),

      backgroundColor: Colors.white,

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            SizedBox(height: 20,),

            Row(

              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text("Queue Follow up", style: TextStyle(color: Colors.black, fontFamily: "poppins_thin", fontSize: 15),),
                    Text("total inquiries: 196", style: TextStyle(color: Colors.grey.shade500, fontFamily: "poppins_thin", fontSize: 13),),

                  ],
                ),

                Container(

                  height: 34,
                  width: 100,

                  decoration: BoxDecoration(

                    color: appColor.primaryColor,
                    borderRadius: BorderRadius.circular(6),

                  ),

                  child: Row(

                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: [
                      SizedBox(width: 4,),
                      Icon(Icons.list_rounded, color: Colors.white, size: 20,),
                      SizedBox(width: 4,),
                      Text("List View", style: TextStyle(fontFamily: "poppins_thin", fontSize: 13, color: Colors.white),),
                    ],

                  ),

                ),

              ],

            ),

            SizedBox(height: 20,),

            Expanded(
              child: ListView.builder(

                itemCount: userAppointmentsList.length,

                itemBuilder: (context, index) {

                  final data = userAppointmentsList[index];

                  return GestureDetector(

                    onTap: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => ivrViewinDetailScreen(userAppointmentData: data)));
                    },

                    child: Container(

                      margin: EdgeInsets.only(bottom: 15),
                      height: 80,
                      width: double.infinity,

                      decoration: BoxDecoration(

                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          const BoxShadow(
                            color: Colors.black12,
                            blurRadius: 3,
                            offset: Offset(1, 3),
                          )
                        ],

                      ),

                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(

                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,

                          children: [

                            Text("${data.id}", style: TextStyle(color: appColor.primaryColor, fontSize: 11, fontFamily: "poppins_thin"),),

                            SizedBox(width: 10,),

                            Column(

                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,

                              children: [

                                Container(
                                  height: 18,
                                  width: MediaQuery.of(context).size.width.toDouble() / 2.26,
                                  // color: Colors.red,
                                  child: Text("${data.name}", style: TextStyle(color: Colors.black, fontSize: 12.6, fontFamily: "poppins_thin"), maxLines: 1, overflow: TextOverflow.ellipsis,)
                                ),
                                Text("${data.date} ${data.time}", style: TextStyle(color: Colors.black38, fontSize: 11, fontFamily: "poppins_thin"),),

                              ],

                            ),

                            Spacer(),

                            Column(

                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.end,

                              children: [

                                Container(
                                  height: 20,
                                  width: 60,
                                  decoration: BoxDecoration(

                                    color: data.status == "Today" ? Colors.blue.shade300 : data.status == "Cnr" ? Colors.green.shade300 : Colors.amber.shade400,
                                    borderRadius: BorderRadius.circular(10),

                                  ),

                                  child: Center(
                                    child: Text("${data.status}", style: TextStyle(color: Colors.white, fontSize: 9.8, fontFamily: "poppins_thin"),),
                                  ),

                                ),

                                Container(
                                  height: 20,
                                  width: 100,
                                  decoration: BoxDecoration(

                                    color: appColor.primaryColor,
                                    borderRadius: BorderRadius.circular(10),

                                  ),

                                  child: Center(
                                    child: Text("${data.type}", style: TextStyle(color: Colors.white, fontSize: 9.8, fontFamily: "poppins_thin"), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                  ),

                                ),

                              ],

                            ),

                          ],

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

      // In ivrViewScreen class, modify the play button's onTap:
      floatingActionButton: _isPlaying
          ? GestureDetector(
        onTap: () {
          _showPauseAlertDialog();
        },
        child: Container(
          height: 52,
          width: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red.shade900,
            boxShadow: [
              const BoxShadow(
                color: Colors.black12,
                blurRadius: 3,
                offset: Offset(1, 3),
              )
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.pause_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
        ),
      )
          : GestureDetector(
        onTap: () {
          setState(() {
            _isPlaying = true;
          });
          // Navigate to detail screen with first item
          if (userAppointmentsList.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ivrViewinDetailScreen(
                  userAppointmentsList: userAppointmentsList,
                  currentIndex: 0,
                ),
              ),
            );
          }
        },
        child: Container(
          height: 52,
          width: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.lightGreen.shade900,
            boxShadow: [
              const BoxShadow(
                color: Colors.black12,
                blurRadius: 3,
                offset: Offset(1, 3),
              )
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
        ),
      ),

    );
  }
}
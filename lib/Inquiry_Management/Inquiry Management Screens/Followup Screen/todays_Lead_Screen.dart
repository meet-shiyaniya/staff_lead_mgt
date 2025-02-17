

import 'dart:math';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Followups Timing Screen/timing_Screen.dart';
// import 'package:inquiry_management_ui/Inquiry%20Management%20Screens/Followups%20Timing%20Screen/timing_Screen.dart';

class ShiftsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20,),
        Expanded(
          child: ListView(
            children: [
              ShiftCard( time: "09:00-10:00", inquiry: "2",),
              ShiftCard( time: "10:00-11:00", inquiry: "10",),
              ShiftCard( time: "11:00-12:00", inquiry: "20",),
              ShiftCard( time: "12:00-01:00", inquiry: "2",),
              ShiftCard( time: "01:00-02:00", inquiry: "10",),
              ShiftCard( time: "02:00-03:00", inquiry: "20",),
              ShiftCard( time: "04:00-05:00", inquiry: "2",),
              ShiftCard( time: "05:00-06:00", inquiry: "10",),
              ShiftCard( time: "06:00-07:00", inquiry: "20",),
            ],
          ),
        ),
      ],
    );
  }
}
class ShiftCard extends StatelessWidget {
  // final String day;
  final String time;
  final String inquiry;
  // final String location;

  ShiftCard({ required this.time, required this.inquiry});



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => TimingScreen(),));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 1, offset: Offset(1, 3)),
          ]

        ),
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 22, color: Colors.red),
                      SizedBox(width: 8),
                      Text(time,style: TextStyle(fontFamily: "poppins_thin",fontSize: 14),),
                    ],
                  ),
                ],
              ),
              Spacer(),
              DottedBorder(
                strokeWidth: 1,
                dashPattern: [10,1],
                borderType: BorderType.Circle,
                child: CircleAvatar(
                  // backgroundColor: Colors.deepPurple.shade200,
                  child: Text(inquiry,style: TextStyle(fontSize: 12,fontFamily: "poppins_thin",color: Colors.black),),
                ),
              ),
              SizedBox(width: 10,),
              // Spacer(),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
            ],
          ),
        ),
      ),
    );
  }
}
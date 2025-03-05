// // import 'dart:ui';
// // import 'dart:ui_web';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:hr_app/Inquiry_Management/Model/Api%20Model/allInquiryModel.dart';
// import 'package:hr_app/Inquiry_Management/Utils/Custom%20widgets/booking_Screen.dart';
// import 'package:hr_app/Inquiry_Management/Utils/Custom%20widgets/quotation_Screen.dart';
// import 'package:hr_app/Inquiry_Management/test.dart';
// // import 'package:inquiry_management_ui/Utils/Custom%20widgets/custom_screen.dart';
// // import 'package:inquiry_management_ui/Utils/Custom%20widgets/quotation_Screen.dart';
// import '../../Model/followup_Model.dart';
// import 'add_lead_Screen.dart';
// import 'custom_screen.dart';
// import 'inquiry_transfer_Screen.dart';
//
// class TestCard extends StatelessWidget {
//   final String id;
//   final String name;
//   final String label;
//   final String username;
//   final String followUpDate;
//   final String nextFollowUpDate;
//   final String inquiryType;
//   final String intArea;
//   final String purposeBuy;
//   final String daySkip;
//   final String hourSkip;
//   // final String phone;
//   // final String email;
//   final String source;
//
//   final bool isSelected; // Track if card is selected
//   final VoidCallback onSelect; // Callback to toggle selection
//
//   // New parameters you need to pass to LeadDetailScreen
//   final List<String> callList;
//   final TextEditingController nextFollowupcontroller;
//   final String? selectedcallFilter;
//   final Inquiry data; // change here
//   final bool isTiming;
//   // Assuming data is a dynamic object with properties like product, apxbuying, services, etc.
//
//   const TestCard({
//     Key? key,
//     required this.id,
//     required this.name,
//     required this.username,
//     required this.label,
//     required this.followUpDate,
//     required this.nextFollowUpDate,
//     required this.inquiryType,
//     required this.intArea,
//     required this.purposeBuy,
//     required this.daySkip,
//     required this.hourSkip,
//     // required this.phone,
//     // required this.email,
//     required this.source,
//     this.isSelected = false,
//     required this.onSelect,
//     required this.callList,
//     required this.nextFollowupcontroller,
//     this.selectedcallFilter,
//     required this.data, required this.isTiming,
//   }) : super(key: key);
//
//
//   void showdialog(BuildContext context){
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20),
//
//             ),
//
//             content: Container(
//               height: 150,
//                 child: Center(child: Text(data.remark,style: TextStyle(fontFamily: "poppins_thin"),))),
//           );
//
//         },);
//   }
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onLongPress: onSelect, // Trigger selection on long press
//       child: Card(
//         margin: EdgeInsets.all(10.0),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16.0),
//         ),
//         elevation: isSelected ? 14.0 : 4.0,
//         color: isSelected?Colors.deepPurple.shade100:Colors.white,// Highlight selected card
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 15,
//                     backgroundColor: Colors.deepPurple.shade300,
//                     child: Text(
//                       id,
//                       style: TextStyle(fontSize: 20, fontFamily: "poppins_thin", color: Colors.white),
//                     ),
//                   ),
//                   SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           name,
//                           style: TextStyle(fontSize: 18, fontFamily: "poppins_thin"),
//                         ),
//                         SizedBox(height: 4),
//                         Row(
//                           children: [
//                             Icon(Icons.person, size: 15),
//                             Text(
//                               ": $username",
//                               style: TextStyle(fontSize: 14, fontFamily: "poppins_thin", color: Colors.grey.shade600),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(context, MaterialPageRoute(builder: (context) => InquiryScreen(),));
//                     },
//                     child: Image(image: AssetImage("asset/Inquiry_module/call-forwarding.png"),width: 30,height: 30,),
//                   ),
//                   SizedBox(width: 10),
//
//
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(context, MaterialPageRoute(builder: (context) => AddVisitScreen(),));
//                     },
//                     child: Image(image: AssetImage("asset/Inquiry_module/map.png"),width: 25,height: 25,),
//                   ),
//                   SizedBox(width: 16),
//
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(context, MaterialPageRoute(builder: (context) => BookingScreen(),));
//                     },
//                     child: Image(image: AssetImage("asset/Inquiry_module/rupee.png"),width: 25,height: 25,),
//                   ),
//                   SizedBox(width: 10,)
//                 ],
//               ),
//               SizedBox(height: 12),
//               Row(
//                 children: [
//                   Chip(
//                     label: Text(
//                       label,
//                       style: TextStyle(color: Colors.white, fontFamily: "poppins_thin"),
//                     ),
//                     backgroundColor: _getLabelColor(label),
//                   ),
//                   SizedBox(width: 8),
//                   Chip(
//                     label: Text(
//                       "Inq Type: $inquiryType",
//                       style: TextStyle(color: Colors.blue, fontFamily: "poppins_thin"),
//                     ),
//                     backgroundColor: Colors.blue.shade50,
//                   ),
//                 ],
//               ),
//               // SizedBox(height: 12),
//               // Container(
//               //   height: 50,
//               //   padding: EdgeInsets.all(10),
//               //   decoration: BoxDecoration(
//               //     borderRadius: BorderRadius.circular(18),
//               //     color: Colors.grey.shade200,
//               //   ),
//               //   child: Row(
//               //     children: [
//               //       Text("Int Area :",style: TextStyle( color: Colors.grey.shade600)),
//               //       SizedBox(width: 4),
//               //       Text("$intArea", style: TextStyle(fontFamily: "poppins_thin")),
//               //       Spacer(),
//               //       Text("Purpose of Buying :",style: TextStyle( color: Colors.grey.shade600)),
//               //       SizedBox(width: 4),
//               //       Text(purposeBuy, style: TextStyle(fontFamily: "poppins_thin")),
//               //     ],
//               //   ),
//               // ),
//               SizedBox(height: 12),
//               Text(
//                 "Created At: $followUpDate",
//                 style: TextStyle(color: Colors.grey.shade600, fontFamily: "poppins_thin"),
//               ),
//               Text(
//                 "Next Follow-up: $nextFollowUpDate",
//                 style: TextStyle(color: Colors.grey.shade600, fontFamily: "poppins_thin"),
//               ),
//               Row(
//                 children: [
//                   Text("Source: ", style: TextStyle(fontFamily: "poppins_thin")),
//                   _buildSourceChip(source),
//                   SizedBox(width: 5,),
//                   Icon(Icons.calendar_month),
//                   Text(daySkip),
//                   SizedBox(width: 5,),
//                   Icon(CupertinoIcons.clock,size: 18,),
//                   Text(hourSkip),
//
//                   Spacer(),
//                   CircleAvatar(
//                     backgroundColor: Colors.deepPurple.shade300,
//                     child: IconButton(onPressed: () {
//                       showdialog(context);
//                     }, icon: Icon(Icons.info_outline,color: Colors.white,)),
//                   )
//                 ],
//               ),
//               if (isSelected) // Show checkbox when selected
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: Checkbox(
//                     value: isSelected,
//                     onChanged: (bool? value) {
//                       onSelect(); // Trigger onSelect callback
//                     },
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Color _getLabelColor(String label) {
//     switch (label.toLowerCase()) {
//       case "fresh":
//         return Colors.green;
//       case "feedback":
//         return Color(0xffff9e4d);
//       case "negotiations":
//         return Colors.blue;
//       case "appointment":
//         return Color(0xffff9e4d);
//       case "qualified":
//         return Colors.purple.shade300;
//       default:
//         return Colors.grey;
//     }
//   }
//
//   Widget _buildSourceChip(String source) {
//     return Chip(
//       label: Text(source, style: TextStyle(fontFamily: "poppins_thin")),
//       backgroundColor: Colors.grey.shade200,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//     );
//   }
// }
// import 'dart:ui';
// import 'dart:ui_web';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:inquiry_management_ui/Utils/Custom%20widgets/custom_screen.dart';
// import 'package:inquiry_management_ui/Utils/Custom%20widgets/quotation_Screen.dart';
import '../../Model/Api Model/allInquiryModel.dart';
import '../../Model/followup_Model.dart';
import '../../test.dart';
import 'add_lead_Screen.dart';
import 'booking_Screen.dart';
import 'custom_screen.dart';
import 'inquiry_transfer_Screen.dart';

class TestCard extends StatelessWidget {
  final String id;
  final String name;
  final String label;
  final String username;
  final String followUpDate;//
  final String nextFollowUpDate;//
  final String inquiryType;
  final String intArea;
  final String purposeBuy;
  final String daySkip;
  final String hourSkip;
  // final String phone;
  // final String email;
  final String source;

  final bool isSelected; // Track if card is selected
  final VoidCallback onSelect; // Callback to toggle selection

  // New parameters you need to pass to LeadDetailScreen
  final List<String> callList;
  final TextEditingController nextFollowupcontroller;
  final String? selectedcallFilter;
  final Inquiry data; // change here
  final bool isTiming;
  // Assuming data is a dynamic object with properties like product, apxbuying, services, etc.

  const TestCard({
    Key? key,
    required this.id,
    required this.name,
    required this.username,
    required this.label,
    required this.followUpDate,
    required this.nextFollowUpDate,
    required this.inquiryType,
    required this.intArea,
    required this.purposeBuy,
    required this.daySkip,
    required this.hourSkip,
    // required this.phone,
    // required this.email,
    required this.source,
    this.isSelected = false,
    required this.onSelect,
    required this.callList,
    required this.nextFollowupcontroller,
    this.selectedcallFilter,
    required this.data, required this.isTiming,
  }) : super(key: key);


  void showdialog(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),

          ),

          content: Container(
              height: 150,
              child: Center(child: Text(data.remark,style: TextStyle(fontFamily: "poppins_thin"),))),
        );

      },);
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onSelect, // Trigger selection on long press
      child: Card(
        margin: EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: isSelected ? 14.0 : 4.0,
        color: isSelected?Colors.deepPurple.shade100:Colors.white,// Highlight selected card
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Container(
              //   height: 15,
              //     decoration: BoxDecoration(
              //       color: Colors.green,
              //       borderRadius: BorderRadius.all(Radius.),
              //     ),
              //     child: Text(id)),

              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.deepPurple.shade300,
                        borderRadius: BorderRadius.circular(8)

                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 9),
                        child: Text(
                          id,
                          style: TextStyle(fontSize: 13, fontFamily: "poppins_thin", color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [



                        Text(
                          name,
                          style: TextStyle(fontSize: 17, fontFamily: "poppins_thin",),
                        ),

                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.person, size: 15),
                            Text(
                              ": $username",
                              style: TextStyle(fontSize: 14, fontFamily: "poppins_thin", color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
          GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>
                          InquiryScreen(inquiryId: id,),
                      ));
                    },
                    child: Image(image: AssetImage("asset/Inquiry_module/call-forwarding.png"),width: 30,height: 30,),
                  ),
                  SizedBox(width: 10),


                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AddVisitScreen(inquiryId: id,),));
                    },
                    child: Image(image: AssetImage("asset/Inquiry_module/map.png"),width: 25,height: 25,),
                  ),
                  SizedBox(width: 16),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => BookingScreen(inquiryId: id,),));
                    },
                    child: Image(image: AssetImage("asset/Inquiry_module/rupee.png"),width: 25,height: 25,),
                  ),
                  SizedBox(width: 10,)
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 0, bottom: 0),
                    child: Container(
                      height: 30,
                      padding: const EdgeInsets.symmetric(horizontal: 12), // Adds space inside
                      decoration: BoxDecoration(
                        color: getLabelColor(label),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all( // Adds a border like the original Chip
                            width: 1.0,color: getBorderColor(label)
                        ),

                      ),
                      child: Center(
                        child: Text(
                          label,
                          style: TextStyle(
                            fontFamily: "poppins_thin",
                            color: Colors.black,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Chip(
                  //   label: Padding(
                  //     padding: EdgeInsets.symmetric(vertical: 1), // Adjust height here
                  //     child: Text(
                  //       label,
                  //       style: TextStyle(
                  //         color: Colors.white,
                  //         fontFamily: "poppins_thin",
                  //       ),
                  //     ),
                  //   ),
                  //   backgroundColor: getLabelColor(label),
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(8.0),
                  //     side: BorderSide(
                  //       color: getBorderColor(label),
                  //       width: 2.0,
                  //     ),
                  //   ),
                  // ),
                  SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(right: 0, bottom: 0),
                    child: Container(
                      height: 30,
                      padding: const EdgeInsets.symmetric(horizontal: 12), // Adds space inside
                      decoration: BoxDecoration(
                        color: Color(0xffebf0f4),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all( // Adds a border like the original Chip
                            width: 1.0,color: Colors.white
                        ),

                      ),
                      child: Center(
                        child: Text(
                          "Inq Type: $inquiryType",
                          style: TextStyle(
                            fontFamily: "poppins_thin",
                            color: Colors.black,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Chip(
                  //
                  //   label: Text(
                  //     "Inq Type: $inquiryType",
                  //     style: TextStyle(color: Colors.blue, fontFamily: "poppins_thin"),
                  //   ),
                  //   backgroundColor: Colors.blue.shade50,
                  // ),
                ],
              ),
              // SizedBox(height: 12),
              // Container(
              //   height: 50,
              //   padding: EdgeInsets.all(10),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(18),
              //     color: Colors.grey.shade200,
              //   ),
              //   child: Row(
              //     children: [
              //       Text("Int Area :",style: TextStyle( color: Colors.grey.shade600)),
              //       SizedBox(width: 4),
              //       Text("$intArea", style: TextStyle(fontFamily: "poppins_thin")),
              //       Spacer(),
              //       Text("Purpose of Buying :",style: TextStyle( color: Colors.grey.shade600)),
              //       SizedBox(width: 4),
              //       Text(purposeBuy, style: TextStyle(fontFamily: "poppins_thin")),
              //     ],
              //   ),
              // ),
              SizedBox(height: 5),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(
                  "Next Follow-up: $nextFollowUpDate",
                  style: TextStyle(color: Colors.grey.shade600, fontFamily: "poppins_thin",fontSize: 12),
                ),
              ),

              Row(
                children: [
                  Text("Source: ", style: TextStyle(fontFamily: "poppins_thin",fontSize: 12)),
                  _buildSourceContainer(source),
                  SizedBox(width: 7,),
                  Image.asset("asset/Inquiry_module/calendar.png",height: 18,width: 18,),
                  SizedBox(width: 3,),

                  // Icon(Icons.calendar_month),
                  Text(daySkip.isNotEmpty ? daySkip : "0"),
                  SizedBox(width: 10,),
                  Image.asset("asset/Inquiry_module/clock.png",height: 18,width: 18,),
                  SizedBox(width: 3,),

                  Text((hourSkip ?? "").isNotEmpty ? hourSkip! : "0"),

                  Spacer(),
                  // CircleAvatar(
                  //   backgroundColor: Colors.deepPurple.shade300,
                  //   child: IconButton(onPressed: () {
                  //     showdialog(context);
                  //   }, icon: Icon(Icons.info_outline,color: Colors.white,)),
                  // )
                ],
              ),
              if (isSelected) // Show checkbox when selected
                Align(
                  alignment: Alignment.centerRight,
                  child: Checkbox(

                    value: isSelected,
                    onChanged: (bool? value) {
                      onSelect(); // Trigger onSelect callback
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  Color getLabelColor(String? stage) {
    switch (stage) {
      case "Fresh":
        return Color(0xff33b5e5); // Lighter vibrant teal (from 0xff0093c8)
      case "Contacted":
        return Color(0xff4da8ff); // Lighter light blue (from 0xff007aff)
      case "Appointment":
        return Color(0xff3d70b2); // Lighter deep blue (from 0xff154889)
      case "Visited":
        return Color(0xff4da8ff); // Lighter solid blue (same as Contacted, from 0xff007aff)
      case "Negotiation":
        return Color(0xffc966c3); // Lighter deep indigo (from 0xffaf2da9)
      case "Feedback":
        return Color(0xff66d977); // Lighter bright green (from 0xff26b43a)
      case "Re_Appointment":
        return Color(0xff3d6ca3); // Lighter dark blue (from 0xff113e78)
      case "Re-Visited":
        return Color(0xfff1ba71);
      case "Converted":
        return Color(0xff73e0b3);// Light orange      case "Converted":
      default:
        return Colors.grey.shade300; // Lighter neutral grey (from shade400)
    }
  }
// New function for border colors
  Color getBorderColor(String? stage) {
    switch (stage) {
      case "Fresh":
        return Color(0xff00c4ff); // Lighter teal
      case "Contacted":
        return Color(0xff33aaff); // Brighter blue
      case "Appointment":
        return Color(0xff2b70c9); // Lighter deep blue
      case "Visited":
        return Color(0xff3399ff); // Lighter solid blue
      case "Negotiation":
        return Color(0xffd94ed1); // Lighter indigo
      case "Feedback":
        return Color(0xff4cd964); // Lighter green
      case "Re_Appointment":
        return Color(0xff2e62b3); // Lighter dark blue
      case "Re-Visited":
        return Color(0xffffca85); // Lighter orange
      case "Converted":
        return Color(0xff73e0b3); // Lighter green
      default:
        return Colors.grey.shade600; // Darker grey
    }
  }
  // Color _getLabelColor(String label) {
  //   switch (label.toLowerCase()) {
  //     case "fresh":
  //       return Colors.green;
  //     case "feedback":
  //       return Color(0xffff9e4d);
  //     case "negotiations":
  //       return Colors.blue;
  //     case "appointment":
  //       return Color(0xffff9e4d);
  //     case "qualified":
  //       return Colors.purple.shade300;
  //     default:
  //       return Colors.grey;
  //   }
  // }

  Widget _buildSourceContainer(String source) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: Colors.grey.shade200)
      ),
      child: Text(
        source,
        style: TextStyle(fontFamily: "poppins_thin",fontSize: 12),
      ),
    );
  }

}
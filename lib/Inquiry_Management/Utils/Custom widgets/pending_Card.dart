// import 'dart:ui';
// import 'dart:ui_web';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hr_app/Inquiry_Management/Model/Api%20Model/allInquiryModel.dart';
import 'package:hr_app/Inquiry_Management/Utils/Custom%20widgets/quotation_Screen.dart';
// import 'package:inquiry_management_ui/Utils/Custom%20widgets/custom_screen.dart';
// import 'package:inquiry_management_ui/Utils/Custom%20widgets/quotation_Screen.dart';
import '../../Model/followup_Model.dart';
import 'add_lead_Screen.dart';
import 'custom_screen.dart';

class TestCard extends StatelessWidget {
  final String id;
  final String name;
  final String label;
  final String username;
  final String followUpDate;
  final String nextFollowUpDate;
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
              Row(
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.deepPurple.shade300,
                    child: Text(
                      id,
                      style: TextStyle(fontSize: 20, fontFamily: "poppins_thin", color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(fontSize: 18, fontFamily: "poppins_thin"),
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LeaddetailScreen(
                        selectedApx: "1-2 Days",
                        selectedPurpose: "budget",
                        selectedTime: "12:00 AM",
                        data: data,
                        callList: callList,
                        selectedaction: "Package 1",
                        selectedButton: "Followup",
                        controller: nextFollowupcontroller,
                        isTiming: isTiming,),));
                    },
                    child: CircleAvatar(
                        backgroundColor: Colors.deepPurple.shade300,
                        child: Icon(Icons.call, color: Colors.white)),
                  ),
                  SizedBox(width: 6),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => QuotationScreen(),));
                    },
                    child: CircleAvatar(
                        backgroundColor: Colors.deepPurple.shade300,
                        child: Icon(Icons.library_books, color: Colors.white)),
                  ),
                  SizedBox(width: 6),
                  CircleAvatar(
                    backgroundColor: Colors.deepPurple.shade300,
                    child: PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert,color: Colors.white,),
                      onSelected: (value) {
                        if (value == 'edit') {
                          // Handle Edit action
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AddLeadScreen(isEdit: true,),));
                        } else if (value == 'delete') {
                          // Handle Delete action
                        }
                      },
                      offset: Offset(0, 20),
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem<String>(
                            value: 'edit',
                            child: Text(
                              'Edit',
                              style: TextStyle(fontFamily: "poppins_thin"),
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'delete',
                            child: Text(
                              'Delete',
                              style: TextStyle(fontFamily: "poppins_thin"),
                            ),
                          ),
                        ];
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Chip(
                    label: Text(
                      label,
                      style: TextStyle(color: Colors.white, fontFamily: "poppins_thin"),
                    ),
                    backgroundColor: _getLabelColor(label),
                  ),
                  SizedBox(width: 8),
                  Chip(
                    label: Text(
                      "Inq Type: $inquiryType",
                      style: TextStyle(color: Colors.blue, fontFamily: "poppins_thin"),
                    ),
                    backgroundColor: Colors.blue.shade50,
                  ),
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
              SizedBox(height: 12),
              Text(
                "Created At: $followUpDate",
                style: TextStyle(color: Colors.grey.shade600, fontFamily: "poppins_thin"),
              ),
              Text(
                "Next Follow-up: $nextFollowUpDate",
                style: TextStyle(color: Colors.grey.shade600, fontFamily: "poppins_thin"),
              ),
              Row(
                children: [
                  Text("Source: ", style: TextStyle(fontFamily: "poppins_thin")),
                  _buildSourceChip(source),
                  SizedBox(width: 5,),
                  Icon(Icons.calendar_month),
                  Text(daySkip),
                  SizedBox(width: 5,),
                  Icon(CupertinoIcons.clock,size: 18,),
                  Text(hourSkip),

                  Spacer(),
                  CircleAvatar(
                    backgroundColor: Colors.deepPurple.shade300,
                    child: IconButton(onPressed: () {
                      showdialog(context);
                    }, icon: Icon(Icons.info_outline,color: Colors.white,)),
                  )
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

  Color _getLabelColor(String label) {
    switch (label.toLowerCase()) {
      case "fresh":
        return Colors.green;
      case "feedback":
        return Color(0xffff9e4d);
      case "negotiations":
        return Colors.blue;
      case "appointment":
        return Color(0xffff9e4d);
      case "qualified":
        return Colors.purple.shade300;
      default:
        return Colors.grey;
    }
  }

  Widget _buildSourceChip(String source) {
    return Chip(
      label: Text(source, style: TextStyle(fontFamily: "poppins_thin")),
      backgroundColor: Colors.grey.shade200,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    );
  }
}
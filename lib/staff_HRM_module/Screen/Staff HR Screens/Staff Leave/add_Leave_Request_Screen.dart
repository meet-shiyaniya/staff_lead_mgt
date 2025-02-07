import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:switcher_button/switcher_button.dart';

import '../../Color/app_Color.dart';

class addLeaveRequestScreen extends StatefulWidget {
  const addLeaveRequestScreen({super.key});

  @override
  State<addLeaveRequestScreen> createState() => _addLeaveRequestScreenState();
}

class _addLeaveRequestScreenState extends State<addLeaveRequestScreen> {

  var nameController = TextEditingController(text: "Gym_smart");
  var approverController = TextEditingController(text: "Rudrram Group");

  var startingDateController = TextEditingController();

  DateTime? _startDate;

  var endingDateController = TextEditingController();

  bool isPaidType = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.white,

      appBar: AppBar(

        backgroundColor: appColor.primaryColor,

        title: Text("Request Leave", style: TextStyle(color: appColor.appbarTxtColor, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),),

        centerTitle: true,

        foregroundColor: Colors.transparent,

        leading: IconButton(

          onPressed: (){
            Navigator.pop(context);
          },

          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20,),

        ),

      ),

      body: Padding(

        padding: const EdgeInsets.symmetric(horizontal: 18.0),

        child: SingleChildScrollView(

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              SizedBox(height: 35,),

              Text("Add New Leave Request", style: TextStyle(color: appColor.bodymainTxtColor, fontSize: 20, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),),

              SizedBox(height: 25,),

              Text("Name :", style: TextStyle(color: appColor.bodymainTxtColor, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 15),),

              SizedBox(height: 10,),

              Card(

                elevation: 2,
                color: Colors.transparent,
                shadowColor: appColor.boxColor,

                child: TextFormField(

                  controller: nameController,

                  readOnly: true,

                  style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13),

                  decoration: InputDecoration(

                    filled: true,

                    fillColor: appColor.subPrimaryColor,

                    hintText: "Short Name",

                    hintStyle: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13),

                    border: OutlineInputBorder(

                      borderRadius: BorderRadius.circular(10), // Adjust the radius as needed

                      borderSide: BorderSide.none, // No visible border

                    ),

                    enabledBorder: OutlineInputBorder(

                      borderRadius: BorderRadius.circular(8),

                      borderSide: BorderSide.none,

                    ),

                    focusedBorder: OutlineInputBorder(

                      borderRadius: BorderRadius.circular(10),

                      borderSide: BorderSide.none,

                    ),

                  ),

                ),

              ),

              SizedBox(height: 15,),

              Text("Approver :", style: TextStyle(color: appColor.bodymainTxtColor, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 15),),

              SizedBox(height: 10,),

              Card(

                elevation: 2,
                color: Colors.transparent,
                shadowColor: appColor.boxColor,

                child: TextFormField(

                  controller: approverController,

                  readOnly: true,

                  style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13),

                  decoration: InputDecoration(

                    filled: true,

                    fillColor: appColor.subPrimaryColor,

                    hintText: "Leave Type",

                    hintStyle: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13),

                    border: OutlineInputBorder(

                      borderRadius: BorderRadius.circular(10), // Adjust the radius as needed

                      borderSide: BorderSide.none, // No visible border

                    ),

                    enabledBorder: OutlineInputBorder(

                      borderRadius: BorderRadius.circular(8),

                      borderSide: BorderSide.none,

                    ),

                    focusedBorder: OutlineInputBorder(

                      borderRadius: BorderRadius.circular(10),

                      borderSide: BorderSide.none,

                    ),

                  ),

                ),

              ),

              SizedBox(height: 15,),

              Text("Start Leave Date :", style: TextStyle(color: appColor.bodymainTxtColor, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 15),),

              SizedBox(height: 10,),

              Card(

                elevation: 2,
                color: Colors.transparent,
                shadowColor: appColor.boxColor,

                child: TextFormField(

                  controller: startingDateController,

                  readOnly: true,

                  decoration: InputDecoration(

                    filled: true,

                    fillColor: appColor.subPrimaryColor,

                    hintText: "DD-MM-YYYY",

                    suffixIcon: Icon(Icons.calendar_month_rounded, size: 20, color: appColor.primaryColor,),

                    hintStyle: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13),

                    border: OutlineInputBorder(

                      borderRadius: BorderRadius.circular(10), // Adjust the radius as needed

                      borderSide: BorderSide.none, // No visible border

                    ),

                    enabledBorder: OutlineInputBorder(

                      borderRadius: BorderRadius.circular(8),

                      borderSide: BorderSide.none,

                    ),

                    focusedBorder: OutlineInputBorder(

                      borderRadius: BorderRadius.circular(10),

                      borderSide: BorderSide.none,

                    ),

                  ),

                  onTap: () async {

                    DateTime? pickedDate = await showDatePicker(

                      context: context,

                      initialDate: DateTime.now(),

                      firstDate: DateTime.now(),

                      lastDate: DateTime(2100),

                    );

                    if (pickedDate != null) {

                      String formattedDate = "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";

                      setState(() {

                        _startDate = pickedDate; // Update selected start date

                        startingDateController.text = formattedDate;

                      });

                    }

                  },

                ),

              ),

              SizedBox(height: 15,),

              Text("End Leave Date :", style: TextStyle(color: appColor.bodymainTxtColor, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 15),),

              SizedBox(height: 10,),

              Card(

                elevation: 2,
                color: Colors.transparent,
                shadowColor: appColor.boxColor,

                child: TextFormField(

                  controller: endingDateController,

                  readOnly: true,

                  decoration: InputDecoration(

                    filled: true,

                    fillColor: appColor.subPrimaryColor,

                    hintText: "DD-MM-YYYY",

                    suffixIcon: Icon(Icons.calendar_month_rounded, size: 20, color: appColor.primaryColor,),

                    hintStyle: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13),

                    border: OutlineInputBorder(

                      borderRadius: BorderRadius.circular(10), // Adjust the radius as needed

                      borderSide: BorderSide.none, // No visible border

                    ),

                    enabledBorder: OutlineInputBorder(

                      borderRadius: BorderRadius.circular(8),

                      borderSide: BorderSide.none,

                    ),

                    focusedBorder: OutlineInputBorder(

                      borderRadius: BorderRadius.circular(10),

                      borderSide: BorderSide.none,

                    ),

                  ),

                  onTap: () async {

                    if (_startDate == null) {

                      ScaffoldMessenger.of(context).showSnackBar(

                        SnackBar(
                          content: Text("Please select the starting holiday date first.", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),),
                          backgroundColor: Colors.deepPurple.shade900,
                        ),

                      );

                      return;

                    }

                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _startDate!.add(Duration(days: 1)),
                      firstDate: _startDate!.add(Duration(days: 1)),
                      lastDate: DateTime(2100),
                    );

                    if (pickedDate != null) {
                      String formattedDate =
                          "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
                      setState(() {
                        endingDateController.text = formattedDate;
                      });
                    }
                  },

                ),

              ),

              SizedBox(height: 15,),

              Text("Select Paid Type :", style: TextStyle(color: appColor.bodymainTxtColor, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 15),),

              SizedBox(height: 18,),

              Row(

                mainAxisAlignment: MainAxisAlignment.spaceAround,

                children: [

                  SizedBox(width: 0,),

                  Container(

                    height: 36,
                    width: MediaQuery.of(context).size.width.toDouble() / 3,

                    decoration: BoxDecoration(

                      color: isPaidType ? Colors.transparent : appColor.primaryColor,

                      border: Border.all(color: isPaidType ? appColor.primaryColor : Colors.transparent, width: 1.2),

                      borderRadius: BorderRadius.circular(8),

                    ),

                    child: Center(

                        child: Text("Paid Leave", style: TextStyle(color: isPaidType ? Colors.black : Colors.white, fontSize: 13.2, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),)

                    ),

                  ),

                  // Spacer(),

                  SwitcherButton(

                    value: isPaidType,

                    onColor: Colors.deepPurple,

                    offColor: Colors.deepPurple.shade100,

                    onChange: (value) {

                      setState(() {

                        isPaidType = value;

                      });

                    },

                  ),

                  // Spacer(),

                  Container(

                    height: 36,
                    width: MediaQuery.of(context).size.width.toDouble() / 3,

                    decoration: BoxDecoration(

                      color: isPaidType ? appColor.primaryColor : Colors.transparent,

                      border: Border.all(color: isPaidType ? Colors.transparent : appColor.primaryColor, width: 1.2),

                      borderRadius: BorderRadius.circular(8),

                    ),

                    child: Center(

                        child: Text("Unpaid Leave", style: TextStyle(color: isPaidType ? Colors.white : Colors.black, fontSize: 13.2, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),)

                    ),

                  ),

                  SizedBox(width: 0,),

                ],
              ),

              SizedBox(height: 18,),

              Text("Leave Name :", style: TextStyle(color: appColor.bodymainTxtColor, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 15),),

              SizedBox(height: 10,),

              Card(

                elevation: 2,
                color: Colors.transparent,
                shadowColor: appColor.boxColor,

                child: TextFormField(

                  decoration: InputDecoration(

                    filled: true,

                    fillColor: appColor.subPrimaryColor,

                    hintText: "Short Name",

                    hintStyle: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13),

                    border: OutlineInputBorder(

                      borderRadius: BorderRadius.circular(10), // Adjust the radius as needed

                      borderSide: BorderSide.none, // No visible border

                    ),

                    enabledBorder: OutlineInputBorder(

                      borderRadius: BorderRadius.circular(8),

                      borderSide: BorderSide.none,

                    ),

                    focusedBorder: OutlineInputBorder(

                      borderRadius: BorderRadius.circular(10),

                      borderSide: BorderSide.none,

                    ),

                  ),

                ),

              ),

              SizedBox(height: 15,),

              Text("Leave Reason :", style: TextStyle(color: appColor.bodymainTxtColor, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 15),),

              SizedBox(height: 10,),

              Card(

                elevation: 2,
                color: Colors.transparent,
                shadowColor: appColor.boxColor,

                child: TextFormField(

                  style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13),

                  decoration: InputDecoration(

                    filled: true,

                    fillColor: appColor.subPrimaryColor,

                    hintText: "Write your leave reason here",

                    hintStyle: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13),

                    border: OutlineInputBorder(

                      borderRadius: BorderRadius.circular(10), // Adjust the radius as needed

                      borderSide: BorderSide.none, // No visible border

                    ),

                    enabledBorder: OutlineInputBorder(

                      borderRadius: BorderRadius.circular(8),

                      borderSide: BorderSide.none,

                    ),

                    focusedBorder: OutlineInputBorder(

                      borderRadius: BorderRadius.circular(10),

                      borderSide: BorderSide.none,

                    ),

                  ),

                ),

              ),

              SizedBox(height: 15,),

              Text("Leave Type :", style: TextStyle(color: appColor.bodymainTxtColor, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 15),),

              SizedBox(height: 10,),

              Card(

                elevation: 2,
                color: Colors.transparent,
                shadowColor: appColor.boxColor,

                child: TextFormField(

                  decoration: InputDecoration(

                    filled: true,

                    fillColor: appColor.subPrimaryColor,

                    hintText: "Leave Type",

                    hintStyle: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13),

                    border: OutlineInputBorder(

                      borderRadius: BorderRadius.circular(10), // Adjust the radius as needed

                      borderSide: BorderSide.none, // No visible border

                    ),

                    enabledBorder: OutlineInputBorder(

                      borderRadius: BorderRadius.circular(8),

                      borderSide: BorderSide.none,

                    ),

                    focusedBorder: OutlineInputBorder(

                      borderRadius: BorderRadius.circular(10),

                      borderSide: BorderSide.none,

                    ),

                  ),

                ),

              ),

              SizedBox(height: 15,),

              Text("Apply Days :", style: TextStyle(color: appColor.bodymainTxtColor, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 15),),

              SizedBox(height: 10,),

              Card(

                elevation: 2,
                color: Colors.transparent,
                shadowColor: appColor.boxColor,

                child: TextFormField(

                  decoration: InputDecoration(

                    filled: true,

                    fillColor: appColor.subPrimaryColor,

                    hintText: "Number Of Days",

                    hintStyle: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13),

                    border: OutlineInputBorder(

                      borderRadius: BorderRadius.circular(10), // Adjust the radius as needed

                      borderSide: BorderSide.none, // No visible border

                    ),

                    enabledBorder: OutlineInputBorder(

                      borderRadius: BorderRadius.circular(8),

                      borderSide: BorderSide.none,

                    ),

                    focusedBorder: OutlineInputBorder(

                      borderRadius: BorderRadius.circular(10),

                      borderSide: BorderSide.none,

                    ),

                  ),

                ),

              ),

              SizedBox(height: 30,),

              Card(

                elevation: 2,
                color: Colors.transparent,
                shadowColor: Colors.grey.shade200,

                child: ElevatedButton(

                  onPressed: () {

                    Fluttertoast.showToast(msg: "New Leave Added");

                    Navigator.pop(context);

                  },

                  child: Text("Add Leave Request", style: TextStyle(color: appColor.appbarTxtColor, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 15),),

                  style: ElevatedButton.styleFrom(

                    backgroundColor: appColor.primaryColor,

                    shape: RoundedRectangleBorder(

                      borderRadius: BorderRadius.circular(10),

                    ),

                    fixedSize: Size(MediaQuery.of(context).size.width.toDouble(), 46),

                  ),

                ),
              ),

              SizedBox(height: 30,),

            ],
          ),

        ),

      ),

    );

  }

}
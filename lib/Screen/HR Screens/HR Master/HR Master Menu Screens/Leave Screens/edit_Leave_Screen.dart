import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_app/Model/HR%20Screen%20Models/HR%20Master%20Models/HR%20Master%20Menu%20Models/leave_Model.dart';
import 'package:switcher_button/switcher_button.dart';

import '../../../../Color/app_Color.dart';

class editLeaveScreen extends StatefulWidget {

  leaveModel leave;

  editLeaveScreen({

    super.key,

    required this.leave

  });

  @override
  State<editLeaveScreen> createState() => _editLeaveScreenState();
}

class _editLeaveScreenState extends State<editLeaveScreen> {

  var nameController = TextEditingController();
  var typeController = TextEditingController();
  var limitController = TextEditingController();
  bool isPaidType = false;

  // function for assign value to each fields
  assignAllValue() {

    nameController.text = widget.leave.leaveName;
    typeController.text = widget.leave.leaveType;
    limitController.text = widget.leave.annualLimit.toString();

    if (widget.leave.paidType == "Paid") {
      isPaidType = false;
    } else {
      isPaidType = true;
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    assignAllValue();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.white,

      appBar: AppBar(

        backgroundColor: appColor.primaryColor,

        title: Text("Leave Management", style: TextStyle(color: appColor.appbarTxtColor, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),),

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

        padding: const EdgeInsets.symmetric(horizontal: 20.0),

        child: SingleChildScrollView(

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              SizedBox(height: 50,),

              Text("Edit Leave", style: TextStyle(color: appColor.bodymainTxtColor, fontSize: 20, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),),

              SizedBox(height: 40,),

              Text("Leave Name :", style: TextStyle(color: appColor.bodymainTxtColor, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 15),),

              SizedBox(height: 18,),

              TextFormField(

                controller: nameController,

                style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),

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

              SizedBox(height: 30,),

              Text("Leave Type :", style: TextStyle(color: appColor.bodymainTxtColor, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 15),),

              SizedBox(height: 18,),

              TextFormField(

                controller: typeController,

                style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),

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

              SizedBox(height: 30,),

              Text("Annual Limit :", style: TextStyle(color: appColor.bodymainTxtColor, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 15),),

              SizedBox(height: 18,),

              TextFormField(

                controller: limitController,

                style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),

                decoration: InputDecoration(

                  filled: true,

                  fillColor: appColor.subPrimaryColor,

                  hintText: "Annual Limit",

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

              SizedBox(height: 30,),

              Text("Select Paid Type :", style: TextStyle(color: appColor.bodymainTxtColor, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 15),),

              SizedBox(height: 32,),

              Row(

                mainAxisAlignment: MainAxisAlignment.spaceAround,

                children: [

                  SizedBox(width: 0,),

                  Container(

                    height: 36,
                    width: 134,

                    decoration: BoxDecoration(

                      color: isPaidType ? Colors.transparent : appColor.primaryColor,

                      border: Border.all(color: isPaidType ? appColor.primaryColor : Colors.transparent, width: 1.2),

                      borderRadius: BorderRadius.circular(8),

                    ),

                    child: Center(

                        child: Text("Paid Leave", style: TextStyle(color: isPaidType ? Colors.black : Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),)

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
                    width: 136,

                    decoration: BoxDecoration(

                      color: isPaidType ? appColor.primaryColor : Colors.transparent,

                      border: Border.all(color: isPaidType ? Colors.transparent : appColor.primaryColor, width: 1.2),

                      borderRadius: BorderRadius.circular(8),

                    ),

                    child: Center(

                        child: Text("Unpaid Leave", style: TextStyle(color: isPaidType ? Colors.white : Colors.black, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),)

                    ),

                  ),

                  SizedBox(width: 0,),

                ],
              ),

              SizedBox(height: 50,),

              ElevatedButton(

                onPressed: () {

                  Fluttertoast.showToast(msg: "Save Changes Successfully");

                  Navigator.pop(context);

                },

                child: Text("Save", style: TextStyle(color: appColor.appbarTxtColor, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 15),),

                style: ElevatedButton.styleFrom(

                  backgroundColor: appColor.primaryColor,

                  shape: RoundedRectangleBorder(

                    borderRadius: BorderRadius.circular(30),

                  ),

                  fixedSize: Size(MediaQuery.of(context).size.width.toDouble(), 46),

                ),

              ),

            ],
          ),
        ),
      ),

    );
  }
}

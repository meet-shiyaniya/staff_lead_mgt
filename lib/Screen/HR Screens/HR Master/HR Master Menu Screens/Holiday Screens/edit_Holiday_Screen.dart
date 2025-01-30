import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_app/Model/HR%20Screen%20Models/HR%20Master%20Models/HR%20Master%20Menu%20Models/holiday_Model.dart';
import 'package:switcher_button/switcher_button.dart';

import '../../../../Color/app_Color.dart';

class editHolidayScreen extends StatefulWidget {

  holidayModel holiday;

  editHolidayScreen({

    super.key,

    required this.holiday

  });

  @override
  State<editHolidayScreen> createState() => _editHolidayScreenState();
}

class _editHolidayScreenState extends State<editHolidayScreen> {

  var nameController = TextEditingController();
  var typeController = TextEditingController();

  var startingDateController = TextEditingController();

  var endingDateController = TextEditingController();

  bool isPaidType = false;

  DateTime? _startingDate;
  DateTime? _endingDate;

  // function for assign value to each fields
  assignAllValue() {

    nameController.text = widget.holiday.holidayName;
    typeController.text = widget.holiday.type;
    startingDateController.text = widget.holiday.startHolidayDate;
    endingDateController.text = widget.holiday.endHolidayDate;

    if (widget.holiday.paidType == "Paid") {
      isPaidType = false;
    } else {
      isPaidType = true;
    }

    DateTime? _parseDate(String date) {
      try {
        List<String> parts = date.split("-");
        return DateTime(
          int.parse(parts[2]), // Year
          int.parse(parts[1]), // Month
          int.parse(parts[0]), // Day
        );
      } catch (e) {
        return null; // Return null if parsing fails
      }
    }

    _startingDate = _parseDate(widget.holiday.startHolidayDate);
    _endingDate = _parseDate(widget.holiday.endHolidayDate);

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

        title: Text("Holiday Management", style: TextStyle(color: appColor.appbarTxtColor, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),),

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

              SizedBox(height: 35,),

              Text("Edit Holiday Plan", style: TextStyle(color: appColor.bodymainTxtColor, fontSize: 20, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),),

              SizedBox(height: 24,),

              Text("Holiday Name :", style: TextStyle(color: appColor.bodymainTxtColor, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 15),),

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

              SizedBox(height: 20,),

              Text("Holiday Type :", style: TextStyle(color: appColor.bodymainTxtColor, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 15),),

              SizedBox(height: 18,),

              TextFormField(

                controller: typeController,

                style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),

                decoration: InputDecoration(

                  filled: true,

                  fillColor: appColor.subPrimaryColor,

                  hintText: "Holiday Type",

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

              SizedBox(height: 20,),

              Text("Starting Holiday Date :", style: TextStyle(color: appColor.bodymainTxtColor, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 15),),

              SizedBox(height: 18,),

              TextFormField(

                controller: startingDateController,

                style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),

                readOnly: true,

                decoration: InputDecoration(

                  filled: true,

                  fillColor: appColor.subPrimaryColor,

                  hintText: "01-02-2023",

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

                    initialDate: _startingDate ?? DateTime.now(),

                    firstDate: DateTime(2025),

                    lastDate: DateTime(2100),

                  );

                  if (pickedDate != null) {

                    String formattedDate = "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";

                    setState(() {

                      _startingDate = pickedDate;

                      startingDateController.text = formattedDate;

                    });

                  }

                },

              ),

              SizedBox(height: 20,),

              Text("Ending Holiday Date :", style: TextStyle(color: appColor.bodymainTxtColor, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 15),),

              SizedBox(height: 18,),

              TextFormField(

                controller: endingDateController,

                readOnly: true,

                style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),

                decoration: InputDecoration(

                  filled: true,

                  fillColor: appColor.subPrimaryColor,

                  hintText: "01-03-2023",

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

                  if (_startingDate == null) {

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
                    initialDate: _endingDate ?? _startingDate!.add(Duration(days: 1)),
                    firstDate: _startingDate!.add(Duration(days: 1)),
                    lastDate: DateTime(2100),
                  );

                  if (pickedDate != null) {
                    String formattedDate = "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
                    setState(() {
                      _endingDate = pickedDate;
                      endingDateController.text = formattedDate;
                    });
                  }
                },

              ),

              SizedBox(height: 20,),

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

              SizedBox(height: 46,),

              ElevatedButton(

                onPressed: () {

                  Fluttertoast.showToast(msg: "Save Changes Successfully");

                  Navigator.pop(context);

                },

                child: Text("Save Plan", style: TextStyle(color: appColor.appbarTxtColor, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 15),),

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
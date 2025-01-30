import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:hr_app/Model/HR%20Screen%20Models/HR%20Master%20Models/HR%20Master%20Menu%20Models/work_Model.dart';
import '../../../../Color/app_Color.dart';

class editWorkScreen extends StatefulWidget {

  workModel dept;

  editWorkScreen({

    super.key,

    required this.dept

  });

  @override
  State<editWorkScreen> createState() => _editWorkScreenState();
}

class _editWorkScreenState extends State<editWorkScreen> {

  var deptNameController = TextEditingController();
  var fullTimeController = TextEditingController();
  var halfTimeController = TextEditingController();
  var maxOTController = TextEditingController();
  var erDepartController = TextEditingController();
  var erArrivalController = TextEditingController();
  var ltArrivalController = TextEditingController();
  var noOfMaxLateController = TextEditingController();

  String halfDayHour = "";
  String halfDayMinute = "";
  String fullDayHour = "";
  String fullDayMinute = "";
  String maxOTHour = "";
  String maxOTMinute = "";

  String? selectedAnnualLeave;
  String? selectedLateAction;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    deptNameController.text = widget.dept.departmentName;
    fullTimeController.text = "${widget.dept.fullDayTime} hour";
    halfTimeController.text = "${widget.dept.halfDayTime} hour";
    maxOTController.text = "${widget.dept.maxOTAllow} hour";
    noOfMaxLateController.text = widget.dept.maxLateNumber.toString().padLeft(2, "0");

    halfDayHour = "${widget.dept.halfDayTime[0]}${widget.dept.halfDayTime[1]}";
    halfDayMinute = "${widget.dept.halfDayTime[3]}${widget.dept.halfDayTime[4]}";
    fullDayHour = "${widget.dept.fullDayTime[0]}${widget.dept.fullDayTime[1]}";
    fullDayMinute = "${widget.dept.fullDayTime[3]}${widget.dept.fullDayTime[4]}";
    maxOTHour = "${widget.dept.maxOTAllow[0]}${widget.dept.maxOTAllow[1]}";
    maxOTMinute = "${widget.dept.maxOTAllow[3]}${widget.dept.maxOTAllow[4]}";

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,

      appBar: AppBar(

        backgroundColor: appColor.primaryColor,

        title: Text("Worktime Management", style: TextStyle(color: appColor.appbarTxtColor, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),),

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

              Text("Edit Worktime", style: TextStyle(color: appColor.bodymainTxtColor, fontSize: 20, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),),

              SizedBox(height: 24,),

              Text("Department Name :", style: TextStyle(color: appColor.bodymainTxtColor, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 15),),

              SizedBox(height: 18,),

              TextFormField(

                controller: deptNameController,

                readOnly: true,

                style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),

                decoration: InputDecoration(

                  filled: true,

                  fillColor: appColor.subPrimaryColor,

                  border: OutlineInputBorder(

                    borderRadius: BorderRadius.circular(10), // Adjust the radius as needed

                    borderSide: BorderSide.none, // No visible border

                  ),

                  enabledBorder: OutlineInputBorder(

                    borderRadius: BorderRadius.circular(10),

                    borderSide: BorderSide.none,

                  ),

                  focusedBorder: OutlineInputBorder(

                    borderRadius: BorderRadius.circular(10),

                    borderSide: BorderSide.none,

                  ),

                ),

              ),

              SizedBox(height: 20,),

              Text("Annual Leave :", style: TextStyle(color: appColor.bodymainTxtColor, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 15),),

              SizedBox(height: 15,),

              DropdownButton2(

                isExpanded: true,

                hint: Text('Nothing selected', style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),),

                value: selectedAnnualLeave,

                style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),

                iconStyleData: IconStyleData(

                  icon: Icon(Icons.arrow_drop_down_rounded, color: Colors.black, size: 34,),

                ),

                buttonStyleData: ButtonStyleData(


                  decoration: BoxDecoration(

                    borderRadius: BorderRadius.circular(10),

                    color: appColor.subPrimaryColor,


                  ),

                  height: 51,

                ),

                underline: Center(),

                dropdownStyleData: DropdownStyleData(

                    decoration: BoxDecoration(

                      color: appColor.subFavColor,

                      borderRadius: BorderRadius.circular(14),

                    ),

                    elevation: 2,

                ),

                items: [

                  DropdownMenuItem(

                    value: 'Sick Leave - 10',

                    child: Text('Sick Leave - 10',style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),),

                  ),

                  DropdownMenuItem(

                    value: 'Unpaid Leave - 15',

                    child: Text('Unpaid Leave - 15',style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),),

                  ),

                  DropdownMenuItem(

                    value: 'awds - 120',

                    child: Text('awds - 120',style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),),

                  ),

                ],

                onChanged: (value) {

                  setState(() {

                    selectedAnnualLeave = value;

                  });

                },

              ),

              SizedBox(height: 20,),

              Text("Late Action :", style: TextStyle(color: appColor.bodymainTxtColor, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 15),),

              SizedBox(height: 15,),

              DropdownButton2(

                isExpanded: true,

                hint: Text('Nothing selected', style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),),

                value: selectedLateAction,

                style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),

                iconStyleData: IconStyleData(

                  icon: Icon(Icons.arrow_drop_down_rounded, color: Colors.black, size: 34,),

                ),

                buttonStyleData: ButtonStyleData(


                  decoration: BoxDecoration(

                    borderRadius: BorderRadius.circular(10),

                    color: appColor.subPrimaryColor,


                  ),

                  height: 51,

                ),

                underline: Center(),

                dropdownStyleData: DropdownStyleData(

                  decoration: BoxDecoration(

                    color: appColor.subFavColor,

                    borderRadius: BorderRadius.circular(14),

                  ),

                  elevation: 2,

                ),

                items: [

                  DropdownMenuItem(

                    value: 'Half Day Absent',

                    child: Text('Half Day Absent',style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),),

                  ),

                  DropdownMenuItem(

                    value: 'Full Day Absent',

                    child: Text('Full Day Absent',style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),),

                  ),

                ],

                onChanged: (value) {

                  setState(() {

                    selectedLateAction = value;

                  });

                },

              ),

              SizedBox(height: 20,),

              Text("Select No. Of Max Late :", style: TextStyle(color: appColor.bodymainTxtColor, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 15),),

              SizedBox(height: 15,),

              TextFormField(

                controller: noOfMaxLateController,

                readOnly: true,

                style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),

                decoration: InputDecoration(

                  filled: true,

                  fillColor: appColor.subPrimaryColor,

                  border: OutlineInputBorder(

                    borderRadius: BorderRadius.circular(10), // Adjust the radius as needed

                    borderSide: BorderSide.none, // No visible border

                  ),

                  enabledBorder: OutlineInputBorder(

                    borderRadius: BorderRadius.circular(10),

                    borderSide: BorderSide.none,

                  ),

                  focusedBorder: OutlineInputBorder(

                    borderRadius: BorderRadius.circular(10),

                    borderSide: BorderSide.none,

                  ),

                ),

                onTap: () async {

                  String selectedOption = noOfMaxLateController.text.padLeft(2, "0");

                  await showDialog(

                    context: context,

                    builder: (context) {

                      return StatefulBuilder(

                        builder: (context, setState) {

                          return Dialog(

                            backgroundColor: appColor.subFavColor,

                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),

                            child: Padding(

                              padding: const EdgeInsets.all(16.0),

                              child: Column(

                                mainAxisSize: MainAxisSize.min,

                                children: [

                                  Text("Select No. of max late", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: "poppins_thin", color: Colors.black,),),

                                  SizedBox(height: 16),

                                  SizedBox(

                                    height: 100,

                                    width: 80,

                                    child: Stack(

                                      alignment: Alignment.center,

                                      children: [

                                        Container(

                                          height: 40,

                                          width: double.infinity,

                                          decoration: BoxDecoration(

                                            borderRadius: BorderRadius.circular(10),

                                            color: Colors.blue.withOpacity(0.3),

                                          ),

                                        ),

                                        ListWheelScrollView.useDelegate(

                                          itemExtent: 40,

                                          physics: FixedExtentScrollPhysics(),

                                          perspective: 0.002,

                                          onSelectedItemChanged: (index) {

                                            setState(() {

                                              selectedOption = index.toString();

                                            });

                                          },

                                          childDelegate: ListWheelChildBuilderDelegate(

                                            builder: (context, index) => Center(

                                              child: Text(index.toString().padLeft(2, '0'), style: TextStyle(fontSize: 14, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, color: Colors.grey.shade800,),),

                                            ),

                                            childCount: 11, // 00 to 10

                                          ),

                                        ),

                                      ],

                                    ),

                                  ),

                                  SizedBox(height: 20),

                                  ElevatedButton(

                                    onPressed: () {

                                      String formattedOption = selectedOption.toString().padLeft(2, '0');

                                      setState(() {

                                        noOfMaxLateController.text = formattedOption;

                                      });

                                      Navigator.of(context).pop();

                                    },

                                    child: Text("Save", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: "poppins_thin", color: Colors.white,),),

                                    style: ElevatedButton.styleFrom(

                                      backgroundColor: appColor.favColor,

                                      textStyle: TextStyle(fontSize: 18),

                                      shape: RoundedRectangleBorder(

                                        borderRadius: BorderRadius.circular(30),

                                      ),

                                      fixedSize: Size(140, 40),

                                    ),

                                  ),

                                ],

                              ),

                            ),

                          );

                        },

                      );

                    },

                  );

                },

              ),

              SizedBox(height: 22,),

              Text("Minimum Working Time :", style: TextStyle(color: appColor.bodymainTxtColor, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 15),),

              SizedBox(height: 20,),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  Container(

                    height: 100,
                    width: MediaQuery.of(context).size.width.toDouble() / 2 - 20,

                    child: Padding(

                      padding: const EdgeInsets.only(right: 20.0),

                      child: Column(

                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [

                          Text("Full day time", style: TextStyle(color: appColor.bodymainTxtColor, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 14),),

                          TextFormField(

                            controller: fullTimeController,

                            readOnly: true,

                            textAlignVertical: TextAlignVertical.center,

                            style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 12),

                            decoration: InputDecoration(

                              hintText: "00:00 hour",

                              hintStyle: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 12),

                              suffixIcon: Icon(Icons.access_time, size: 20, color: appColor.primaryColor,),

                            ),

                            onTap: () async {

                              String selectedHour = fullDayHour;

                              String selectedMinute = fullDayMinute;

                              await showDialog(

                                context: context,

                                builder: (context) {

                                  return StatefulBuilder(

                                    builder: (context, setState) {

                                      return Dialog(

                                        backgroundColor: appColor.subFavColor,

                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),

                                        child: Padding(

                                          padding: const EdgeInsets.all(16.0),

                                          child: Column(

                                            mainAxisSize: MainAxisSize.min,

                                            children: [


                                              Text("Select Time", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: "poppins_thin", color: Colors.black),),

                                              SizedBox(height: 16),

                                              Row(

                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                                                children: [

                                                  Column(

                                                    children: [

                                                      Text("Hours", style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, fontFamily: "poppins_thin", color: Colors.black),),

                                                      SizedBox(

                                                        height: 120,

                                                        width: 80,

                                                        child: Stack(

                                                          alignment: Alignment.center,

                                                          children: [

                                                            Container(

                                                              height: 40,

                                                              width: double.infinity,

                                                              decoration: BoxDecoration(

                                                                borderRadius: BorderRadius.circular(10),

                                                                color: Colors.blue.withOpacity(0.3),

                                                              ),

                                                            ),

                                                            ListWheelScrollView.useDelegate(

                                                              itemExtent: 40,

                                                              physics: FixedExtentScrollPhysics(),

                                                              perspective: 0.002,

                                                              onSelectedItemChanged: (index) {

                                                                setState(() {

                                                                  selectedHour = index.toString();

                                                                });

                                                              },

                                                              childDelegate: ListWheelChildBuilderDelegate(

                                                                builder: (context, index) => Center(

                                                                  child: Text(index.toString().padLeft(2, '0'), style: TextStyle(fontSize: 15, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, color: Colors.grey.shade800),),

                                                                ),

                                                                childCount: 24,

                                                              ),

                                                            ),

                                                          ],

                                                        ),

                                                      ),

                                                    ],

                                                  ),

                                                  Column(

                                                    children: [

                                                      Text("Minutes", style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, fontFamily: "poppins_thin", color: Colors.black),),

                                                      SizedBox(

                                                        height: 120,

                                                        width: 80,

                                                        child: Stack(

                                                          alignment: Alignment.center,

                                                          children: [

                                                            Container(

                                                              height: 40,

                                                              width: double.infinity,

                                                              decoration: BoxDecoration(

                                                                borderRadius: BorderRadius.circular(10),

                                                                color: Colors.blue.withOpacity(0.3),

                                                              ),

                                                            ),

                                                            ListWheelScrollView.useDelegate(

                                                              itemExtent: 40,

                                                              physics: FixedExtentScrollPhysics(),

                                                              perspective: 0.002,

                                                              onSelectedItemChanged: (index) {

                                                                setState(() {

                                                                  selectedMinute = index.toString();

                                                                });

                                                              },

                                                              childDelegate: ListWheelChildBuilderDelegate(

                                                                builder: (context, index) => Center(

                                                                  child: Text(index.toString().padLeft(2, '0'), style: TextStyle(fontSize: 15, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, color: Colors.grey.shade800),),

                                                                ),

                                                                childCount: 60,

                                                              ),

                                                            ),

                                                          ],

                                                        ),

                                                      ),

                                                    ],

                                                  ),

                                                ],

                                              ),

                                              SizedBox(height: 20),

                                              ElevatedButton(

                                                onPressed: () {

                                                  String formattedTime = "${selectedHour.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')}";

                                                  setState(() {

                                                    fullTimeController.text = "${formattedTime} hour";

                                                  });

                                                  Navigator.of(context).pop();

                                                },

                                                child: Text("Save", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: "poppins_thin", color: Colors.white),),

                                                style: ElevatedButton.styleFrom(

                                                  backgroundColor: appColor.favColor,

                                                  textStyle: TextStyle(fontSize: 18),

                                                  shape: RoundedRectangleBorder(

                                                    borderRadius: BorderRadius.circular(30),

                                                  ),

                                                  fixedSize: Size(140, 45),

                                                ),

                                              ),

                                            ],

                                          ),

                                        ),

                                      );

                                    },

                                  );

                                },

                              );

                            },

                          ),

                        ],
                      ),
                    ),

                  ),

                  Container(

                    height: 100,
                    width: MediaQuery.of(context).size.width.toDouble() / 2 - 20,

                    child: Padding(

                      padding: const EdgeInsets.only(left: 20.0),

                      child: Column(

                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [

                          Text("Half day time", style: TextStyle(color: appColor.bodymainTxtColor, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 14),),

                          TextFormField(

                            controller: halfTimeController,

                            readOnly: true,

                            textAlignVertical: TextAlignVertical.center,

                            style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 12),

                            decoration: InputDecoration(

                              hintText: "00:00 hour",

                              hintStyle: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 12),

                              suffixIcon: Icon(Icons.access_time, size: 20, color: appColor.primaryColor,),

                            ),

                            onTap: () async {

                              String selectedHour = halfDayHour;

                              String selectedMinute = halfDayMinute;

                              await showDialog(

                                context: context,

                                builder: (context) {

                                  return StatefulBuilder(

                                    builder: (context, setState) {

                                      return Dialog(

                                        backgroundColor: appColor.subFavColor,

                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),

                                        child: Padding(

                                          padding: const EdgeInsets.all(16.0),

                                          child: Column(

                                            mainAxisSize: MainAxisSize.min,

                                            children: [


                                              Text("Select Time", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: "poppins_thin", color: Colors.black),),

                                              SizedBox(height: 16),

                                              Row(

                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                                                children: [

                                                  Column(

                                                    children: [

                                                      Text("Hours", style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, fontFamily: "poppins_thin", color: Colors.black),),

                                                      SizedBox(

                                                        height: 120,

                                                        width: 80,

                                                        child: Stack(

                                                          alignment: Alignment.center,

                                                          children: [

                                                            Container(

                                                              height: 40,

                                                              width: double.infinity,

                                                              decoration: BoxDecoration(

                                                                borderRadius: BorderRadius.circular(10),

                                                                color: Colors.blue.withOpacity(0.3),

                                                              ),

                                                            ),

                                                            ListWheelScrollView.useDelegate(

                                                              itemExtent: 40,

                                                              physics: FixedExtentScrollPhysics(),

                                                              perspective: 0.002,

                                                              onSelectedItemChanged: (index) {

                                                                setState(() {

                                                                  selectedHour = index.toString();

                                                                });

                                                              },

                                                              childDelegate: ListWheelChildBuilderDelegate(

                                                                builder: (context, index) => Center(

                                                                  child: Text(index.toString().padLeft(2, '0'), style: TextStyle(fontSize: 15, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, color: Colors.grey.shade800),),

                                                                ),

                                                                childCount: 24,

                                                              ),

                                                            ),

                                                          ],

                                                        ),

                                                      ),

                                                    ],

                                                  ),

                                                  Column(

                                                    children: [

                                                      Text("Minutes", style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, fontFamily: "poppins_thin", color: Colors.black),),

                                                      SizedBox(

                                                        height: 120,

                                                        width: 80,

                                                        child: Stack(

                                                          alignment: Alignment.center,

                                                          children: [

                                                            Container(

                                                              height: 40,

                                                              width: double.infinity,

                                                              decoration: BoxDecoration(

                                                                borderRadius: BorderRadius.circular(10),

                                                                color: Colors.blue.withOpacity(0.3),

                                                              ),

                                                            ),

                                                            ListWheelScrollView.useDelegate(

                                                              itemExtent: 40,

                                                              physics: FixedExtentScrollPhysics(),

                                                              perspective: 0.002,

                                                              onSelectedItemChanged: (index) {

                                                                setState(() {

                                                                  selectedMinute = index.toString();

                                                                });

                                                              },

                                                              childDelegate: ListWheelChildBuilderDelegate(

                                                                builder: (context, index) => Center(

                                                                  child: Text(index.toString().padLeft(2, '0'), style: TextStyle(fontSize: 15, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, color: Colors.grey.shade800),),

                                                                ),

                                                                childCount: 60,

                                                              ),

                                                            ),

                                                          ],

                                                        ),

                                                      ),

                                                    ],

                                                  ),

                                                ],

                                              ),

                                              SizedBox(height: 20),

                                              ElevatedButton(

                                                onPressed: () {

                                                  String formattedTime = "${selectedHour.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')}";

                                                  setState(() {

                                                    halfTimeController.text = "${formattedTime} hour";

                                                  });

                                                  Navigator.of(context).pop();

                                                },

                                                child: Text("Save", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: "poppins_thin", color: Colors.white),),

                                                style: ElevatedButton.styleFrom(

                                                  backgroundColor: appColor.favColor,

                                                  textStyle: TextStyle(fontSize: 18),

                                                  shape: RoundedRectangleBorder(

                                                    borderRadius: BorderRadius.circular(30),

                                                  ),

                                                  fixedSize: Size(140, 45),

                                                ),

                                              ),

                                            ],

                                          ),

                                        ),

                                      );

                                    },

                                  );

                                },

                              );

                            },

                          ),

                        ],
                      ),
                    ),

                  ),

                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  Container(

                    height: 100,
                    width: MediaQuery.of(context).size.width.toDouble() / 2 - 20,

                    child: Padding(

                      padding: const EdgeInsets.only(right: 20.0),

                      child: Column(

                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [

                          Text("Max. OT allow", style: TextStyle(color: appColor.bodymainTxtColor, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 14),),

                          TextFormField(

                            controller: maxOTController,

                            readOnly: true,

                            textAlignVertical: TextAlignVertical.center,

                            style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 12),

                            decoration: InputDecoration(

                              hintText: "00:00 hour",

                              hintStyle: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 12),

                              suffixIcon: Icon(Icons.access_time, size: 20, color: appColor.primaryColor,),

                            ),

                            onTap: () async {

                              String selectedHour = maxOTHour;

                              String selectedMinute = maxOTMinute;

                              await showDialog(

                                context: context,

                                builder: (context) {

                                  return StatefulBuilder(

                                    builder: (context, setState) {

                                      return Dialog(

                                        backgroundColor: appColor.subFavColor,

                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),

                                        child: Padding(

                                          padding: const EdgeInsets.all(16.0),

                                          child: Column(

                                            mainAxisSize: MainAxisSize.min,

                                            children: [


                                              Text("Select Time", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: "poppins_thin", color: Colors.black),),

                                              SizedBox(height: 16),

                                              Row(

                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                                                children: [

                                                  Column(

                                                    children: [

                                                      Text("Hours", style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, fontFamily: "poppins_thin", color: Colors.black),),

                                                      SizedBox(

                                                        height: 120,

                                                        width: 80,

                                                        child: Stack(

                                                          alignment: Alignment.center,

                                                          children: [

                                                            Container(

                                                              height: 40,

                                                              width: double.infinity,

                                                              decoration: BoxDecoration(

                                                                borderRadius: BorderRadius.circular(10),

                                                                color: Colors.blue.withOpacity(0.3),

                                                              ),

                                                            ),

                                                            ListWheelScrollView.useDelegate(

                                                              itemExtent: 40,

                                                              physics: FixedExtentScrollPhysics(),

                                                              perspective: 0.002,

                                                              onSelectedItemChanged: (index) {

                                                                setState(() {

                                                                  selectedHour = index.toString();

                                                                });

                                                              },

                                                              childDelegate: ListWheelChildBuilderDelegate(

                                                                builder: (context, index) => Center(

                                                                  child: Text(index.toString().padLeft(2, '0'), style: TextStyle(fontSize: 15, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, color: Colors.grey.shade800),),

                                                                ),

                                                                childCount: 24,

                                                              ),

                                                            ),

                                                          ],

                                                        ),

                                                      ),

                                                    ],

                                                  ),

                                                  Column(

                                                    children: [

                                                      Text("Minutes", style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, fontFamily: "poppins_thin", color: Colors.black),),

                                                      SizedBox(

                                                        height: 120,

                                                        width: 80,

                                                        child: Stack(

                                                          alignment: Alignment.center,

                                                          children: [

                                                            Container(

                                                              height: 40,

                                                              width: double.infinity,

                                                              decoration: BoxDecoration(

                                                                borderRadius: BorderRadius.circular(10),

                                                                color: Colors.blue.withOpacity(0.3),

                                                              ),

                                                            ),

                                                            ListWheelScrollView.useDelegate(

                                                              itemExtent: 40,

                                                              physics: FixedExtentScrollPhysics(),

                                                              perspective: 0.002,

                                                              onSelectedItemChanged: (index) {

                                                                setState(() {

                                                                  selectedMinute = index.toString();

                                                                });

                                                              },

                                                              childDelegate: ListWheelChildBuilderDelegate(

                                                                builder: (context, index) => Center(

                                                                  child: Text(index.toString().padLeft(2, '0'), style: TextStyle(fontSize: 15, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, color: Colors.grey.shade800),),

                                                                ),

                                                                childCount: 60,

                                                              ),

                                                            ),

                                                          ],

                                                        ),

                                                      ),

                                                    ],

                                                  ),

                                                ],

                                              ),

                                              SizedBox(height: 20),

                                              ElevatedButton(

                                                onPressed: () {

                                                  String formattedTime = "${selectedHour.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')}";

                                                  setState(() {

                                                    maxOTController.text = "${formattedTime} hour";

                                                  });

                                                  Navigator.of(context).pop();

                                                },

                                                child: Text("Save", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: "poppins_thin", color: Colors.white),),

                                                style: ElevatedButton.styleFrom(

                                                  backgroundColor: appColor.favColor,

                                                  textStyle: TextStyle(fontSize: 18),

                                                  shape: RoundedRectangleBorder(

                                                    borderRadius: BorderRadius.circular(30),

                                                  ),

                                                  fixedSize: Size(140, 45),

                                                ),

                                              ),

                                            ],

                                          ),

                                        ),

                                      );

                                    },

                                  );

                                },

                              );

                            },

                          ),

                        ],
                      ),
                    ),

                  ),

                  Container(

                    height: 100,
                    width: MediaQuery.of(context).size.width.toDouble() / 2 - 20,

                    child: Padding(

                      padding: const EdgeInsets.only(left: 20.0),

                      child: Column(

                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [

                          Text("Early departure", style: TextStyle(color: appColor.bodymainTxtColor, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 14),),

                          TextFormField(

                            controller: erDepartController,

                            readOnly: true,

                            textAlignVertical: TextAlignVertical.center,

                            style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 12),

                            decoration: InputDecoration(

                              hintText: "00:00 hour",

                              hintStyle: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 12),

                              suffixIcon: Icon(Icons.access_time, size: 20, color: appColor.primaryColor,),

                            ),

                            onTap: () async {

                              String selectedHour = "0";

                              String selectedMinute = "0";

                              await showDialog(

                                context: context,

                                builder: (context) {

                                  return StatefulBuilder(

                                    builder: (context, setState) {

                                      return Dialog(

                                        backgroundColor: appColor.subFavColor,

                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),

                                        child: Padding(

                                          padding: const EdgeInsets.all(16.0),

                                          child: Column(

                                            mainAxisSize: MainAxisSize.min,

                                            children: [


                                              Text("Select Time", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: "poppins_thin", color: Colors.black),),

                                              SizedBox(height: 16),

                                              Row(

                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                                                children: [

                                                  Column(

                                                    children: [

                                                      Text("Hours", style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, fontFamily: "poppins_thin", color: Colors.black),),

                                                      SizedBox(

                                                        height: 120,

                                                        width: 80,

                                                        child: Stack(

                                                          alignment: Alignment.center,

                                                          children: [

                                                            Container(

                                                              height: 40,

                                                              width: double.infinity,

                                                              decoration: BoxDecoration(

                                                                borderRadius: BorderRadius.circular(10),

                                                                color: Colors.blue.withOpacity(0.3),

                                                              ),

                                                            ),

                                                            ListWheelScrollView.useDelegate(

                                                              itemExtent: 40,

                                                              physics: FixedExtentScrollPhysics(),

                                                              perspective: 0.002,

                                                              onSelectedItemChanged: (index) {

                                                                setState(() {

                                                                  selectedHour = index.toString();

                                                                });

                                                              },

                                                              childDelegate: ListWheelChildBuilderDelegate(

                                                                builder: (context, index) => Center(

                                                                  child: Text(index.toString().padLeft(2, '0'), style: TextStyle(fontSize: 15, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, color: Colors.grey.shade800),),

                                                                ),

                                                                childCount: 24,

                                                              ),

                                                            ),

                                                          ],

                                                        ),

                                                      ),

                                                    ],

                                                  ),

                                                  Column(

                                                    children: [

                                                      Text("Minutes", style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, fontFamily: "poppins_thin", color: Colors.black),),

                                                      SizedBox(

                                                        height: 120,

                                                        width: 80,

                                                        child: Stack(

                                                          alignment: Alignment.center,

                                                          children: [

                                                            Container(

                                                              height: 40,

                                                              width: double.infinity,

                                                              decoration: BoxDecoration(

                                                                borderRadius: BorderRadius.circular(10),

                                                                color: Colors.blue.withOpacity(0.3),

                                                              ),

                                                            ),

                                                            ListWheelScrollView.useDelegate(

                                                              itemExtent: 40,

                                                              physics: FixedExtentScrollPhysics(),

                                                              perspective: 0.002,

                                                              onSelectedItemChanged: (index) {

                                                                setState(() {

                                                                  selectedMinute = index.toString();

                                                                });

                                                              },

                                                              childDelegate: ListWheelChildBuilderDelegate(

                                                                builder: (context, index) => Center(

                                                                  child: Text(index.toString().padLeft(2, '0'), style: TextStyle(fontSize: 15, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, color: Colors.grey.shade800),),

                                                                ),

                                                                childCount: 60,

                                                              ),

                                                            ),

                                                          ],

                                                        ),

                                                      ),

                                                    ],

                                                  ),

                                                ],

                                              ),

                                              SizedBox(height: 20),

                                              ElevatedButton(

                                                onPressed: () {

                                                  String formattedTime = "${selectedHour.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')}";

                                                  setState(() {

                                                    erDepartController.text = "${formattedTime} hour";

                                                  });

                                                  Navigator.of(context).pop();

                                                },

                                                child: Text("Save", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: "poppins_thin", color: Colors.white),),

                                                style: ElevatedButton.styleFrom(

                                                  backgroundColor: appColor.favColor,

                                                  textStyle: TextStyle(fontSize: 18),

                                                  shape: RoundedRectangleBorder(

                                                    borderRadius: BorderRadius.circular(30),

                                                  ),

                                                  fixedSize: Size(140, 45),

                                                ),

                                              ),

                                            ],

                                          ),

                                        ),

                                      );

                                    },

                                  );

                                },

                              );

                            },

                          ),

                        ],
                      ),
                    ),

                  ),

                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  Container(

                    height: 100,
                    width: MediaQuery.of(context).size.width.toDouble() / 2 - 20,

                    child: Padding(

                      padding: const EdgeInsets.only(right: 20.0),

                      child: Column(

                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [

                          Text("Early Arrival", style: TextStyle(color: appColor.bodymainTxtColor, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 14),),

                          TextFormField(

                            controller: erArrivalController,

                            readOnly: true,

                            textAlignVertical: TextAlignVertical.center,

                            style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 12),

                            decoration: InputDecoration(

                              hintText: "00:00 hour",

                              hintStyle: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 12),

                              suffixIcon: Icon(Icons.access_time, size: 20, color: appColor.primaryColor,),

                            ),

                            onTap: () async {

                              String selectedHour = "0";

                              String selectedMinute = "0";

                              await showDialog(

                                context: context,

                                builder: (context) {

                                  return StatefulBuilder(

                                    builder: (context, setState) {

                                      return Dialog(

                                        backgroundColor: appColor.subFavColor,

                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),

                                        child: Padding(

                                          padding: const EdgeInsets.all(16.0),

                                          child: Column(

                                            mainAxisSize: MainAxisSize.min,

                                            children: [


                                              Text("Select Time", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: "poppins_thin", color: Colors.black),),

                                              SizedBox(height: 16),

                                              Row(

                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                                                children: [

                                                  Column(

                                                    children: [

                                                      Text("Hours", style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, fontFamily: "poppins_thin", color: Colors.black),),

                                                      SizedBox(

                                                        height: 120,

                                                        width: 80,

                                                        child: Stack(

                                                          alignment: Alignment.center,

                                                          children: [

                                                            Container(

                                                              height: 40,

                                                              width: double.infinity,

                                                              decoration: BoxDecoration(

                                                                borderRadius: BorderRadius.circular(10),

                                                                color: Colors.blue.withOpacity(0.3),

                                                              ),

                                                            ),

                                                            ListWheelScrollView.useDelegate(

                                                              itemExtent: 40,

                                                              physics: FixedExtentScrollPhysics(),

                                                              perspective: 0.002,

                                                              onSelectedItemChanged: (index) {

                                                                setState(() {

                                                                  selectedHour = index.toString();

                                                                });

                                                              },

                                                              childDelegate: ListWheelChildBuilderDelegate(

                                                                builder: (context, index) => Center(

                                                                  child: Text(index.toString().padLeft(2, '0'), style: TextStyle(fontSize: 15, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, color: Colors.grey.shade800),),

                                                                ),

                                                                childCount: 24,

                                                              ),

                                                            ),

                                                          ],

                                                        ),

                                                      ),

                                                    ],

                                                  ),

                                                  Column(

                                                    children: [

                                                      Text("Minutes", style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, fontFamily: "poppins_thin", color: Colors.black),),

                                                      SizedBox(

                                                        height: 120,

                                                        width: 80,

                                                        child: Stack(

                                                          alignment: Alignment.center,

                                                          children: [

                                                            Container(

                                                              height: 40,

                                                              width: double.infinity,

                                                              decoration: BoxDecoration(

                                                                borderRadius: BorderRadius.circular(10),

                                                                color: Colors.blue.withOpacity(0.3),

                                                              ),

                                                            ),

                                                            ListWheelScrollView.useDelegate(

                                                              itemExtent: 40,

                                                              physics: FixedExtentScrollPhysics(),

                                                              perspective: 0.002,

                                                              onSelectedItemChanged: (index) {

                                                                setState(() {

                                                                  selectedMinute = index.toString();

                                                                });

                                                              },

                                                              childDelegate: ListWheelChildBuilderDelegate(

                                                                builder: (context, index) => Center(

                                                                  child: Text(index.toString().padLeft(2, '0'), style: TextStyle(fontSize: 15, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, color: Colors.grey.shade800),),

                                                                ),

                                                                childCount: 60,

                                                              ),

                                                            ),

                                                          ],

                                                        ),

                                                      ),

                                                    ],

                                                  ),

                                                ],

                                              ),

                                              SizedBox(height: 20),

                                              ElevatedButton(

                                                onPressed: () {

                                                  String formattedTime = "${selectedHour.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')}";

                                                  setState(() {

                                                    erArrivalController.text = "${formattedTime} hour";

                                                  });

                                                  Navigator.of(context).pop();

                                                },

                                                child: Text("Save", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: "poppins_thin", color: Colors.white),),

                                                style: ElevatedButton.styleFrom(

                                                  backgroundColor: appColor.favColor,

                                                  textStyle: TextStyle(fontSize: 18),

                                                  shape: RoundedRectangleBorder(

                                                    borderRadius: BorderRadius.circular(30),

                                                  ),

                                                  fixedSize: Size(140, 45),

                                                ),

                                              ),

                                            ],

                                          ),

                                        ),

                                      );

                                    },

                                  );

                                },

                              );

                            },

                          ),

                        ],
                      ),
                    ),

                  ),

                  Container(

                    height: 100,
                    width: MediaQuery.of(context).size.width.toDouble() / 2 - 20,

                    child: Padding(

                      padding: const EdgeInsets.only(left: 20.0),

                      child: Column(

                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [

                          Text("Late Arrival", style: TextStyle(color: appColor.bodymainTxtColor, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 14),),

                          TextFormField(

                            controller: ltArrivalController,

                            readOnly: true,

                            textAlignVertical: TextAlignVertical.center,

                            style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 12),

                            decoration: InputDecoration(

                              hintText: "00:00 hour",

                              hintStyle: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 12),

                              suffixIcon: Icon(Icons.access_time, size: 20, color: appColor.primaryColor,),

                            ),

                            onTap: () async {

                              String selectedHour = "0";

                              String selectedMinute = "0";

                              await showDialog(

                                context: context,

                                builder: (context) {

                                  return StatefulBuilder(

                                    builder: (context, setState) {

                                      return Dialog(

                                        backgroundColor: appColor.subFavColor,

                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),

                                        child: Padding(

                                          padding: const EdgeInsets.all(16.0),

                                          child: Column(

                                            mainAxisSize: MainAxisSize.min,

                                            children: [


                                              Text("Select Time", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: "poppins_thin", color: Colors.black),),

                                              SizedBox(height: 16),

                                              Row(

                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                                                children: [

                                                  Column(

                                                    children: [

                                                      Text("Hours", style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, fontFamily: "poppins_thin", color: Colors.black),),

                                                      SizedBox(

                                                        height: 120,

                                                        width: 80,

                                                        child: Stack(

                                                          alignment: Alignment.center,

                                                          children: [

                                                            Container(

                                                              height: 40,

                                                              width: double.infinity,

                                                              decoration: BoxDecoration(

                                                                borderRadius: BorderRadius.circular(10),

                                                                color: Colors.blue.withOpacity(0.3),

                                                              ),

                                                            ),

                                                            ListWheelScrollView.useDelegate(

                                                              itemExtent: 40,

                                                              physics: FixedExtentScrollPhysics(),

                                                              perspective: 0.002,

                                                              onSelectedItemChanged: (index) {

                                                                setState(() {

                                                                  selectedHour = index.toString();

                                                                });

                                                              },

                                                              childDelegate: ListWheelChildBuilderDelegate(

                                                                builder: (context, index) => Center(

                                                                  child: Text(index.toString().padLeft(2, '0'), style: TextStyle(fontSize: 15, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, color: Colors.grey.shade800),),

                                                                ),

                                                                childCount: 24,

                                                              ),

                                                            ),

                                                          ],

                                                        ),

                                                      ),

                                                    ],

                                                  ),

                                                  Column(

                                                    children: [

                                                      Text("Minutes", style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, fontFamily: "poppins_thin", color: Colors.black),),

                                                      SizedBox(

                                                        height: 120,

                                                        width: 80,

                                                        child: Stack(

                                                          alignment: Alignment.center,

                                                          children: [

                                                            Container(

                                                              height: 40,

                                                              width: double.infinity,

                                                              decoration: BoxDecoration(

                                                                borderRadius: BorderRadius.circular(10),

                                                                color: Colors.blue.withOpacity(0.3),

                                                              ),

                                                            ),

                                                            ListWheelScrollView.useDelegate(

                                                              itemExtent: 40,

                                                              physics: FixedExtentScrollPhysics(),

                                                              perspective: 0.002,

                                                              onSelectedItemChanged: (index) {

                                                                setState(() {

                                                                  selectedMinute = index.toString();

                                                                });

                                                              },

                                                              childDelegate: ListWheelChildBuilderDelegate(

                                                                builder: (context, index) => Center(

                                                                  child: Text(index.toString().padLeft(2, '0'), style: TextStyle(fontSize: 15, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, color: Colors.grey.shade800),),

                                                                ),

                                                                childCount: 60,

                                                              ),

                                                            ),

                                                          ],

                                                        ),

                                                      ),

                                                    ],

                                                  ),

                                                ],

                                              ),

                                              SizedBox(height: 20),

                                              ElevatedButton(

                                                onPressed: () {

                                                  String formattedTime = "${selectedHour.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')}";

                                                  setState(() {

                                                    ltArrivalController.text = "${formattedTime} hour";

                                                  });

                                                  Navigator.of(context).pop();

                                                },

                                                child: Text("Save", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: "poppins_thin", color: Colors.white),),

                                                style: ElevatedButton.styleFrom(

                                                  backgroundColor: appColor.favColor,

                                                  textStyle: TextStyle(fontSize: 18),

                                                  shape: RoundedRectangleBorder(

                                                    borderRadius: BorderRadius.circular(30),

                                                  ),

                                                  fixedSize: Size(140, 45),

                                                ),

                                              ),

                                            ],

                                          ),

                                        ),

                                      );

                                    },

                                  );

                                },

                              );

                            },

                          ),

                        ],
                      ),
                    ),

                  ),

                ],
              ),

              ElevatedButton(

                onPressed: () {

                  Navigator.pop(context);

                },

                child: Text("Save", style: TextStyle(color: appColor.appbarTxtColor, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 15),),

                style: ElevatedButton.styleFrom(

                  backgroundColor: appColor.primaryColor,

                  shape: RoundedRectangleBorder(

                    borderRadius: BorderRadius.circular(30),

                  ),

                  fixedSize: Size(MediaQuery.of(context).size.width.toDouble(), 45),

                ),

              ),

              SizedBox(height: 25,),

            ],

          ),

        ),

      ),

    );

  }

}
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_app/Model/HR%20Screen%20Models/HR%20Master%20Models/HR%20Master%20Menu%20Models/shift_Model.dart';
import 'package:intl/intl.dart';

import '../../../../Color/app_Color.dart';

class editShiftScreen extends StatefulWidget {

  shiftModel shift;

  editShiftScreen({

    super.key,

    required this.shift

  });

  @override
  State<editShiftScreen> createState() => _editShiftScreenState();
}

class _editShiftScreenState extends State<editShiftScreen> {

  var nameController = TextEditingController();

  var inTimeController = TextEditingController();

  var outTimeController = TextEditingController();

  var lunchInController = TextEditingController();

  var lunchOutController = TextEditingController();

  var extraHRSController = TextEditingController();

  var workingHRSController = TextEditingController();

  bool isLunchTimeCount = true;

  // function for assign value to each fields
  assignAllValue() {

    nameController.text = widget.shift.shiftName;
    inTimeController.text = widget.shift.inTime;
    outTimeController.text = widget.shift.outTime;
    workingHRSController.text = widget.shift.totalWorkingHours;

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

      appBar: AppBar(

        backgroundColor: appColor.primaryColor,

        title: Text("Shift Management", style: TextStyle(color: appColor.appbarTxtColor, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),),

        centerTitle: true,

        foregroundColor: Colors.transparent,

        leading: IconButton(

          onPressed: (){
            Navigator.pop(context);
          },

          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20,),

        ),

      ),

      backgroundColor: Colors.white,

      body: Padding(

        padding: const EdgeInsets.symmetric(horizontal: 20.0),

        child: SingleChildScrollView(

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              SizedBox(height: 30,),

              Text("Edit Shift", style: TextStyle(color: appColor.bodymainTxtColor, fontSize: 20, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),),

              SizedBox(height: 30,),

              TextFormField(

                controller: nameController,

                style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),

                decoration: InputDecoration(

                  enabledBorder: OutlineInputBorder(

                    borderRadius: BorderRadius.circular(10),

                    borderSide: BorderSide(color: appColor.primaryColor),

                  ),

                  focusedBorder: OutlineInputBorder(

                    borderRadius: BorderRadius.circular(15),

                    borderSide: BorderSide(color: appColor.primaryColor),

                  ),

                  hintText: "Shift Name",

                  hintStyle: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 14),

                ),

              ),

              SizedBox(height: 45,),

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

                          Text("In Time", style: TextStyle(color: Colors.grey.shade800, fontFamily: "poppins_thin", fontWeight: FontWeight.w800, fontSize: 14),),

                          TextFormField(

                              controller: inTimeController,

                              readOnly: true,

                              style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),

                              decoration: InputDecoration(

                                hintText: "00:00",

                                hintStyle: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 12),

                                suffixIcon: Icon(Icons.access_time, size: 20, color: appColor.primaryColor,),

                              ),

                              onTap: () async {

                                TimeOfDay? pickedTime = await showTimePicker(

                                  context: context,

                                  initialTime: TimeOfDay.now(),

                                  builder: (BuildContext context, Widget? child) {

                                    return Theme(

                                      data: ThemeData.light().copyWith(

                                        primaryColor: Colors.red, // Header background color

                                        shadowColor: Colors.orange, // Selected time color

                                        buttonTheme: ButtonThemeData(

                                          colorScheme: ColorScheme.light(primary: Colors.teal),

                                        ),

                                        timePickerTheme: TimePickerThemeData(


                                          dayPeriodColor: appColor.subPrimaryColor,

                                          dayPeriodTextColor: Colors.black,

                                          dialBackgroundColor: appColor.subPrimaryColor,

                                          hourMinuteColor: appColor.subPrimaryColor,

                                          entryModeIconColor: Colors.black,

                                          dialTextStyle: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),

                                          dayPeriodTextStyle: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),

                                          hourMinuteTextStyle: TextStyle(color: Colors.black, fontSize: 44, fontFamily: "poppins_thin"),

                                          dayPeriodShape: RoundedRectangleBorder(

                                            borderRadius: BorderRadius.circular(10),

                                          ),

                                          dayPeriodBorderSide: BorderSide(color: appColor.primaryColor),

                                          dialHandColor: appColor.primaryColor, // Dial hand color

                                          hourMinuteTextColor: Colors.black, // Hour and minute text color

                                          backgroundColor: appColor.subFavColor, // Dialog background color

                                        ),

                                      ),

                                      child: child!,

                                    );

                                  },

                                );

                                if (pickedTime != null) {
                                  setState(() {
                                    String formattedTime = pickedTime.format(context);
                                    inTimeController.text = formattedTime;
                                  });
                                }
                              }

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

                          Text("Out Time", style: TextStyle(color: Colors.grey.shade800, fontFamily: "poppins_thin", fontWeight: FontWeight.w800, fontSize: 14),),

                          TextFormField(

                              controller: outTimeController,

                              readOnly: true,

                              style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),

                              decoration: InputDecoration(

                                hintText: "00:00",

                                hintStyle: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 12),

                                suffixIcon: Icon(Icons.access_time, size: 20, color: appColor.primaryColor,),

                              ),

                              onTap: () async {

                                TimeOfDay? pickedTime = await showTimePicker(

                                  context: context,

                                  initialTime: TimeOfDay.now(),

                                  builder: (BuildContext context, Widget? child) {

                                    return Theme(

                                      data: ThemeData.light().copyWith(

                                        primaryColor: Colors.red, // Header background color

                                        shadowColor: Colors.orange, // Selected time color

                                        buttonTheme: ButtonThemeData(

                                          colorScheme: ColorScheme.light(primary: Colors.teal),

                                        ),

                                        timePickerTheme: TimePickerThemeData(


                                          dayPeriodColor: appColor.subPrimaryColor,

                                          dayPeriodTextColor: Colors.black,

                                          dialBackgroundColor: appColor.subPrimaryColor,

                                          hourMinuteColor: appColor.subPrimaryColor,

                                          entryModeIconColor: Colors.black,

                                          dialTextStyle: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),

                                          dayPeriodTextStyle: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),

                                          hourMinuteTextStyle: TextStyle(color: Colors.black, fontSize: 44, fontFamily: "poppins_thin"),

                                          dayPeriodShape: RoundedRectangleBorder(

                                            borderRadius: BorderRadius.circular(10),

                                          ),

                                          dayPeriodBorderSide: BorderSide(color: appColor.primaryColor),

                                          dialHandColor: appColor.primaryColor, // Dial hand color

                                          hourMinuteTextColor: Colors.black, // Hour and minute text color

                                          backgroundColor: appColor.subFavColor, // Dialog background color

                                        ),

                                      ),

                                      child: child!,

                                    );

                                  },

                                );

                                if (pickedTime != null) {
                                  setState(() {
                                    String formattedTime = pickedTime.format(context);
                                    outTimeController.text = formattedTime;
                                  });
                                }
                              }


                          ),

                        ],
                      ),
                    ),

                  ),

                ],
              ),

              SizedBox(height: 10,),

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

                          Text("Lunch In", style: TextStyle(color: Colors.grey.shade800, fontFamily: "poppins_thin", fontWeight: FontWeight.w800, fontSize: 14),),

                          TextFormField(

                              controller: lunchInController,

                              readOnly: true,

                              style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),

                              decoration: InputDecoration(

                                hintText: "00:00",

                                hintStyle: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 12),

                                suffixIcon: Icon(Icons.access_time, size: 20, color: appColor.primaryColor,),

                              ),

                              onTap: () async {

                                TimeOfDay? pickedTime = await showTimePicker(

                                  context: context,

                                  initialTime: TimeOfDay.now(),

                                  builder: (BuildContext context, Widget? child) {

                                    return Theme(

                                      data: ThemeData.light().copyWith(

                                        primaryColor: Colors.red, // Header background color

                                        shadowColor: Colors.orange, // Selected time color

                                        buttonTheme: ButtonThemeData(

                                          colorScheme: ColorScheme.light(primary: Colors.teal),

                                        ),

                                        timePickerTheme: TimePickerThemeData(


                                          dayPeriodColor: appColor.subPrimaryColor,

                                          dayPeriodTextColor: Colors.black,

                                          dialBackgroundColor: appColor.subPrimaryColor,

                                          hourMinuteColor: appColor.subPrimaryColor,

                                          entryModeIconColor: Colors.black,

                                          dialTextStyle: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),

                                          dayPeriodTextStyle: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),

                                          hourMinuteTextStyle: TextStyle(color: Colors.black, fontSize: 44, fontFamily: "poppins_thin"),

                                          dayPeriodShape: RoundedRectangleBorder(

                                            borderRadius: BorderRadius.circular(10),

                                          ),

                                          dayPeriodBorderSide: BorderSide(color: appColor.primaryColor),

                                          dialHandColor: appColor.primaryColor, // Dial hand color

                                          hourMinuteTextColor: Colors.black, // Hour and minute text color

                                          backgroundColor: appColor.subFavColor, // Dialog background color

                                        ),

                                      ),

                                      child: child!,

                                    );

                                  },

                                );

                                if (pickedTime != null) {
                                  setState(() {
                                    String formattedTime = pickedTime.format(context);
                                    lunchInController.text = formattedTime;
                                  });
                                }
                              }

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

                          Text("Lunch Out", style: TextStyle(color: Colors.grey.shade800, fontFamily: "poppins_thin", fontWeight: FontWeight.w800, fontSize: 14),),

                          TextFormField(

                              controller: lunchOutController,

                              readOnly: true,

                              style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),

                              decoration: InputDecoration(

                                hintText: "00:00",

                                hintStyle: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 12),

                                suffixIcon: Icon(Icons.access_time, size: 20, color: appColor.primaryColor,),

                              ),

                              onTap: () async {

                                TimeOfDay? pickedTime = await showTimePicker(

                                  context: context,

                                  initialTime: TimeOfDay.now(),

                                  builder: (BuildContext context, Widget? child) {

                                    return Theme(

                                      data: ThemeData.light().copyWith(

                                        primaryColor: Colors.red, // Header background color

                                        shadowColor: Colors.orange, // Selected time color

                                        buttonTheme: ButtonThemeData(

                                          colorScheme: ColorScheme.light(primary: Colors.teal),

                                        ),

                                        timePickerTheme: TimePickerThemeData(


                                          dayPeriodColor: appColor.subPrimaryColor,

                                          dayPeriodTextColor: Colors.black,

                                          dialBackgroundColor: appColor.subPrimaryColor,

                                          hourMinuteColor: appColor.subPrimaryColor,

                                          entryModeIconColor: Colors.black,

                                          dialTextStyle: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),

                                          dayPeriodTextStyle: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),

                                          hourMinuteTextStyle: TextStyle(color: Colors.black, fontSize: 44, fontFamily: "poppins_thin"),

                                          dayPeriodShape: RoundedRectangleBorder(

                                            borderRadius: BorderRadius.circular(10),

                                          ),

                                          dayPeriodBorderSide: BorderSide(color: appColor.primaryColor),

                                          dialHandColor: appColor.primaryColor, // Dial hand color

                                          hourMinuteTextColor: Colors.black, // Hour and minute text color

                                          backgroundColor: appColor.subFavColor, // Dialog background color

                                        ),

                                      ),

                                      child: child!,

                                    );

                                  },

                                );

                                if (pickedTime != null) {
                                  setState(() {
                                    String formattedTime = pickedTime.format(context);
                                    lunchOutController.text = formattedTime;
                                  });
                                }
                              }


                          ),

                        ],
                      ),
                    ),

                  ),

                ],
              ),

              SizedBox(height: 5,),

              Row(
                children: [

                  Switch(

                    value: isLunchTimeCount,

                    activeTrackColor: appColor.primaryColor,

                    inactiveTrackColor: appColor.subFavColor,

                    onChanged: (value) {

                      setState(() {

                        isLunchTimeCount = value;

                      });

                    },

                  ),

                  SizedBox(width: 6,),

                  Text("Lunch time count in working hours", style: TextStyle(color: Colors.grey.shade800, fontFamily: "poppins_thin", fontWeight: FontWeight.w800, fontSize: 14),),

                ],
              ),

              SizedBox(height: 30,),

              Text("Extra Hours", style: TextStyle(color: Colors.grey.shade800, fontFamily: "poppins_thin", fontWeight: FontWeight.w800, fontSize: 14),),

              TextFormField(

                controller: extraHRSController,

                readOnly: true,

                style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),

                decoration: InputDecoration(

                  hintText: "00:00 hour",

                  hintStyle: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 12),

                  suffixIcon: Icon(Icons.access_time, size: 20, color: appColor.primaryColor,),

                ),

                onTap: () async {

                  TimeOfDay? pickedTime = await showTimePicker(

                    context: context,

                    initialTime: TimeOfDay.now(),

                    builder: (BuildContext context, Widget? child) {

                      return Theme(

                        data: ThemeData.light().copyWith(

                          primaryColor: Colors.red, // Header background color

                          shadowColor: Colors.orange, // Selected time color

                          buttonTheme: ButtonThemeData(

                            colorScheme: ColorScheme.light(primary: Colors.teal),

                          ),

                          timePickerTheme: TimePickerThemeData(


                            dayPeriodColor: Colors.transparent,

                            dayPeriodTextColor: Colors.transparent,

                            dialBackgroundColor: appColor.subPrimaryColor,

                            hourMinuteColor: appColor.subPrimaryColor,

                            entryModeIconColor: Colors.black,

                            dialTextStyle: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),

                            hourMinuteTextStyle: TextStyle(color: Colors.black, fontSize: 44, fontFamily: "poppins_thin"),

                            dayPeriodBorderSide: BorderSide(color: Colors.transparent),

                            dialHandColor: appColor.primaryColor, // Dial hand color

                            hourMinuteTextColor: Colors.black, // Hour and minute text color

                            backgroundColor: appColor.subFavColor, // Dialog background color

                          ),

                        ),

                        child: child!,

                      );

                    },

                  );

                  if (pickedTime != null) {

                    setState(() {

                      final String formattedTime = "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')} hour";

                      extraHRSController.text = formattedTime; // Display the formatted time

                    });

                  }

                },

              ),

              SizedBox(height: 30,),

              Text("Working Hours", style: TextStyle(color: Colors.grey.shade800, fontFamily: "poppins_thin", fontWeight: FontWeight.w800, fontSize: 14),),

              TextFormField(

                controller: workingHRSController,

                readOnly: true,

                style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),

                decoration: InputDecoration(

                  hintText: "00:00 hour",

                  hintStyle: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 12),

                  suffixIcon: Icon(Icons.access_time, size: 20, color: appColor.primaryColor,),

                ),

                onTap: () {
                  // Parse the input times using the 12-hour format with AM/PM
                  DateTime? inTime = _parseTimeToDateTime(inTimeController.text);
                  DateTime? outTime = _parseTimeToDateTime(outTimeController.text);
                  DateTime? lunchInTime = _parseTimeToDateTime(lunchInController.text);
                  DateTime? lunchOutTime = _parseTimeToDateTime(lunchOutController.text);
                  Duration extraTime = _parseTimeToDuration(extraHRSController.text);

                  // Debug output
                  print('In Time: $inTime');
                  print('Out Time: $outTime');
                  print('Lunch In Time: $lunchInTime');
                  print('Lunch Out Time: $lunchOutTime');
                  print('Extra Time: $extraTime');

                  // Check if times are valid and calculate working hours
                  if (inTime != null && outTime != null) {
                    Duration workDuration = outTime.difference(inTime); // Difference between In and Out Time

                    // Debug output
                    print('Work Duration: $workDuration');

                    if (isLunchTimeCount && lunchInTime != null && lunchOutTime != null) {
                      // Count lunch time when isLunchTimeCount is true
                      Duration lunchDuration = lunchOutTime.difference(lunchInTime); // Difference between Lunch In and Lunch Out
                      if (lunchDuration.inMinutes > 0) {
                        workDuration += lunchDuration; // Add lunch time to work duration
                      }

                      // Debug output
                      print('Lunch Duration (Added): $lunchDuration');
                    } else if (!isLunchTimeCount && lunchInTime != null && lunchOutTime != null) {
                      // Subtract lunch time when isLunchTimeCount is false
                      Duration lunchDuration = lunchOutTime.difference(lunchInTime); // Difference between Lunch In and Lunch Out
                      if (lunchDuration.inMinutes > 0) {
                        workDuration -= lunchDuration; // Subtract lunch time from work duration
                      }

                      // Debug output
                      print('Lunch Duration (Subtracted): $lunchDuration');
                    }

                    // Add the extra hours if any
                    workDuration += extraTime;

                    // Debug output
                    print('Final Work Duration: $workDuration');

                    // Format the result into hours and minutes
                    String formattedWorkingHours = _formatDurationToTime(workDuration);

                    // Set the result to the controller
                    setState(() {
                      workingHRSController.text = formattedWorkingHours;
                    });
                  } else {
                    setState(() {
                      workingHRSController.text = "00:00 hours"; // Default value if times are invalid
                    });
                  }
                },

              ),

              SizedBox(height: 40,),

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

  DateTime? _parseTimeToDateTime(String time) {

    if (time.isEmpty) return null; // Return null if the time is empty

    try {

      return DateFormat("hh:mm a").parse(time);

    } catch (e) {

      print('Error parsing time: $time');

      return null; // Return null if the parsing fails

    }

  }

  Duration _parseTimeToDuration(String time) {

    if (time.isEmpty) return Duration.zero; // Return zero if the time is empty

    List<String> parts = time.split(':');

    if (parts.length == 2) {

      try {

        int hours = int.parse(parts[0]);

        int minutes = int.parse(parts[1]);

        return Duration(hours: hours, minutes: minutes);

      } catch (e) {

        print('Error parsing extra time: $time');

        return Duration.zero; // Return zero if the parsing fails

      }

    }

    return Duration.zero; // Return zero if the time format is invalid

  }

  String _formatDurationToTime(Duration duration) {

    int hours = duration.inHours;

    int minutes = duration.inMinutes % 60;

    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')} hours";

  }

}
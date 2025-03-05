import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
// import '../../../../Provider/UserProvider.dart';
import '../../../../../Provider/UserProvider.dart';
import '../../Color/app_Color.dart';

class addLeaveRequestScreen extends StatefulWidget {
  const addLeaveRequestScreen({super.key});

  @override
  State<addLeaveRequestScreen> createState() => _addLeaveRequestScreenState();
}

class _addLeaveRequestScreenState extends State<addLeaveRequestScreen> {

  var nameController = TextEditingController();
  var approverController = TextEditingController();

  var startingDateController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;

  var selectedLeaveType;
  var selectedLeaveTypeId;

  var endingDateController = TextEditingController();

  var applyDaysController = TextEditingController();
  var leaveReasonController = TextEditingController();

  var headID;
  var underTeam;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      // Fetch leave types data
      await userProvider.fetchLeaveTypesData();
      await userProvider.fetchStaffLeavesData();

      // Safely access the fetched data
      final userName = userProvider.leaveTypesData?.data?.username ?? '';
      final approverName = userProvider.leaveTypesData?.data?.headName ?? '';
      headID = userProvider.leaveTypesData?.data?.head ?? '';
      underTeam  = userProvider.staffLeavesData?.data?[0].underTeam ?? '';

      // Set controller values
      nameController.text = userName;
      approverController.text = approverName;

      // Trigger UI update if necessary
      if (mounted) {
        setState(() {});
      }
    });

  }

  @override
  Widget build(BuildContext context) {

    final userProvider = Provider.of<UserProvider>(context).leaveTypesData;
    final leaveTypesList = userProvider?.data?.typeOfLeave ?? [];

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

                  style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),

                  decoration: InputDecoration(

                    filled: true,

                    fillColor: appColor.subPrimaryColor,

                    hintText: "User Name",

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

              ),

              SizedBox(height: 15,),

              Text("Type Of Leave :", style: TextStyle(color: appColor.bodymainTxtColor, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 15),),

              SizedBox(height: 10,),

              Card(
                elevation: 2,
                color: Colors.transparent,
                shadowColor: appColor.boxColor,
                child: DropdownButton2(

                  isExpanded: true,

                  hint: Text('Select leave type', style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),),

                  value: selectedLeaveType,

                  style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),

                  iconStyleData: IconStyleData(

                    icon: Icon(Icons.arrow_drop_down_rounded, color: appColor.primaryColor, size: 34,),

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

                  items: leaveTypesList.map((leave) {
                    String displayText = "${leave.leaveType}";
                    return DropdownMenuItem<String>(
                      value: displayText,
                      child: Text(displayText, style: TextStyle( color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5,),),
                    );
                  }).toList(),

                  onChanged: (value) {
                    setState(() {
                      selectedLeaveType = value;
                    });
                  },

                ),
              ),

              SizedBox(height: 15,),

              Text("Leave Date From :", style: TextStyle(color: appColor.bodymainTxtColor, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 15),),

              SizedBox(height: 10,),

              Card(

                elevation: 2,
                color: Colors.transparent,
                shadowColor: appColor.boxColor,

                child: TextFormField(

                  controller: startingDateController,

                  style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),

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

                        // _calculateApplyDays();

                      });

                    }

                  },

                ),

              ),

              SizedBox(height: 15,),

              Text("Leave Date To :", style: TextStyle(color: appColor.bodymainTxtColor, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 15),),

              SizedBox(height: 10,),

              Card(

                elevation: 2,
                color: Colors.transparent,
                shadowColor: appColor.boxColor,

                child: TextFormField(

                  controller: endingDateController,

                  style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),

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
                      initialDate: _startDate!.add(Duration(days: 0)),
                      firstDate: _startDate!.add(Duration(days: 0)),
                      lastDate: DateTime(2100),
                    );

                    if (pickedDate != null) {
                      String formattedDate =
                          "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
                      setState(() {
                        _endDate = pickedDate;
                        endingDateController.text = formattedDate;
                      });
                    }
                  },

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

                  controller: applyDaysController,

                  style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),

                  onTap: () {

                    setState(() {

                        if (_startDate != null && _endDate != null) {
                          int days = _endDate!.difference(_startDate!).inDays + 1;
                            applyDaysController.text = "${days}";
                        } else {
                          applyDaysController.text = "";
                          Fluttertoast.showToast(msg: "Enter Leave Date From and To!");
                        }

                    });

                  },

                  readOnly: true,

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

              SizedBox(height: 15,),

              Text("Leave Reason :", style: TextStyle(color: appColor.bodymainTxtColor, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 15),),

              SizedBox(height: 10,),

              Card(

                elevation: 2,
                color: Colors.transparent,
                shadowColor: appColor.boxColor,

                child: TextFormField(

                  controller: leaveReasonController,

                  style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),

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

              SizedBox(height: 30,),

              Card(

                elevation: 2,
                color: Colors.transparent,
                shadowColor: Colors.grey.shade200,

                child: ElevatedButton(

                  onPressed: () async {

                    bool isLeaveAdded = await Provider.of<UserProvider>(context, listen: false).sendLeaveRequest(
                      head_name: headID,
                      full_name: nameController.text,
                      under_team: underTeam,
                      date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                      reporting_to: approverController.text,
                      apply_days: applyDaysController.text,
                      from_date: startingDateController.text,
                      to_date: endingDateController.text,
                      leave_reason: leaveReasonController.text,
                      leave_type: selectedLeaveType,
                      leave_type_id: selectedLeaveType,
                    );

                    if (isLeaveAdded) {
                      Fluttertoast.showToast(msg: "Leave request send successfully");
                      Navigator.pop(context, true);
                    } else {
                      Fluttertoast.showToast(msg: "Failed to send leave request");
                    }
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
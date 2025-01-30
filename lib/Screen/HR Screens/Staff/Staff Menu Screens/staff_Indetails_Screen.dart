import 'package:flutter/material.dart';
import 'package:hr_app/Model/HR%20Screen%20Models/Staff/staff_Model.dart';
import 'package:hr_app/Screen/Color/app_Color.dart';
import 'package:hr_app/Screen/HR%20Screens/Staff/Edit%20Staff%20Indetails/edit_Contact_Screen.dart';
import 'package:hr_app/Screen/HR%20Screens/Staff/Edit%20Staff%20Indetails/edit_Emp_Work_Screen.dart';
import 'package:hr_app/Screen/HR%20Screens/Staff/Edit%20Staff%20Indetails/edit_Financial_Screen.dart';
import 'package:hr_app/Screen/HR%20Screens/Staff/Edit%20Staff%20Indetails/edit_Profile_Screen.dart';

class staffIndetailsScreen extends StatefulWidget {

  staffModel staffData;

  staffIndetailsScreen({

    super.key,

    required this.staffData

  });

  @override
  State<staffIndetailsScreen> createState() => _staffIndetailsScreenState();
}

class _staffIndetailsScreenState extends State<staffIndetailsScreen> {

  var passwordController = TextEditingController();

  bool showMoreDetailsForProfile = false;
  bool showMoreDetailsForWorking = false;
  bool showMoreDetailsForContact = false;
  bool showMoreDetailsForFinance = false;
  bool isPasswordVisible = true;

  @override
  Widget build(BuildContext context) {

    final staff = widget.staffData;
    passwordController.text = staff.password;

    return Scaffold(

      backgroundColor: Colors.white,

      body: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Container(

            height: 204,
            width: MediaQuery.of(context).size.width.toDouble(),

            color: Colors.grey.shade50,

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                SizedBox(height: 30,),

                Row(

                  children: [

                    IconButton(

                      onPressed: (){

                        Navigator.pop(context);

                      },

                      icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20,)

                    ),

                    Spacer(),

                    Padding(

                      padding: const EdgeInsets.only(top: 15.0),

                      child: Container(

                        height: 24,
                        width: 80,

                        decoration: BoxDecoration(

                          borderRadius: BorderRadius.circular(6),

                          color: staff.type == "Active" ? Colors.green.shade900 : Colors.red.shade900,

                        ),

                        child: Center(

                          child: Text(staff.type, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: "poppins_light"),),

                        ),

                      ),

                    ),

                    SizedBox(width: 22,),

                  ],

                ),

                SizedBox(height: 5,),

                Row(

                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    SizedBox(width: 20,),

                    Container(

                      height: 100,
                      width: 100,

                      decoration: BoxDecoration(

                        shape: BoxShape.circle,
                        // color: Colors.yellow.shade900

                      ),

                      child: Stack(

                        children: [

                          Center(

                            child: Container(

                              height: 100,
                              width: 100,

                              decoration: BoxDecoration(

                                shape: BoxShape.circle,

                                border: Border.all(color: Colors.indigo.shade500, width: 2),

                                image: DecorationImage(image: NetworkImage(staff.profileImg), fit: BoxFit.cover),

                              ),

                            ),

                          ),

                          Positioned(

                            bottom: 0,
                            right: 0,

                            child: Container(

                              height: 30,
                              width: 30,

                              decoration: BoxDecoration(

                                shape: BoxShape.circle,

                                color: Colors.black,

                              ),

                              child: Center(

                                child: Icon(Icons.camera_alt_outlined, color: Colors.white, size: 16,),

                              ),

                            ),

                          ),

                        ],

                      ),

                    ),

                    SizedBox(width: 30,),

                    Column(

                      mainAxisAlignment: MainAxisAlignment.start,

                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [

                        Row(

                          children: [

                            Icon(Icons.person, color: Colors.black, size: 19,),

                            SizedBox(width: 8,),

                            Text(staff.staffName, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16, fontFamily: "poppins_thin"),),

                          ],

                        ),

                        SizedBox(height: 3,),

                        Row(

                          children: [

                            Icon(Icons.phone, color: Colors.grey.shade800, size: 17,),

                            SizedBox(width: 10,),

                            Text(staff.contactNo, style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: "poppins_light"),),

                          ],

                        ),

                        SizedBox(height: 3,),

                        Row(

                          children: [

                            Icon(Icons.email_rounded, color: Colors.grey.shade800, size: 17,),

                            SizedBox(width: 11,),

                            Text(staff.email, style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: "poppins_light"),),

                          ],

                        ),

                        SizedBox(height: 3,),

                        Row(

                          children: [

                            Icon(Icons.report_gmailerrorred_rounded, color: Colors.grey.shade800, size: 18,),

                            SizedBox(width: 11,),

                            Text(staff.headName, style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: "poppins_light"),),

                          ],

                        ),

                      ],

                    ),

                  ],

                ),

              ],

            ),

          ),

          Expanded(
            
            child: Padding(
              
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              
              child: SingleChildScrollView(

                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    SizedBox(height: 20,),

                    Row(

                      crossAxisAlignment: CrossAxisAlignment.center,

                      children: [

                        Text("Profile Info", style: TextStyle(color: appColor.primaryColor, fontFamily: "poppins_thin", fontSize: 17, fontWeight: FontWeight.bold),),

                        Spacer(),

                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => editProfileScreen()));
                          },
                          child: Image.network("https://icon-library.com/images/edit-icon-png/edit-icon-png-0.jpg", color: appColor.primaryColor, height: 18,)
                        ),

                      ],

                    ),

                    SizedBox(height: 20,),

                    Container(

                      width: MediaQuery.of(context).size.width.toDouble(),

                      decoration: BoxDecoration(

                        color: Colors.grey.shade50,

                        borderRadius: BorderRadius.circular(15),

                        boxShadow: [

                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            spreadRadius: 1,
                            offset: Offset(0, 4),
                          ),

                        ],

                      ),

                      child: AnimatedContainer(

                        duration: Duration(milliseconds: 1000),

                        curve: Curves.easeInOut,

                        child: SingleChildScrollView(

                          child: Column(

                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [

                              SizedBox(height: 20),

                              Row(

                                children: [

                                  SizedBox(width: 10),

                                  Container(

                                    height: 40,
                                    width: 160,

                                    decoration: BoxDecoration(

                                      color: appColor.subPrimaryColor,

                                      borderRadius: BorderRadius.circular(8),

                                    ),

                                    child: Center(

                                      child: Text("Employee ID : ${staff.staffId.toString()}", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: "poppins_light",),),

                                    ),

                                  ),

                                  Spacer(),

                                  Container(

                                    height: 40,
                                    width: 160,

                                    decoration: BoxDecoration(

                                      color: appColor.subPrimaryColor,

                                      borderRadius: BorderRadius.circular(8),

                                    ),

                                    child: Row(

                                      mainAxisAlignment: MainAxisAlignment.center,

                                      children: [

                                        Icon(Icons.person, size: 20, color: Colors.black),

                                        SizedBox(width: 6),

                                        Text(staff.staffName, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: "poppins_light",),),

                                      ],

                                    ),

                                  ),

                                  SizedBox(width: 10),

                                ],

                              ),

                              SizedBox(height: 20),

                              Center(

                                child: Container(

                                  height: 40,
                                  width: 340,

                                  decoration: BoxDecoration(

                                    color: appColor.subPrimaryColor,

                                    borderRadius: BorderRadius.circular(8),

                                  ),

                                  child: Center(

                                    child: Text("username : ${staff.username}", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 14, fontFamily: "poppins_light",),),

                                  ),

                                ),

                              ),

                              SizedBox(height: 20),

                              Row(

                                children: [

                                  SizedBox(width: 10),

                                  Container(

                                    height: 40,
                                    width: 160,

                                    decoration: BoxDecoration(

                                      color: appColor.subPrimaryColor,

                                      borderRadius: BorderRadius.circular(8),

                                    ),

                                    child: Row(

                                      mainAxisAlignment: MainAxisAlignment.center,

                                      children: [

                                        Icon(Icons.calendar_month_rounded, size: 20, color: Colors.black),

                                        SizedBox(width: 6),

                                        Text(staff.dob, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: "poppins_light",),),

                                      ],

                                    ),

                                  ),

                                  Spacer(),

                                  Container(

                                    height: 40,
                                    width: 160,

                                    decoration: BoxDecoration(

                                      color: appColor.subPrimaryColor,

                                      borderRadius: BorderRadius.circular(8),

                                    ),

                                    child: Center(

                                      child: Text("Gender : ${staff.gender}", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: "poppins_light",),),

                                    ),

                                  ),

                                  SizedBox(width: 10),

                                ],

                              ),

                              SizedBox(height: 20),

                              if (showMoreDetailsForProfile) ...[

                                Center(

                                  child: Container(

                                    height: 40,
                                    width: 340,

                                    decoration: BoxDecoration(

                                      color: appColor.subPrimaryColor,

                                      borderRadius: BorderRadius.circular(8),

                                    ),

                                    child: Center(

                                      child: Text("Address : ${staff.address}", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 14, fontFamily: "poppins_light",),),

                                    ),

                                  ),

                                ),

                                SizedBox(height: 20,),

                                Row(

                                  children: [

                                    SizedBox(width: 10),

                                    Container(

                                      height: 40,
                                      width: 160,

                                      decoration: BoxDecoration(

                                        color: appColor.subPrimaryColor,

                                        borderRadius: BorderRadius.circular(8),

                                      ),

                                      child: Center(

                                        child: Text("${staff.maritalStatus}", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: "poppins_light",),),

                                      ),

                                    ),

                                    Spacer(),

                                    Container(

                                      height: 40,
                                      width: 160,

                                      decoration: BoxDecoration(

                                        color: appColor.subPrimaryColor,

                                        borderRadius: BorderRadius.circular(8),

                                      ),

                                      child: Row(

                                        mainAxisAlignment: MainAxisAlignment.center,

                                        children: [

                                          Icon(Icons.bloodtype_rounded, size: 20, color: Colors.black),

                                          SizedBox(width: 6),

                                          Text(staff.bloodGroup, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: "poppins_light",),),

                                        ],

                                      ),

                                    ),

                                    SizedBox(width: 10),

                                  ],

                                ),

                                SizedBox(height: 20),

                                Center(

                                  child: Container(

                                    height: 40,
                                    width: 340,

                                    decoration: BoxDecoration(

                                      color: appColor.subPrimaryColor,

                                      borderRadius: BorderRadius.circular(8),

                                    ),

                                    child: Center(

                                      child: Text("Town : ${staff.town}", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 14, fontFamily: "poppins_light",),),

                                    ),

                                  ),

                                ),

                                SizedBox(height: 20),

                                Row(

                                  children: [

                                    SizedBox(width: 10),

                                    Container(

                                      height: 40,
                                      width: 160,

                                      decoration: BoxDecoration(

                                        color: appColor.subPrimaryColor,

                                        borderRadius: BorderRadius.circular(8),

                                      ),

                                      child: Row(

                                        mainAxisAlignment: MainAxisAlignment.center,

                                        children: [

                                          Icon(Icons.location_city_rounded, size: 20, color: Colors.black),

                                          SizedBox(width: 6),

                                          Text(staff.city, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: "poppins_light",),),

                                        ],

                                      ),

                                    ),

                                    Spacer(),

                                    Container(

                                      height: 40,
                                      width: 160,

                                      decoration: BoxDecoration(

                                        color: appColor.subPrimaryColor,

                                        borderRadius: BorderRadius.circular(8),

                                      ),

                                      child: Center(

                                        child: Text("Pin Code : ${staff.pinCode}", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: "poppins_light",),),

                                      ),

                                    ),

                                    SizedBox(width: 10),

                                  ],

                                ),

                                SizedBox(height: 20),

                              ],

                              GestureDetector(

                                onTap: () {

                                  setState(() {

                                    showMoreDetailsForProfile = !showMoreDetailsForProfile;

                                  });

                                },

                                child: Row(

                                  mainAxisAlignment: MainAxisAlignment.center,

                                  children: [

                                    Text(showMoreDetailsForProfile ? "Less Details" : "More Details", style: TextStyle(color: Colors.deepPurple.shade400, fontWeight: FontWeight.bold, fontSize: 14,),),

                                    AnimatedRotation(

                                      turns: showMoreDetailsForProfile ? 0.5 : 0,

                                      duration: Duration(milliseconds: 300),

                                      child: Icon(Icons.expand_more_rounded, color: Colors.deepPurple.shade400,),

                                    ),

                                  ],

                                ),

                              ),

                              SizedBox(height: 20,),

                            ],

                          ),

                        ),

                      ),

                    ),

                    SizedBox(height: 35,),

                    Row(

                      crossAxisAlignment: CrossAxisAlignment.center,

                      children: [

                        Text("Employee Working Details", style: TextStyle(color: appColor.primaryColor, fontFamily: "poppins_thin", fontSize: 17, fontWeight: FontWeight.bold),),

                        Spacer(),

                        GestureDetector(

                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => editEmpWorkScreen()));
                          },

                          child: Image.network("https://icon-library.com/images/edit-icon-png/edit-icon-png-0.jpg", color: appColor.primaryColor, height: 18,)

                        ),

                      ],

                    ),

                    SizedBox(height: 20,),

                    Container(

                      width: MediaQuery.of(context).size.width.toDouble(),

                      decoration: BoxDecoration(

                        color: Colors.grey.shade50,

                        borderRadius: BorderRadius.circular(15),

                        boxShadow: [

                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            spreadRadius: 1,
                            offset: Offset(0, 4), // Subtle bottom shadow
                          ),

                        ],

                      ),

                      child: AnimatedContainer(

                        duration: Duration(milliseconds: 1000),

                        curve: Curves.easeInOut,

                        child: SingleChildScrollView(

                          child: Column(

                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [

                              SizedBox(height: 20),

                              Row(

                                children: [

                                  SizedBox(width: 10),

                                  Container(

                                    height: 40,
                                    width: 160,

                                    decoration: BoxDecoration(

                                      color: appColor.subPrimaryColor,

                                      borderRadius: BorderRadius.circular(8),

                                    ),

                                    child: Center(

                                      child: Text("Role : ${staff.role}", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: "poppins_light",),),

                                    ),

                                  ),

                                  Spacer(),

                                  Container(

                                    height: 40,
                                    width: 160,

                                    decoration: BoxDecoration(

                                      color: appColor.subPrimaryColor,

                                      borderRadius: BorderRadius.circular(8),

                                    ),

                                    child: Row(

                                      mainAxisAlignment: MainAxisAlignment.center,

                                      children: [

                                        Icon(Icons.work_rounded, size: 20, color: Colors.black),

                                        SizedBox(width: 6),

                                        Text(staff.department, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: "poppins_light",),),

                                      ],

                                    ),

                                  ),

                                  SizedBox(width: 10),

                                ],

                              ),

                              SizedBox(height: 20),

                              Center(

                                child: Container(

                                  height: 40,
                                  width: 340,

                                  decoration: BoxDecoration(

                                    color: appColor.subPrimaryColor,

                                    borderRadius: BorderRadius.circular(8),

                                  ),

                                  child: Center(

                                    child: Text("Reporting To : ${staff.headName}", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 14, fontFamily: "poppins_light",),),

                                  ),

                                ),

                              ),

                              SizedBox(height: 20),

                              Row(

                                children: [

                                  SizedBox(width: 10),

                                  Container(

                                    height: 40,
                                    width: 160,

                                    decoration: BoxDecoration(

                                      color: appColor.subPrimaryColor,

                                      borderRadius: BorderRadius.circular(8),

                                    ),

                                    child: Row(

                                      mainAxisAlignment: MainAxisAlignment.center,

                                      children: [

                                        Icon(Icons.location_on_rounded, size: 20, color: Colors.black),

                                        SizedBox(width: 6),

                                        Text(staff.jobLocation, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: "poppins_light",),),

                                      ],

                                    ),

                                  ),

                                  Spacer(),

                                  Container(

                                    height: 40,
                                    width: 160,

                                    decoration: BoxDecoration(

                                      color: appColor.subPrimaryColor,

                                      borderRadius: BorderRadius.circular(8),

                                    ),

                                    child: Center(

                                      child: Text("Session : ${staff.session}", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: "poppins_light",),),

                                    ),

                                  ),

                                  SizedBox(width: 10),

                                ],

                              ),

                              SizedBox(height: 20),

                              if (showMoreDetailsForWorking) ...[

                                Center(

                                  child: Container(

                                    height: 40,
                                    width: 340,

                                    decoration: BoxDecoration(

                                      color: appColor.subPrimaryColor,

                                      borderRadius: BorderRadius.circular(8),

                                    ),

                                    child: Center(

                                      child: Text("Active Time : ${staff.userActiveTime}", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 14, fontFamily: "poppins_light",),),

                                    ),

                                  ),

                                ),

                                SizedBox(height: 20,),

                                Row(

                                  children: [

                                    SizedBox(width: 10),

                                    Container(

                                      height: 40,
                                      width: 160,

                                      decoration: BoxDecoration(

                                        color: appColor.subPrimaryColor,

                                        borderRadius: BorderRadius.circular(8),

                                      ),

                                      child: Center(

                                        child: Text("workshift : ${staff.workShift}", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: "poppins_light",),),

                                      ),

                                    ),

                                    Spacer(),

                                    Container(

                                      height: 40,
                                      width: 160,

                                      decoration: BoxDecoration(

                                        color: appColor.subPrimaryColor,

                                        borderRadius: BorderRadius.circular(8),

                                      ),

                                      child: Row(

                                        mainAxisAlignment: MainAxisAlignment.center,

                                        children: [

                                          Icon(Icons.calendar_month_rounded, size: 20, color: Colors.black),

                                          SizedBox(width: 6),

                                          Text(staff.joiningDate, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: "poppins_light",),),

                                        ],

                                      ),

                                    ),

                                    SizedBox(width: 10),

                                  ],

                                ),

                                SizedBox(height: 20),

                                Center(

                                  child: Container(

                                    height: 40,
                                    width: 340,

                                    decoration: BoxDecoration(

                                      color: appColor.subPrimaryColor,

                                      borderRadius: BorderRadius.circular(8),

                                    ),

                                    child: Center(

                                      child: Text("Week Off : ${staff.weekOf}", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 14, fontFamily: "poppins_light",),),

                                    ),

                                  ),

                                ),

                                SizedBox(height: 20),

                              ],

                              GestureDetector(

                                onTap: () {

                                  setState(() {

                                    showMoreDetailsForWorking = !showMoreDetailsForWorking;

                                  });

                                },

                                child: Row(

                                  mainAxisAlignment: MainAxisAlignment.center,

                                  children: [

                                    Text(showMoreDetailsForWorking ? "Less Details" : "More Details", style: TextStyle(color: Colors.deepPurple.shade400, fontWeight: FontWeight.bold, fontSize: 14,),),

                                    AnimatedRotation(

                                      turns: showMoreDetailsForWorking ? 0.5 : 0,

                                      duration: Duration(milliseconds: 300),

                                      child: Icon(Icons.expand_more_rounded, color: Colors.deepPurple.shade400,),

                                    ),

                                  ],

                                ),

                              ),

                              SizedBox(height: 20,),

                            ],

                          ),

                        ),

                      ),

                    ),

                    SizedBox(height: 35,),

                    Row(

                      crossAxisAlignment: CrossAxisAlignment.center,

                      children: [

                        Text("Contact Details", style: TextStyle(color: appColor.primaryColor, fontFamily: "poppins_thin", fontSize: 17, fontWeight: FontWeight.bold),),

                        Spacer(),

                        GestureDetector(

                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => editContactScreen()));
                          },

                          child: Image.network("https://icon-library.com/images/edit-icon-png/edit-icon-png-0.jpg", color: appColor.primaryColor, height: 18,)

                        ),

                      ],

                    ),

                    SizedBox(height: 20,),

                    Container(

                      width: MediaQuery.of(context).size.width.toDouble(),

                      decoration: BoxDecoration(

                        color: Colors.grey.shade50,

                        borderRadius: BorderRadius.circular(15),

                        boxShadow: [

                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            spreadRadius: 1,
                            offset: Offset(0, 4), // Subtle bottom shadow
                          ),

                        ],

                      ),

                      child: AnimatedContainer(

                        duration: Duration(milliseconds: 1000),

                        curve: Curves.easeInOut,

                        child: SingleChildScrollView(

                          child: Column(

                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [

                              SizedBox(height: 20),

                              Row(

                                children: [

                                  SizedBox(width: 10),

                                  Container(

                                    height: 40,
                                    width: 160,

                                    decoration: BoxDecoration(

                                      color: appColor.subPrimaryColor,

                                      borderRadius: BorderRadius.circular(8),

                                    ),

                                    child: Row(

                                      mainAxisAlignment: MainAxisAlignment.center,

                                      children: [

                                        Icon(Icons.call, size: 20, color: Colors.black),

                                        SizedBox(width: 6),

                                        Text(staff.contactNo, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: "poppins_light",),),

                                      ],

                                    ),

                                  ),

                                  Spacer(),

                                  Container(

                                    height: 40,
                                    width: 160,

                                    decoration: BoxDecoration(

                                      color: appColor.subPrimaryColor,

                                      borderRadius: BorderRadius.circular(8),

                                    ),

                                    child: Row(

                                      mainAxisAlignment: MainAxisAlignment.center,

                                      children: [

                                        Icon(Icons.call, size: 20, color: Colors.black),

                                        SizedBox(width: 6),

                                        Text(staff.altPhoneNum, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: "poppins_light",),),

                                      ],

                                    ),

                                  ),

                                  SizedBox(width: 10),

                                ],

                              ),

                              SizedBox(height: 20),

                              Center(

                                child: Container(

                                  height: 40,
                                  width: 340,

                                  decoration: BoxDecoration(

                                    color: appColor.subPrimaryColor,

                                    borderRadius: BorderRadius.circular(8),

                                  ),

                                  child: Center(

                                    child: Text("Skype : ${staff.skype}", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 14, fontFamily: "poppins_light",),),

                                  ),

                                ),

                              ),

                              SizedBox(height: 20),

                              if (showMoreDetailsForContact) ...[

                                Center(

                                  child: Container(

                                    height: 40,
                                    width: 340,

                                    decoration: BoxDecoration(

                                      color: appColor.subPrimaryColor,

                                      borderRadius: BorderRadius.circular(8),

                                    ),

                                    child: Row(

                                      mainAxisAlignment: MainAxisAlignment.center,

                                      children: [

                                        Icon(Icons.email_rounded, size: 20, color: Colors.black),

                                        SizedBox(width: 6),

                                        Text(staff.email, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: "poppins_light",),),

                                      ],

                                    ),

                                  ),

                                ),

                                SizedBox(height: 20),

                                Center(

                                  child: Container(

                                    height: 40,
                                    width: 340,

                                    decoration: BoxDecoration(

                                      color: appColor.subPrimaryColor,

                                      borderRadius: BorderRadius.circular(8),

                                    ),

                                    child: Center(

                                      child: Text("Work Email : ${staff.workEmail}", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 14, fontFamily: "poppins_light",),),

                                    ),

                                  ),

                                ),

                                SizedBox(height: 20),

                              ],

                              GestureDetector(

                                onTap: () {

                                  setState(() {

                                    showMoreDetailsForContact = !showMoreDetailsForContact;

                                  });

                                },

                                child: Row(

                                  mainAxisAlignment: MainAxisAlignment.center,

                                  children: [

                                    Text(showMoreDetailsForContact ? "Less Details" : "More Details", style: TextStyle(color: Colors.deepPurple.shade400, fontWeight: FontWeight.bold, fontSize: 14,),),

                                    AnimatedRotation(

                                      turns: showMoreDetailsForContact ? 0.5 : 0,

                                      duration: Duration(milliseconds: 300),

                                      child: Icon(Icons.expand_more_rounded, color: Colors.deepPurple.shade400,),

                                    ),

                                  ],

                                ),

                              ),

                              SizedBox(height: 20,),

                            ],

                          ),

                        ),

                      ),

                    ),

                    SizedBox(height: 35,),

                    Row(

                      crossAxisAlignment: CrossAxisAlignment.center,

                      children: [

                        Text("Password", style: TextStyle(color: appColor.primaryColor, fontFamily: "poppins_thin", fontSize: 17, fontWeight: FontWeight.bold),),

                        Spacer(),

                        GestureDetector(

                          onTap: () {
                            _showEditPasswordDialog();
                          },

                          child: Image.network("https://icon-library.com/images/edit-icon-png/edit-icon-png-0.jpg", color: appColor.primaryColor, height: 18,)

                        ),

                      ],

                    ),

                    SizedBox(height: 20,),

                    Container(

                      height: 80,
                      width: MediaQuery.of(context).size.width.toDouble(),

                      decoration: BoxDecoration(

                        color: Colors.grey.shade50,

                        borderRadius: BorderRadius.circular(15),

                        boxShadow: [

                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            spreadRadius: 1,
                            offset: Offset(0, 4), // Subtle bottom shadow
                          ),

                        ],

                      ),
                      
                      child: Padding(

                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 18),

                        child: TextField(

                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: "poppins_light",),

                          textAlignVertical: TextAlignVertical.center,

                          controller: passwordController,

                          obscureText: isPasswordVisible,

                          readOnly: true,

                          decoration: InputDecoration(

                            border: InputBorder.none,

                            filled: true,

                            fillColor: appColor.subPrimaryColor,

                            enabledBorder: OutlineInputBorder(

                              borderRadius: BorderRadius.circular(8),

                              borderSide: BorderSide(color: Colors.transparent),

                            ),

                            focusedBorder: OutlineInputBorder(

                              borderRadius: BorderRadius.circular(8),

                              borderSide: BorderSide(color: Colors.transparent),

                            ),
                            
                            suffixIcon: IconButton(
                              onPressed: (){
                                setState(() {
                                  isPasswordVisible = !isPasswordVisible;
                                });
                              },
                              icon: Icon(isPasswordVisible ? Icons.visibility_off_rounded : Icons.visibility_rounded, color: Colors.black, size: 20,),
                            ),

                          ),

                        ),

                      ),

                    ),

                    SizedBox(height: 35,),

                    Row(

                      crossAxisAlignment: CrossAxisAlignment.center,

                      children: [

                        Text("Financial Details", style: TextStyle(color: appColor.primaryColor, fontFamily: "poppins_thin", fontSize: 17, fontWeight: FontWeight.bold),),

                        Spacer(),

                        GestureDetector(

                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => editFinancialScreen()));
                          },

                          child: Image.network("https://icon-library.com/images/edit-icon-png/edit-icon-png-0.jpg", color: appColor.primaryColor, height: 18,)

                        ),

                      ],

                    ),

                    SizedBox(height: 20,),

                    Container(

                      width: MediaQuery.of(context).size.width.toDouble(),

                      decoration: BoxDecoration(

                        color: Colors.grey.shade50,

                        borderRadius: BorderRadius.circular(15),

                        boxShadow: [

                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            spreadRadius: 1,
                            offset: Offset(0, 4), // Subtle bottom shadow
                          ),

                        ],

                      ),

                      child: AnimatedContainer(

                        duration: Duration(milliseconds: 1000),

                        curve: Curves.easeInOut,

                        child: SingleChildScrollView(

                          child: Column(

                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [

                              SizedBox(height: 20),

                              Row(

                                children: [

                                  SizedBox(width: 10),

                                  Container(

                                    height: 40,
                                    width: 160,

                                    decoration: BoxDecoration(

                                      color: appColor.subPrimaryColor,

                                      borderRadius: BorderRadius.circular(8),

                                    ),

                                    child: Row(

                                      mainAxisAlignment: MainAxisAlignment.center,

                                      children: [

                                        Icon(Icons.account_balance_rounded, size: 20, color: Colors.black),

                                        SizedBox(width: 6),

                                        Text(staff.bankName, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: "poppins_light",),),

                                      ],

                                    ),

                                  ),

                                  Spacer(),

                                  Container(

                                    height: 40,
                                    width: 160,

                                    decoration: BoxDecoration(

                                      color: appColor.subPrimaryColor,

                                      borderRadius: BorderRadius.circular(8),

                                    ),

                                    child: Row(

                                      mainAxisAlignment: MainAxisAlignment.center,

                                      children: [

                                        Icon(Icons.account_box_rounded, size: 20, color: Colors.black),

                                        SizedBox(width: 6),

                                        Text(staff.accountNum, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: "poppins_light",),),

                                      ],

                                    ),

                                  ),

                                  SizedBox(width: 10),

                                ],

                              ),

                              SizedBox(height: 20),

                              Center(

                                child: Container(

                                  height: 40,
                                  width: 340,

                                  decoration: BoxDecoration(

                                    color: appColor.subPrimaryColor,

                                    borderRadius: BorderRadius.circular(8),

                                  ),

                                  child: Center(

                                    child: Text("IFSC Code : ${staff.ifsc}", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 14, fontFamily: "poppins_light",),),

                                  ),

                                ),

                              ),

                              SizedBox(height: 20),

                              if (showMoreDetailsForFinance) ...[

                                Row(

                                  children: [

                                    SizedBox(width: 10),

                                    Container(

                                      height: 40,
                                      width: 160,

                                      decoration: BoxDecoration(

                                        color: appColor.subPrimaryColor,

                                        borderRadius: BorderRadius.circular(8),

                                      ),

                                      child: Row(

                                        mainAxisAlignment: MainAxisAlignment.center,

                                        children: [

                                          Icon(Icons.monetization_on_rounded, size: 20, color: Colors.black),

                                          SizedBox(width: 6),

                                          Text(staff.salary.toString(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: "poppins_light",),),

                                        ],

                                      ),

                                    ),

                                    Spacer(),

                                    Container(

                                      height: 40,
                                      width: 160,

                                      decoration: BoxDecoration(

                                        color: appColor.subPrimaryColor,

                                        borderRadius: BorderRadius.circular(8),

                                      ),

                                      child: Row(

                                        mainAxisAlignment: MainAxisAlignment.center,

                                        children: [

                                          Icon(Icons.credit_card_rounded, size: 20, color: Colors.black),

                                          SizedBox(width: 6),

                                          Text(staff.panNum, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: "poppins_light",),),

                                        ],

                                      ),

                                    ),

                                    SizedBox(width: 10),

                                  ],

                                ),

                                SizedBox(height: 20),

                              ],

                              GestureDetector(

                                onTap: () {

                                  setState(() {

                                    showMoreDetailsForFinance = !showMoreDetailsForFinance;

                                  });

                                },

                                child: Row(

                                  mainAxisAlignment: MainAxisAlignment.center,

                                  children: [

                                    Text(showMoreDetailsForFinance ? "Less Details" : "More Details", style: TextStyle(color: Colors.deepPurple.shade400, fontWeight: FontWeight.bold, fontSize: 14,),),

                                    AnimatedRotation(

                                      turns: showMoreDetailsForFinance ? 0.5 : 0,

                                      duration: Duration(milliseconds: 300),

                                      child: Icon(Icons.expand_more_rounded, color: Colors.deepPurple.shade400,),

                                    ),

                                  ],

                                ),

                              ),

                              SizedBox(height: 20,),

                            ],

                          ),

                        ),

                      ),

                    ),

                    SizedBox(height: 35,),

                    Row(

                      crossAxisAlignment: CrossAxisAlignment.center,

                      children: [

                        Text("Emergency Contact", style: TextStyle(color: appColor.primaryColor, fontFamily: "poppins_thin", fontSize: 17, fontWeight: FontWeight.bold),),

                        Spacer(),

                        IconButton(
                          onPressed: (){
                            _showAddEmergencyContactDialog();
                          },
                          icon: Icon(Icons.add_circle_outline_rounded, color: appColor.primaryColor, size: 25,),
                        ),

                      ],

                    ),

                    SizedBox(height: 20,),

                    Container(

                      width: MediaQuery.of(context).size.width.toDouble(),

                      decoration: BoxDecoration(

                        color: Colors.grey.shade50,

                        borderRadius: BorderRadius.circular(15),

                        boxShadow: [

                          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5, spreadRadius: 1, offset: Offset(0, 4),),

                        ],

                      ),

                      child: SingleChildScrollView(

                        child: Column(

                          children: [

                            ListView.builder(

                              physics: const NeverScrollableScrollPhysics(),

                              shrinkWrap: true, // This allows ListView to only take up the space it needs

                              itemCount: staff.emergencyContacts.length,

                              itemBuilder: (context, index) {

                                final contactList = staff.emergencyContacts[index];

                                return Padding(

                                  padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 15),

                                  child: Container(

                                    height: 80,

                                    width: MediaQuery.of(context).size.width.toDouble(),

                                    decoration: BoxDecoration(

                                      borderRadius: BorderRadius.circular(8),

                                      color: appColor.subPrimaryColor,

                                    ),

                                    child: Padding(

                                      padding: const EdgeInsets.symmetric(horizontal: 10.0),

                                      child: Row(

                                        crossAxisAlignment: CrossAxisAlignment.center,

                                        children: [

                                          Container(

                                            height: 80,

                                            width: 80,

                                            child: Column(

                                              mainAxisAlignment: MainAxisAlignment.center,

                                              crossAxisAlignment: CrossAxisAlignment.center,

                                              children: [

                                                Icon(Icons.perm_identity_rounded, color: Colors.black, size: 22),

                                                SizedBox(height: 5),

                                                Text(

                                                  contactList["name"]!,

                                                  style: TextStyle(

                                                    color: Colors.black,

                                                    fontWeight: FontWeight.bold,

                                                    fontSize: 14,

                                                    fontFamily: "poppins_light",

                                                  ),

                                                ),

                                              ],

                                            ),

                                          ),

                                          SizedBox(width: 10),

                                          Container(

                                            height: 80,

                                            width: 160,

                                            child: Column(

                                              children: [

                                                Spacer(),

                                                Row(

                                                  children: [

                                                    Icon(Icons.phone, color: Colors.black, size: 18),

                                                    SizedBox(width: 5),

                                                    Text(

                                                      contactList["cno"]!,

                                                      style: TextStyle(

                                                        color: Colors.black,

                                                        fontWeight: FontWeight.bold,

                                                        fontSize: 14,

                                                        fontFamily: "poppins_light",

                                                      ),

                                                    ),

                                                  ],

                                                ),

                                                SizedBox(height: 7),

                                                Row(

                                                  children: [

                                                    Icon(Icons.link_rounded, color: Colors.black, size: 17),

                                                    SizedBox(width: 6),

                                                    Text(

                                                      contactList["relation"]!,

                                                      style: TextStyle(

                                                        color: Colors.black,

                                                        fontWeight: FontWeight.bold,

                                                        fontSize: 14,

                                                        fontFamily: "poppins_light",

                                                      ),

                                                    ),

                                                  ],

                                                ),

                                                Spacer(),

                                              ],

                                            ),

                                          ),

                                          Spacer(),

                                          Container(

                                            height: 80,

                                            width: 50,

                                            child: Center(

                                              child: PopupMenuButton<String>(

                                                color: appColor.subFavColor,

                                                position: PopupMenuPosition.values[0],

                                                shape: RoundedRectangleBorder(

                                                  borderRadius: BorderRadius.circular(8),

                                                ),

                                                icon: Icon(Icons.more_vert_rounded, size: 20, color: appColor.primaryColor),

                                                onSelected: (value) {

                                                  if (value == 'edit') {

                                                    print("Edit clicked");

                                                  } else if (value == 'delete') {

                                                    print("Delete clicked");

                                                  }

                                                },

                                                itemBuilder: (BuildContext context) {

                                                  return [

                                                    PopupMenuItem<String>(

                                                      onTap: () {

                                                        _showEditEmergencyContactDialog();

                                                      },

                                                      value: 'edit',

                                                      child: Row(

                                                        children: [

                                                          Icon(Icons.edit_off_rounded, size: 18, color: Colors.yellow.shade800),

                                                          SizedBox(width: 6),

                                                          Text("Edit", style: TextStyle(color: Colors.yellow.shade800, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 13,),),

                                                        ],

                                                      ),

                                                    ),

                                                    PopupMenuItem<String>(

                                                      value: 'delete',

                                                      child: Row(

                                                        children: [

                                                          Icon(Icons.delete_forever_rounded, size: 18, color: Colors.red.shade600),

                                                          SizedBox(width: 6),

                                                          Text("Delete", style: TextStyle(color: Colors.red.shade600, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 13,),),

                                                        ],

                                                      ),

                                                      onTap: () {

                                                        ScaffoldMessenger.of(context).showSnackBar(

                                                          SnackBar(content: Text("Emergency Contact Deleted successfully")),

                                                        );

                                                      },

                                                    ),

                                                  ];

                                                },

                                              ),

                                            ),

                                          ),

                                        ],

                                      ),

                                    ),

                                  ),

                                );

                              },

                            ),

                          ],

                        ),

                      ),

                    ),

                    SizedBox(height: 100,),

                  ],

                ),

              ),
              
            ),
            
          ),

        ],

      ),

    );

  }

  void _showEditPasswordDialog() {

    TextEditingController newPasswordController = TextEditingController(text: passwordController.text);

    bool showNewPassword = false;

    showDialog(

      context: context,

      builder: (context) {

        return StatefulBuilder(builder: (context, setState) {

          return AlertDialog(

            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),

            title: Text("Edit Password", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            content: TextFormField(

              controller: newPasswordController,

              style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),

              obscureText: showNewPassword,

              decoration: InputDecoration(

                hintText: "Enter New Password",

                hintStyle: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13),

                border: OutlineInputBorder(),

                suffixIcon: IconButton(

                  icon: Icon(showNewPassword ? Icons.visibility_off : Icons.visibility, color: Colors.black, size: 20,),

                  onPressed: () {

                    setState(() {

                      showNewPassword = !showNewPassword;

                    });

                  },

                ),

              ),

            ),

            actions: [

              TextButton(

                onPressed: () {

                  Navigator.pop(context); // Close the dialog

                },

                child: Text("Cancel"),

              ),

              ElevatedButton(

                onPressed: () {

                  setState(() {

                    passwordController.text = newPasswordController.text;

                  });

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(

                    SnackBar(content: Text("Password updated successfully")),

                  );

                },

                child: Text("Save"),

              ),

            ],

          );

        });

      },

    );

  }

  void _showAddEmergencyContactDialog() {

    showDialog(

      context: context,

      builder: (context) {

        return StatefulBuilder(builder: (context, setState) {

          return AlertDialog(

            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),

            title: Text("Add Emergency Contact", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            content: Container(

              height: 170,

              child: Column(

                children: [

                  TextFormField(

                    style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),

                    decoration: InputDecoration(

                      hintText: "Enter Name",

                      hintStyle: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13),

                      suffixIcon: Icon(Icons.perm_identity_rounded, color: Colors.black, size: 20,),

                      border: OutlineInputBorder(),

                    ),

                  ),

                  SizedBox(height: 6,),

                  TextFormField(

                    keyboardType: TextInputType.number,

                    style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),

                    decoration: InputDecoration(

                      hintText: "Contact Number",

                      hintStyle: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13),

                      suffixIcon: Icon(Icons.phone, color: Colors.black, size: 20,),

                      border: OutlineInputBorder(),

                    ),

                  ),

                  SizedBox(height: 6,),

                  TextFormField(

                    style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),

                    decoration: InputDecoration(

                      hintText: "Relation",

                      hintStyle: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13),

                      suffixIcon: Icon(Icons.link_rounded, color: Colors.black, size: 20,),

                      border: OutlineInputBorder(),

                    ),

                  ),

                ],

              ),

            ),

            actions: [

              TextButton(

                onPressed: () {

                  Navigator.pop(context); // Close the dialog

                },

                child: Text("Cancel"),

              ),

              ElevatedButton(

                onPressed: () {

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(

                    SnackBar(content: Text("Emergency Contact Added successfully")),

                  );

                },

                child: Text("Add"),

              ),

            ],

          );

        });

      },

    );

  }

  void _showEditEmergencyContactDialog() {

    showDialog(

      context: context,

      builder: (context) {

        return StatefulBuilder(builder: (context, setState) {

          return AlertDialog(

            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),

            title: Text("Edit Emergency Contact", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            content: Container(

              height: 170,

              child: Column(

                children: [

                  TextFormField(

                    style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),

                    decoration: InputDecoration(

                      hintText: "Enter Name",

                      hintStyle: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13),

                      suffixIcon: Icon(Icons.perm_identity_rounded, color: Colors.black, size: 20,),

                      border: OutlineInputBorder(),

                    ),

                  ),

                  SizedBox(height: 6,),

                  TextFormField(

                    keyboardType: TextInputType.number,

                    style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),

                    decoration: InputDecoration(

                      hintText: "Contact Number",

                      hintStyle: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13),

                      suffixIcon: Icon(Icons.phone, color: Colors.black, size: 20,),

                      border: OutlineInputBorder(),

                    ),

                  ),

                  SizedBox(height: 6,),

                  TextFormField(

                    style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),

                    decoration: InputDecoration(

                      hintText: "Relation",

                      hintStyle: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13),

                      suffixIcon: Icon(Icons.link_rounded, color: Colors.black, size: 20,),

                      border: OutlineInputBorder(),

                    ),

                  ),

                ],

              ),

            ),

            actions: [

              TextButton(

                onPressed: () {

                  Navigator.pop(context); // Close the dialog

                },

                child: Text("Cancel"),

              ),

              ElevatedButton(

                onPressed: () {

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(

                    SnackBar(content: Text("Emergency Contact updated successfully")),

                  );

                },

                child: Text("Save"),

              ),

            ],

          );

        });

      },

    );

  }

}
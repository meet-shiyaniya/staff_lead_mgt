import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hr_app/Screen/Color/app_Color.dart';
import 'package:hr_app/Screen/HR%20Screens/Staff/Add%20Staff%20Menu%20Screens/add_Staff_1_Screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:switcher_button/switcher_button.dart';

class addStaffScreen extends StatefulWidget {
  @override
  _addStaffScreenState createState() => _addStaffScreenState();
}

class _addStaffScreenState extends State<addStaffScreen> {

  bool isAttendanceOn = false;
  bool isActive = false;

  final TextEditingController _usernameController = TextEditingController(text: 'gymsmart_');
  final TextEditingController _phoneController = TextEditingController(text: '+91 ');
  final TextEditingController _simAllocationController = TextEditingController(text: '+91 ');
  final TextEditingController _altMobileController = TextEditingController(text: '+91 ');
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _deptController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _activeTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _sessionController = TextEditingController();

  final TextEditingController _joinDateController = TextEditingController();

  File? _profileImage;

  final ImagePicker _picker = ImagePicker();

  // Function to open camera
  Future<void> _openCamera() async {

    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {

      setState(() {

        _profileImage = File(pickedFile.path);  // Use _profileImage instead of _image

      });

    }

  }

  // Function to open gallery
  Future<void> _openGallery() async {

    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {

      setState(() {

        _profileImage = File(pickedFile.path);  // Use _profileImage instead of _image

      });

    }

  }

  // Function to show bottom sheet with options
  void _showImagePickerOptions() {

    showModalBottomSheet(

      context: context,

      shape: RoundedRectangleBorder(

        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),

      ),

      builder: (context) => Container(

        padding: EdgeInsets.only(bottom: 10, top: 20),

        height: 180,

        child: Column(

          mainAxisSize: MainAxisSize.min,

          children: [

            Text("Choose Profile Picture", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),),

            SizedBox(height: 10),

            ListTile(

              leading: Icon(Icons.camera_alt, color: Colors.deepPurple.shade800),

              title: Text("Take Photo", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black)),

              onTap: () {

                _openCamera();

                Navigator.pop(context);  // Fix added

              },

            ),

            ListTile(

              leading: Icon(Icons.image, color: Colors.deepPurple.shade800),

              title: Text("Choose from Gallery", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black)),

              onTap: () {

                _openGallery();

                Navigator.pop(context);  // Fix added

              },

            ),

          ],

        ),

      ),

    );

  }

  // Function to prevent deletion of the "+91 " prefix
  void _onTextChanged(TextEditingController controller) {

    if (!controller.text.startsWith('+91 ')) {

      setState(() {

        controller.text = '+91 ';

        controller.selection = TextSelection.fromPosition(

          TextPosition(offset: controller.text.length),

        );

      });

    }

  }

  @override
  void initState() {
    super.initState();

    // Add listeners to maintain +91 prefix
    _phoneController.addListener(() => _onTextChanged(_phoneController));
    _simAllocationController.addListener(() => _onTextChanged(_simAllocationController));
    _altMobileController.addListener(() => _onTextChanged(_altMobileController));

  }

  @override
  void dispose() {

    _phoneController.dispose();
    _simAllocationController.dispose();
    _altMobileController.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: Text("Staff Management", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),),

        backgroundColor: appColor.primaryColor,

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

        padding: const EdgeInsets.symmetric(horizontal: 16.0),

        child: SingleChildScrollView(

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              SizedBox(height: 30,),

              Text("Enter staff details for add Staff", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, fontFamily: "poppins_thin", color: Colors.black),),

              SizedBox(height: 25),

              Row(

                crossAxisAlignment: CrossAxisAlignment.center,

                children: [

                  Icon(Icons.person, color: Colors.black, size: 20,),

                  SizedBox(width: 6,),

                  Text("Staff Profile Details", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: "poppins_thin", color: Colors.black),),

                ],

              ),

              SizedBox(height: 22,),

              Row(

                children: [

                  CircleAvatar(

                    radius: 40,

                    backgroundColor: appColor.boxColor,

                    backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,

                    child: _profileImage == null ? GestureDetector(

                      onTap: _showImagePickerOptions,

                      child: Icon(Icons.camera_alt, size: 38, color: Colors.grey.shade700),

                    ) : null,

                  ),

                  SizedBox(width: 20),

                  Expanded(

                    child: TextFormField(

                      controller: _usernameController,

                      style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),

                      decoration: InputDecoration(
                        
                        suffixIcon: Icon(Icons.perm_identity_rounded, color: Colors.black, size: 20,),

                        filled: true,

                        fillColor: appColor.subPrimaryColor,

                        border: OutlineInputBorder(

                          borderRadius: BorderRadius.circular(8),

                          borderSide: BorderSide.none,

                        ),

                        enabledBorder: OutlineInputBorder(

                          borderRadius: BorderRadius.circular(8),

                          borderSide: BorderSide.none,

                        ),

                        focusedBorder: OutlineInputBorder(

                          borderRadius: BorderRadius.circular(8),

                          borderSide: BorderSide.none,

                        ),

                      ),

                      onChanged: (value) {

                        if (!value.startsWith('gymsmart_')) {

                          _usernameController.text = 'gymsmart_';

                          _usernameController.selection = TextSelection.fromPosition(

                            TextPosition(offset: _usernameController.text.length),

                          );

                        }

                      },

                    ),

                  ),

                ],

              ),

              SizedBox(height: 24,),

              Row(

                mainAxisAlignment: MainAxisAlignment.spaceAround,

                children: [

                  SizedBox(width: 0,),

                  Container(

                    height: 36,
                    width: 134,

                    decoration: BoxDecoration(

                      color: isAttendanceOn ? Colors.transparent : appColor.primaryColor,

                      border: Border.all(color: isAttendanceOn ? appColor.primaryColor : Colors.transparent, width: 1.2),

                      borderRadius: BorderRadius.circular(8),

                    ),

                    child: Center(

                        child: Text("Attendance On", style: TextStyle(color: isAttendanceOn ? Colors.black : Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),)

                    ),

                  ),

                  // Spacer(),

                  SwitcherButton(

                    value: isAttendanceOn,

                    onColor: Colors.deepPurple,

                    offColor: Colors.deepPurple.shade100,

                    onChange: (value) {

                      setState(() {

                        isAttendanceOn = value;

                      });

                    },

                  ),

                  // Spacer(),

                  Container(

                    height: 36,
                    width: 136,

                    decoration: BoxDecoration(

                      color: isAttendanceOn ? appColor.primaryColor : Colors.transparent,

                      border: Border.all(color: isAttendanceOn ? Colors.transparent : appColor.primaryColor, width: 1.2),

                      borderRadius: BorderRadius.circular(8),

                    ),

                    child: Center(

                        child: Text("Attendance Off", style: TextStyle(color: isAttendanceOn ? Colors.white : Colors.black, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),)

                    ),

                  ),

                  SizedBox(width: 0,),

                ],
              ),

              SizedBox(height: 24),

              buildTextField("Full name", "Enter Fullname", true, _fullNameController),

              buildTextField("E-mail address", "Enter Email Address", true, _emailController),

              Row(

                children: [

                  Expanded(child: buildTextField("Mobile No.", "+91", true, _phoneController),),

                  SizedBox(width: 15),

                  Expanded(child: buildTextField("Alt. Mobile No.", "+91", false, _altMobileController),),

                ],

              ),

              Row(

                children: [

                  Expanded(child: buildDropdownField("User type", ["Admin", "Employee", "HR"]),),

                  SizedBox(width: 15),

                  Expanded(child: buildDropdownField("Head", ["Manager", "Supervisor"]),),

                ],

              ),

              buildTextField("Department", "Enter Department", false, _deptController),

              buildTextField("Address", "Enter Address", false, _addressController),

              Row(

                children: [

                  Expanded(child: buildTextField("Dob", "Date of birth", false, _dobController),),

                  SizedBox(width: 15),

                  Expanded(child: buildDropdownField("Shift type", ["Morning", "Evening", "Night"]),),

                ],

              ),

              Row(

                children: [

                  Expanded(child: buildTimeField("User active time", _activeTimeController)),

                  SizedBox(width: 15),

                  Expanded(child: buildTimeField("End time", _endTimeController)),

                ],

              ),

              SizedBox(height: 24,),

              Row(

                mainAxisAlignment: MainAxisAlignment.spaceAround,

                children: [

                  SizedBox(width: 0,),

                  Container(

                    height: 36,
                    width: 134,

                    decoration: BoxDecoration(

                      color: isActive ? Colors.transparent : appColor.primaryColor,

                      border: Border.all(color: isActive ? appColor.primaryColor : Colors.transparent, width: 1.2),

                      borderRadius: BorderRadius.circular(8),

                    ),

                    child: Center(

                        child: Text("user active", style: TextStyle(color: isActive ? Colors.black : Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),)

                    ),

                  ),

                  // Spacer(),

                  SwitcherButton(

                    value: isActive,

                    onColor: Colors.deepPurple,

                    offColor: Colors.deepPurple.shade100,

                    onChange: (value) {

                      setState(() {

                        isActive = value;

                      });

                    },

                  ),

                  // Spacer(),

                  Container(

                    height: 36,
                    width: 136,

                    decoration: BoxDecoration(

                      color: isActive ? appColor.primaryColor : Colors.transparent,

                      border: Border.all(color: isActive ? Colors.transparent : appColor.primaryColor, width: 1.2),

                      borderRadius: BorderRadius.circular(8),

                    ),

                    child: Center(

                        child: Text("user inactive", style: TextStyle(color: isActive ? Colors.white : Colors.black, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),)

                    ),

                  ),

                  SizedBox(width: 0,),

                ],
              ),

              SizedBox(height: 24,),

              buildTextField("Session", "Session", false, _sessionController),

              // SizedBox(height: 10),
              //
              // Row(
              //
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //
              //   children: [
              //
              //     Icon(Icons.work_rounded, color: Colors.black, size: 20,),
              //
              //     SizedBox(width: 6,),
              //
              //     Text("Office Use", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: "poppins_thin", color: Colors.black),),
              //
              //   ],
              //
              // ),
              //
              // SizedBox(height: 22,),
              //
              // buildTextField("Join Date", "Joining Date", false, _joinDateController),

              SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,

                children: [

                  ElevatedButton(

                    onPressed: () {

                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => addStaff1Screen()));

                      // ScaffoldMessenger.of(context).showSnackBar(
                      //
                      //   SnackBar(content: Text("new staff added successfully")),
                      //
                      // );

                    },

                    style: ElevatedButton.styleFrom(

                      backgroundColor: appColor.primaryColor,

                      shape: RoundedRectangleBorder(

                        borderRadius: BorderRadius.circular(20),

                      ),

                      fixedSize: Size(MediaQuery.of(context).size.width.toDouble() / 2 - 20, 40),

                    ),

                    child: Row(

                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [

                        Text("Next", style: TextStyle(fontSize: 14, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, color: Colors.white)),
                        SizedBox(width: 0,),
                        Icon(Icons.navigate_next_rounded, color: Colors.white, size: 22,),

                      ],

                    ),

                  ),

                ],

              ),

              SizedBox(height: 30,),

            ],

          ),

        ),

      ),

    );

  }

  Widget buildTextField(String label, String hint, bool required, TextEditingController controller) {

    return Padding(

      padding: const EdgeInsets.only(bottom: 20),

      child: TextFormField(

        controller: controller,

        readOnly: controller == _dobController || controller == _joinDateController,

        onTap: () async {

          if (controller == _dobController || controller == _joinDateController) {

            DateTime? pickedDate = await showDatePicker(

              context: context,

              initialDate: DateTime.now(),

              firstDate: DateTime(1990),

              lastDate: DateTime.now(),

            );

            if (pickedDate != null) {

              String formattedDate = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";

              setState(() {

                controller == _dobController ? _dobController.text = formattedDate : _joinDateController.text = formattedDate;

              });

            }

          }

        },

        keyboardType: controller == _altMobileController || controller == _phoneController || controller == _sessionController ? TextInputType.number : controller == _emailController ? TextInputType.emailAddress : TextInputType.text,

        style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),

        decoration: InputDecoration(

          hintText: hint,
          
          suffixIcon: Icon(controller == _phoneController || controller == _altMobileController ? Icons.phone : controller == _emailController ? Icons.email_rounded : controller == _dobController || controller == _joinDateController ? Icons.calendar_month_rounded : controller == _addressController ? Icons.home : controller == _fullNameController ? Icons.person : controller == _sessionController ? Icons.lock_open_rounded : Icons.work_rounded, size: 20,),

          filled: true,

          fillColor: appColor.subPrimaryColor,

          border: OutlineInputBorder(

            borderRadius: BorderRadius.circular(8),

            borderSide: BorderSide.none,

          ),

          enabledBorder: OutlineInputBorder(

            borderRadius: BorderRadius.circular(8),

            borderSide: BorderSide.none,

          ),

          focusedBorder: OutlineInputBorder(

            borderRadius: BorderRadius.circular(8),

            borderSide: BorderSide.none,

          ),

        ),

      ),

    );

  }

  Widget buildDropdownField(String label, List<String> items) {

    return Padding(

      padding: const EdgeInsets.only(bottom: 20),

      child: DropdownButtonFormField<String>(

        style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),

        decoration: InputDecoration(

          hintText: "$label *",

          filled: true,

          fillColor: appColor.subPrimaryColor,

          border: OutlineInputBorder(

            borderRadius: BorderRadius.circular(8),

            borderSide: BorderSide.none,

          ),

          enabledBorder: OutlineInputBorder(

            borderRadius: BorderRadius.circular(8),

            borderSide: BorderSide.none,

          ),

          focusedBorder: OutlineInputBorder(

            borderRadius: BorderRadius.circular(8),

            borderSide: BorderSide.none,

          ),

        ),

        items: items.map((String value) {

          return DropdownMenuItem<String>(

            value: value,

            child: Text(value),

          );

        }).toList(),

        onChanged: (value) {},

      ),

    );

  }

  Widget buildTimeField(String hint, TextEditingController controller) {

    return TextFormField(

      controller: controller,

      readOnly: true,

      style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),

      decoration: InputDecoration(

        hintText: hint,

        filled: true,

        fillColor: appColor.subPrimaryColor,

        border: OutlineInputBorder(

          borderRadius: BorderRadius.circular(8),

          borderSide: BorderSide.none,

        ),

        enabledBorder: OutlineInputBorder(

          borderRadius: BorderRadius.circular(8),

          borderSide: BorderSide.none,

        ),

        focusedBorder: OutlineInputBorder(

          borderRadius: BorderRadius.circular(8),

          borderSide: BorderSide.none,

        ),

        suffixIcon: Icon(Icons.access_time),

      ),

      onTap: () async {

        String selectedHour = "00";

        String selectedMinute = "00";

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

                              controller == _activeTimeController ? _activeTimeController.text = "${formattedTime}" : _endTimeController.text = "${formattedTime}";;

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

    );

  }

}
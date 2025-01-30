import 'package:flutter/material.dart';
import 'package:hr_app/Screen/Color/app_Color.dart';
import 'package:hr_app/Screen/HR%20Screens/Staff/staff_Home_Screen.dart';

class addStaff2Screen extends StatefulWidget {
  @override
  _addStaff2ScreenState createState() => _addStaff2ScreenState();
}

class _addStaff2ScreenState extends State<addStaff2Screen> {

  final TextEditingController _joinDateController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _relationController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  final List<String> _weekDays = [
    "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
  ];

  final List<String> _bloodGroups = [
    "A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"
  ];

  List<String> _selectedDays = [];

  void _toggleSelection(String day) {
    setState(() {
      _selectedDays.contains(day)
          ? _selectedDays.remove(day)
          : _selectedDays.add(day);
    });
  }

  String? _selectedBloodGroup;

  void _onSelectBloodGroup(String group) {
    setState(() {
      _selectedBloodGroup = group;
    });
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

              Row(

                crossAxisAlignment: CrossAxisAlignment.center,

                children: [

                  Icon(Icons.work_rounded, color: Colors.black, size: 20,),

                  SizedBox(width: 6,),

                  Text("Office Use", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: "poppins_thin", color: Colors.black),),

                ],

              ),

              SizedBox(height: 22,),

              buildTextField("Join Date", "Joining Date", false, _joinDateController),

              SizedBox(height: 0),

              Text("Select Week Off Days", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: "poppins_thin", color: Colors.grey.shade700),),

              SizedBox(height: 12),

              Wrap(

                spacing: 8.0,

                runSpacing: 2.0,

                children: _weekDays.map((day) {

                  final isSelected = _selectedDays.contains(day);

                  return ChoiceChip(

                    label: Text(day),

                    selected: isSelected,

                    selectedColor: Colors.deepPurple.shade100,

                    backgroundColor: Colors.grey.shade200,

                    labelStyle: TextStyle(color: isSelected ? Colors.deepPurple : Colors.black, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,),

                    onSelected: (selected) => _toggleSelection(day),

                  );

                }).toList(),

              ),

              SizedBox(height: 20),

              Text("Selected Days: ${_selectedDays.isEmpty ? 'None' : _selectedDays.join(', ')}", style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, fontFamily: "poppins_thin", color: Colors.grey.shade700),),

              SizedBox(height: 30,),

              Row(

                crossAxisAlignment: CrossAxisAlignment.center,

                children: [

                  Icon(Icons.phone, color: Colors.black, size: 20,),

                  SizedBox(width: 6,),

                  Text("Emergency contact", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: "poppins_thin", color: Colors.black),),

                ],

              ),

              SizedBox(height: 22,),

              buildTextField("Name", "Enter Name", false, _nameController),

              buildTextField("Relation", "Relation", false, _relationController),

              buildTextField("Mobile number", "Mobile number", false, _mobileController),

              Text("Select Blood Group", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: "poppins_thin", color: Colors.grey.shade700),),

              SizedBox(height: 12),

              Wrap(

                spacing: 8.0,

                runSpacing: 2.0,

                children: _bloodGroups.map((group) {

                  final isSelected = _selectedBloodGroup == group;

                  return ChoiceChip(

                    showCheckmark: false,

                    label: Text(group),

                    selected: isSelected,

                    selectedColor: Colors.deepPurple.shade100,

                    backgroundColor: Colors.grey.shade200,

                    labelStyle: TextStyle(color: isSelected ? Colors.deepPurple : Colors.black, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,),

                    onSelected: (selected) => _onSelectBloodGroup(group),

                  );

                }).toList(),

              ),

              SizedBox(height: 20),

              Text("Selected Blood Group: ${_selectedBloodGroup ?? 'None'}", style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: Colors.grey.shade700, fontFamily: "poppins_thin"),),

              SizedBox(height: 30,),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,

                children: [

                  ElevatedButton(

                    onPressed: () {

                      Navigator.pop(context);

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

                        Icon(Icons.navigate_before_rounded, color: Colors.white, size: 22,),
                        SizedBox(width: 0,),
                        Text("Previous", style: TextStyle(fontSize: 14, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, color: Colors.white)),

                      ],

                    ),

                  ),

                  SizedBox(width: 8,),

                  ElevatedButton(

                    onPressed: () {

                      Navigator.popAndPushNamed(context, '/staffHome');

                      ScaffoldMessenger.of(context).showSnackBar(

                        SnackBar(content: Text("new staff added successfully")),

                      );

                    },

                    style: ElevatedButton.styleFrom(

                      backgroundColor: appColor.primaryColor,

                      shape: RoundedRectangleBorder(

                        borderRadius: BorderRadius.circular(20),

                      ),

                      fixedSize: Size(MediaQuery.of(context).size.width.toDouble() / 2 - 20, 40),

                    ),

                    child: Text("Add Staff", style: TextStyle(fontSize: 14, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, color: Colors.white)),

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

        keyboardType: controller == _mobileController ? TextInputType.number : TextInputType.name,

        readOnly: controller == _joinDateController,

        onTap: () async {

          if (controller == _joinDateController) {

            DateTime? pickedDate = await showDatePicker(

              context: context,

              initialDate: DateTime.now(),

              firstDate: DateTime(1990),

              lastDate: DateTime.now(),

            );

            if (pickedDate != null) {

              String formattedDate = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";

              setState(() {

                _joinDateController.text = formattedDate;

              });

            }

          }

        },

        style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),

        decoration: InputDecoration(

          hintText: hint,

          suffixIcon: Icon(controller == _joinDateController ? Icons.calendar_month_rounded : controller == _nameController ? Icons.person : controller == _relationController ? Icons.link_rounded : controller == _mobileController ? Icons.phone : Icons.mail_outline_rounded, size: 20,),

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

}
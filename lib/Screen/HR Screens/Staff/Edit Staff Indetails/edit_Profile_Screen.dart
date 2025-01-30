import 'package:flutter/material.dart';
import 'package:hr_app/Screen/Color/app_Color.dart';

class editProfileScreen extends StatelessWidget {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController(text: 'gymsmart_');

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        elevation: 1,

        title: Text('Edit Profile Information', style: TextStyle(color: Colors.black, fontFamily: "poppins_thin", fontSize: 18, fontWeight: FontWeight.bold),),

        foregroundColor: Colors.transparent,

        leading: IconButton(

          onPressed: (){
            Navigator.pop(context);
          },

          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20,),

        ),

      ),

      backgroundColor: Colors.white,

      body: Padding(

        padding: const EdgeInsets.symmetric(horizontal: 16.0),

        child: SingleChildScrollView(

          child: Form(

            key: _formKey,

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                SizedBox(height: 30,),

                _buildLabel('Username *'),

                SizedBox(height: 6,),

                _buildUsernameField(),

                SizedBox(height: 10),

                _buildLabel('Name *'),

                SizedBox(height: 6,),

                _buildTextField('vb'),

                SizedBox(height: 10),

                _buildLabel('Date of Birth'),

                SizedBox(height: 6,),

                _buildTextField('DD/MM/YYYY'),

                SizedBox(height: 10),

                _buildLabel('Gender'),

                SizedBox(height: 6,),

                _buildDropdown(['Select'], 'Select'),

                SizedBox(height: 10),

                _buildLabel('Marital Status'),

                SizedBox(height: 6,),

                _buildDropdown(['Select option'], 'Select option'),

                SizedBox(height: 10),

                _buildLabel('Address'),

                SizedBox(height: 6,),

                _buildTextField('Address'),

                SizedBox(height: 10),

                Row(

                  children: [

                    Expanded(child: _buildLabel('Town')),

                    SizedBox(width: 10),

                    Expanded(child: _buildLabel('City')),

                  ],

                ),

                SizedBox(height: 6,),

                Row(

                  children: [

                    Expanded(child: _buildTextField('Town')),

                    SizedBox(width: 10),

                    Expanded(child: _buildTextField('City')),

                  ],

                ),

                SizedBox(height: 10),

                Row(

                  children: [

                    Expanded(child: _buildLabel('Pin Code')),

                    SizedBox(width: 10),

                    Expanded(child: _buildLabel('Blood Group')),

                  ],

                ),

                SizedBox(height: 6,),

                Row(

                  children: [

                    Expanded(child: _buildTextField('Pin code')),

                    SizedBox(width: 10),

                    Expanded(child: _buildDropdown(['blood group'], 'Select blood group'),),

                  ],

                ),

                SizedBox(height: 20),

                ElevatedButton(

                  onPressed: () {

                    if (_formKey.currentState!.validate()) {

                      ScaffoldMessenger.of(context).showSnackBar(

                        SnackBar(content: Text('Profile Saved!')),

                      );

                      Navigator.pop(context);

                    }

                  },

                  style: ElevatedButton.styleFrom(

                    backgroundColor: appColor.primaryColor,

                    fixedSize: Size(MediaQuery.of(context).size.width.toDouble(), 43),

                  ),

                  child: Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: "poppins_thin")),

                ),

              ],

            ),

          ),

        ),

      ),

    );

  }

  Widget _buildLabel(String text) {

    return Text(text, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black, fontFamily: "poppins_thin"),);

  }

  Widget _buildUsernameField() {

    return Card(

      elevation: 1,

      shadowColor: Colors.black,

      color: Colors.transparent,

      child: TextFormField(

        controller: _usernameController,

        style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),

        decoration: InputDecoration(

          filled: true,

          fillColor: appColor.subPrimaryColor,

          hintStyle: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13),

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

          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),

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

    );

  }


  Widget _buildTextField(String hint) {

    return Card(

      elevation: 1,

      shadowColor: Colors.black,

      color: Colors.transparent,

      child: TextFormField(

        style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),

        decoration: InputDecoration(

          hintText: hint,

          hintStyle: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13),

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

          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),

        ),

      ),

    );

  }

  Widget _buildDropdown(List<String> items, String hint) {

    return Card(

      elevation: 1,
      
      shadowColor: Colors.black,

      color: Colors.transparent,

      child: DropdownButtonFormField<String>(

        style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13),

        decoration: InputDecoration(

          filled: true,

          fillColor: appColor.subPrimaryColor,

          hintStyle: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13),

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

          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),

        ),

        value: items.first,

        onChanged: (value) {},

        items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),

      ),

    );

  }

}
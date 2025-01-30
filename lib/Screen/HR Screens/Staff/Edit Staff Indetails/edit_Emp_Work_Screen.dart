import 'package:flutter/material.dart';

import '../../../Color/app_Color.dart';

class editEmpWorkScreen extends StatelessWidget {

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: Text('Edit Emp Working Details', style: TextStyle(color: Colors.black, fontFamily: "poppins_thin", fontSize: 18, fontWeight: FontWeight.bold),),

        elevation: 1,

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

        padding: const EdgeInsets.symmetric(horizontal: 14.0),

        child: SingleChildScrollView(

          child: Form(

            key: _formKey,

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                SizedBox(height: 30,),

                _buildTextField('Department', 'Membership Director 2', isReadable: true),

                SizedBox(height: 16,),

                _buildRow([
                  _buildTextField('Reporting Head *', 'gymsmart', isReadable: true),
                  _buildDropdownField('User Role *', ['Admin'], 'Admin'),
                ]),

                SizedBox(height: 6,),

                _buildTextField('Job location', 'Job location'),

                SizedBox(height: 16,),

                _buildRow([
                  _buildDropdownField('Work Shift *', ['Select shift'], 'Select shift'),
                  _buildTextField('Join Date', 'DD/MM/YYYY', isDate: true),
                ]),

                SizedBox(height: 6,),

                _buildRow([
                  _buildTextField('Session', '1'),
                  _buildDropdownField('Week Off', ['Sunday'], 'Sunday'),
                ]),

                SizedBox(height: 6,),

                _buildRow([
                  _buildTimeField('User active time from', '09:00'),
                  _buildTimeField('User active time To', '20:00'),
                ]),

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

  Widget _buildRow(List<Widget> children) {

    return Padding(

      padding: const EdgeInsets.only(bottom: 10),

      child: Row(

        children: children
            .expand((child) => [
          Expanded(child: child),
          SizedBox(width: 10) // Add spacing between fields
        ]).toList()..removeLast(), // Remove the trailing SizedBox

      ),

    );

  }

  Widget _buildTextField(String label, String hint, {bool isDate = false, bool isReadable = false}) {

    return Column(

      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        _buildLabel(label),

        TextFormField(

          readOnly: isReadable ? true : false,

          style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),

          decoration: InputDecoration(

            hintText: hint,

            suffixIcon: isDate ? Icon(Icons.calendar_today) : null,

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

      ],

    );

  }

  Widget _buildDropdownField(String label, List<String> items, String selectedValue) {

    return Column(

      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        _buildLabel(label),

        DropdownButtonFormField<String>(

          style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),

          decoration: InputDecoration(

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

          value: selectedValue,

          onChanged: (value) {},

          items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),

        ),

      ],

    );

  }

  Widget _buildTimeField(String label, String hint) {

    return Column(

      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        if (label.isNotEmpty) _buildLabel(label),

        TextFormField(

          style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),

          decoration: InputDecoration(

            hintText: hint,

            suffixIcon: Icon(Icons.access_time),

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

      ],

    );

  }

  Widget _buildLabel(String text) {

    return Padding(

      padding: const EdgeInsets.only(bottom: 5),

      child: Text(text, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, fontFamily: "poppins_thin", color: Colors.black),),

    );

  }

}
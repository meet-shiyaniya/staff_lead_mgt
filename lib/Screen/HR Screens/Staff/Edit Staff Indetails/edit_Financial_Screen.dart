import 'package:flutter/material.dart';
import 'package:hr_app/Screen/Color/app_Color.dart';

class editFinancialScreen extends StatefulWidget {
  @override
  _editFinancialScreenState createState() => _editFinancialScreenState();
}

class _editFinancialScreenState extends State<editFinancialScreen> {

  final _formKey = GlobalKey<FormState>();

  // Controllers for the text fields
  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController accountNumController = TextEditingController();
  final TextEditingController panNumController = TextEditingController();
  final TextEditingController ifscController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        elevation: 1,

        title: Text('Edit Financial Details', style: TextStyle(color: Colors.black, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 18),),

        foregroundColor: Colors.transparent,

        leading: IconButton(

          onPressed: (){
            Navigator.pop(context);
          },

          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20,),

        ),

      ),

      backgroundColor: Colors.white,

      body: SingleChildScrollView(

        child: Padding(

          padding: EdgeInsets.symmetric(horizontal: 16.0),

          child: Form(

            key: _formKey,

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                SizedBox(height: 30,),

                Text("Bank Name", style: TextStyle(color: Colors.black, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 15),),

                SizedBox(height: 6,),

                Card(

                  elevation: 1,
                  color: appColor.subPrimaryColor,

                  child: TextFormField(

                    controller: bankNameController,

                    style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),

                    decoration: InputDecoration(

                      hintText: 'Bank Name',

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

                    ),

                    validator: (value) {

                      if (value == null || value.isEmpty || value.length <= 4) {

                        return 'Please enter a bank name';

                      }

                      return null;

                    },

                  ),
                ),

                SizedBox(height: 16),

                Text("Account Number", style: TextStyle(color: Colors.black, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 15),),

                SizedBox(height: 6,),

                Card(

                  elevation: 1,
                  color: appColor.subPrimaryColor,

                  child: TextFormField(

                    controller: accountNumController,

                    style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),

                    decoration: InputDecoration(

                    hintText: 'Account Number',

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

                    ),

                    keyboardType: TextInputType.number,

                    validator: (value) {

                      if (value == null || value.isEmpty || value.length < 8 && value.length > 12) {

                        return 'Please enter a valid Account number';

                      }

                      return null;

                    },

                  ),
                ),

                SizedBox(height: 16),

                Text("Pan Number", style: TextStyle(color: Colors.black, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 15),),

                SizedBox(height: 6,),

                Card(

                  elevation: 1,
                  color: appColor.subPrimaryColor,

                  child: TextFormField(

                    controller: panNumController,

                    maxLength: 10,

                    style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),

                    decoration: InputDecoration(

                      hintText: 'Pancard number',

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

                    ),

                    validator: (value) {

                      if (value == null || value.isEmpty || value.length != 10) {

                        return 'Please enter a valid Pan number';

                      }

                      return null;

                    },

                  ),
                ),

                SizedBox(height: 16),

                Text("IFSC Code", style: TextStyle(color: Colors.black, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 15),),

                SizedBox(height: 6,),

                Card(

                  elevation: 1,
                  color: appColor.subPrimaryColor,

                  child: TextFormField(

                    controller: ifscController,

                    maxLength: 11,

                    style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),

                    decoration: InputDecoration(

                      hintText: 'IFSC Code',

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

                    ),

                    keyboardType: TextInputType.number,

                    validator: (value) {

                      if (value == null || value.isEmpty || value.length != 11) {

                        return 'Please enter a valid IFSC Code';

                      }

                      return null;

                    },

                  ),
                ),

                SizedBox(height: 16),

                Text("Salary", style: TextStyle(color: Colors.black, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 15),),

                SizedBox(height: 6,),

                Card(

                  elevation: 1,
                  color: appColor.subPrimaryColor,

                  child: TextFormField(

                    controller: salaryController,

                    style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),

                    decoration: InputDecoration(

                      hintText: 'Salary',

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

                    ),

                    keyboardType: TextInputType.number,

                    validator: (value) {

                      if (value == null || value.isEmpty) {

                        return 'Please enter a Salary';

                      }

                      return null;

                    },

                  ),
                ),

                SizedBox(height: 32),

                SizedBox(

                  width: double.infinity,

                  child: ElevatedButton(

                    onPressed: () {

                      if (_formKey.currentState?.validate() ?? false) {

                        ScaffoldMessenger.of(context).showSnackBar(

                          SnackBar(content: Text('Saving Contact Details')),

                        );

                      }

                    },

                    child: Text('Save', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),),

                    style: ElevatedButton.styleFrom(

                        minimumSize: Size(double.infinity, 43),

                        backgroundColor: appColor.primaryColor

                    ),

                  ),

                ),

              ],

            ),

          ),

        ),
      ),

    );

  }

}
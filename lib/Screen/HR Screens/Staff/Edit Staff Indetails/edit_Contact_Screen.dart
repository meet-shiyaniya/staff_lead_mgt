import 'package:flutter/material.dart';
import 'package:hr_app/Screen/Color/app_Color.dart';

class editContactScreen extends StatefulWidget {
  @override
  _editContactScreenState createState() => _editContactScreenState();
}

class _editContactScreenState extends State<editContactScreen> {

  final _formKey = GlobalKey<FormState>();

  // Controllers for the text fields
  final TextEditingController _phoneController = TextEditingController(text: '+91 ');
  final TextEditingController _simAllocationController = TextEditingController(text: '+91 ');
  final TextEditingController _altMobileController = TextEditingController(text: '+91 ');
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _workEmailController = TextEditingController();
  final TextEditingController _skypeController = TextEditingController();

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
    _emailController.dispose();
    _workEmailController.dispose();
    _skypeController.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        elevation: 1,

        title: Text('Edit Contact Details', style: TextStyle(color: Colors.black, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 18),),

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

                Text("Phone Number", style: TextStyle(color: Colors.black, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 15),),

                SizedBox(height: 6,),

                Card(

                  elevation: 1,
                  color: appColor.subPrimaryColor,

                  child: TextFormField(

                    controller: _phoneController,

                    style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),

                    decoration: InputDecoration(

                      hintText: 'Phone Number',

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

                    keyboardType: TextInputType.phone,

                    validator: (value) {

                      if (value == null || value.isEmpty || value.length <= 4) {

                        return 'Please enter a valid phone number';

                      }

                      return null;

                    },

                  ),
                ),

                SizedBox(height: 16),

                Text("Sim Allocation Number", style: TextStyle(color: Colors.black, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 15),),

                SizedBox(height: 6,),

                Card(

                  elevation: 1,
                  color: appColor.subPrimaryColor,

                  child: TextFormField(

                    controller: _simAllocationController,

                    style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),

                    decoration: InputDecoration(

                      hintText: 'SIM Allocation Number',

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

                    keyboardType: TextInputType.phone,

                    validator: (value) {

                      if (value == null || value.isEmpty || value.length <= 4) {

                        return 'Please enter a valid SIM allocation number';

                      }

                      return null;

                    },

                  ),
                ),

                SizedBox(height: 16),

                Text("Alt. Mobile Number", style: TextStyle(color: Colors.black, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 15),),

                SizedBox(height: 6,),

                Card(

                  elevation: 1,
                  color: appColor.subPrimaryColor,

                  child: TextFormField(

                    controller: _altMobileController,

                    style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),

                    decoration: InputDecoration(

                      hintText: 'Alternate Mobile Number',

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

                    keyboardType: TextInputType.phone,

                    validator: (value) {

                      if (value == null || value.isEmpty || value.length <= 4) {

                        return 'Please enter a valid alternate mobile number';

                      }

                      return null;

                    },

                  ),
                ),

                SizedBox(height: 16),

                Text("Email address", style: TextStyle(color: Colors.black, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 15),),

                SizedBox(height: 6,),

                Card(

                  elevation: 1,
                  color: appColor.subPrimaryColor,

                  child: TextFormField(

                    controller: _emailController,

                    style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),

                    decoration: InputDecoration(

                      hintText: 'abc@gmail.com',

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

                    keyboardType: TextInputType.emailAddress,

                    validator: (value) {

                      if (value == null || value.isEmpty) {

                        return 'Please enter an email address';

                      }

                      return null;

                    },

                  ),
                ),

                SizedBox(height: 16),

                Text("Work Email address", style: TextStyle(color: Colors.black, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 15),),

                SizedBox(height: 6,),

                Card(

                  elevation: 1,
                  color: appColor.subPrimaryColor,

                  child: TextFormField(

                    controller: _workEmailController,

                    style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),

                    decoration: InputDecoration(

                      hintText: 'ajasys@gmail.com',

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

                    keyboardType: TextInputType.emailAddress,

                    validator: (value) {

                      if (value == null || value.isEmpty) {

                        return 'Please enter a work email address';

                      }

                      return null;

                    },

                  ),
                ),

                SizedBox(height: 16),

                Text("Skype", style: TextStyle(color: Colors.black, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 15),),

                SizedBox(height: 6,),

                Card(

                  elevation: 1,
                  color: appColor.subPrimaryColor,

                  child: TextFormField(

                    controller: _skypeController,

                    style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w700, fontSize: 13.5),

                    decoration: InputDecoration(

                      hintText: 'Skype',

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

                    keyboardType: TextInputType.text,

                    validator: (value) {

                      if (value == null || value.isEmpty) {

                        return 'Please enter your Skype ID';

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
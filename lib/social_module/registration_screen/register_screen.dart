import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../colors/colors.dart';
import '../login_screen/login_screen.dart';
import '../registration_screen/register_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController createPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool _obscureCreatePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height/2.9,
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color:AppColors.primaryColor.withOpacity(0.6),
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(50),bottomLeft: Radius.circular(50)),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey.shade400,
                //     offset: Offset(1,3),
                //     blurRadius: 3,
                //     spreadRadius: 1
                //   )
                // ]
              ),
            ),

            Container(),
            Positioned(
                top: MediaQuery.of(context).size.height/8,
                left: MediaQuery.of(context).size.width/21,
                child:Container(
                    height:MediaQuery.of(context).size.height/1.2,
                    width:MediaQuery.of(context).size.width/1.1,
                    // margin:EdgeInsets.all(10),
                    padding:EdgeInsets.only(left: 20,right: 20,top: 15),
                    decoration:BoxDecoration(
                        color:Colors.white,
                        borderRadius:BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade400,
                              offset: Offset(1,3),
                              blurRadius: 3,
                              spreadRadius: 1
                          )
                        ]
                    ),
                    child:SingleChildScrollView(
                      child: Column(
                          children:[
                            Text("Register Here",style: GoogleFonts.dancingScript(color: Colors.grey,fontSize: 20),),
                            Image.asset('assets/images/login/newlogin.png', height: 160, width: 160),
                            Text(
                              "Join the Team, Unlock Possibilities!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 24,
                                  // fontWeight: FontWeight.w600,
                                  color: AppColors.primaryColor
                                // color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  // Mobile Number TextField
                                  TextFormField(
                                    controller: mobileNumberController,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.grey[200],
                                      labelText: 'Mobile Number',
                                      hintText: 'Enter your mobile number',
                                      prefixIcon: Icon(Icons.verified, color: AppColors.primaryColor),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your mobile number';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  // Create Password TextField
                                  TextFormField(
                                    controller: createPasswordController,
                                    obscureText: _obscureCreatePassword,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.grey[200],
                                      labelText: 'Create Password',
                                      hintText: 'Enter your password',
                                      prefixIcon: Icon(Icons.lock_outline, color: AppColors.primaryColor),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscureCreatePassword ? Icons.visibility_off : Icons.visibility,
                                          color: AppColors.primaryColor,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscureCreatePassword = !_obscureCreatePassword;
                                          });
                                        },
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please create a password';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  // Confirm Password TextField
                                  TextFormField(
                                    controller: confirmPasswordController,
                                    obscureText: _obscureConfirmPassword,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.grey[200],
                                      labelText: 'Confirm Password',
                                      hintText: 'Re-enter your password',
                                      prefixIcon: Icon(Icons.lock, color: AppColors.primaryColor),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                                          color: AppColors.primaryColor,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscureConfirmPassword = !_obscureConfirmPassword;
                                          });
                                        },
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please confirm your password';
                                      }
                                      if (value != createPasswordController.text) {
                                        return 'Passwords do not match';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  // Login Button
                                  Container(
                                    width: double.infinity,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          showDialog(
                                            context: context,
                                            builder: (_) => AlertDialog(
                                              title: const Text('Welcome!',
                                                  style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontWeight: FontWeight.bold)),
                                              content: Text(
                                                  'Welcome back, ${mobileNumberController.text}!',
                                                  style: const TextStyle(fontFamily: 'Poppins')),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('OK',
                                                      style: TextStyle(fontFamily: 'Poppins')),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      },
                                      child: const Text(
                                        'Register',
                                        style: TextStyle(
                                            color: Colors.white, fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                     children: [

                                       Text(
                                         'Already Have an Account?',
                                         style: TextStyle(fontFamily: 'Poppins', color: Colors.grey),
                                       ),
                                       TextButton(onPressed: (){
                                         Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                                       }, child: Text("Login",style: TextStyle(fontFamily: "poppins",fontSize: 16),),)
                                     ],
                                  )
                                  // Forgot Password
                                  // TextButton(
                                  //   onPressed: () {
                                  //     Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                                  //   },
                                  //   child: Text(
                                  //     'Already Have an Account?',
                                  //     style: TextStyle(fontFamily: 'Poppins', color: AppColors.primaryColor),
                                  //   ),
                                  // ),

                                ],
                              ),
                            ),

                          ]
                      ),
                    )

                )
            )

          ],
        )
    );
  }
}
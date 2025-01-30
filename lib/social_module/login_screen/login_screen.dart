import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../chatting_module/example.dart';
import '../colors/colors.dart';
import '../registration_screen/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;

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
                child:Column(
                    children:[
                      Text("Login Here",style: GoogleFonts.dancingScript(color: Colors.grey,fontSize: 20),),
                      Image.asset('assets/images/login/newlogin.png', height: 160, width: 160),
                      Text(
                        'Welcome Back! Lets get started.',
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
                            // Email TextField
                            TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[200],
                                labelText: 'Email',
                                hintText: 'Enter your email',
                                prefixIcon: Icon(Icons.email, color: AppColors.primaryColor),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            // Password TextField
                            TextFormField(
                              controller: passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[200],
                                labelText: 'Password',
                                hintText: 'Enter your password',
                                prefixIcon: Icon(Icons.lock, color: AppColors.primaryColor),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                    color: AppColors.primaryColor,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
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
                                  return 'Please enter your password';
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
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>ExampleTabbar()));
                                  }
                                },
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                      color: Colors.white, fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Forgot Password
                            TextButton(
                              onPressed: () {
                                // Forgot Password Logic
                              },
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(fontFamily: 'Poppins', color: AppColors.primaryColor),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // New User Option
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('New User? ',
                                    style: TextStyle(fontFamily: 'Poppins')),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => RegisterScreen()));
                                  },
                                  child: const Text('Create an Account',
                                      style: TextStyle(
                                          fontFamily: 'Poppins', color: Colors.blue)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                    ]
                )

            )
          )

        ],
      )
    );
  }
}
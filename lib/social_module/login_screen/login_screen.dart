import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hr_app/Staff%20Attendance%20Options/Mannual%20Day%20Start/mannual_Attendance_Screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../Provider/UserProvider.dart';
import '../../Staff Attendance Options/Selfie Punch Attendance/face_onboarding.dart';
import '../colors/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final String font="poppins";
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;

  final FlutterSecureStorage _secureStorage=FlutterSecureStorage();

  void _markAttendanceAndNavigate(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    await prefs.setString('attendanceDate', today);
    Navigator.pushReplacementNamed(context, '/dashboard');
  }

  @override
  Widget build(BuildContext context) {



    void signIn() async {
      final username = emailController.text.trim();
      final password = passwordController.text.trim();

      if (username.isEmpty || password.isEmpty) {
        Fluttertoast.showToast(
          msg: "Please enter both email and password❌",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Colors.white,
        );
        return;
      }

      bool isSuccess = await Provider.of<UserProvider>(context, listen: false).login(username, password);

      if (isSuccess) {
        String? token = await _secureStorage.read(key: 'token');
        if (token != null) {
          print("Login Successful");
          Fluttertoast.showToast(
            msg: "Login Successful ✅",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: AppColors.primaryColor,
            textColor: Colors.white,
          );
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => FaceOnboarding()));
        } else {
          print("Login failed");
        }
      } else {
        Fluttertoast.showToast(
          msg: "Invalid username or password. Please try again ❌.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Colors.white,
        );
      }
    }


    return Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height/3,
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
                top: MediaQuery.of(context).size.height/5.6,
                left: MediaQuery.of(context).size.width/21,
                child:Container(
                    height:MediaQuery.of(context).size.height/1.5,
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
                          Text("Login Here",style:TextStyle(color: AppColors.primaryColor,fontSize: 24,fontFamily: "poppins_thin"),),
                          SizedBox(height: 15,),
                          Image.asset('asset/rtosmart.png', height: 100, width: 100),
                          SizedBox(height: 15,),
                          Text(
                            'Welcome Back! Lets get started.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'poppins_thin',
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryColor.withOpacity(0.8)
                              // color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 30),
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
                                    labelStyle: TextStyle(fontFamily: "poppins_thin",fontWeight: FontWeight.bold),
                                    hintStyle:TextStyle(fontFamily: font,fontWeight: FontWeight.bold),
                                    prefixIcon: Icon(Icons.email, color: AppColors.primaryColor),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),

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
                                    labelStyle: TextStyle(fontFamily: "poppins_thin",fontWeight: FontWeight.bold),
                                    hintStyle: TextStyle(fontFamily: font,fontWeight: FontWeight.bold),
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
                                    }if(value.length<8){
                                      return "Please enter 8 digits valid password";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 30),
                                // Login Button
                                Container(
                                  width: double.infinity,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: TextButton(
                                    onPressed: (){
                                      signIn();
                                      print("successfully fetched");

                                    },
                                    child: const Text(
                                      'Login',
                                      style: TextStyle(
                                          color: Colors.white, fontFamily: 'Poppins_thin', fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                // const SizedBox(height: 10),
                                // // Forgot Password
                                // TextButton(
                                //   onPressed: () {
                                //     // Forgot Password Logic
                                //   },
                                //   child: Text(
                                //     'Forgot Password?',
                                //     style: TextStyle(fontFamily:font, color: AppColors.primaryColor,fontWeight: FontWeight.bold),
                                //   ),
                                // ),
                                // const SizedBox(height: 10),
                                // New User Option
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   children: [
                                //      Text('New User? ',
                                //         style: TextStyle(fontFamily: AppColors.font,fontWeight: FontWeight.bold)),
                                //     TextButton(
                                //       onPressed: () {
                                //         Navigator.push(
                                //             context,
                                //             MaterialPageRoute(
                                //                 builder: (context) => RegisterScreen()));
                                //       },
                                //       child:  Text('Create an Account',
                                //           style: TextStyle(
                                //               fontFamily: AppColors.font, color: Colors.blue,fontWeight: FontWeight.bold)),
                                //     ),
                                //   ],
                                // ),
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



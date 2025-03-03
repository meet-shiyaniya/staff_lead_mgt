import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hr_app/Staff%20Attendance%20Options/Mannual%20Day%20Start/mannual_Attendance_Screen.dart';
import 'package:hr_app/Week%20Off%20Or%20Holiday/time_Out_Screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../Provider/UserProvider.dart';
import '../../Staff Attendance Options/QR Scanner/qr_Onboarding_Screen.dart';
import '../../Staff Attendance Options/Selfie Punch Attendance/face_onboarding.dart';
import '../../Week Off Or Holiday/week_Off_Screen.dart';
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

  var staffAttendanceMethod;
  var staffAttendanceMethodStatus;

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

      // Validate input fields
      if (username.isEmpty || password.isEmpty) {
        Fluttertoast.showToast(
          msg: "Please enter both email and password ❌",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Colors.white,
        );
        return;
      }

      // Attempt login
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      bool isSuccess = await userProvider.login(username, password);

      if (!isSuccess) {
        Fluttertoast.showToast(
          msg: "Invalid username or password. Please try again ❌",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Colors.white,
        );
        return;
      }

      // Fetch authentication token
      String? token = await _secureStorage.read(key: 'token');
      if (token == null) {
        print("❌ Login failed: Token not found");
        return;
      }

      // Fetch user profile data
      await userProvider.fetchProfileData();
      final profileData = userProvider.profileData?.staffProfile;

      if (profileData == null) {
        print("❌ Error: Failed to fetch profile data");
        Fluttertoast.showToast(msg: "Failed to load profile. Please try again.");
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }

      DateTime? _parseTime(String? timeString) {
        if (timeString == null || timeString.isEmpty) return null;

        try {
          final now = DateTime.now();
          final formattedTime = DateFormat('hh:mm a').parse(timeString); // Parses '09:00 AM' format
          return DateTime(now.year, now.month, now.day, formattedTime.hour, formattedTime.minute);
        } catch (e) {
          print('⚠️ Error parsing time: $e');
          return null;
        }
      }

      // Time comparison logic
      final now = DateTime.now();
      final activeFromTime = _parseTime(profileData.activeFromTime);
      final activeToTime = _parseTime(profileData.activeToTime);

      if (activeFromTime != null && activeToTime != null) {
        if (now.isBefore(activeFromTime) || now.isAfter(activeToTime)) {
          print("⏰ Navigating to TimeoutScreen (Outside Active Time)");
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => timeOutScreen()));
          return;
        }
      } else {
        print("⚠️ Warning: activeFromTime or activeToTime is null");
      }

      // Check if today is a holiday, week off, or vacation
      if (profileData.holidayToday == 1 || profileData.weekoffToday == 1 || profileData.vacationToday == 1) {
        print("📅 Navigating to WeekOff Screen (Holiday/Weekoff/Vacation)");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => weekOffScreen()));
        return;
      }

      final staffAttendanceMethod = profileData.staffAttendanceMethod;

      if (staffAttendanceMethod == "0") {
        print("✅ Navigating to Dashboard (Staff_attendance_method = 0)");
        Navigator.pushReplacementNamed(context, '/dashboard');
        return;
      }

      if (staffAttendanceMethod == "1") {
        final prefs = await SharedPreferences.getInstance();
        final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
        final isAttendanceMarkedForToday = prefs.getBool('attendanceMarked_$today') ?? false;

        if (isAttendanceMarkedForToday) {
          print("✅ Navigating to Dashboard (Attendance already marked)");
          Navigator.pushReplacementNamed(context, '/dashboard');
          return;
        }

        // Navigate to appropriate attendance screen
        final attendanceMethod = profileData.attendanceMethod ?? "selfi_attendance";
        Widget nextScreen;
        switch (attendanceMethod) {
          case "day_attendance":
            nextScreen = mannualAttendanceScreen();
            break;
          case "qr_attendance":
            nextScreen = qrOnboardingScreen();
            break;
          default:
            nextScreen = FaceOnboarding();
        }

        print("📸 Navigating to Attendance Screen ($attendanceMethod)");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => nextScreen));
        return;
      }

      // Handle invalid attendance method
      print("❌ Error: Invalid Staff_attendance_method: $staffAttendanceMethod");
      Fluttertoast.showToast(msg: "Invalid attendance method. Please contact support.");
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



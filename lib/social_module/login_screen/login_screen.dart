import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hr_app/Staff%20Attendance%20Options/Mannual%20Day%20Start/mannual_Attendance_Screen.dart';
import 'package:hr_app/Week%20Off%20Or%20Holiday/inactive_Screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../Provider/UserProvider.dart';
import '../../Staff Attendance Options/QR Scanner/qr_Onboarding_Screen.dart';
import '../../Staff Attendance Options/Selfie Punch Attendance/face_onboarding.dart';
import '../../staff_HRM_module/Screen/Staff HR Screens/Attendannce/timeOutScreen.dart';
import '../../staff_HRM_module/Screen/Staff HR Screens/Attendannce/weekOffScreen.dart';
import '../colors/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final String font = "poppins";
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  void _markAttendanceAndNavigate(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    await prefs.setString('attendanceDate', today);
    Navigator.pushReplacementNamed(context, '/dashboard');
  }

  Future<void> signIn() async {
    final username = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      if (!_validateInputs(username, password)) {
        _showErrorToast("Please enter both email and password ❌");
        return;
      }

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (!await _attemptLogin(userProvider, username, password)) {
        _showErrorToast("Invalid username or password. Please try again ❌");
        return;
      }

      final token = await _secureStorage.read(key: 'token');
      if (token == null) {
        debugPrint("❌ Login failed: Token not found");
        throw Exception("Authentication token not found");
      }

      await userProvider.fetchProfileData();
      final profileData = userProvider.profileData?.staffProfile;
      if (profileData == null) {
        debugPrint("❌ Error: Failed to fetch profile data");
        _showErrorToast("Failed to load profile. Please try again.");
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }

      if (profileData.status == "inactive") {
        _navigateTo(inactiveScreen());
        return;
      }

      if (!_isWithinActiveTime(profileData)) {
        debugPrint("⏰ Navigating to TimeoutScreen (Outside Active Time)");
        _navigateTo(timeOutScreen());
        return;
      }

      if (_isSpecialDay(profileData)) {
        debugPrint("📅 Navigating to WeekOff Screen (Holiday/Weekoff/Vacation)");
        _navigateTo(weekOffScreen());
        return;
      }

      await _handleAttendanceNavigation(profileData);
    } catch (e, stackTrace) {
      debugPrint("❌ Sign-in error: $e\n$stackTrace");
      _showErrorToast("An unexpected error occurred. Please try again.");
    }
  }

  bool _validateInputs(String username, String password) {
    return username.isNotEmpty && password.isNotEmpty;
  }

  Future<bool> _attemptLogin(UserProvider provider, String username, String password) async {
    return await provider.login(username, password);
  }

  void _showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
  }

  DateTime? _parseTime(String? timeString) {
    if (timeString == null || timeString.isEmpty) return null;
    try {
      final now = DateTime.now();
      final formattedTime = DateFormat('hh:mm a').parse(timeString);
      return DateTime(now.year, now.month, now.day, formattedTime.hour, formattedTime.minute);
    } catch (e) {
      debugPrint('⚠️ Error parsing time: $e');
      return null;
    }
  }

  bool _isWithinActiveTime(dynamic profile) {
    final now = DateTime.now();
    final activeFromTime = _parseTime(profile.activeFromTime);
    final activeToTime = _parseTime(profile.activeToTime);

    if (activeFromTime == null || activeToTime == null) {
      debugPrint("⚠️ Warning: activeFromTime or activeToTime is null");
      return true;
    }
    return now.isAfter(activeFromTime) && now.isBefore(activeToTime);
  }

  bool _isSpecialDay(dynamic profile) {
    return profile.holidayToday == 1 ||
        profile.weekoffToday == 1 ||
        profile.vacationToday == 1 &&
        profile.accessRequestStatusToday == 0;
  }

  void _navigateTo(Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  Future<void> _handleAttendanceNavigation(dynamic profile) async {
    final staffAttendanceMethod = profile.isAttendance;

    switch (staffAttendanceMethod) {
      case "1":
        debugPrint("✅ Navigating to Dashboard (Staff_attendance_method = 0)");
        Navigator.pushReplacementNamed(context, '/dashboard');
        break;
      case "0":
        final prefs = await SharedPreferences.getInstance();
        final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
        final isAttendanceMarked = prefs.getBool('attendanceMarked_$today') ?? false;

        if (isAttendanceMarked) {
          debugPrint("✅ Navigating to Dashboard (Attendance already marked)");
          Navigator.pushReplacementNamed(context, '/dashboard');
          return;
        }

        final attendanceMethod = profile.attendanceMethod ?? "selfi_attendance";
        final nextScreen = _getAttendanceScreen(attendanceMethod);
        debugPrint("📸 Navigating to Attendance Screen ($attendanceMethod)");
        _navigateTo(nextScreen);
        break;
      default:
        debugPrint("❌ Error: Invalid Staff_attendance_method: $staffAttendanceMethod");
        _showErrorToast("Invalid attendance method. Please contact support.");
    }
  }

  Widget _getAttendanceScreen(String attendanceMethod) {
    switch (attendanceMethod) {
      case "day_attendance":
        return mannualAttendanceScreen();
      case "qr_attendance":
        return qrOnboardingScreen();
      default:
        return FaceOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the full screen height and width
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SingleChildScrollView( // Added to allow scrolling if content overflows
        child: SizedBox(
          height: screenHeight, // Ensure the content takes full height
          child: Stack(
            children: [
              Container(
                height: screenHeight / 3, // Top section remains 1/3 of screen
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.6),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(50),
                    bottomLeft: Radius.circular(50),
                  ),
                ),
              ),
              Positioned(
                top: screenHeight / 6, // Adjusted top position to be more proportional
                left: screenWidth / 20, // Slightly adjusted for better centering
                child: Container(
                  height: screenHeight * 0.75, // Increased height to fit more content (75% of screen)
                  width: screenWidth * 0.9, // Adjusted width to be 90% of screen
                  padding: EdgeInsets.only(left: 20, right: 20, top: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400,
                        offset: Offset(1, 3),
                        blurRadius: 3,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Login Here",
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 24,
                          fontFamily: "poppins_thin",
                        ),
                      ),
                      SizedBox(height: 15),
                      Image.asset('asset/rtosmart.png', height: 100, width: 100),
                      SizedBox(height: 15),
                      Text(
                        'Welcome Back! Lets get started.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'poppins_thin',
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[200],
                                labelText: 'Email',
                                hintText: 'Enter your email',
                                labelStyle: TextStyle(fontFamily: "poppins_thin", fontWeight: FontWeight.bold),
                                hintStyle: TextStyle(fontFamily: font, fontWeight: FontWeight.bold),
                                prefixIcon: Icon(Icons.email, color: AppColors.primaryColor),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[200],
                                labelText: 'Password',
                                hintText: 'Enter your password',
                                labelStyle: TextStyle(fontFamily: "poppins_thin", fontWeight: FontWeight.bold),
                                hintStyle: TextStyle(fontFamily: font, fontWeight: FontWeight.bold),
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
                            const SizedBox(height: 30),
                            Container(
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: TextButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    await signIn();
                                    debugPrint("Login attempt completed");
                                  }
                                },
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Poppins_thin',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
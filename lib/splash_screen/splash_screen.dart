import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_app/Week%20Off%20Or%20Holiday/week_Off_Screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../Provider/UserProvider.dart';
import '../Staff Attendance Options/Mannual Day Start/mannual_Attendance_Screen.dart';
import '../Staff Attendance Options/QR Scanner/qr_Onboarding_Screen.dart';
import '../Staff Attendance Options/Selfie Punch Attendance/face_onboarding.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _checkInitialNavigation();

    Future.delayed(const Duration(milliseconds: 80), () {
      if (mounted) {
        setState(() {
          _isExpanded = true;
        });
      }
    });
  }

  Future<void> _checkInitialNavigation() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return; // Check if widget is still mounted

    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
    final token = await _secureStorage.read(key: 'token');

    if (isFirstLaunch || token == null || token.isEmpty) {
      print('First launch or no token, navigating to LoginScreen');
      await prefs.setBool('isFirstLaunch', false);
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
        // Handle subsequent navigation in the LoginScreen instead of here
      }
    } else {
      _handleAuthenticatedFlow();
    }
  }

  Future<void> _handleAuthenticatedFlow() async {
    if (!mounted) return;

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.fetchProfileData();

    if (!mounted) return;

    final profileData = userProvider.profileData?.staffProfile;

    // If profile data is null, redirect to login
    if (profileData == null) {
      print('❌ Error: Failed to fetch profile data');
      Fluttertoast.showToast(msg: 'Failed to load profile. Please try again.');
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    // If today is a holiday, week off, or vacation, go to the week-off screen
    if (profileData.holidayToday == 1 || profileData.weekoffToday == 1 || profileData.vacationToday == 1) {
      print('📅 Navigating to WeekOff Screen (Holiday/Weekoff/Vacation)');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => weekOffScreen()));
      return;
    }

    final staffAttendanceMethod = profileData.staffAttendanceMethod;

    // If staffAttendanceMethod is "0", go to the dashboard directly
    if (staffAttendanceMethod == "0") {
      print('✅ Navigating to Dashboard (Staff_attendance_method = 0)');
      Navigator.pushReplacementNamed(context, '/dashboard');
      return;
    }

    // If staffAttendanceMethod is "1", check if attendance is already marked
    if (staffAttendanceMethod == "1") {
      final prefs = await SharedPreferences.getInstance();
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final isAttendanceMarkedForToday = prefs.getBool('attendanceMarked_$today') ?? false;

      if (isAttendanceMarkedForToday) {
        print('✅ Navigating to Dashboard (Attendance already marked for today)');
        Navigator.pushReplacementNamed(context, '/dashboard');
        return;
      }

      final attendanceMethod = profileData.attendanceMethod ?? "selfi_attendance";

      print('📸 Navigating to Attendance Screen (Attendance not marked)');
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

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => nextScreen));
      return;
    }

    // If staffAttendanceMethod is invalid
    print('❌ Error: Invalid Staff_attendance_method: $staffAttendanceMethod');
    Fluttertoast.showToast(msg: 'Invalid attendance method. Please contact support.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(seconds: 3),
                  width: _isExpanded ? 180.0 : 130.0,
                  height: _isExpanded ? 180.0 : 130.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white24),
                    color: Colors.transparent,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Center(child: Image.asset("asset/logo.png")),
                    ),
                  ),
                ),
              ),
            ),
            Image.asset("asset/RealtoSmart Logo.png", height: 50, width: 150),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../Provider/UserProvider.dart';
import '../Staff Attendance Options/Mannual Day Start/mannual_Attendance_Screen.dart';
import '../Staff Attendance Options/QR Scanner/qr_Onboarding_Screen.dart';
import '../Staff Attendance Options/Selfie Punch Attendance/face_onboarding.dart';
import '../dashboard.dart';


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

      }
    } else {
      _handleAuthenticatedFlow();
    }
  }

  Future<void> _handleAuthenticatedFlow() async {
    if (!mounted) return;

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.fetchProfileData();
    final profileData = userProvider.profileData;

    if (!mounted) return;

    if (profileData != null && profileData.staffProfile != null) {
      final staffAttendanceMethod = profileData.staffProfile!.staffAttendanceMethod;

      if (staffAttendanceMethod == "0") {
        print('Navigating to Dashboard (Staff_attendance_method = 0)');
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else if (staffAttendanceMethod == "1") {
        final prefs = await SharedPreferences.getInstance();
        final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
        final isAttendanceMarkedForToday = prefs.getBool('attendanceMarked_$today') ?? false;
        final String staffAttendanceMethodStatus = userProvider.profileData?.staffProfile?.attendanceMethod ?? "selfi_attendance";

        if (isAttendanceMarkedForToday) {
          print('Navigating to Dashboard (Attendance already marked for today)');
          Navigator.pushReplacementNamed(context, '/dashboard');


        } else {


          print('Navigating to FaceOnboarding (Attendance not marked)');
          if(staffAttendanceMethodStatus=="day_attendance"){
            Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>mannualAttendanceScreen()));
          }else if(staffAttendanceMethodStatus=="qr_attendance"){
            Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>qrOnboardingScreen()));

          }else{
            Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>FaceOnboarding()));
          }

        }
      } else {
        print('Error: Invalid Staff_attendance_method: $staffAttendanceMethod');
        Fluttertoast.showToast(msg: 'Invalid attendance method. Please contact support.');
      }
    } else {
      print('Error: Failed to fetch profile data');
      Fluttertoast.showToast(msg: 'Failed to load profile. Please try again.');
      Navigator.pushReplacementNamed(context, '/login');
    }
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
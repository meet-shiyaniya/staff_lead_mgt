import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:hr_app/Week%20Off%20Or%20Holiday/time_Out_Screen.dart';
// import 'package:hr_app/Week%20Off%20Or%20Holiday/week_Off_Screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../Provider/UserProvider.dart';
import '../Staff Attendance Options/Mannual Day Start/mannual_Attendance_Screen.dart';
import '../Staff Attendance Options/QR Scanner/qr_Onboarding_Screen.dart';
import '../Staff Attendance Options/Selfie Punch Attendance/face_onboarding.dart';
import '../Week Off Or Holiday/inactive_Screen.dart';
import '../staff_HRM_module/Screen/Staff HR Screens/Attendannce/timeOutScreen.dart';
import '../staff_HRM_module/Screen/Staff HR Screens/Attendannce/weekOffScreen.dart';


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

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.fetchProfileData();
      if (!mounted) return;

      final profileData = userProvider.profileData?.staffProfile;

      // Handle missing profile data
      if (profileData == null) {
        _showErrorToast('Failed to load profile. Please try again.');
        _navigateToLogin();
        return;
      }

      // Check user status and redirect if inactive
      if (_isUserInactive(profileData)) {
        _navigateToScreen(inactiveScreen(), 'User is inactive');
        return;
      }

      // Validate active time window
      if (!_isWithinActiveTime(profileData)) {
        _navigateToScreen(timeOutScreen(), '⏰ Outside active time window');
        return;
      }

      // Check for special days (holiday, week-off, vacation)
      if (_isSpecialDay(profileData)) {
        _navigateToScreen(weekOffScreen(), '📅 Holiday, week-off, or vacation detected');
        return;
      }

      // Handle attendance flow based on staffAttendanceMethod
      await _processAttendanceFlow(profileData);

    } catch (e, stackTrace) {
      debugPrint('❌ Error in authenticated flow: $e\n$stackTrace');
      _showErrorToast('An unexpected error occurred. Please try again.');
      _navigateToLogin();
    }
  }

// Helper methods for improved readability and modularity
  bool _isUserInactive(dynamic profile) {
    return profile.status == "inactive";
  }

  bool _isWithinActiveTime(dynamic profile) {
    final now = DateTime.now();
    final activeFromTime = _parseTime(profile.activeFromTime);
    final activeToTime = _parseTime(profile.activeToTime);

    if (activeFromTime == null || activeToTime == null) {
      debugPrint('⚠️ Warning: activeFromTime or activeToTime is null');
      return true; // Default to allowing if time parsing fails
    }

    return now.isAfter(activeFromTime) && now.isBefore(activeToTime);
  }

  bool _isSpecialDay(dynamic profile) {
    return profile.holidayToday == 1 ||
        profile.weekoffToday == 1 ||
        profile.vacationToday == 1;
  }

  Future<void> _processAttendanceFlow(dynamic profile) async {
    final staffAttendanceMethod = profile.isAttendance;

    switch (staffAttendanceMethod) {
      case "1":
        _navigateToDashboard('✅ No attendance required');
        break;

      case "0":
        final isAttendanceMarked = await _isAttendanceMarked();
        if (isAttendanceMarked) {
          _navigateToDashboard('✅ Attendance already marked');
        } else {
          _navigateToAttendanceScreen(profile.attendanceMethod);
        }
        break;

      default:
        _showErrorToast('Invalid attendance method: $staffAttendanceMethod. Please contact support.');
    }
  }

  Future<bool> _isAttendanceMarked() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return prefs.getBool('attendanceMarked_$today') ?? false;
  }

  void _navigateToScreen(Widget screen, String logMessage) {
    print(logMessage);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => screen));
  }

  void _navigateToDashboard(String logMessage) {
    print(logMessage);
    Navigator.pushReplacementNamed(context, '/dashboard');
  }

  void _navigateToLogin() {
    print('❌ Redirecting to login');
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _navigateToAttendanceScreen(String? attendanceMethod) {
    final method = attendanceMethod ?? 'selfi_attendance';
    Widget nextScreen;

    switch (method) {
      case 'day_attendance':
        nextScreen = mannualAttendanceScreen();
        break;
      case 'qr_attendance':
        nextScreen = qrOnboardingScreen();
        break;
      default:
        nextScreen = FaceOnboarding();
    }

    debugPrint('📸 Navigating to Attendance Screen: $method');
    _navigateToScreen(nextScreen, 'Navigating to $method attendance');
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

  void _showErrorToast(String message) {
    print('❌ Error: $message');
    Fluttertoast.showToast(msg: message);
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
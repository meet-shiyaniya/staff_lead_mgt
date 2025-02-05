import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../social_module/colors/colors.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    // Add 4-second delay
    await Future.delayed(Duration(seconds: 4));

    final prefs = await SharedPreferences.getInstance();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final attendanceDate = prefs.getString('attendanceDate');

    if (attendanceDate == today) {
      // Attendance already marked today, go to dashboard
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      // No attendance marked today, go to login
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
            Lottie.asset(
              'asset/working_hours.json', // Add your Lottie animation
              width: 200,
              height: 200,
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}



// // Sample Login Screen (replace with your actual login screen)
// class LoginScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Login')),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             // After successful login, mark attendance
//             _markAttendanceAndNavigate(context);
//           },
//           child: Text('Login'),
//         ),
//       ),
//     );
//   }
//
//   void _markAttendanceAndNavigate(BuildContext context) async {
//     final prefs = await SharedPreferences.getInstance();
//     final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
//
//     await prefs.setString('attendanceDate', today);
//     Navigator.pushReplacementNamed(context, '/dashboard');
//   }
// }
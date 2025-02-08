import 'package:flutter/material.dart';
import 'package:hr_app/bottom_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();


    Future.delayed(const Duration(milliseconds: 80), () {
      setState(() {
        _isExpanded = true;
      });
    });
  }

  Future<void> _navigateToNextScreen() async {
    // Add 4-second delay
    await Future.delayed(Duration(seconds: 3));

    final prefs = await SharedPreferences.getInstance();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final attendanceDate = prefs.getString('attendanceDate');
    final isAttendance = prefs.getBool('attendanceMarked');

    // Check if attendance has been marked for today
    if (isAttendance == true) {
      // Attendance already marked today, go to dashboard
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavScreen()));
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
            Image.asset("asset/RealtoSmart Logo.png",height: 50,width: 150,),
            SizedBox(height:20),

          ],
        ),
      ),
    );
  }
}


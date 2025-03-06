import 'package:flutter/material.dart';
import 'package:hr_app/Provider/UserProvider.dart';
import 'package:hr_app/bottom_navigation.dart';
import 'package:hr_app/staff_HRM_module/Screen/Color/app_Color.dart';
import 'package:provider/provider.dart';

class mannualAttendanceScreen extends StatefulWidget {
  const mannualAttendanceScreen({super.key});

  @override
  State<mannualAttendanceScreen> createState() => _mannualAttendanceScreenState();
}

class _mannualAttendanceScreenState extends State<mannualAttendanceScreen> {
  bool _isLoading = false; // Track loading state

  Future<void> _markAttendance() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      // Await the attendance submission
      await userProvider.sendMannualAttendanceData();

      // Navigate to BottomNavScreen after successful submission
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavScreen()),
        );
      }
    } catch (e) {
      // Handle errors (e.g., network failure, API error)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to mark attendance: $e',
              style: const TextStyle(fontFamily: "poppins_thin"),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // Hide loading indicator
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: appColor.primaryColor,
        title: const Text(
          "Mark Attendance",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "poppins_thin",
            fontSize: 18,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),
            Container(
              height: 340,
              width: double.infinity,
              child: Image.asset(
                "asset/Attendance Animations/manAttendance.png",
                height: 350,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Begin Your Workday",
              style: TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontFamily: "poppins_thin",
              ),
            ),
            const SizedBox(height: 2),
            Text(
              "Tap the button to mark your attendance and start your day.",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 15,
                fontFamily: "poppins_thin",
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _isLoading ? null : _markAttendance, // Disable tap when loading
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.purple.shade700, Colors.deepPurple.shade700],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.indigo.shade100,
                            spreadRadius: 4,
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: _isLoading
                          ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Day",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "poppins_thin",
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            "Start",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "poppins_thin",
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      _isLoading ? "Marking Attendance..." : "Tap to Start Your Day",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 15,
                        fontFamily: "poppins_thin",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
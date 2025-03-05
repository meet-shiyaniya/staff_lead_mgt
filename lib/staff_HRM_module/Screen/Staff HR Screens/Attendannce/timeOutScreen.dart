import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
// import 'package:realtosmart/staff_HRM_module/Screen/Color/app_Color.dart';
import '../../../../../Provider/UserProvider.dart';
import '../../../../../bottom_navigation.dart';
// import '../../../../Screen/Color/app_Color.dart';
import '../../Color/app_Color.dart';

class timeOutScreen extends StatefulWidget {
  const timeOutScreen({super.key});

  @override
  State<timeOutScreen> createState() => _timeOutScreenState();
}

class _timeOutScreenState extends State<timeOutScreen> {

  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  bool _isRequestSent = false;
  var activeTimeFrom;
  var activeTimeTo;

  Future<void> _fetchTypeOfToday() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.fetchProfileData();

    if (!mounted) return;

    final profile = userProvider.profileData?.staffProfile;
    final bool isApproved = (profile?.accessRequestStatusToday ?? 0) == 1;
    setState(() {
      activeTimeFrom = profile?.activeFromTime;
      activeTimeTo = profile?.activeToTime;
    });

    if (mounted) {

      // If isApproved is true, navigate to BottomNavScreen
      if (isApproved) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNavScreen()),
        );
      }
    }
  }

  Future<void> _refreshData() async {
    await _fetchTypeOfToday();
  }

  Future<bool> _sendAppUseRequest () async {

    final url = Uri.parse("https://admin.dev.ajasys.com/api/sendAccessRequest");

    try {

      String? token = await _secureStorage.read(key: 'token');

      if (token == null) {

        return false;

      }

      final response = await http.post(

          url,
          headers: {

            'Content-Type': 'application/json'

          },
          body: jsonEncode({'token': token})

      );

      if (response.statusCode == 200) {

        Fluttertoast.showToast(msg: "Request sent successfully");
        return true;

      } else {

        Fluttertoast.showToast(msg: "Request not sent!");
        return false;

      }

    } catch (e) {

      Fluttertoast.showToast(msg: "Something Went Wrong!");
      return false;

    }

  }

  @override
  void initState() {
    super.initState();
    _fetchTypeOfToday();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: Colors.deepPurple.shade700,
        backgroundColor: appColor.subFavColor,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.12),

                // Top Image
                SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: Image.asset('asset/Attendance Animations/manAttendance.png'),
                ),
                const SizedBox(height: 20),

                // Message
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "Access denied: You can only use your account during your official working hours from ${activeTimeFrom} to ${activeTimeTo}.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontFamily: "poppins_thin", color: Colors.black),
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.12,
                  height: MediaQuery.of(context).size.width * 0.12,
                  child: Lottie.asset('asset/Attendance Animations/holidayanim.json', fit: BoxFit.contain, repeat: true),
                ),

                const SizedBox(height: 20),

                // Instruction
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "If You Want to Access Your Account, Click On button and Wait For the Approval.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, fontFamily: "poppins_thin", fontStyle: FontStyle.italic, color: Colors.grey.shade700),
                  ),
                ),
                const SizedBox(height: 20),

                // Request Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: _isRequestSent
                      ? Text(
                    "Your Request Has Been Sent Successfully",
                    style: TextStyle(fontSize: 14, fontFamily: "poppins_thin", color: Colors.green.shade700, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  )
                      : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _sendAppUseRequest();
                          _isRequestSent = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appColor.primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        "Send Request For Account Access",
                        style: TextStyle(fontSize: 15, fontFamily: "poppins_thin", color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40), // Bottom spacing
              ],
            ),
          ),
        ),
      ),
    );
  }
}
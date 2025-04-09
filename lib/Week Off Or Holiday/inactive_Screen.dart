import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hr_app/social_module/login_screen/login_screen.dart';
import 'package:hr_app/staff_HRM_module/Screen/Color/app_Color.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../Provider/UserProvider.dart';

class inactiveScreen extends StatefulWidget {
  const inactiveScreen({super.key});

  @override
  State<inactiveScreen> createState() => _inactiveScreenState();
}

class _inactiveScreenState extends State<inactiveScreen> {

  final _secureStorage = const FlutterSecureStorage();
  var Status;

  Future<void> _fetchTypeOfToday() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.fetchProfileData();

    if (!mounted) return;

    final profile = userProvider.profileData?.staffProfile;
    final bool isApproved = (profile?.status ?? "inactive") == "active";
    setState(() {

      Status = profile?.status;

    });

    if (mounted) {

      // If isApproved is true, navigate to BottomNavScreen
      if (isApproved) {
        await _secureStorage.delete(key: 'token');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
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
        onRefresh: _fetchTypeOfToday,
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
                  child: Image.asset('asset/holiday.png'),
                ),
                const SizedBox(height: 20),

                // Message
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "Inactive staff members are not permitted to use this application. Please contact your administrator to reactivate your account.",
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
                const SizedBox(height: 40), // Bottom spacing
              ],
            ),
          ),
        ),
      ),
    );
  }
}
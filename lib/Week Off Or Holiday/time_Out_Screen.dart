import 'package:flutter/material.dart';
import 'package:hr_app/Provider/UserProvider.dart';
import 'package:hr_app/bottom_navigation.dart';
import 'package:hr_app/staff_HRM_module/Screen/Color/app_Color.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class TimeOutScreen extends StatefulWidget {
  const TimeOutScreen({super.key});

  @override
  State<TimeOutScreen> createState() => _TimeOutScreenState();
}

class _TimeOutScreenState extends State<TimeOutScreen> {
  bool _isLoading = false; // Track loading state
  String? activeTimeFrom;
  String? activeTimeTo;

  Future<void> _fetchProfileData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() => _isLoading = true); // Show loading while fetching profile

    try {
      await userProvider.fetchProfileData();

      if (!mounted) return;

      final profile = userProvider.profileData?.staffProfile;
      final bool isApproved = (profile?.accessRequestStatusToday ?? 0) == 1;

      setState(() {
        activeTimeFrom = profile?.activeFromTime ?? "N/A";
        activeTimeTo = profile?.activeToTime ?? "N/A";
      });

      if (mounted && isApproved) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to load profile data: $e',
              style: const TextStyle(fontFamily: "poppins_thin"),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _refreshData() async {
    await _fetchProfileData();
  }

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
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
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.12),
                SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: Image.asset('asset/holiday.png'),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: _isLoading && activeTimeFrom == null
                      ? const Center(child: CircularProgressIndicator())
                      : Text(
                    "Access denied: You can only use your account during your official working hours from $activeTimeFrom to $activeTimeTo.",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: "poppins_thin",
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.12,
                  height: MediaQuery.of(context).size.width * 0.12,
                  child: Lottie.asset(
                    'asset/Attendance Animations/holidayanim.json',
                    fit: BoxFit.contain,
                    repeat: true,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "Pull down to refresh and check if access has been granted.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: "poppins_thin",
                      fontStyle: FontStyle.italic,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
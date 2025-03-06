import 'package:flutter/material.dart';
import 'package:hr_app/Provider/UserProvider.dart';
import 'package:hr_app/bottom_navigation.dart';
import 'package:hr_app/staff_HRM_module/Screen/Color/app_Color.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class WeekOffScreen extends StatefulWidget {
  const WeekOffScreen({super.key});

  @override
  State<WeekOffScreen> createState() => _WeekOffScreenState();
}

class _WeekOffScreenState extends State<WeekOffScreen> {
  bool _isRequestSent = false;
  bool _isLoading = false; // Track loading state for both profile fetch and request
  String title = "Loading...";

  Future<void> _fetchProfileData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() => _isLoading = true);

    try {
      await userProvider.fetchProfileData();

      if (!mounted) return;

      final profile = userProvider.profileData?.staffProfile;
      final bool isApproved = (profile?.accessRequestStatusToday ?? 0) == 1;
      final bool isHoliday = (profile?.holidayToday ?? 0) == 1;
      final bool isWeekOff = (profile?.weekoffToday ?? 0) == 1;
      final bool isVacation = (profile?.vacationToday ?? 0) == 1;

      String newTitle;
      if (isHoliday) {
        newTitle = "Today is a holiday! 🎉\nEnjoy your break and relax!";
      } else if (isWeekOff) {
        newTitle = "Today is your week off! 🎉\nEnjoy your well-deserved break.\nWork will wait! 😊";
      } else if (isVacation) {
        newTitle = "You're on vacation today! 🌴\nRelax, recharge, and enjoy your time off!";
      } else {
        newTitle = "Welcome to work! Have a productive day! 💼";
      }

      if (mounted) {
        setState(() {
          title = newTitle;
        });

        if (isApproved) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BottomNavScreen()),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          title = "Failed to load data. Pull to refresh.";
        });
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

  Future<void> _sendAccessRequest() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() => _isLoading = true);

    try {
      await userProvider.sendAppUseRequest();
      if (mounted) {
        setState(() {
          _isRequestSent = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Request sent successfully',
              style: TextStyle(fontFamily: "poppins_thin"),
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isRequestSent = false); // Reset on failure
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to send request: $e',
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
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 17,
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
                    _isRequestSent
                        ? "Your request has been sent. Please wait for approval."
                        : "If you need access today, send a request for approval.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: "poppins_thin",
                      fontStyle: FontStyle.italic,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: _isRequestSent
                      ? const Text(
                    "Your Request Has Been Sent Successfully",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: "poppins_thin",
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  )
                      : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _sendAccessRequest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appColor.primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : const Text(
                        "Send Request For Account Access",
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: "poppins_thin",
                          color: Colors.white,
                        ),
                      ),
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
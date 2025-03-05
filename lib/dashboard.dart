import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_app/staff_HRM_module/Model/Realtomodels/Realtostaffprofilemodel.dart';
// import 'package:hr_app/staff_HRM_module/Model/Realtomodels/Realtostaffprofilemodel.dart';
// import 'package:hr_app/staff_HRM_module/staff_HRM_module/Model/Realtomodels/Realtostaffprofilemodel.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
// import 'package:realtosmart/staff_HRM_module/Model/Realtomodels/Realtostaffprofilemodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';

import 'Inquiry_Management/Inquiry Management Screens/all_inquiries_Screen.dart';
import 'Inquiry_Management/Inquiry Management Screens/dismiss_request_Screen.dart';
import 'Inquiry_Management/Inquiry Management Screens/followup_and_cnr_Screen.dart';
import 'Provider/UserProvider.dart';
import 'dashboard_ui/dashboard2/dashboard2.dart';
import 'dashboard_ui/main_dashboard/mainDashboard.dart';
import 'dashboard_ui/personalDashboard_screen/MainDashboard_screen.dart';
import 'dashboard_ui/personalDashboard_screen/PersonalDashboard.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with WidgetsBindingObserver {
  double progressValue = 0.0;
  Timer? timer;
  int elapsedSeconds = 0;
  final int totalDuration = 9 * 60 * 60 + 30 * 60; // 9 hours 30 minutes
  bool isDayStarted = false;
  String entryTime = "";
  String exitTime = "";
  bool isDayEndedToday = false;
  String selectedFilter = 'Today'; // Default filter
  List<String> filterOptions = [
    'Today',
    'Last 7 Days',
    'Last 30 Days',
    'Current Month',
    'Previous Month'
  ];
  String cselectedFilter = 'Daily'; // Default filter
  List<String> cfilterOptions = ['Daily', 'Last Week', 'Last Month'];

  // Sample data for demonstration
  List<double> dailyData = [
    5,
    3,
    4,
    2,
    6,
    7,
    5
  ]; // Data for each day of the week
  List<double> lastWeekData = [20, 15, 25, 30, 10, 5, 15]; // Data for last week
  List<double> lastMonthData = [50, 40, 60, 70]; // Data for last few months

  // State for dashboard selection (default to Personal Dashboard)
  int _selectedDashboardIndex = 0; // 0: Main, 1: Personal, 2: Site, 3: Team
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<UserProvider>(context, listen: false).fetchProfileData();
    });
    WidgetsBinding.instance.addObserver(this);
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final lastEndDateStr = prefs.getString('lastEndDate');
    if (lastEndDateStr != null && lastEndDateStr == currentDate) {
      setState(() {
        isDayEndedToday = false;
        isDayStarted = false;
        exitTime = prefs.getString('exitTime') ?? "";
        entryTime = prefs.getString('entryTime') ?? "";
        elapsedSeconds = prefs.getInt('elapsedSeconds') ?? 0;
      });
      return;
    }

    final attendanceTimeStr = prefs.getString('attendanceTime');
    if (attendanceTimeStr != null && attendanceTimeStr.isNotEmpty) {
      final attendanceTime = DateFormat('hh:mm:ss a').parse(attendanceTimeStr);
      final now = DateTime.now();
      final attendanceDateTime = DateTime(now.year, now.month, now.day,
          attendanceTime.hour, attendanceTime.minute, attendanceTime.second);

      setState(() {
        isDayStarted = true;
        entryTime = DateFormat('hh:mm:ss a').format(attendanceDateTime);
        elapsedSeconds = now.difference(attendanceDateTime).inSeconds;
        progressValue = (elapsedSeconds / totalDuration).clamp(0.0, 1.0);
      });

      _resumeTimer();
    } else {
      setState(() {
        isDayStarted = prefs.getBool('isDayStarted') ?? false;
        elapsedSeconds = prefs.getInt('elapsedSeconds') ?? 0;
        entryTime = prefs.getString('entryTime') ?? "";
        exitTime = prefs.getString('exitTime') ?? "";

        if (isDayStarted) {
          _resumeTimer();
          _syncElapsedTime();
        }
      });
    }
  }

  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDayStarted', isDayStarted);
    await prefs.setInt('elapsedSeconds', elapsedSeconds);
    await prefs.setString('entryTime', entryTime);
    await prefs.setString('exitTime', exitTime);
    await prefs.setString('lastRecordedTime', DateTime.now().toIso8601String());
  }

  void startDay() {
    final now = DateTime.now();
    final attendanceTimeStr = DateFormat('hh:mm:ss a').format(now);

    setState(() {
      progressValue = 0.0;
      elapsedSeconds = 0;
      isDayStarted = true;
      isDayEndedToday = false;
      entryTime = attendanceTimeStr;
      exitTime = "";
    });

    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('lastEndDate');
      prefs.setString('attendanceTime', attendanceTimeStr);
    });

    _saveState();
    _resumeTimer();
  }

  void _resumeTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        elapsedSeconds++;
        progressValue = elapsedSeconds / totalDuration;
        if (progressValue >= 1) {
          timer.cancel();
          progressValue = 1.0;
        }
      });
      _saveState();
    });
  }

  void endDay() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();

    setState(() {
      timer?.cancel();
      progressValue = elapsedSeconds / totalDuration;
      exitTime = DateFormat('hh:mm:ss a').format(now);
      isDayStarted = false;
      isDayEndedToday = true;
    });

    await prefs.setString('lastEndDate', DateFormat('yyyy-MM-dd').format(now));
    await prefs.setString('exitTime', exitTime);
    await prefs.setString('entryTime', entryTime);
    await prefs.setInt('elapsedSeconds', elapsedSeconds);
    await _saveState();
  }

  String getElapsedTime() {
    final hours = (elapsedSeconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((elapsedSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (elapsedSeconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  Future<void> _syncElapsedTime() async {
    final prefs = await SharedPreferences.getInstance();
    final lastRecordedTimeStr = prefs.getString('lastRecordedTime');
    final attendanceTimeStr = prefs.getString('attendanceTime');

    if (lastRecordedTimeStr != null && attendanceTimeStr != null) {
      final lastRecordedTime = DateTime.parse(lastRecordedTimeStr);
      final currentTime = DateTime.now();
      final elapsedSinceLastRecord =
          currentTime.difference(lastRecordedTime).inSeconds;

      setState(() {
        elapsedSeconds += elapsedSinceLastRecord;
        if (elapsedSeconds >= totalDuration) {
          elapsedSeconds = totalDuration;
          timer?.cancel();
        }
      });

      _saveState();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _saveState();
    } else if (state == AppLifecycleState.resumed) {
      _syncElapsedTime();
      _checkAttendanceMarked();
    }
  }

  Future<void> _checkAttendanceMarked() async {
    final prefs = await SharedPreferences.getInstance();
    bool attendanceMarked = prefs.getBool('attendanceMarked') ?? false;

    if (attendanceMarked) {
      await prefs.setBool('attendanceMarked', false);
    }
  }

  DateTime _selectedDate = DateTime.now();

  List<DateTime> _dates = [
    DateTime.now().add(Duration(days: -3)),
    DateTime.now().add(Duration(days: -2)),
    DateTime.now().add(Duration(days: -1)),
    DateTime.now(),
    DateTime.now().add(Duration(days: 1)),
    DateTime.now().add(Duration(days: 2)),
    DateTime.now().add(Duration(days: 3)),
  ];

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Widget _getDashboardBody() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final Dashboardpermission = userProvider.dashboardpermissionModel;

    // Extract permissions (default to false if null)
    final mainDboardPermission = Dashboardpermission?.mainDboard ?? false;
    final siteDashboardPermission = Dashboardpermission?.siteDashboard ?? false;
    final teamDashboardPermission = Dashboardpermission?.teamDashboard ?? false;

    switch (_selectedDashboardIndex) {
      case 0: // Main Dashboard
        return mainDboardPermission ? MainDashboardScreen() : PersonalDashboardScreen();
      case 1: // Personal Dashboard (always available)
        return PersonalDashboardScreen();
      case 2: // Site Dashboard
        return siteDashboardPermission ? StaffDashboard() : PersonalDashboardScreen();
      case 3: // Team Dashboard
        return teamDashboardPermission ? DashboardScreen() : PersonalDashboardScreen();
      default:
        return PersonalDashboardScreen(); // Default to Personal
    }
  }
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    Realtostaffprofilemodel? profile = userProvider.profileData;
    final profileImage = profile?.staffProfile?.profileImg;
    final Dashboardpermission = userProvider.dashboardpermissionModel;

    if (profile == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    // Extract permissions (default to false if null, except Personal which is always available)
    final mainDboardPermission = Dashboardpermission?.mainDboard ?? false;
    final siteDashboardPermission = Dashboardpermission?.siteDashboard ?? false;
    final teamDashboardPermission = Dashboardpermission?.teamDashboard ?? false;

    // Set default dashboard: Main if permitted, otherwise Personal
    if (_selectedDashboardIndex == null) {
      _selectedDashboardIndex = mainDboardPermission ? 0 : 1;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 100,
        surfaceTintColor: Colors.white,
        flexibleSpace: Container(
          height: 70,
          width: double.infinity,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                offset: const Offset(1, 2),
                color: Colors.grey.shade200,
                blurRadius: 1,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDashboardIndex = 1; // Always return to Personal Dashboard
                  });
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0.5, 0.5),
                        color: Colors.grey.shade400,
                        blurRadius: 2,
                        spreadRadius: 1,
                      ),
                    ],
                    border: Border.all(
                      color: Colors.white,
                      width: 1.0,
                    ),
                  ),
                  child: ClipOval(
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(
                      "$profileImage",
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(Icons.error, size: 50),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Hello, ${profile.staffProfile?.name.toString() ?? 'User'}",
                    style: TextStyle(
                      fontFamily: "poppins_thin",
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "Today " + DateFormat('yyyy-MM-dd').format(DateTime.now()),
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: "poppins_thin",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(),
                ),
                child: PopupMenuButton<int>(
                  icon: const Icon(Icons.menu, color: Colors.black87),
                  onSelected: (int index) {
                    setState(() {
                      _selectedDashboardIndex = index;
                    });
                  },
                  itemBuilder: (BuildContext context) {
                    List<PopupMenuEntry<int>> menuItems = [];
                    if (mainDboardPermission) {
                      menuItems.add(_buildPopupMenuItem(0, 'Main', Icons.dashboard));
                    }
                    // Personal is always available, no condition
                    menuItems.add(_buildPopupMenuItem(1, 'Personal', Icons.person));
                    if (siteDashboardPermission) {
                      menuItems.add(_buildPopupMenuItem(2, 'Site', Icons.location_city));
                    }
                    if (teamDashboardPermission) {
                      menuItems.add(_buildPopupMenuItem(3, 'Team', Icons.group));
                    }
                    return menuItems;
                  },
                  color: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade200, width: 1),
                  ),
                  offset: const Offset(0, 50),
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: _getDashboardBody(),
    );
  }

  PopupMenuItem<int> _buildPopupMenuItem(int value, String text, IconData icon) {
    return PopupMenuItem<int>(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple[900], size: 20),
          SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              fontFamily: "poppins_thin",
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  //
  // Widget _buildDateSelection() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: _dates.map((date) {
  //       bool isSelected = _selectedDate.day == date.day;
  //       return GestureDetector(
  //         onTap: () => _onDateSelected(date),
  //         child: Container(
  //           height: isSelected
  //               ? MediaQuery.of(context).size.height / 12
  //               : MediaQuery.of(context).size.height / 14,
  //           width: isSelected
  //               ? MediaQuery.of(context).size.width / 8.5
  //               : MediaQuery.of(context).size.width / 9.5,
  //           margin: EdgeInsets.only(left: 5, bottom: 5, right: 5),
  //           padding: EdgeInsets.all(3),
  //           decoration: BoxDecoration(
  //             color:
  //             isSelected ? Colors.deepPurple.shade300 : Colors.transparent,
  //             borderRadius: BorderRadius.circular(15),
  //             border: Border.all(
  //               color: isSelected ? Colors.deepPurple.shade300 : Colors.grey,
  //               width: 1,
  //             ),
  //           ),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Text(
  //                 '${date.day}',
  //                 style: TextStyle(
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.bold,
  //                   color: isSelected ? Colors.white : Colors.black,
  //                 ),
  //               ),
  //               Text(
  //                 _getDayName(date.weekday),
  //                 style: TextStyle(
  //                   fontSize: 12,
  //                   color: isSelected ? Colors.white : Colors.grey,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     }).toList(),
  //   );
  // }
  //
  // Widget _buildDirectDataView() {
  //   switch (selectedFilter) {
  //     case 'Last 7 Days':
  //       return Text('Data for Last 7 Days',
  //           style: TextStyle(fontFamily: "poppins_thin"));
  //     case 'Last 30 Days':
  //       return Text('Data for Last 30 Days',
  //           style: TextStyle(fontFamily: "poppins_thin"));
  //     case 'Current Month':
  //       return Text('Data for Current Month',
  //           style: TextStyle(fontFamily: "poppins_thin"));
  //     case 'Previous Month':
  //       return Text('Data for Previous Month',
  //           style: TextStyle(fontFamily: "poppins_thin"));
  //     default:
  //       return Text('Select a filter',
  //           style: TextStyle(fontFamily: "poppins_thin"));
  //   }
  // }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  // List<BarChartGroupData> _getBarGroups() {
  //   List<double> data = [];
  //   switch (cselectedFilter) {
  //     case 'Daily':
  //       data = dailyData;
  //       break;
  //     case 'Last Week':
  //       data = lastWeekData;
  //       break;
  //     case 'Last Month':
  //       data = lastMonthData;
  //       break;
  //     default:
  //       data = [];
  //   }
  //
  //   DateTime now = DateTime.now();
  //   int currentDayIndex = now.weekday - 1; // Monday = 0, Sunday = 6
  //   int currentMonthIndex = now.month - 1; // January = 0, December = 11
  //
  //   return data.asMap().entries.map((entry) {
  //     int index = entry.key;
  //     double value = entry.value;
  //     bool isHighlighted = false;
  //     switch (cselectedFilter) {
  //       case 'Daily':
  //       case 'Last Week':
  //         isHighlighted = index == currentDayIndex;
  //         break;
  //       case 'Last Month':
  //         isHighlighted = index == currentMonthIndex;
  //         break;
  //     }
  //
  //     return BarChartGroupData(
  //       x: index,
  //       barRods: [
  //         BarChartRodData(
  //           toY: value,
  //           color:
  //           isHighlighted ? Colors.deepPurple : Colors.deepPurple.shade300,
  //           width: 20,
  //         ),
  //       ],
  //     );
  //   }).toList();
  // }

  final List leads = [
    {
      "name": "Total\nLeads",
      "icon": Icons.leaderboard_outlined,
      "mainBg": Colors.green.shade50,
      "bgColor": LinearGradient(
        colors: [Colors.green, Colors.green, Colors.white70],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      "leadCount": "1058",
      "detail": "+21% from previous month"
    },
    {
      "name": "Deal\nClosed",
      "icon": Icons.done,
      "mainBg": Colors.red.shade50,
      "bgColor": LinearGradient(
        colors: [Colors.red, Colors.red, Colors.white70],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      "leadCount": "745",
      "detail": "+12% from previous month"
    },
    {
      "name": "Today's\nMeetings",
      "icon": Icons.schedule,
      "mainBg": Colors.blue.shade50,
      "bgColor": LinearGradient(
        colors: [Colors.blue, Colors.blue, Colors.white70],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      "leadCount": "2",
      "detail": "We've scheduled 2 Meetings"
    },
    {
      "name": "Today's\nTask",
      "icon": Icons.task_alt,
      "mainBg": Colors.orange.shade50,
      "bgColor": LinearGradient(
        colors: [Colors.orange, Colors.orange, Colors.white70],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      "leadCount": "12",
      "detail": "There are pending Tasks"
    }
  ];
}

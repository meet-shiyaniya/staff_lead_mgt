import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_app/Inquiry_Management/Inquiry%20Management%20Screens/all_inquiries_Screen.dart';
import 'package:hr_app/Inquiry_Management/Inquiry%20Management%20Screens/followup_and_cnr_Screen.dart';
import 'package:hr_app/social_module/colors/colors.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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

  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  static const String baseUrl = 'https://admin.dev.ajasys.com/api';

  Future<bool> _sendUpdatedAttendanceData () async {

    String editBioStatus = "1";
    String createdAtDateTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()).toString();
    String exitDateTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()).toString();

    final url = Uri.parse('$baseUrl/insert_attendance_newday');

    try {

      String? token = await _secureStorage.read(key: 'token');

      if (token == null) {

        return false;

      }

      Map<String, String> bodyData = {

        "token": token,
        "edit_bio": editBioStatus,
        "created_at": createdAtDateTime,
        "exit_date_time": exitDateTime,

      };

      final response = await http.post(

          url,
          headers: {

            'Content-Type': 'application/json'

          },
          body: jsonEncode(bodyData)

      );

      if (response.statusCode == 200) {

        final data = jsonDecode(response.body);
        Fluttertoast.showToast(msg: "✅ Attendance marked: Updated");
        // Fluttertoast.showToast(msg: data);
        return true;

      } else {

        Fluttertoast.showToast(msg: "Failed to send attendance data!");
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
    WidgetsBinding.instance.addObserver(this);
    _loadState();
  }

  // Update _loadState method
  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Check if day was ended today
    final lastEndDateStr = prefs.getString('lastEndDate');
    if (lastEndDateStr != null && lastEndDateStr == currentDate) {
      setState(() {
        isDayEndedToday = false;
        isDayStarted = false;
        // Load previous day's data
        exitTime = prefs.getString('exitTime') ?? "";
        entryTime = prefs.getString('entryTime') ?? "";
        elapsedSeconds = prefs.getInt('elapsedSeconds') ?? 0;
      });
      return;
    }

    // Load attendance time if exists for current day
    // In _loadState() method
    final attendanceTimeStr = prefs.getString('attendanceTime');
    if (attendanceTimeStr != null && attendanceTimeStr.isNotEmpty) {
      final attendanceTime = DateFormat('hh:mm:ss a').parse(attendanceTimeStr);
      final now = DateTime.now();
      final attendanceDateTime = DateTime(
          now.year, now.month, now.day,
          attendanceTime.hour, attendanceTime.minute, attendanceTime.second
      );

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

    // Clear previous day's data
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

    // Save all relevant data
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
      final elapsedSinceLastRecord = currentTime.difference(lastRecordedTime).inSeconds;

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
      _saveState(); // Save state when the app goes to the background
    } else if (state == AppLifecycleState.resumed) {
      _syncElapsedTime(); // Sync time when the app resumes
      // Automatically start the day if it was previously ended
      _checkAttendanceMarked();
    }
  }


  // Update _checkAttendanceMarked()
  Future<void> _checkAttendanceMarked() async {
    final prefs = await SharedPreferences.getInstance();
    bool attendanceMarked = prefs.getBool('attendanceMarked') ?? false;

    if (attendanceMarked) {
      await prefs.setBool('attendanceMarked', false); // Just reset the flag
    }
  }
  // Future<void> _checkAttendanceMarked() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   bool attendanceMarked = prefs.getBool('attendanceMarked') ?? false;
  //
  //   if (attendanceMarked) {
  //     startDay(); // Start the day if attendance was marked
  //     entryTime = prefs.getString('entryTime') ?? ""; // Set entry time
  //     await prefs.setBool('attendanceMarked', false); // Reset the flag
  //   }
  // }

  @override
  void dispose() {
    timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0.5, 0.5),
                      color: Colors.grey.shade400,
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
                    "https://i.pinimg.com/736x/85/25/83/852583511c3109d7a4efa0c3a233be1e.jpg",
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Hello, Maulik Patel",
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
                      fontFamily: AppColors.font,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Icon(Icons.search),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 5.1,
              width: double.infinity,
              margin: const EdgeInsets.only(left: 15, right: 15),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: isDayEndedToday ? startDay : (isDayStarted ? _sendUpdatedAttendanceData : startDay),
                          child: Container(
                            height: 30,
                            width: 120,
                            margin: const EdgeInsets.only(left: 30, top: 20),
                            decoration: BoxDecoration(
                              color: isDayEndedToday ? Colors.white70: Colors.white70,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                isDayStarted ? "Day End" : "Day Start",
                                style: TextStyle(
                                  fontFamily: "poppins_thin",
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isDayEndedToday ? Colors.black45 : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // GestureDetector(
                        //   onTap: isDayStarted ? endDay : startDay, // Toggle between start and end
                        //   child: Container(
                        //     height: 30,
                        //     width: 120,
                        //     margin: const EdgeInsets.only(left: 30, top: 20),
                        //     decoration: BoxDecoration(
                        //       color: Colors.white54,
                        //       borderRadius: BorderRadius.circular(20),
                        //     ),
                        //     child: Center(
                        //       child: Text(
                        //         isDayStarted ? "Day End" : "Day Start",
                        //         style: TextStyle(
                        //             fontFamily: "poppins_thin",
                        //             fontSize: 12,
                        //             fontWeight: FontWeight.bold),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(left: 25, top: 5),
                          child: Text(
                            isDayStarted
                                ? "Unify your social world—connect, manage, and grow your Company effortlessly. All the Best"
                                : "Start your day with purpose and positivity. Let's make it productive and fulfilling!",
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: AppColors.font,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // if (isDayStarted)
                          Container(
                            margin: EdgeInsets.only(top: 10, left: 30),
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                height: 25,
                                width: 150,
                                decoration: BoxDecoration(
                                  color: Colors.white54,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    "Working Time: ${getElapsedTime()}",
                                    style: TextStyle(
                                        fontFamily: "poppins_thin",
                                        fontSize: 10,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: CircularPercentIndicator(
                      radius: 45,
                      lineWidth: 14,
                      backgroundWidth: 8,
                      percent: progressValue,
                      animation: true,
                      animateFromLastPercent: true,
                      center: Lottie.asset(
                        'asset/working_hours.json',
                        fit: BoxFit.contain,
                        width: 50,
                        height: 50,
                      ),
                      progressColor: AppColors.primaryColor,
                      backgroundColor: Colors.grey.shade200,
                      circularStrokeCap: CircularStrokeCap.round,
                    ),
                  ),
                ],
              ),
            ),
            if (isDayStarted)
              Container(
                height: MediaQuery.of(context).size.height / 10,
                width: double.infinity,
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 5,
                      offset: const Offset(1, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(),
                    Image.asset("asset/intime.png", height: 30, width: 30),
                    Column(
                      children: [
                        const Text(
                          "In Time :",
                          style: TextStyle(
                            fontFamily: "poppins_thin",
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        Text(entryTime.isNotEmpty ? entryTime : "--:--:--",style: TextStyle(
                          fontFamily: "poppins_thin",
                          fontWeight: FontWeight.bold,

                        ),),
                      ],
                    ),
                    const VerticalDivider(
                      color: Colors.grey,
                      thickness: 0.5,
                      width: 18,
                    ),
                    SizedBox(),
                    Image.asset("asset/workingHour.png", height: 30, width: 30),
                    Column(
                      children: [
                        const Text(
                          "Working Hour:",
                          style: TextStyle(
                            fontFamily: "poppins_thin",
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        Text(getElapsedTime(), style: const TextStyle(fontFamily: "poppins_thin")),
                      ],
                    ),
                  ],
                ),
              ),
            if (exitTime.isNotEmpty)
              Container(
                height: MediaQuery.of(context).size.height / 10,
                width: double.infinity,
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 5,
                      offset: const Offset(1, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Image.asset("asset/intime.png", height: 20, width: 20),
                            SizedBox(width: 3),
                            Text("In Time :", style: TextStyle(fontFamily: "poppins_thin", fontWeight: FontWeight.bold, color: Colors.green)),
                          ],
                        ),
                        Text("$entryTime", style: TextStyle(fontFamily: "poppins_thin",fontSize:15,fontWeight: FontWeight.bold,)),
                      ],
                    ),
                    VerticalDivider(
                      color: Colors.grey,
                      thickness: 0.5,
                      width: 18,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Image.asset("asset/out time.png", height: 20, width: 20),
                            SizedBox(width: 3),
                            Text("Out Time :", style: TextStyle(fontFamily: "poppins_thin", fontWeight: FontWeight.bold, color: Colors.red)),
                          ],
                        ),
                        Text("$exitTime", style: TextStyle(fontFamily: "poppins_thin",fontSize:15,fontWeight: FontWeight.bold,)),
                      ],
                    ),
                    SizedBox(),
                    VerticalDivider(
                      color: Colors.grey,
                      thickness: 0.5,
                      width: 18,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Image.asset("asset/workingHour.png", height: 20, width: 20),
                            SizedBox(width: 3),
                            Text("Work Hour:", style: TextStyle(fontFamily: "poppins_thin", fontWeight: FontWeight.bold, color: Colors.blue,)),
                          ],
                        ),
                        Text("${getElapsedTime()}",style: TextStyle(fontFamily: "poppins_thin",fontSize:15,fontWeight: FontWeight.bold,)),
                      ],
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Daily Activities", style: TextStyle(fontFamily: "poppins_thin")),
                  Image.asset("asset/peopleDashboard.png", height: 50, width: 100),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 2,
              child: GridView.builder(
                itemCount: leads.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.05,
                  mainAxisSpacing: 10,
                ),
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      index == 0
                          ? Navigator.push(context, MaterialPageRoute(builder: (context) => AllInquiriesScreen()))
                          : index == 1
                          ? Navigator.push(context, MaterialPageRoute(builder: (context) => AllInquiriesScreen()))
                          : index == 2
                          ? Navigator.push(context, MaterialPageRoute(builder: (context) => FollowupAndCnrScreen()))
                          : Navigator.push(context, MaterialPageRoute(builder: (context) => FollowupAndCnrScreen()));
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.deepPurple.shade50,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            offset: Offset(1, 3),
                            blurRadius: 1,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  leads[index]["name"],
                                  style: TextStyle(fontFamily: "poppins_thin", fontSize: 16),
                                ),
                                Container(
                                  height: 60,
                                  width: MediaQuery.of(context).size.width/10,
                                  // margin: EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: leads[index]['bgColor'],
                                  ),
                                  child: Icon(leads[index]["icon"], color: Colors.white, weight: 35),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(leads[index]["leadCount"], style: TextStyle(fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 23)),
                                Text(leads[index]["detail"], style: TextStyle(fontFamily: "poppins", fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  final List leads = [
    {
      "name": "Total\nLeads",
      "icon": Icons.leaderboard_outlined,
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
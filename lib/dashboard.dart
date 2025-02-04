import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hr_app/social_module/colors/colors.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:animate_do/animate_do.dart'; // For animation effects
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with WidgetsBindingObserver{
  double progressValue = 0.0;
  Timer? timer;
  int elapsedSeconds = 0;
  final int totalDuration = 8 * 60 * 60; // 8 hours in seconds
  bool isDayStarted = false;
  String entryTime = "";
  String exitTime = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDayStarted = prefs.getBool('isDayStarted') ?? false;
      elapsedSeconds = prefs.getInt('elapsedSeconds') ?? 0;
      entryTime = prefs.getString('entryTime') ?? "";
      exitTime = prefs.getString('exitTime') ?? "";

      if (isDayStarted) {
        _resumeTimer();
        _syncElapsedTime(); // Sync elapsed time on resume
      }
    });
  }

  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDayStarted', isDayStarted);
    prefs.setInt('elapsedSeconds', elapsedSeconds);
    prefs.setString('entryTime', entryTime);
    prefs.setString('exitTime', exitTime);
    prefs.setString('lastRecordedTime', DateTime.now().toIso8601String());
  }

  void startDay() {
    setState(() {
      progressValue = 0.0;
      elapsedSeconds = 0;
      isDayStarted = true;
      entryTime = DateFormat('hh:mm:ss a').format(DateTime.now());
      exitTime = "";
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

  void endDay() {
    setState(() {
      timer?.cancel();
      progressValue = elapsedSeconds / totalDuration;
      exitTime = DateFormat('hh:mm:ss a').format(DateTime.now());
      isDayStarted = false;
    });

    _saveState();
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
    if (lastRecordedTimeStr != null) {
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
      _saveState(); // Save state when the app goes to the background
    } else if (state == AppLifecycleState.resumed) {
      _syncElapsedTime(); // Sync time when the app resumes
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  String getGreetingMessage() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return "Good\nMorning";
    } else if (hour < 18) {
      return "Good\nAfternoon";
    } else {
      return "Good\nEvening";
    }
  }


  final List leads = [
    {
      "name":"Total\nLeads",
      "icon": Icons.leaderboard_outlined,
      "bgColor":  LinearGradient(
        colors: [Colors.green,Colors.green, Colors.white70],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      "leadCount": "1058",
      "detail": "+21% from previous month"
    },
    {
      "name":"Deal\nClosed",
      "icon": Icons.done,
      "bgColor":  LinearGradient(
        colors: [Colors.red,Colors.red, Colors.white70],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      "leadCount": "745",
      "detail": "+12% from previous month"
    },
    {
      "name":"Today's\nMeetings",
      "icon": Icons.schedule,
      "bgColor":  LinearGradient(
        colors: [Colors.blue, Colors.blue,Colors.white70],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      "leadCount": "2",
      "detail": "We have schedule 2 Meetings"
    },
    {
      "name":"Today's\nTask",
      "icon": Icons.task_alt,
      "bgColor":  LinearGradient(
        colors: [Colors.orange,Colors.orange, Colors.white70],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      "leadCount": "12",
      "detail": "There are pending Task"
    }
  ];




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
                    "Hello, Meetashri Patel",
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 155,
                width: double.infinity,
                margin: const EdgeInsets.only(left: 15,right: 15,top: 15),
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
                            onTap: isDayStarted ? endDay : startDay,
                            child: Container(
                              height: 30,
                              width: 120,
                              margin: const EdgeInsets.only(left: 30, top: 20),
                              decoration: BoxDecoration(
                                color: Colors.white54,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  isDayStarted ? "Day End" : "Day Start",
                                  style: TextStyle(
                                      fontFamily: "poppins_thin",
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
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
          
                          if (isDayStarted)
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
                      child: ZoomIn(
                        child: CircularPercentIndicator(
                          radius: 45,
                          lineWidth: 15,
                          backgroundWidth: 8,
                          percent: progressValue,
                          animation: true,
                          animateFromLastPercent: true,
                          // center: Text(
                          //   getGreetingMessage(), // Call function for dynamic greetings
                          //   style:  TextStyle(
                          //     fontSize: 10,
                          //     // fontWeight: FontWeight.bold,
                          //     color: Colors.white,
                          //     fontFamily: "poppins_thin"
                          //   ),
                          //   textAlign: TextAlign.center,
                          // ),
                          center:Lottie.asset('asset/Inquiry_module/no_result.json', fit: BoxFit.contain, width: 50, height: 50),
                          progressColor: AppColors.primaryColor,
                          backgroundColor: Colors.grey.shade200,
                          circularStrokeCap: CircularStrokeCap.round,
                        ),
                      )
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(),
                      Image.asset("asset/intime.png",height: 30,width: 30,),
                      Column(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "In Time :",
                            style: TextStyle(
                              fontFamily: "poppins_thin",
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          Text(entryTime.isNotEmpty ? entryTime : "--:--:--"),
                        ],
                      ),
                      const VerticalDivider(
                        color: Colors.grey,
                        thickness: 0.5,
                        width: 18,
                      ),
                      SizedBox(),
                      Image.asset("asset/workingHour.png",height: 30,width: 30,),
                      Column(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
          
                          const Text(
                            "Working Hour :",
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
                  height: MediaQuery.of(context).size.height/10,
                  width: double.infinity,
                  margin: const EdgeInsets.all(15),
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(),
          
          
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Image.asset("asset/intime.png",height: 20,width: 20,),
                              SizedBox(width:3),
                              Text("In Time :",style: TextStyle(fontFamily: "poppins_thin",fontWeight: FontWeight.bold,color: Colors.green),),
                            ],
                          ),
          
                          Text("$entryTime",style: TextStyle(fontFamily:"poppins_thin"))
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
                              Image.asset("asset/out time.png",height: 20,width: 20,),
                              SizedBox(width:3),
                              Text("Out Time :",style: TextStyle(fontFamily: "poppins_thin",fontWeight: FontWeight.bold,color: Colors.red),),
                            ],
                          ),
          
                          Text("$exitTime",style: TextStyle(fontFamily:"poppins_thin"),)
                        ],
                      ),
                      SizedBox(),
          
                      // Image.asset("asset/workingHour.png",height: 30,width: 30,),
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
                              Image.asset("asset/workingHour.png",height: 20,width: 20,),
                              SizedBox(width:3),
                              Text("Work Hour:",style: TextStyle(fontFamily: "poppins_thin",fontWeight: FontWeight.bold,color: Colors.blue),),
                            ],
                          ),
          
                          Text("${getElapsedTime()}")
                        ],
                      ),
          
                    ],
                  ),
                  // child: Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Text(
                  //       "Entry Time: $entryTime",
                  //       style: const TextStyle(
                  //         fontSize: 14,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     ),
                  //     const SizedBox(height: 5),
                  //     Text(
                  //       "Exit Time: $exitTime",
                  //       style: const TextStyle(
                  //         fontSize: 14,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ),
              Padding(
                padding: const EdgeInsets.only(left: 20,right: 20,bottom: 5),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[
                      Text("Daily Activities",style: TextStyle(fontFamily: "poppins_thin"),),
                      Image.asset("asset/peopleDashboard.png",height: 50,width: 100,),
                    ]
                ),
              ),
          
          
              Container(
                height: 450,
                child: GridView.builder(

                    itemCount: leads.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 1.10,mainAxisSpacing: 10),
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index){

                  return Container(
                    margin: EdgeInsets.only(left: 10,right: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.deepPurple.shade50,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade300,
                              offset: Offset(1,3),
                              blurRadius: 1,
                              spreadRadius: 1
                          )
                        ]
                    ),
                    child: Column(

                      crossAxisAlignment:CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                leads[index]["name"],
                                style: TextStyle(fontFamily: "poppins_thin",fontSize: 16),
                              ),
                              Container(
                                  height: 60,
                                  width: 40,
                                  margin: EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    // shape: BoxShape.circle,
                                    gradient: leads[index]['bgColor'],
                                    // color:Colors.deepOrangeAccent.shade400
                                  ),
                                  child: Icon(leads[index]["icon"],color: Colors.white,weight: 35,)
                              ),



                            ],
                          ),
                        ),
                        Padding(
                          padding:  EdgeInsets.only(left: 10,right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(leads[index]["leadCount"],style: TextStyle(fontFamily: "poppins_thin",fontWeight: FontWeight.bold,fontSize: 23),),
                              Text(leads[index]["detail"],style: TextStyle(fontFamily: "poppins",fontWeight: FontWeight.bold,),)
                            ],
                          ),
                        )
                      ],
                    ),

                  );
                }),
              )
          
            ],
          ),
        ),
      ),
    );
  }
}
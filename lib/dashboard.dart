import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hr_app/social_module/colors/colors.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:animate_do/animate_do.dart'; // For animation effects

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  double progressValue = 0.0;
  Timer? timer;
  int elapsedSeconds = 0;
  final int totalDuration = 8 * 60 * 60; // 8 hours in seconds
  bool isDayStarted = false;
  String entryTime = "";
  String exitTime = "";

  void startDay() {
    setState(() {
      progressValue = 0.0;
      elapsedSeconds = 0;
      isDayStarted = true;
      entryTime = DateFormat('hh:mm:ss').format(DateTime.now());
      exitTime = ""; // Reset exit time
    });

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
    });
  }

  void endDay() {
    setState(() {
      timer?.cancel();
      progressValue = elapsedSeconds / totalDuration;
      exitTime = DateFormat('hh:mm:ss a').format(DateTime.now());
      isDayStarted = false;
    });
  }

  String getElapsedTime() {
    final hours = (elapsedSeconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((elapsedSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (elapsedSeconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 100,
        flexibleSpace: SafeArea(
          child: Container(
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
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            height: 155,
            width: double.infinity,
            margin: const EdgeInsets.only(left: 15,right: 15,top: 15),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.3),
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
                          height: 25,
                          width: 120,
                          margin: const EdgeInsets.only(left: 30, top: 25),
                          decoration: BoxDecoration(
                            color: Colors.white54,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              isDayStarted ? "Day End" : "Day Start",
                              style: TextStyle(
                                  fontFamily: "poppins_thin",
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(left: 25, top: 5),
                        child: Text(
                          "Unify your social world—connect, manage, and grow all your accounts effortlessly. Simplify your workflow, amplify your reach.",
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontFamily: AppColors.font,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
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
                      lineWidth: 8,
                      percent: progressValue,
                      animation: true,
                      animateFromLastPercent: true,
                      center: Text(
                        "${(progressValue * 100).toStringAsFixed(1)}%",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      progressColor: AppColors.primaryColor,
                      backgroundColor: Colors.grey.shade200,
                      circularStrokeCap: CircularStrokeCap.round,
                    ),
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
            padding: const EdgeInsets.only(left: 20,right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
                Text("Daily Activities",style: TextStyle(fontFamily: "poppins_thin"),),
                Image.asset("asset/peopleDashboard.png",height: 50,width: 50,)
              ]
            ),
          )
        ],
      ),
    );
  }
}

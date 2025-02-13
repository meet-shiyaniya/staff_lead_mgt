import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:intl/intl.dart';

import '../../Color/app_Color.dart';

class attendanceScreen extends StatefulWidget {
  @override
  _attendanceScreenState createState() => _attendanceScreenState();
}

class _attendanceScreenState extends State<attendanceScreen> {

  String selectedFilter = "Last 7 Days";

  List<Map<String, dynamic>> attendanceRecords = [];

  int presentCount = 0;
  int absentCount = 0;
  int halfDayCount = 0;
  int lateCount = 0;

  final List<String> filters = [

    "Last 7 Days",
    "Last 30 Days",
    "Last Month",

  ];

  @override
  void initState() {
    super.initState();
    _fetchAttendanceData();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: Text('Attendance Dashboard', style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: "poppins_thin", fontWeight: FontWeight.bold),),

        backgroundColor: Colors.white,

        centerTitle: true,

        leading: Container(
          margin: EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Colors.grey.shade400, blurRadius: 3, offset: Offset(1, 3)),],
          ),
          child: IconButton(

            onPressed: (){
              Navigator.pop(context);
            },

            icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20,),

          ),
        ),

        actions: [

          PopupMenuButton<String>(

            icon: Icon(Icons.more_vert, color: Colors.black, size: 20,),

            onSelected: (String value) {

              setState(() {

                selectedFilter = value;

                _fetchAttendanceData();

              });

            },

            itemBuilder: (BuildContext context) {

              return filters.map((String choice) {

                return PopupMenuItem<String>(

                  value: choice,

                  height: 40,

                  child: Text(choice, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey.shade700),),

                );

              }).toList();

            },

          ),

        ],
        flexibleSpace: Container(color: Colors.white,),

      ),

      backgroundColor: Colors.white,

      body: SingleChildScrollView(

        padding: EdgeInsets.all(16),

        child: Column(

          children: [

            _buildChart(),

            SizedBox(height: 20),

            _buildAttendanceList(),

          ],

        ),

      ),

    );

  }

  Widget _buildChart() {

    return Container(

      height: 250,
      padding: EdgeInsets.all(10),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius: BorderRadius.circular(12),

        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(1, 3))],

      ),

      child: Column(

        children: [

          Text("Attendance Overview", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

          SizedBox(height: 10),

          Expanded(

            child: PieChart(

              curve: Curves.linearToEaseOut,
              duration: Duration(seconds: 2),

              PieChartData(

                sections: [

                  _chartSection(presentCount, Colors.green.shade800, "Present"),

                  _chartSection(absentCount, Colors.red.shade800, "Absent"),

                  _chartSection(halfDayCount, Colors.orange.shade800, "Half-day"),

                  _chartSection(lateCount, Colors.blue.shade800, "Late"),

                ],

                sectionsSpace: 2,

                centerSpaceRadius: 40,

              ),

            ),

          ),

        ],

      ),

    );

  }

  PieChartSectionData _chartSection(int value, Color color, String title) {

    return PieChartSectionData(

      value: value.toDouble(),

      color: color,

      title: "$title\n$value",

      radius: 56,

      titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),

    );

  }

  Widget _buildAttendanceList() {

    return Column(

      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        SizedBox(height: 2,),

        Text('Showing: $selectedFilter', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: "poppins_thin", color: Colors.black)),

        SizedBox(height: 10),

        ListView.builder(

          shrinkWrap: true,

          physics: NeverScrollableScrollPhysics(),

          itemCount: attendanceRecords.length,

          itemBuilder: (context, index) {

            final record = attendanceRecords[index];

            return _attendanceCard(

              date: record['date'],

              checkIn: record['checkIn'],

              checkOut: record['checkOut'],

              status: record['status'],

            );

          },

        ),

      ],

    );

  }

  Widget _attendanceCard({required String date, required String checkIn, required String checkOut, required String status}) {

    return Container(

      height: 80,
      width: MediaQuery.of(context).size.width.toDouble(),
      margin: EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(

        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(1, 3))],

      ),

      child: Row(

        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          SizedBox(width: 12,),

          Container(

            height: 46,
            width: 36,

            decoration: BoxDecoration(

              // color: appColor.boxColor,

              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey.shade400, width: 1.2),

            ),

            child: Center(

              child: Icon(status == 'Present' ? Icons.check_circle : Icons.cancel, color: status == 'Present' ? Colors.green.shade900 : Colors.red.shade900, size: 22,),

            ),

          ),

          SizedBox(width: 16,),

          Container(

            height: 80,
            width: 190,

            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Container(

                  height: 19,
                  width: 190,
                  // color: Colors.red.shade200,

                  child: Column(

                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(date, style: TextStyle(color: Colors.grey.shade900, fontFamily: "poppins_thin", fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis,),

                    ],

                  ),

                ),

                Row(

                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,

                  children: [

                    Column(

                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,

                      children: [

                        Text("Check In", style: TextStyle(color: Colors.grey.shade800, fontFamily: "poppins_thin", fontSize: 12.8), maxLines: 1, overflow: TextOverflow.ellipsis,),
                        Text(checkIn, style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontSize: 12.5), maxLines: 1, overflow: TextOverflow.ellipsis,),

                      ],

                    ),

                    Spacer(),

                    Column(

                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,

                      children: [

                        Text("Check Out", style: TextStyle(color: Colors.grey.shade800, fontFamily: "poppins_thin", fontSize: 12.8), maxLines: 1, overflow: TextOverflow.ellipsis,),
                        Text(checkOut, style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontSize: 12.5), maxLines: 1, overflow: TextOverflow.ellipsis,),

                      ],

                    ),

                  ],

                ),

              ],

            ),

          ),

          Spacer(),

          Text(status, style: TextStyle(fontSize: 12.5,  fontFamily: "poppins_thin", color: status == 'Present' ? Colors.green.shade900 : Colors.red.shade900)),

          SizedBox(width: 12,),

        ],

      ),

    );

  }

  void _fetchAttendanceData() {

    DateTime now = DateTime.now();

    DateTime startDate;

    if (selectedFilter == "Last 7 Days") {

      startDate = now.subtract(Duration(days: 6));

    } else if (selectedFilter == "Last 30 Days") {

      startDate = now.subtract(Duration(days: 29));

    } else if (selectedFilter == "Last Month") {

      startDate = DateTime(now.year, now.month - 1, 1);

      now = DateTime(now.year, now.month, 0);

    } else {

      return;

    }

    presentCount = 0;

    absentCount = 0;

    halfDayCount = 0;

    lateCount = 0;

    setState(() {

      attendanceRecords = List.generate(

        now.difference(startDate).inDays + 1,

            (index) {

          DateTime date = startDate.add(Duration(days: index));

          String status;

          if (index % 6 == 0) {

            status = 'Absent';

            absentCount++;

          } else if (index % 5 == 0) {

            status = 'Half-day';

            halfDayCount++;

          } else if (index % 4 == 0) {

            status = 'Late';

            lateCount++;

          } else {

            status = 'Present';

            presentCount++;

          }

          return {

            'date': DateFormat('MMMM d, yyyy').format(date),

            'checkIn': status == 'Absent' ? '00:00' : '09:00 AM',

            'checkOut': status == 'Absent' ? '00:00' : '06:30 PM',

            'status': status,

          };

        },

      );

    });

  }

}
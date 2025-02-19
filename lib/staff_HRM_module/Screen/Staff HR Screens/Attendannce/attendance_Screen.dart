import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hr_app/Provider/UserProvider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../Model/Realtomodels/Realtostaffattendancemodel.dart';

class attendanceScreen extends StatefulWidget {
  @override
  _attendanceScreenState createState() => _attendanceScreenState();
}

class _attendanceScreenState extends State<attendanceScreen> {

  String selectedFilter = "Last 7 Days";

  List<Data> staffAttendanceList = [];

  List<Map<String, dynamic>> attendanceRecords = [];

  final List<String> filters = ["Last 7 Days", "Last 30 Days", "Last Month"];

  Future<void> _fetchStaffAttendanceData() async {

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    await userProvider.fetchStaffAttendanceData();

    setState(() {

      staffAttendanceList = userProvider.staffAttendanceData?.data ?? [];
      _updateAttendanceRecords();

    });

  }

  @override
  void initState() {
    super.initState();
    _fetchStaffAttendanceData();
  }

  void _updateAttendanceRecords() {
    attendanceRecords = _filterAttendanceByPunchDate();
  }

  List<Map<String, dynamic>> _filterAttendanceByPunchDate() {

    DateTime now = DateTime.now();
    DateTime startDate;
    DateTime endDate = now;

    // Determine the start date based on the selected filter
    switch (selectedFilter) {

      case 'Last 7 Days':

        startDate = now.subtract(Duration(days: 7));
        break;

      case 'Last 30 Days':

        startDate = now.subtract(Duration(days: 30));
        break;

      case 'Last Month':

      // Calculate the start date for the previous month
        startDate = DateTime(now.year, now.month - 1, 0); // First day of the previous month
        endDate = DateTime(now.year, now.month, 0); // Last day of the previous month
        break;

      default:

        startDate = now.subtract(Duration(days: 7)); // Fallback to Last 7 Days

    }

    // Generate a set of expected dates within the range, starting from endDate to startDate
    Set<String> expectedDates = {};

    for (int i = 0; i < endDate.difference(startDate).inDays; i++) {

      expectedDates.add(DateFormat('dd-MM-yyyy').format(endDate.subtract(Duration(days: i))));

    }

    // Convert the set to a list (already in descending order)
    List<String> sortedDates = expectedDates.toList();

    // Create a map of attendance records with punch dates as keys
    Map<String, Map<String, dynamic>> attendanceMap = {};

    for (var record in staffAttendanceList) {

      // Check if punchDate is not null and not '0000-00-00'
      if (record.punchDate != null && record.punchDate != '0000-00-00') {

        // Convert punchDate to the same format as expectedDates (dd-MM-yyyy)
        String formattedPunchDate;

        try {

          formattedPunchDate = DateFormat('dd-MM-yyyy').format(DateTime.parse(record.punchDate!));

        } catch (e) {

          // Handle invalid date format
          formattedPunchDate = 'Invalid Date';

        }

        // Extract time part (HH:mm) from entryDateTime
        String checkInTime = '00:00'; // Default value

        if (record.entryDateTime != null) {

          try {

            List<String> dateTimeParts = record.entryDateTime!.split(' ');

            if (dateTimeParts.length > 1) {

              String timePart = dateTimeParts[1]; // Get the time part (HH:mm:ss)

              checkInTime = timePart.substring(0, 5); // Extract HH:mm

            }

          } catch (e) {

            // Handle invalid time format
            checkInTime = '00:00';

          }

        }

        // Extract time part (HH:mm) from exitDateTime
        String checkOutTime = '00:00'; // Default value

        if (record.exitDateTime != null) {

          try {

            List<String> dateTimeParts = record.exitDateTime!.split(' ');

            if (dateTimeParts.length > 1) {

              String timePart = dateTimeParts[1]; // Get the time part (HH:mm:ss)

              checkOutTime = timePart.substring(0, 5); // Extract HH:mm

            }

          } catch (e) {

            // Handle invalid time format
            checkOutTime = '00:00';

          }

        }

        attendanceMap[formattedPunchDate] = {

          'date': formattedPunchDate,
          'checkIn': checkInTime, // Assign extracted time for check-in
          'checkOut': checkOutTime, // Assign extracted time for check-out
          'status': 'Present', // Mark as Present if punch date exists

        };

      }

    }

    // Generate the final list of attendance data in descending order
    return sortedDates.map((date) {

      if (attendanceMap.containsKey(date)) {

        return attendanceMap[date]!; // Return the present record

      } else {

        return {

          'date': date,
          'checkIn': '00:00',
          'checkOut': '00:00',
          'status': 'Absent', // Mark as Absent if punch date does not exist

        };

      }

    }).toList();

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

            position: PopupMenuPosition.under,

            onSelected: (value) {

              setState(() {

                selectedFilter = value;
                _updateAttendanceRecords();

              });

            },

            itemBuilder: (context) => filters.map((choice) => PopupMenuItem<String>(

              value: choice,
              height: 40,
              child: Text(choice, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey.shade700),),

            )).toList(),

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

                  _chartSection(attendanceRecords.where((e) => e['status'] == 'Present').length, Colors.green.shade700, "Present"),
                  _chartSection(attendanceRecords.where((e) => e['status'] == 'Absent').length, Colors.red.shade700, "Absent"),

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

    // return ListTile(
    //
    //   title: Text(date),
    //
    //   subtitle: Text("Check-In: $checkIn, Check-Out: $checkOut"),
    //
    //   trailing: Text(status, style: TextStyle(color: status == 'Present' ? Colors.green : Colors.red),),
    //
    // );

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

}
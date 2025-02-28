import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hr_app/Provider/UserProvider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../Model/Realtomodels/Realtostaffattendancemodel.dart';
import '../../Color/app_Color.dart';

class attendanceScreen extends StatefulWidget {
  @override
  _attendanceScreenState createState() => _attendanceScreenState();
}

class _attendanceScreenState extends State<attendanceScreen> {

  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  String selectedFilter = "Last 7 Days"; // Default filter
  List<Calendar> staffAttendanceList = [];
  List<Map<String, dynamic>> attendanceRecords = [];
  bool isLoading = true;

  final List<String> filters = ["Last 7 Days", "Current Month", "Last Month"];

  @override
  void initState() {
    super.initState();
    _fetchCurrentMonthAttendance();
  }

  /// Fetch current month's attendance data from backend
  Future<void> _fetchCurrentMonthAttendance() async {
    setState(() => isLoading = true);

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.fetchStaffAttendanceData(); // Fetch current month data

    staffAttendanceList = userProvider.staffAttendanceData?.data?.calendar ?? [];
    _updateAttendanceRecords();

    setState(() => isLoading = false);
  }

  /// Fetch attendance for a specific year and month (for "Last Month" filter)
  Future<void> _fetchLastMonthAttendance() async {
    setState(() => isLoading = true);

    final url = Uri.parse("https://admin.dev.ajasys.com/api/month_attendance");
    final String? token = await _secureStorage.read(key: 'token');

    if (token == null) return;

    DateTime lastMonth = DateTime.now().subtract(const Duration(days: 30));

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'token': token,
          'selectedYear': lastMonth.year,
          'selectedMonth': lastMonth.month
        }),
      );

      print("API Response: ${response.body}");  // Debugging Line

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        staffAttendanceList = List<Calendar>.from(
            jsonResponse['data']['calendar'].map((x) => Calendar.fromJson(x))
        );
        // Fluttertoast.showToast(msg: staffAttendanceList.length.toString());

        print("Parsed Attendance List: $staffAttendanceList"); // Debugging Line

        _updateAttendanceRecords();
      }
    } catch (e) {
      print("Error fetching last month attendance: $e");
    }

    setState(() => isLoading = false);
  }

  /// Update records based on selected filter
  void _updateAttendanceRecords() {
    if (staffAttendanceList.isEmpty) {
      print("Staff Attendance List is empty!"); // Debugging Line
      setState(() {
        attendanceRecords = [];
        isLoading = false;
      });
      return;
    }

    setState(() {
      attendanceRecords = _filterAttendanceByPunchDate();
      print("Updated Attendance Records: $attendanceRecords"); // Debugging Line
      isLoading = false; // Ensure the UI knows data is available
    });
  }

  /// Filter attendance data based on selected filter
  List<Map<String, dynamic>> _filterAttendanceByPunchDate() {
    DateTime now = DateTime.now();
    DateTime startDate;
    DateTime endDate = now;

    switch (selectedFilter) {
      case 'Last 7 Days':
        startDate = now.subtract(const Duration(days: 6)); // Include today
        break;
      case 'Current Month':
        startDate = DateTime(now.year, now.month, 1);
        endDate = DateTime(now.year, now.month + 1, 0);
        break;
      case 'Last Month':
        startDate = DateTime(now.year, now.month - 1, 1);
        endDate = DateTime(now.year, now.month, 0);
        break;
      default:
        startDate = now.subtract(const Duration(days: 6));
    }

    // Expected dates within the selected range in "dd-MM-yyyy" format
    Set<String> expectedDates = {};
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      expectedDates.add(DateFormat('dd-MM-yyyy').format(startDate.add(Duration(days: i))));
    }

    // Create a map of attendance records from API data
    Map<String, Map<String, dynamic>> attendanceMap = {};

    for (var record in staffAttendanceList) {
      if (record.date != null && record.date != '0000-00-00') {
        String formattedPunchDate = DateFormat('dd-MM-yyyy').format(DateTime.parse(record.date!));

        if (expectedDates.contains(formattedPunchDate)) {
          attendanceMap[formattedPunchDate] = {
            'date': formattedPunchDate,
            'checkIn': record.inTime ?? '00:00',
            'checkOut': record.outTime ?? '00:00',
            'status': record.status ?? 'Absent',
          };
        }
      }
    }

    // Build final attendance list
    List<Map<String, dynamic>> attendanceList = expectedDates.map((date) {
      return attendanceMap.containsKey(date)
          ? attendanceMap[date]!
          : {'date': date, 'checkIn': '00:00', 'checkOut': '00:00', 'status': 'Absent'};
    }).toList();

    // Sort the list by date in descending order
    attendanceList.sort((a, b) {
      DateTime dateA = DateFormat('dd-MM-yyyy').parse(a['date']);
      DateTime dateB = DateFormat('dd-MM-yyyy').parse(b['date']);
      return dateB.compareTo(dateA); // Descending order
    });

    return attendanceList;
  }

  /// Handle filter change
  void _onFilterChanged(String newFilter) async {
    setState(() {
      selectedFilter = newFilter;
      isLoading = true; // Ensure UI shows loading state
    });

    if (newFilter == "Last Month") {
      await _fetchLastMonthAttendance();  // Fetch last month's data via API
    } else {
      await _fetchCurrentMonthAttendance();  // Fetch current month data
    }

    setState(() {
      isLoading = false; // Refresh UI
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: Text('Attendance Dashboard', style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: "poppins_thin", fontWeight: FontWeight.bold),),

        backgroundColor: Colors.white,

        centerTitle: true,

        leading: Container(

          margin: EdgeInsets.all(9),

          decoration: BoxDecoration(

            color: appColor.subFavColor,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Colors.grey.shade400, blurRadius: 3, offset: Offset(1, 3)),],

          ),

          child: IconButton(

            onPressed: (){
              Navigator.pop(context);
            },

            icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 16,),

          ),
        ),

        actions: [

          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black, size: 20),
            position: PopupMenuPosition.under,
            offset: const Offset(0, 8),
            color: appColor.subFavColor,
            onSelected: (value) {
              setState(() {
                selectedFilter = value;
                _onFilterChanged(value); // Call function to handle filter logic
              });
            },
            itemBuilder: (context) => filters.map((choice) => PopupMenuItem<String>(
              value: choice,
              height: 40,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                choice,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.grey.shade800,
                ),
              ),
            )).toList(),
          ),

        ],
        flexibleSpace: Container(color: Colors.white,),

      ),

      backgroundColor: Colors.white,

      body: staffAttendanceList.isEmpty ? Center(

        child: CircularProgressIndicator(

          color: Colors.deepPurple.shade700,

        ),

      ) :

      SingleChildScrollView(

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

              key: ValueKey(selectedFilter),

              curve: Curves.linearToEaseOut,
              duration: Duration(seconds: 2),

              PieChartData(

                sections: [

                  _chartSection(attendanceRecords.where((e) => e['status'] == 'present').length, Colors.green.shade700, "Present"),
                  _chartSection(attendanceRecords.where((e) => e['status'] == 'absent').length, Colors.red.shade700, "Absent"),
                  _chartSection(attendanceRecords.where((e) => e['status'] == 'half day').length, Colors.orange.shade600, "Half-Day"),

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

              child: Icon(status == 'present' ? Icons.check_circle : status == 'half day' ? Icons.access_time : Icons.cancel, color: status == 'present' ? Colors.green.shade900 : status == 'half day' ? Colors.orange.shade700 : Colors.red.shade900, size: 22,),

            ),

          ),

          SizedBox(width: 16,),

          Container(

            height: 80,
            width: MediaQuery.of(context).size.width.toDouble()/2,
            // color: Colors.red,

            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Container(

                  height: 19,
                  width: MediaQuery.of(context).size.width.toDouble()/2,
                  // color: Colors.red.shade200,

                  child: Text(date, style: TextStyle(color: Colors.grey.shade900, fontFamily: "poppins_thin", fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis,),

                ),

                SizedBox(height: 6,),

                Row(

                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,

                  children: [

                    Image.asset("asset/HR Screen Images/check-in.png", height: 16,),
                    SizedBox(width: 5,),
                    Text(checkIn, style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontSize: 12.5), maxLines: 1, overflow: TextOverflow.ellipsis,),

                    Spacer(),

                    Image.asset("asset/HR Screen Images/check-out.png", height: 16,),
                    SizedBox(width: 5,),
                    Text(checkOut, style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontSize: 12.5), maxLines: 1, overflow: TextOverflow.ellipsis,),

                  ],

                ),

              ],

            ),

          ),

          Spacer(),

          Text(status, style: TextStyle(fontSize: 12.5,  fontFamily: "poppins_thin", color: status == 'present' ? Colors.green.shade900 : status == 'half day' ? Colors.orange.shade700 : Colors.red.shade900)),

          SizedBox(width: 12,),

        ],

      ),

    );

  }

}
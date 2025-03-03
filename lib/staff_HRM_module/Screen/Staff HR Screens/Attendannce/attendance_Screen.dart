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

  final List<String> filters = ["Last 7 Days", "Last 30 Days", "Last Month"];

  @override
  void initState() {
    super.initState();
    _fetchTwoMonthsAttendance();
  }

  /// Fetch both current and previous month's attendance data from backend
  Future<void> _fetchTwoMonthsAttendance() async {
    setState(() => isLoading = true);

    final url = Uri.parse("https://admin.dev.ajasys.com/api/month_attendance");
    final String? token = await _secureStorage.read(key: 'token');
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (token == null) return;

    DateTime now = DateTime.now();
    DateTime lastMonth = DateTime(now.year, now.month - 1, 1);

    try {
      // Fetch current month data
      await userProvider.fetchStaffAttendanceData();
      List<Calendar> currentMonthData = userProvider.staffAttendanceData?.data?.calendar ?? [];

      // Fetch last month data
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'token': token,
          'selectedYear': lastMonth.year,
          'selectedMonth': lastMonth.month,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        List<Calendar> lastMonthData = List<Calendar>.from(
          jsonResponse['data']['calendar'].map((x) => Calendar.fromJson(x)),
        );

        // Combine both months' data
        staffAttendanceList = [...currentMonthData, ...lastMonthData];
        _updateAttendanceRecords();
      }
    } catch (e) {
      print("Error fetching attendance data: $e");
    }

    setState(() => isLoading = false);
  }

  /// Update records based on selected filter
  void _updateAttendanceRecords() {
    if (staffAttendanceList.isEmpty) {
      print("Staff Attendance List is empty!");
      setState(() {
        attendanceRecords = [];
        isLoading = false;
      });
      return;
    }

    setState(() {
      attendanceRecords = _filterAttendanceByPunchDate();
      print("Updated Attendance Records: $attendanceRecords");
      isLoading = false;
    });
  }

  /// Filter attendance data based on selected filter
  List<Map<String, dynamic>> _filterAttendanceByPunchDate() {
    DateTime now = DateTime.now();
    DateTime startDate;
    DateTime endDate = now;

    switch (selectedFilter) {
      case 'Last 7 Days':
        startDate = now.subtract(const Duration(days: 6));
        break;
      case 'Last 30 Days':
        startDate = now.subtract(const Duration(days: 29));
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
      expectedDates
          .add(DateFormat('dd-MM-yyyy').format(startDate.add(Duration(days: i))));
    }

    // Create a map of attendance records from API data
    Map<String, Map<String, dynamic>> attendanceMap = {};

    for (var record in staffAttendanceList) {
      if (record.date != null && record.date != '0000-00-00') {
        String formattedPunchDate =
        DateFormat('dd-MM-yyyy').format(DateTime.parse(record.date!));

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
          : {
        'date': date,
        'checkIn': '00:00',
        'checkOut': '00:00',
        'status': 'Absent'
      };
    }).toList();

    // Sort the list by date in descending order
    attendanceList.sort((a, b) {
      DateTime dateA = DateFormat('dd-MM-yyyy').parse(a['date']);
      DateTime dateB = DateFormat('dd-MM-yyyy').parse(b['date']);
      return dateB.compareTo(dateA);
    });

    return attendanceList;
  }

  /// Handle filter change
  void _onFilterChanged(String newFilter) {
    setState(() {
      selectedFilter = newFilter;
      isLoading = true;
    });

    _updateAttendanceRecords(); // Simply filter the already fetched data

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Attendance Dashboard',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: "poppins_thin",
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: Container(
          margin: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: appColor.subFavColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade400,
                blurRadius: 3,
                offset: const Offset(1, 3),
              ),
            ],
          ),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
              size: 16,
            ),
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black, size: 20),
            position: PopupMenuPosition.under,
            offset: const Offset(0, 8),
            color: appColor.subFavColor,
            onSelected: (value) {
              _onFilterChanged(value);
            },
            itemBuilder: (context) => filters
                .map(
                  (choice) => PopupMenuItem<String>(
                value: choice,
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  choice,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),
            )
                .toList(),
          ),
        ],
        flexibleSpace: Container(color: Colors.white),
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: Colors.deepPurple.shade700,
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildChart(),
            const SizedBox(height: 20),
            _buildAttendanceList(),
          ],
        ),
      ),
    );
  }

  Widget _buildChart() {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          const BoxShadow(
            color: Colors.black12,
            blurRadius: 3,
            offset: Offset(1, 3),
          )
        ],
      ),
      child: Column(
        children: [
          const Text(
            "Attendance Overview",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: PieChart(
              key: ValueKey(selectedFilter),
              curve: Curves.linearToEaseOut,
              duration: const Duration(seconds: 2),
              PieChartData(
                sections: [
                  _chartSection(
                    attendanceRecords
                        .where((e) => e['status'] == 'present')
                        .length,
                    Colors.green.shade700,
                    "present",
                  ),
                  _chartSection(
                    attendanceRecords.where((e) => e['status'] == 'absent').length,
                    Colors.red.shade700,
                    "absent",
                  ),
                  _chartSection(
                    attendanceRecords
                        .where((e) => e['status'] == 'half day')
                        .length,
                    Colors.orange.shade500,
                    "halfday",
                  ),
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
      titleStyle:
      const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }

  Widget _buildAttendanceList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 2),
        Text(
          'Showing: $selectedFilter',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            fontFamily: "poppins_thin",
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
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

  Widget _attendanceCard({
    required String date,
    required String checkIn,
    required String checkOut,
    required String status,
  }) {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width.toDouble(),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          const BoxShadow(
            color: Colors.black12,
            blurRadius: 3,
            offset: Offset(1, 3),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 12),
          Container(
            height: 46,
            width: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey.shade400, width: 1.2),
            ),
            child: Center(
              child: Icon(
                status == 'present'
                    ? Icons.check_circle
                    : status == 'half day'
                    ? Icons.access_time
                    : Icons.cancel,
                color: status == 'present'
                    ? Colors.green.shade900
                    : status == 'half day'
                    ? Colors.orange.shade700
                    : Colors.red.shade900,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            height: 80,
            width: MediaQuery.of(context).size.width.toDouble() / 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 19,
                  width: MediaQuery.of(context).size.width.toDouble() / 2,
                  child: Text(
                    date,
                    style: TextStyle(
                      color: Colors.grey.shade900,
                      fontFamily: "poppins_thin",
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      "asset/HR Screen Images/check-in.png",
                      height: 16,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      checkIn,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontFamily: "poppins_thin",
                        fontSize: 12.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Image.asset(
                      "asset/HR Screen Images/check-out.png",
                      height: 16,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      checkOut,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontFamily: "poppins_thin",
                        fontSize: 12.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          Text(
            status,
            style: TextStyle(
              fontSize: 12.5,
              fontFamily: "poppins_thin",
              color: status == 'present'
                  ? Colors.green.shade900
                  : status == 'half day'
                  ? Colors.orange.shade700
                  : Colors.red.shade900,
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}
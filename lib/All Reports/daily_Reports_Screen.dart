import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../Provider/UserProvider.dart';
import '../staff_HRM_module/Screen/Color/app_Color.dart';
import 'Models/fetch_Daily_Reports_Model.dart';
import 'Models/fetch_Month_Filter_Model.dart';

// Define custom colors as constants
Color primaryPurple = Colors.deepPurple.shade300;
const Color lightGrayBackground = Colors.white;
const Color textColorDark = Colors.black87;
const Color textColorLight = Colors.black54;

class dailyReportsScreen extends StatefulWidget {
  @override
  _dailyReportsScreenState createState() => _dailyReportsScreenState();
}

class _dailyReportsScreenState extends State<dailyReportsScreen> {

  String selectedMonth = DateFormat('MMMM-yyyy').format(DateTime.now());
  String? storedDate; // Variable to store the selected date in 'YYYY-MM-DD' format

  // Helper function to get the last day of the month
  String _getLastDayOfMonth(DateTime date) {
    DateTime lastDay = DateTime(date.year, date.month + 1, 0); // Last day of current month
    return DateFormat('yyyy-MM-dd').format(lastDay);
  }

  @override
  void initState() {
    super.initState();
    // Fetch initial data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.fetchMonthsData();
      // Set initial storedDate to current month in 'YYYY-MM-DD' format (last day)
      storedDate = _getLastDayOfMonth(DateTime.now());
      userProvider.fetchDailyReports(month: storedDate!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        // Set initial storedDate if monthsData is available and storedDate is null
        if (storedDate == null && userProvider.monthsData?.dropDown != null) {
          final currentMonthData = userProvider.monthsData!.dropDown!.firstWhere(
                (month) => month.monthName == selectedMonth,
            orElse: () => userProvider.monthsData!.dropDown!.first,
          );
          storedDate = currentMonthData.date;
          print('Initial stored date from monthsData: $storedDate');
          // Fluttertoast.showToast(msg: storedDate.toString());
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Daily Reports',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: "poppins_thin",
              ),
            ),
            backgroundColor: appColor.primaryColor,
            centerTitle: true,
            foregroundColor: Colors.white,
            leading: IconButton(

              onPressed: (){
                Navigator.pop(context);
              },

              icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20,),

            ),
            actions: [
              PopupMenuButton<String>(
                color: Colors.white,
                offset: Offset(0, 12),
                position: PopupMenuPosition.under,
                icon: Icon(Icons.filter_list, color: Colors.white),
                onSelected: (String value) {
                  setState(() {
                    selectedMonth = value;
                    final selectedMonthData = userProvider.monthsData!.dropDown!.firstWhere(
                          (month) => month.monthName == value,
                    );
                    storedDate = selectedMonthData.date;
                    // Fetch daily reports with the selected storedDate
                    userProvider.fetchDailyReports(month: storedDate!);
                  });
                },
                itemBuilder: (BuildContext context) {
                  if (userProvider.isLoading) {
                    return [
                      PopupMenuItem<String>(
                        enabled: false,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ];
                  }
                  if (userProvider.errorMessage != null) {
                    return [
                      PopupMenuItem<String>(
                        enabled: false,
                        child: Text('Error: ${userProvider.errorMessage}'),
                      ),
                    ];
                  }
                  if (userProvider.monthsData?.dropDown == null ||
                      userProvider.monthsData!.dropDown!.isEmpty) {
                    return [
                      PopupMenuItem<String>(
                        enabled: false,
                        child: Text('No months available'),
                      ),
                    ];
                  }

                  return userProvider.monthsData!.dropDown!.map((DropDown month) {
                    return PopupMenuItem<String>(
                      value: month.monthName!,
                      child: ListTile(
                        title: Text(
                          month.monthName!,
                          style: TextStyle(
                            fontSize: 12.5,
                            color: month.monthName == selectedMonth
                                ? Colors.deepPurple.shade400
                                : Colors.grey.shade700,
                            fontFamily: "poppins_thin",
                          ),
                        ),
                      ),
                    );
                  }).toList();
                },
              ),
            ],
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Container(
              color: lightGrayBackground,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      'Selected Month: $selectedMonth',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: textColorDark,
                        fontFamily: "poppins_thin",
                      ),
                    ),
                  ),
                  if (userProvider.isDailyRpLoading == true)
                    _buildShimmerEffect() // Show shimmer effect while loading
                  else if (userProvider.dailyReportsData != null)
                    _buildDailyReports(userProvider.dailyReportsData!) // Show data when available
                  else
                    Text(
                      'No data available',
                      style: TextStyle(
                        fontSize: 15,
                        color: textColorLight,
                        fontFamily: "poppins_thin",
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmerEffect() {
    return Column(
      children: List.generate(6, (index) => _buildShimmerCard()),
    );
  }

  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        elevation: 3,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.only(bottom: 16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100,
                height: 20,
                color: Colors.white,
              ),
              SizedBox(height: 12),
              Container(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10, // Simulating a few days
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Column(
                        children: [
                          Container(
                            width: 40,
                            height: 20,
                            color: Colors.white,
                          ),
                          SizedBox(height: 4),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDailyReports(FetchDailyReportsModel reports) {
    // Organize data by product name
    Map<String, List<int>> activityData = {
      'Inquiries': List.filled(31, 0),
      'Calls': List.filled(31, 0),
      'Appointments': List.filled(31, 0),
      'Visits': List.filled(31, 0),
      'Bookings': List.filled(31, 0),
      'Closes': List.filled(31, 0),
    };

    for (var category in reports.data) {
      for (var datum in category) {
        int dayIndex = int.parse(datum.monthName.split(' ')[0]) - 1;
        switch (datum.productName) {
          case ProductName.INQ:
            activityData['Inquiries']![dayIndex] = datum.bookingCount;
            break;
          case ProductName.CALL:
            activityData['Calls']![dayIndex] = datum.bookingCount;
            break;
          case ProductName.APPOINTMENT:
            activityData['Appointments']![dayIndex] = datum.bookingCount;
            break;
          case ProductName.VISIT:
            activityData['Visits']![dayIndex] = datum.bookingCount;
            break;
          case ProductName.BOOKING:
            activityData['Bookings']![dayIndex] = datum.bookingCount;
            break;
          case ProductName.CLOSE:
            activityData['Closes']![dayIndex] = datum.bookingCount;
            break;
        }
      }
    }

    return Column(
      children: activityData.entries.map((entry) {
        return _buildDailyReportRow(entry.key, entry.value);
      }).toList(),
    );
  }

  Widget _buildDailyReportRow(String title, List<int> data) {
    return Card(
      elevation: 3,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: textColorDark,
                    fontFamily: "poppins_thin",
                  ),
                ),
                Text(
                  'Total: ${data.reduce((a, b) => a + b)}',
                  style: TextStyle(
                    fontSize: 13,
                    color: textColorLight,
                    fontFamily: "poppins_thin",
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Container(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  String date = '${index + 1}-${DateFormat('MM').format(DateTime.parse(storedDate!))}';
                  int value = data[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                          child: Center(
                            child: Text(
                              date,
                              style: TextStyle(
                                fontSize: 11,
                                color: textColorLight,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SizedBox(height: 4),
                        Tooltip(
                          message: '$date: $value $title',
                          child: Container(
                            width: 36.4,
                            height: 36.4,
                            decoration: BoxDecoration(
                              color: value > 0 ? Colors.deepPurple.shade200 : Colors.grey[200],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                '$value',
                                style: TextStyle(
                                  color: value > 0 ? Colors.white : textColorLight,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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
}
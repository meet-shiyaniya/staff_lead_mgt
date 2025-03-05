import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hr_app/dashboard_ui/main_dashboard/performance_screen.dart';
import 'package:hr_app/dashboard_ui/main_dashboard/report_ui.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
// import 'package:realtosmart/dashboard_ui/main_dashboard/performance_screen.dart';
// import 'package:realtosmart/dashboard_ui/main_dashboard/report_ui.dart';
import '../../Provider/UserProvider.dart';
import '../../social_module/colors/colors.dart';
import '../../staff_HRM_module/Model/Realtomodels/Realtostaffprofilemodel.dart';
import '../dashboard2/dashboard2.dart';
import '../main_dashboard/activity_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  String _selectedFilter = 'month';
  String _selectedCategory = 'Inquiry';
  late TabController _tabController;

  final List<Map<String, dynamic>> performanceData = [
    {'month': '2024-12', 'leads': 0, 'visits': 1, 'bookings': 0},
    {'month': '2025-01', 'leads': 14, 'visits': 3, 'bookings': 4},
    {'month': '2025-02', 'leads': 2, 'visits': 2, 'bookings': 0},
  ];

  final List<Map<String, dynamic>> pendingFollowups = [
    {'user': 'Abcbuildcon', 'autoLeads': 0, 'selfLeads': 0, 'today': 0, 'pending': 3},
    {'user': 'Ajasys', 'autoLeads': 0, 'selfLeads': 0, 'today': 0, 'pending': 2},
  ];

  List<BarChartGroupData> _getBarChartData(String filter, String category) {
    final now = DateTime.now();
    final Map<String, Map<String, List<double>>> dataMap = {
      'Daily': {
        'Inquiry': [10, 5, 30, 12, 20, 8, 22],
        'Lead': [8, 3, 25, 10, 15, 6, 18],
        'Data': [12, 7, 20, 15, 25, 10, 30],
        'Visit': [5, 2, 15, 8, 10, 4, 12],
        'Cancel Booking': [2, 1, 10, 5, 7, 3, 8],
        'Conversion': [7, 4, 20, 10, 15, 6, 18],
      },
      'Weekly': {
        'Inquiry': [30, 15, 25, 35],
        'Lead': [25, 12, 20, 30],
        'Data': [35, 18, 30, 40],
        'Visit': [15, 8, 12, 20],
        'Cancel Booking': [10, 5, 8, 15],
        'Conversion': [20, 10, 18, 25],
      },
      'Monthly': {
        'Inquiry': [20, 65, 15, 40, 50, 30, 45, 65, 15, 40, 35, 55],
        'Lead': [15, 55, 10, 35, 45, 25, 40, 60, 12, 35, 30, 50],
        'Data': [25, 70, 20, 45, 55, 35, 50, 70, 18, 45, 40, 60],
        'Visit': [10, 40, 8, 25, 35, 20, 30, 50, 10, 30, 25, 40],
        'Cancel Booking': [5, 30, 5, 15, 25, 10, 20, 40, 8, 20, 15, 30],
        'Conversion': [18, 60, 12, 38, 48, 28, 42, 62, 14, 38, 32, 52],
      },
      'Yearly': {
        'Inquiry': [100, 150, 80, 220, 200],
        'Lead': [80, 120, 60, 180, 160],
        'Data': [120, 180, 100, 250, 230],
        'Visit': [50, 80, 40, 120, 100],
        'Cancel Booking': [30, 50, 20, 80, 60],
        'Conversion': [90, 140, 70, 200, 180],
      },
    };

    final Map<String, Color> colorMap = {
      'Inquiry': Colors.deepPurple,
      'Lead': Colors.purple.shade300,
      'Data': Colors.purpleAccent.withOpacity(0.5),
      'Visit': Colors.greenAccent.withOpacity(0.5),
      'Cancel Booking': Colors.red.shade300,
      'Conversion': Colors.teal.shade300,
    };

    final data = dataMap[filter]?[category] ?? dataMap['Daily']!['Inquiry']!;
    final barColor = colorMap[category] ?? Colors.deepPurple;

    return List.generate(data.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: data[index].toDouble(),
            color: barColor,
            width: 20,
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      );
    });
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1: return 'Mon';
      case 2: return 'Tue';
      case 3: return 'Wed';
      case 4: return 'Thu';
      case 5: return 'Fri';
      case 6: return 'Sat';
      case 7: return 'Sun';
      default: return '';
    }
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1: return 'Jan';
      case 2: return 'Feb';
      case 3: return 'Mar';
      case 4: return 'Apr';
      case 5: return 'May';
      case 6: return 'Jun';
      case 7: return 'Jul';
      case 8: return 'Aug';
      case 9: return 'Sep';
      case 10: return 'Oct';
      case 11: return 'Nov';
      case 12: return 'Dec';
      default: return '';
    }
  }

  String _getBottomTitle(String filter, double value) {
    final now = DateTime.now();
    switch (filter) {
      case 'Daily':
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final day = startOfWeek.add(Duration(days: value.toInt()));
        return _getDayName(day.weekday);
      case 'Weekly':
        final weekStart = now.subtract(Duration(days: now.weekday - 1 + 7 * (3 - value.toInt())));
        final weekEnd = weekStart.add(Duration(days: 6));
        return '${weekStart.day}/${weekStart.month}';
      case 'Monthly':
        return _getMonthName(value.toInt() + 1);
      case 'Yearly':
        return '${now.year - 4 + value.toInt()}';
      default:
        return '';
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    Realtostaffprofilemodel? profile = userProvider.profileData;
    if (profile == null) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(width: 10),
                    Text("My Task", style: TextStyle(fontFamily: "poppins_thin", fontSize: 18)),
                    Spacer(),
                    Image.asset("asset/peopleDashboard.png", height: 50, width: 100),
                  ],
                ),
              ),
              SizedBox(height: 10),
              _buildSummaryCards(),
              SizedBox(height: 10),
              _buildPerformanceSection(),
              SizedBox(height: 10),
              // _buildTabBar(),
              SizedBox(height: 12),
              _buildTabContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(child: _buildSummaryCard('Total Leads', '120', Colors.blue.shade50)),
        Expanded(child: _buildSummaryCard('My Visits', '45', Colors.yellow.shade50)),
        Expanded(child: _buildSummaryCard('My Booking', '15', Colors.green.shade50)),
        Expanded(child: _buildSummaryCard('Follow ups', '12.5%', Colors.red.shade50)),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color) {
    return Container(
      margin: EdgeInsets.only(left: 5, right: 5),
      height: MediaQuery.of(context).size.height / 8.5,
      width: MediaQuery.of(context).size.width / 5,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            offset: Offset(1, 3),
            color: Colors.grey.shade400,
            blurRadius: 1,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text(title, style: TextStyle(fontSize: 14, fontFamily: "poppins_thin")),
            Spacer(),
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceSection() {
    return Card(
      color: Colors.grey.shade50,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(

              children: [
                Text(
                  'Inquiries',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: "poppins_thin",
                    color: Colors.deepPurple[900],
                  ),
                ),
                Spacer(),
                Row(
                  children: [


                    PopupMenuButton<String>(
                      initialValue: _selectedCategory,
                      onSelected: (String value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(value: 'Inquiry', child: Text('Inquiry', style: TextStyle(fontFamily: "poppins_thin"))),
                        PopupMenuItem<String>(value: 'Lead', child: Text('Lead', style: TextStyle(fontFamily: "poppins_thin"))),
                        PopupMenuItem<String>(value: 'Data', child: Text('Data', style: TextStyle(fontFamily: "poppins_thin"))),
                        PopupMenuItem<String>(value: 'Visit', child: Text('Visit', style: TextStyle(fontFamily: "poppins_thin"))),
                        PopupMenuItem<String>(value: 'Cancel Booking', child: Text('Cancel Booking', style: TextStyle(fontFamily: "poppins_thin"))),
                        PopupMenuItem<String>(value: 'Conversion', child: Text('Conversion', style: TextStyle(fontFamily: "poppins_thin"))),
                      ],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 8,
                      offset: Offset(0, 40),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.deepPurple),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _selectedCategory,
                              style: TextStyle(
                                fontSize: 12,
                                overflow: TextOverflow.ellipsis,
                                color: Colors.deepPurple,
                                fontFamily: "poppins_thin",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(Icons.arrow_drop_down, color: Colors.deepPurple),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Container(
                      height: 40,
                      width: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.deepPurple),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.filter_list, color: Colors.deepPurple),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => _buildFilterOptions(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              height: 200,
              child: BarChart(
                BarChartData(
                  barGroups: _getBarChartData(_selectedFilter, _selectedCategory),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) => Text(
                          _getBottomTitle(_selectedFilter, value),
                          style: TextStyle(color: Colors.deepPurple[900], fontSize: 10),
                        ),
                      ),
                    ),
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOptions() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Select Time Filter', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          ...['Weekly', 'Monthly', 'Yearly'].map((filter) => ListTile(
            title: Text(filter),
            onTap: () {
              setState(() {
                _selectedFilter = filter;
              });
              Navigator.pop(context);
            },
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 45,
      margin: EdgeInsets.only(left: 15, right: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(offset: Offset(1, 3), color: Colors.grey.shade300)],
      ),
      child: TabBar(
        // indicatorAnimation: TabIndicatorAnimation.elastic,
        controller: _tabController,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: Colors.deepPurple.withOpacity(0.9),
          borderRadius: BorderRadius.circular(8),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.deepPurple[900],
        tabs: [
          Tab(text: 'Performance'),
          Tab(text: 'Reports'),
          Tab(text: 'Activities'),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return Container(
      height: MediaQuery.of(context).size.height / 1,
      child: TabBarView(
        controller: _tabController,
        children: [
          PerformanceScreen(),
          ReportScreen(),
          InquiryDashboard(),
        ],
      ),
    );
  }
}
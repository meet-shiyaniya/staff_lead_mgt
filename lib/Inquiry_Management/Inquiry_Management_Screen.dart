import 'package:auto_size_text/auto_size_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'Inquiry Management Screens/all_inquiries_Screen.dart';
import 'Inquiry Management Screens/assign_to_other_Screen.dart';
import 'Inquiry Management Screens/dismiss_request_Screen.dart';
import 'Inquiry Management Screens/followup_and_cnr_Screen.dart';
import 'Utils/category_Card.dart';

class InquiryManagementScreen extends StatefulWidget {
  const InquiryManagementScreen({super.key});

  @override
  State<InquiryManagementScreen> createState() =>
      _InquiryManagementScreenState();
}

class _InquiryManagementScreenState extends State<InquiryManagementScreen> {
  int _selectedPeriod = 0; // 0 - Today, 1 - Last 7 Days, 2 - Last Month, 3 - Yearly
  final GlobalKey _iconKey = GlobalKey();
  final List<List<double>> inquiryValuesByPeriod = [
    [50, 30, 15, 5], // Today
    [220, 100, 80, 40], // Last 7 Days
    [500, 200, 150, 100], // Last Month
    [2000, 800, 600, 400], // Yearly
  ];

  final List<String> labels = ["Inquiries", "Visit", "Booking\nCancel", "Conversion"];

  double getMaxY() {
    switch (_selectedPeriod) {
      case 0:
        return 200; // Today
      case 1:
        return 250; // Last 7 Days
      case 2:
        return 600; // Last Month
      case 3:
        return 2500; // Yearly
      default:
        return 250;
    }
  }

  double getMinY() => 0;

  int getLeftTitlesInterval() {
    switch (_selectedPeriod) {
      case 0:
        return 50; // Today
      case 1:
        return 50; // Last 7 Days
      case 2:
        return 100; // Last Month
      case 3:
        return 500; // Yearly
      default:
        return 50;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 22),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;
              final isLargeScreen = screenWidth > 600;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      "Effortless Inquiry ",
                      style: TextStyle(
                          fontSize: isLargeScreen ? 20 : 16,
                          fontFamily: "poppins_light"),
                      maxLines: 1,
                      minFontSize: 18,
                    ),
                    AutoSizeText(
                      "Tracking & Management",
                      style: TextStyle(
                          fontSize: isLargeScreen ? 24 : 20,
                          fontFamily: "poppins_thin"),
                      maxLines: 1,
                      minFontSize: 22,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Container(
                        margin: EdgeInsets.only(left: 10,right: 10),
                        height: MediaQuery.of(context).size.height / 3.45,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                offset: Offset(1,3),
                                blurRadius: 2,
                                spreadRadius: 2),
                          ],
                        ),
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Row(
                                children: [
                                  Text(
                                    "Inquiry Status - ${_getPeriodName()}",
                                    style: TextStyle(
                                      color: Colors.deepPurple,
                                      fontSize: 18,
                                      fontFamily: "poppins_thin",
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Spacer(),
                                  IconButton(
                                    key: _iconKey,
                                    icon: Icon(Icons.more_vert, color: Colors.deepPurple),
                                    onPressed: () {
                                      _showPeriodMenu(_iconKey);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: BarChart(
                                BarChartData(
                                  alignment: BarChartAlignment.spaceAround,
                                  maxY: getMaxY(),
                                  minY: getMinY(),
                                  barGroups: List.generate(
                                    inquiryValuesByPeriod[_selectedPeriod].length,
                                        (index) => _barData(
                                      index,
                                      inquiryValuesByPeriod[_selectedPeriod][index],
                                      Colors.deepPurple,
                                    ),
                                  ),
                                  titlesData: FlTitlesData(
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) {
                                          return Text(
                                            labels[value.toInt()],
                                            style: TextStyle(
                                              color: Colors.deepPurple,
                                              fontSize: 12,
                                              fontFamily: "poppins_thin",
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) {
                                          final int interval = getLeftTitlesInterval();
                                          if (value % interval == 0) {
                                            return Text(
                                              value.toInt().toString(),
                                              style: TextStyle(
                                                color: Colors.deepPurple,
                                                fontFamily: "poppins_thin",
                                                fontSize: 12,
                                              ),
                                            );
                                          }
                                          return SizedBox.shrink();
                                        },
                                        reservedSize: 32,
                                      ),
                                    ),
                                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  ),
                                  borderData: FlBorderData(show: false),
                                  gridData: FlGridData(show: false),
                                  barTouchData: BarTouchData(
                                    touchTooltipData: BarTouchTooltipData(
                                      tooltipRoundedRadius: 12,
                                      getTooltipColor: (group) => Colors.white,
                                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                        return BarTooltipItem(
                                          "${rod.toY.toInt()}",
                                          TextStyle(
                                              color: Colors.deepPurple,
                                              fontSize: 16,
                                              fontFamily: "poppins_thin"),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: AutoSizeText(
                        "All Leads",
                        style: TextStyle(
                          fontFamily: "poppins_thin",
                          fontSize: isLargeScreen ? 25 : 22,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        minFontSize: 22,
                      ),
                    ),
                    ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => FollowupAndCnrScreen()),
                            );
                          },
                          child: CategoryCard(
                            icon: Icons.assignment,
                            title: 'Followup & CNR',
                          ),
                        ),
                        SizedBox(height: 12),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AllInquiriesScreen()),
                            );
                          },
                          child: CategoryCard(
                            icon: Icons.list_alt,
                            title: 'All Inquiries',
                          ),
                        ),
                        SizedBox(height: 12),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => DismissRequestScreen()),
                            );
                          },
                          child: CategoryCard(
                            icon: Icons.cancel,
                            title: 'Dismiss Request',
                          ),
                        ),
                        SizedBox(height: 12),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AssignToOtherScreen()),
                            );
                          },
                          child: CategoryCard(
                            icon: Icons.swap_horiz,
                            title: 'Assign to Other',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  String _getPeriodName() {
    switch (_selectedPeriod) {
      case 0:
        return "Today";
      case 1:
        return "Last 7 Days";
      case 2:
        return "Last Month";
      case 3:
        return "Yearly";
      default:
        return "";
    }
  }

  BarChartGroupData _barData(int x, double value, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: value,
          width: 20,
          color: color,
          borderRadius: BorderRadius.circular(16),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: getMaxY(),
            color: Colors.deepPurple.withOpacity(0.1),
          ),
        ),
      ],
    );
  }

  void _showPeriodMenu(GlobalKey key) async {
    final RenderBox renderBox = key.currentContext?.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    final selectedPeriod = await showMenu<int>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + size.height,
        0,
        0,
      ),
      items: [
        PopupMenuItem<int>(value: 0, child: Text("Today")),
        PopupMenuItem<int>(value: 1, child: Text("Last 7 Days")),
        PopupMenuItem<int>(value: 2, child: Text("Last Month")),
        PopupMenuItem<int>(value: 3, child: Text("Yearly")),
      ],
    );

    if (selectedPeriod != null) {
      setState(() {
        _selectedPeriod = selectedPeriod;
      });
    }
  }
}

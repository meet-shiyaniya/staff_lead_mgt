import 'package:auto_size_text/auto_size_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../social_module/colors/colors.dart';
import 'Inquiry Management Screens/all_inquiries_Screen.dart';
import 'Inquiry Management Screens/assign_to_other_Screen.dart';
import 'Inquiry Management Screens/contact_block_Screen.dart';
import 'Inquiry Management Screens/dismiss_request_Screen.dart';
import 'Inquiry Management Screens/followup_and_cnr_Screen.dart';
import 'Utils/Custom widgets/custom_widgets.dart';
import 'Utils/category_Card.dart';

class InquiryManagementScreen extends StatefulWidget {
  const InquiryManagementScreen({super.key});

  @override
  State<InquiryManagementScreen> createState() =>
      _InquiryManagementScreenState();
}

class _InquiryManagementScreenState extends State<InquiryManagementScreen> {
  int _selectedPeriod = 0;  // 0 - Today, 1 - Last 7 Days, 2 - Last Month, 3 - Yearly
  final GlobalKey _iconKey = GlobalKey();
  final List<List<double>> inquiryValuesByPeriod = [
    [50, 30, 15, 5,20,10],  // Today
    [220, 100, 80, 40,10,20], // Last 7 Days
    [500, 200, 150, 100,40,30], // Last Month
    [2000, 800, 600, 400,200,30], // Yearly
  ];

  final List<String> labels = ["All", "Dismiss", "Today's","Pending","Cnr", "Assigned"];
  // int _selectedPeriod = 0; // 0 - Today, 1 - Last 7 Days, 2 - Last Month, 3 - Yearly
  // final GlobalKey _iconKey = GlobalKey();
  //
  // final List<List<double>> inquiryValuesByPeriod = [
  //   [50, 30, 15, 5], // Today
  //   [220, 100, 80, 40], // Last 7 Days
  //   [500, 200, 150, 100], // Last Month
  //   [2000, 800, 600, 400], // Yearly
  // ];

  // final List<String> labels = ["All", "Dismissed", "Follow-up", "Assigned"];

  // Function to adjust the Y-axis limits dynamically based on selected period
  double getMaxY() {
    switch (_selectedPeriod) {
      case 0: return 250;  // Today
      case 1: return 250;  // Last 7 Days
      case 2: return 600;  // Last Month
      case 3: return 2500; // Yearly
      default: return 250;
    }
  }

  double getMinY() {
    return 0;
  }

  int getLeftTitlesInterval() {
    switch (_selectedPeriod) {
      case 0: return 50; // Today
      case 1: return 50; // Last 7 Days
      case 2: return 100; // Last Month
      case 3: return 500; // Yearly
      default: return 50;
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
              final screenHeight = MediaQuery.of(context).size.height;
              final isLargeScreen = screenWidth > 600;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Section
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

                    // Bar Chart Section
                    // Bar Chart Section
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Container(
                        height: 300,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.deepPurple.shade300, Colors.purple.shade200],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 8, spreadRadius: 2),
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
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Spacer(),
                                  IconButton(
                                    key: _iconKey,
                                    icon: Icon(Icons.more_vert, color: Colors.white),
                                    onPressed: () {
                                      _showPeriodMenu(_iconKey);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            // Bar Chart
                            Expanded(
                              child: BarChart(
                                BarChartData(
                                  alignment: BarChartAlignment.spaceAround,
                                  maxY: getMaxY(),  // Adjust maxY based on selected period
                                  minY: getMinY(),
                                  barGroups: List.generate(
                                    inquiryValuesByPeriod[_selectedPeriod].length,
                                        (index) => _barData(index, inquiryValuesByPeriod[_selectedPeriod][index], Colors.white),
                                  ),
                                  titlesData: FlTitlesData(
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) {
                                          return Text(
                                            labels[value.toInt()],
                                            style: TextStyle(
                                              color: Colors.white,
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
                                          // Adjust intervals for left axis
                                          final int interval = getLeftTitlesInterval();
                                          if (value % interval == 0) {
                                            return Text(
                                              value.toInt().toString(),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "poppins_thin",
                                                fontSize: 12,
                                              ),
                                            );
                                          }
                                          return SizedBox.shrink();  // No label for non-interval values
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

                    // All Leads Section
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AutoSizeText(
                        "All Leads",
                        style: TextStyle(
                          fontFamily: "poppins_thin",
                          fontSize: isLargeScreen ? 30 : 24,
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
                            Navigator.push(context, MaterialPageRoute(builder: (context) => FollowupAndCnrScreen(),));
                          },
                          child: CategoryCard(
                            icon: Icons.assignment,
                            title: 'Followup & CNR',
                          ),
                        ),
                        SizedBox(height: 12),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AllInquiriesScreen(),));
                          },
                          child: CategoryCard(
                              icon: Icons.list_alt,
                              title: 'All Inquiries'
                          ),
                        ),
                        SizedBox(height: 12),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => DismissRequestScreen(),));
                          },
                          child: CategoryCard(
                            icon: Icons.cancel,
                            title: 'Dismiss Request',
                          ),
                        ),
                        SizedBox(height: 12),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AssignToOtherScreen(),));
                          },
                          child: CategoryCard(
                              icon: Icons.swap_horiz,
                              title: 'Assign to Other'
                          ),
                        ),
                      ],
                    ),
                    // Task Containers
                    // Row(
                    //   children: [
                    //     // Left Column
                    //     Expanded(
                    //       child: Column(
                    //         children: [
                    //           GestureDetector(
                    //             onTap: () {
                    //               Navigator.push(
                    //                 context,
                    //                 MaterialPageRoute(
                    //                   builder: (context) => FollowupAndCnrScreen(),
                    //                 ),
                    //               );
                    //             },
                    //             child: TaskContainer(
                    //               title: 'Followup And \nCNR',
                    //               color: Colors.blue.shade100,
                    //               imagePath: 'asset/Inquiry_module/rating.png',
                    //               height: screenHeight * 0.25,
                    //               imageHeight: screenHeight * 0.08,
                    //               imageWidth: screenWidth * 0.2,
                    //             ),
                    //           ),
                    //           SizedBox(height: 16),
                    //           GestureDetector(
                    //             onTap: () {
                    //               Navigator.push(
                    //                 context,
                    //                 MaterialPageRoute(
                    //                   builder: (context) => AllInquiriesScreen(),
                    //                 ),
                    //               );
                    //             },
                    //             child: TaskContainer(
                    //               title: 'All Inquiries',
                    //               color: Colors.green.shade100,
                    //               imagePath: 'asset/Inquiry_module/all.png',
                    //               height: screenHeight * 0.18,
                    //               imageHeight: screenHeight * 0.06,
                    //               imageWidth: screenWidth * 0.18,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //     SizedBox(width: 16),
                    //     // Right Column
                    //     Expanded(
                    //       child: Column(
                    //         children: [
                    //           GestureDetector(
                    //             onTap: () {
                    //               Navigator.push(
                    //                 context,
                    //                 MaterialPageRoute(
                    //                   builder: (context) => DismissRequestScreen(),
                    //                 ),
                    //               );
                    //             },
                    //             child: TaskContainer(
                    //               title: 'Dismiss \n Request',
                    //               color: Colors.purple.shade100,
                    //               imagePath: 'asset/Inquiry_module/job.png',
                    //               height: screenHeight * 0.22,
                    //               imageHeight: screenHeight * 0.06,
                    //               imageWidth: screenWidth * 0.18,
                    //             ),
                    //           ),
                    //           SizedBox(height: 16),
                    //           GestureDetector(
                    //             onTap: () {
                    //               Navigator.push(
                    //                 context,
                    //                 MaterialPageRoute(
                    //                   builder: (context) => AssignToOtherScreen(),
                    //                 ),
                    //               );
                    //             },
                    //             child: TaskContainer(
                    //               title: 'Assign to Other',
                    //               color: Colors.orange.shade100,
                    //               imagePath: 'asset/Inquiry_module/other.png',
                    //               height: screenHeight * 0.22,
                    //               imageHeight: screenHeight * 0.06,
                    //               imageWidth: screenWidth * 0.20,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  SizedBox(height: 10,)
                  ],
                ),

              );
            },
          ),
        ),
      ),
    );
  }

  // BarChartGroupData _barData(int x, double value, Color color) {
  //   return BarChartGroupData(
  //     x: x,
  //     barRods: [
  //       BarChartRodData(
  //         toY: value,
  //         width: 12,
  //         color: color,
  //         borderRadius: BorderRadius.circular(16),
  //         backDrawRodData: BackgroundBarChartRodData(
  //           show: true,
  //           toY: 250,
  //           color: Colors.white.withOpacity(0.2),
  //         ),
  //       ),
  //     ],
  //   );
  // }
  String _getPeriodName() {
    switch (_selectedPeriod) {
      case 0: return "Today";
      case 1: return "Last 7 Days";
      case 2: return "Last Month";
      case 3: return "Yearly";
      default: return "";
    }
  }

  // Data for the bar chart
  BarChartGroupData _barData(int x, double value, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: value,
          width: 12,
          color: color,
          borderRadius: BorderRadius.circular(16),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: getMaxY(),  // Set the background rod's maximum Y to match the chart's maxY
            color: Colors.white.withOpacity(0.2),
          ),
        ),
      ],
    );
  }

  void _showPeriodMenu(GlobalKey key) async {
    final RenderBox renderBox = key.currentContext?.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero); // Get the position of the icon
    final size = renderBox.size; // Get the size of the icon

    final selectedPeriod = await showMenu<int>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx, // The X position of the icon
        position.dy + size.height, // The Y position of the icon plus the height of the icon
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

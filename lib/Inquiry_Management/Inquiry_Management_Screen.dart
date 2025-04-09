import 'package:auto_size_text/auto_size_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../social_module/colors/colors.dart';
import 'Inquiry Management Screens/all_inquiries_Screen.dart';
import 'Inquiry Management Screens/assign_to_other_Screen.dart';
import 'Inquiry Management Screens/dismiss_request_Screen.dart';
import 'Inquiry Management Screens/followup_and_cnr_Screen.dart';
import 'Utils/Custom widgets/category_Card.dart';
// import 'Utils/category_Card.dart';

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

  final List<String> labels = [
    "Inquiries",
    "Visit",
    "Booking\nCancel",
    "Conversion"
  ];

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

  void _showPeriodMenu() {
    final List<String> _periodNames = [
      "Today",
      "Last 7 Days",
      "Last Month",
      "Yearly"
    ];

    // Get the position and size of the IconButton using its GlobalKey
    final RenderBox? button = _iconKey.currentContext
        ?.findRenderObject() as RenderBox?;
    if (button == null) return; // Exit if the button isn't rendered yet

    final Offset buttonPosition = button.localToGlobal(
        Offset.zero); // Top-left corner of the button
    final Size buttonSize = button.size; // Width and height of the button

    // Calculate the position to show the menu below the button
    final RelativeRect position = RelativeRect.fromLTRB(
      buttonPosition.dx, // Left edge aligned with the button's left
      buttonPosition.dy + buttonSize.height, // Top starts below the button
      MediaQuery
          .of(context)
          .size
          .width - (buttonPosition.dx + buttonSize.width), // Right edge
      0, // Bottom (not strictly needed, but kept for completeness)
    );

    showMenu(
      context: context,
      position: position,
      // Use dynamic position
      color: Colors.white,
      elevation: 4,
      // Add slight elevation for a polished look
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
            10), // Rounded corners for modern UI
      ),
      items: [
        for (int i = 0; i < 4; i++)
          PopupMenuItem(
            value: i,
            child: Text(
              _periodNames[i],
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.bold,
                fontSize: 13,
                fontFamily: "poppins_thin", // Consistent with your chart typography
              ),
            ),
          ),
      ],
    ).then((value) {
      if (value != null) {
        setState(() {
          _selectedPeriod = value;
        });
      }
    });
  }

  Widget _buildInquiryStatusChart() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 12,
            spreadRadius: 3,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Inquiry Status - ${_getPeriodName()}",
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontFamily: "poppins_thin",
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              IconButton(
                key: _iconKey,
                icon: const Icon(Icons.more_vert, color: Colors.black54),
                onPressed: _showPeriodMenu,
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 260,
            // Increased height slightly to give more room for bottom labels
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceEvenly,
                maxY: getMaxY(),
                // Dynamic max Y value
                minY: getMinY(),
                // Fixed min Y value
                gridData: const FlGridData(
                  show: false, // Disable grid lines
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: getLeftTitlesInterval().toDouble(),
                      getTitlesWidget: (value, meta) =>
                          Text(
                            value.toInt().toString(),
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 10,
                              fontFamily: "poppins_thin",
                            ),
                          ),
                      reservedSize: 27,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      // Added reservedSize to ensure full label visibility
                      getTitlesWidget: (value, meta) =>
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            // Increased padding slightly
                            child: Text(
                              labels[value.toInt()],
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 9.8,
                                fontFamily: "poppins_thin",
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                    ),
                  ),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                // No border for a clean look
                barGroups: List.generate(
                  labels.length,
                      (index) =>
                      BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: inquiryValuesByPeriod[_selectedPeriod][index],
                            width: 26,
                            // Wider bars for a bold look
                            gradient: LinearGradient(
                              colors: [
                                Colors.deepPurple.shade700,
                                Colors.purple.shade900,
                                Colors.deepPurple.shade700,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(10)),
                            backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: getMaxY(),
                              color: Colors.white, // Subtle background bar
                            ),
                          ),
                        ],
                      ),
                ),
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (group) =>
                        Colors.deepPurple.shade800.withOpacity(0.9),
                    tooltipPadding: const EdgeInsets.all(8),
                    tooltipMargin: 12,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${labels[group.x]}\n',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: rod.toY.toString(),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              swapAnimationDuration: const Duration(milliseconds: 600),
              // Smooth animation
              swapAnimationCurve: Curves.easeInOutCubic,
            ),
          ),
        ],
      ),
    );
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
                    _buildInquiryStatusChart(),


                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 16.0),
                    //   child: Container(
                    //     margin: EdgeInsets.only(left: 10,right: 10),
                    //     height: MediaQuery.of(context).size.height / 3.45,
                    //     width: double.infinity,
                    //     decoration: BoxDecoration(
                    //       color: Colors.deepPurple.shade200,
                    //       borderRadius: BorderRadius.circular(20),
                    //       // boxShadow: [
                    //       //   BoxShadow(
                    //       //       color: Colors.black12,
                    //       //       offset: Offset(1,3),
                    //       //       blurRadius: 2,
                    //       //       spreadRadius: 2),
                    //       // ],
                    //     ),
                    //     padding: EdgeInsets.all(16),
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.center,
                    //       children: [
                    //         Padding(
                    //           padding: const EdgeInsets.only(bottom: 16),
                    //           child: Row(
                    //             children: [
                    //               Text(
                    //                 "Inquiry Status - ${_getPeriodName()}",
                    //                 style: TextStyle(
                    //                   color: Colors.white,
                    //                   fontSize: 16,
                    //                   fontFamily: "poppins_thin",
                    //                   fontWeight: FontWeight.bold,
                    //                 ),
                    //               ),
                    //               Spacer(),
                    //               IconButton(
                    //                 key: _iconKey,
                    //                 icon: Icon(Icons.more_vert, color: Colors.white),
                    //                 onPressed: () {
                    //                   _showPeriodMenu(_iconKey);
                    //                 },
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //         Expanded(
                    //           child: BarChart(
                    //             BarChartData(
                    //               alignment: BarChartAlignment.spaceAround,
                    //               maxY: getMaxY(),
                    //               minY: getMinY(),
                    //               barGroups: List.generate(
                    //                 inquiryValuesByPeriod[_selectedPeriod].length,
                    //                     (index) => _barData(
                    //                   index,
                    //                   inquiryValuesByPeriod[_selectedPeriod][index],
                    //                   Colors.white,
                    //                 ),
                    //               ),
                    //               titlesData: FlTitlesData(
                    //                 bottomTitles: AxisTitles(
                    //                   sideTitles: SideTitles(
                    //                     showTitles: true,
                    //                     getTitlesWidget: (value, meta) {
                    //                       return Text(
                    //                         labels[value.toInt()],
                    //                         style: TextStyle(
                    //                           color: Colors.white,
                    //                           fontSize: 12,
                    //                           fontFamily: "poppins_thin",
                    //                         ),
                    //                       );
                    //                     },
                    //                   ),
                    //                 ),
                    //                 leftTitles: AxisTitles(
                    //                   sideTitles: SideTitles(
                    //                     showTitles: true,
                    //                     getTitlesWidget: (value, meta) {
                    //                       final int interval = getLeftTitlesInterval();
                    //                       if (value % interval == 0) {
                    //                         return Text(
                    //                           value.toInt().toString(),
                    //                           style: TextStyle(
                    //                             color: Colors.white,
                    //                             fontFamily: "poppins_thin",
                    //                             fontSize: 12,
                    //                           ),
                    //                         );
                    //                       }
                    //                       return SizedBox.shrink();
                    //                     },
                    //                     reservedSize: 32,
                    //                   ),
                    //                 ),
                    //                 rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    //                 topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    //               ),
                    //               borderData: FlBorderData(show: false),
                    //               gridData: FlGridData(show: false),
                    //               barTouchData: BarTouchData(
                    //                 touchTooltipData: BarTouchTooltipData(
                    //                   tooltipRoundedRadius: 12,
                    //                   getTooltipColor: (group) => Colors.white,
                    //                   getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    //                     return BarTooltipItem(
                    //                       "${rod.toY.toInt()}",
                    //                       TextStyle(
                    //                           color: Colors.deepPurple,
                    //                           fontSize: 16,
                    //                           fontFamily: "poppins_thin"),
                    //                     );
                    //                   },
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AutoSizeText(
                        "All Leads",
                        style: TextStyle(
                          fontFamily: "poppins_thin",
                          fontSize: isLargeScreen ? 22 : 20,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        minFontSize: 22,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    FollowupAndCnrScreen(0)),
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
                                MaterialPageRoute(
                                    builder: (context) => AllInquiriesScreen()),
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
                                MaterialPageRoute(
                                    builder: (context) => DismissRequestScreen()),
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
                                MaterialPageRoute(
                                    builder: (context) => AssignToOtherScreen()),
                              );
                            },
                            child: CategoryCard(
                              icon: Icons.swap_horiz,
                              title: 'Assign to Other',
                            ),
                          ),
                        ],
                      ),
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
            color: Colors.deepPurple.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

}

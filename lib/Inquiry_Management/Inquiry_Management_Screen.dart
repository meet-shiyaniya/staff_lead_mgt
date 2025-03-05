import 'package:auto_size_text/auto_size_text.dart';
import 'package:hr_app/Inquiry_Management/Model/Api%20Model/inquiry_Option_Model.dart';
import 'package:hr_app/staff_HRM_module/Screen/Color/app_Color.dart';
import 'package:flutter/material.dart';
import 'Inquiry Management Screens/all_inquiries_Screen.dart';
import 'Inquiry Management Screens/followup_and_cnr_Screen.dart';
import 'package:fl_chart/fl_chart.dart';

class InquiryManagementScreen extends StatefulWidget {
  const InquiryManagementScreen({super.key});

  @override
  State<InquiryManagementScreen> createState() => _InquiryManagementScreenState();
}

class _InquiryManagementScreenState extends State<InquiryManagementScreen> {

  List<inquiryOptionModel> inquiryOptionList = [

    inquiryOptionModel("Followup & CNR", Icons.assignment, Colors.purple.shade100),
    inquiryOptionModel("All Inquiries", Icons.list_alt, Colors.blue.shade100),
    inquiryOptionModel("Dismiss Request", Icons.cancel, Colors.indigo.shade100),
    inquiryOptionModel("Assign to Other", Icons.swap_horiz, Colors.deepPurple.shade100),

  ];

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
      case 0: return 200;
      case 1: return 250;
      case 2: return 600;
      case 3: return 2500;
      default: return 250;
    }
  }

  double getMinY() => 0;

  int getLeftTitlesInterval() {
    switch (_selectedPeriod) {
      case 0: return 50;
      case 1: return 50;
      case 2: return 100;
      case 3: return 500;
      default: return 50;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isLargeScreen = constraints.maxWidth > 600;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    "Effortless Inquiry ",
                    style: TextStyle(
                        fontSize: isLargeScreen ? 20 : 16,
                        fontFamily: "poppins_light",
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w600),
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
                  const SizedBox(height: 16),
                  _buildInquiryStatusChart(),
                  SizedBox(height: 4,),
                  _buildLeadsSection(),
                  SizedBox(height: 20,),
                ],
              ),
            );
          },
        ),
      ),
    );
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
            height: 260, // Increased height slightly to give more room for bottom labels
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceEvenly,
                maxY: getMaxY(), // Dynamic max Y value
                minY: getMinY(), // Fixed min Y value
                gridData: const FlGridData(
                  show: false, // Disable grid lines
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: getLeftTitlesInterval().toDouble(),
                      getTitlesWidget: (value, meta) => Text(
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
                      reservedSize: 40, // Added reservedSize to ensure full label visibility
                      getTitlesWidget: (value, meta) => Padding(
                        padding: const EdgeInsets.only(top: 12.0), // Increased padding slightly
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
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false), // No border for a clean look
                barGroups: List.generate(
                  labels.length,
                      (index) => BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: inquiryValuesByPeriod[_selectedPeriod][index],
                        width: 26, // Wider bars for a bold look
                        gradient: LinearGradient(
                          colors: [
                            Colors.deepPurple.shade700,
                            Colors.purple.shade900,
                            Colors.deepPurple.shade700,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
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
                    getTooltipColor: (group) => Colors.deepPurple.shade800.withOpacity(0.9),
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
              swapAnimationDuration: const Duration(milliseconds: 600), // Smooth animation
              swapAnimationCurve: Curves.easeInOutCubic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeadsSection() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8, top: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AutoSizeText(
            "All Leads",
            style: TextStyle(
              fontFamily: "poppins_thin",
              fontSize: 16,
              color: Colors.black,
            ),
            maxLines: 1,
            minFontSize: 16,
          ),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(), // Prevents scrolling within GridView
            itemCount: inquiryOptionList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 columns
              crossAxisSpacing: 3,
              mainAxisSpacing: 14,
              mainAxisExtent: 146, // Adjusted for a good look
            ),
            itemBuilder: (context, index) {
              return _buildCategoryCard(inquiryOptionList[index], context);
            },
          ),
        ],
      ),
    );
  }

  String _getPeriodName() {
    return ["Today", "Last 7 Days", "Last Month", "Yearly"][_selectedPeriod];
  }

  void _showPeriodMenu() {
    final List<String> _periodNames = ["Today", "Last 7 Days", "Last Month", "Yearly"];

    // Get the position and size of the IconButton using its GlobalKey
    final RenderBox? button = _iconKey.currentContext?.findRenderObject() as RenderBox?;
    if (button == null) return; // Exit if the button isn't rendered yet

    final Offset buttonPosition = button.localToGlobal(Offset.zero); // Top-left corner of the button
    final Size buttonSize = button.size; // Width and height of the button

    // Calculate the position to show the menu below the button
    final RelativeRect position = RelativeRect.fromLTRB(
      buttonPosition.dx, // Left edge aligned with the button's left
      buttonPosition.dy + buttonSize.height, // Top starts below the button
      MediaQuery.of(context).size.width - (buttonPosition.dx + buttonSize.width), // Right edge
      0, // Bottom (not strictly needed, but kept for completeness)
    );

    showMenu(
      context: context,
      position: position, // Use dynamic position
      color: Colors.white,
      elevation: 4, // Add slight elevation for a polished look
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Rounded corners for modern UI
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

}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;

}

Widget _buildCategoryCard(inquiryOptionModel option, BuildContext context) {
  return GestureDetector(
    onTap: () {
      // Handle navigation based on title
      if (option.title == "Followup & CNR") {
        Navigator.push(context, MaterialPageRoute(builder: (_) => FollowupAndCnrScreen()));
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (_) => AllInquiriesScreen()));
      }
      // Add other navigation cases if needed
    },
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: option.color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            spreadRadius: 2,
            offset: Offset(1, 3),
          ),
        ],
      ),
      padding: EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            radius: 28,
            child: Icon(
              option.icon,
              size: 25,
              color: Colors.deepPurple.shade500,
            ),
          ),
          SizedBox(height: 10),
          Text(
            option.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontFamily: "poppins_thin",
              color: Colors.black,
            ),
          ),
        ],
      ),
    ),
  );
}
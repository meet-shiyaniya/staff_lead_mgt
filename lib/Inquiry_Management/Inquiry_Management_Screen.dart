import 'package:auto_size_text/auto_size_text.dart';
import 'package:hr_app/Inquiry_Management/Model/Api%20Model/inquiry_Option_Model.dart';
import 'package:hr_app/staff_HRM_module/Screen/Color/app_Color.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'Inquiry Management Screens/all_inquiries_Screen.dart';
import 'Inquiry Management Screens/followup_and_cnr_Screen.dart';

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
                  _buildLeadsSection(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInquiryStatusChart() {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "Inquiry Status - ${_getPeriodName()}",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: "poppins_thin"
              ),
            ),
            const Spacer(),
            IconButton(
              key: _iconKey,
              icon: const Icon(Icons.more_vert, color: Colors.black),
              onPressed: _showPeriodMenu,
            ),
          ],
        ),
        SizedBox(
          height: 200,
          child: SfCartesianChart(
            plotAreaBorderWidth: 0,
            primaryXAxis: CategoryAxis(
              majorGridLines: MajorGridLines(width: 0),
              labelStyle: TextStyle(color: Colors.grey.shade700, fontSize: 11, fontWeight: FontWeight.w500),
            ),
            primaryYAxis: NumericAxis(
              minimum: getMinY().toDouble(),
              maximum: getMaxY().toDouble(),
              interval: getLeftTitlesInterval().toDouble(),
              majorGridLines: MajorGridLines(width: 0),
              labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 11, fontWeight: FontWeight.w500),
            ),
            series: <CartesianSeries<ChartData, String>>[
              ColumnSeries<ChartData, String>(
                dataSource: List.generate(
                  labels.length,
                      (index) => ChartData(
                    labels[index],
                    inquiryValuesByPeriod[_selectedPeriod][index].toDouble(),
                  ),
                ),
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y,
                color: Colors.deepPurple.shade500,
                width: 0.5,
                isTrackVisible: true,
                trackBorderWidth: 0,
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF512DA8), // Deep Purple
                    Color(0xFF673AB7), // Slightly lighter Purple
                    Color(0xFF9575CD), // Soft Lavender/Purple shade
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                trackColor: Colors.indigo.shade50,
                trackBorderColor: Colors.transparent,
                borderColor: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                dataLabelSettings: const DataLabelSettings(isVisible: true),
              ),
            ],
          ),
        ),
      ],
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

    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 200, 10, 0),
      color: appColor.subFavColor,
      items: [
        for (int i = 0; i < 4; i++)
          PopupMenuItem(value: i, child: Text(_periodNames[i], style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold, fontSize: 13.5),)),
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
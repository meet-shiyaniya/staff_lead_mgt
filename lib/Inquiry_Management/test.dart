// // // // import 'package:auto_size_text/auto_size_text.dart';
// // // // import 'package:fl_chart/fl_chart.dart';
// // // // import 'package:flutter/material.dart';
// // // // import 'Inquiry Management Screens/all_inquiries_Screen.dart';
// // // // import 'Inquiry Management Screens/assign_to_other_Screen.dart';
// // // // import 'Inquiry Management Screens/dismiss_request_Screen.dart';
// // // // import 'Inquiry Management Screens/followup_and_cnr_Screen.dart';
// // // // import 'Utils/Custom widgets/custom_widgets.dart';
// // // // import 'Utils/category_Card.dart';
// // // //
// // // // class TestScreen extends StatefulWidget {
// // // //   const TestScreen({super.key});
// // // //
// // // //   @override
// // // //   State<TestScreen> createState() => _TestScreenState();
// // // // }
// // // //
// // // // class _TestScreenState extends State<TestScreen> {
// // // //   int _selectedPeriod = 0;  // 0 - Today, 1 - Last 7 Days, 2 - Last Month, 3 - Yearly
// // // //   final GlobalKey _iconKey = GlobalKey();
// // // //   final List<List<double>> inquiryValuesByPeriod = [
// // // //     [50, 30, 15, 5,20,10],  // Today
// // // //     [220, 100, 80, 40,10,20], // Last 7 Days
// // // //     [500, 200, 150, 100,40,30], // Last Month
// // // //     [2000, 800, 600, 400,200,30], // Yearly
// // // //   ];
// // // //
// // // //   final List<String> labels = ["All", "Dismiss", "Today's","Pending","Cnr", "Assigned"];
// // // //   // int _selectedPeriod = 0; // 0 - Today, 1 - Last 7 Days, 2 - Last Month, 3 - Yearly
// // // //   // final GlobalKey _iconKey = GlobalKey();
// // // //   //
// // // //   // final List<List<double>> inquiryValuesByPeriod = [
// // // //   //   [50, 30, 15, 5], // Today
// // // //   //   [220, 100, 80, 40], // Last 7 Days
// // // //   //   [500, 200, 150, 100], // Last Month
// // // //   //   [2000, 800, 600, 400], // Yearly
// // // //   // ];
// // // //
// // // //   // final List<String> labels = ["All", "Dismissed", "Follow-up", "Assigned"];
// // // //
// // // //   // Function to adjust the Y-axis limits dynamically based on selected period
// // // //   double getMaxY() {
// // // //     switch (_selectedPeriod) {
// // // //       case 0: return 250;  // Today
// // // //       case 1: return 250;  // Last 7 Days
// // // //       case 2: return 600;  // Last Month
// // // //       case 3: return 2500; // Yearly
// // // //       default: return 250;
// // // //     }
// // // //   }
// // // //
// // // //   double getMinY() {
// // // //     return 0;
// // // //   }
// // // //
// // // //   int getLeftTitlesInterval() {
// // // //     switch (_selectedPeriod) {
// // // //       case 0: return 50; // Today
// // // //       case 1: return 50; // Last 7 Days
// // // //       case 2: return 100; // Last Month
// // // //       case 3: return 500; // Yearly
// // // //       default: return 50;
// // // //     }
// // // //   }
// // // //
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       backgroundColor: Colors.white,
// // // //       body: SafeArea(
// // // //         child: Padding(
// // // //           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 22),
// // // //           child: LayoutBuilder(
// // // //             builder: (context, constraints) {
// // // //               final screenWidth = constraints.maxWidth;
// // // //               final screenHeight = MediaQuery.of(context).size.height;
// // // //               final isLargeScreen = screenWidth > 600;
// // // //
// // // //               return SingleChildScrollView(
// // // //                 child: Column(
// // // //                   crossAxisAlignment: CrossAxisAlignment.start,
// // // //                   children: [
// // // //                     // Title Section
// // // //                     AutoSizeText(
// // // //                       "Effortless Inquiry ",
// // // //                       style: TextStyle(
// // // //                           fontSize: isLargeScreen ? 20 : 16,
// // // //                           fontFamily: "poppins_light"),
// // // //                       maxLines: 1,
// // // //                       minFontSize: 18,
// // // //                     ),
// // // //                     AutoSizeText(
// // // //                       "Tracking & Management",
// // // //                       style: TextStyle(
// // // //                           fontSize: isLargeScreen ? 24 : 20,
// // // //                           fontFamily: "poppins_thin"),
// // // //                       maxLines: 1,
// // // //                       minFontSize: 22,
// // // //                     ),
// // // //
// // // //                     // Bar Chart Section
// // // //                     // Bar Chart Section
// // // //                     Padding(
// // // //                       padding: const EdgeInsets.symmetric(vertical: 16.0),
// // // //                       child: Container(
// // // //                         height: 300,
// // // //                         width: double.infinity,
// // // //                         decoration: BoxDecoration(
// // // //                           gradient: LinearGradient(
// // // //                             colors: [Colors.deepPurple.shade300, Colors.purple.shade200],
// // // //                             begin: Alignment.topLeft,
// // // //                             end: Alignment.bottomRight,
// // // //                           ),
// // // //                           borderRadius: BorderRadius.circular(20),
// // // //                           boxShadow: [
// // // //                             BoxShadow(color: Colors.black12, blurRadius: 8, spreadRadius: 2),
// // // //                           ],
// // // //                         ),
// // // //                         padding: EdgeInsets.all(16),
// // // //                         child: Column(
// // // //                           crossAxisAlignment: CrossAxisAlignment.center,
// // // //                           children: [
// // // //                             Padding(
// // // //                               padding: const EdgeInsets.only(bottom: 16),
// // // //                               child: Row(
// // // //                                 children: [
// // // //                                   Text(
// // // //                                     "Inquiry Status - ${_getPeriodName()}",
// // // //                                     style: TextStyle(
// // // //                                       color: Colors.white,
// // // //                                       fontSize: 18,
// // // //                                       fontWeight: FontWeight.bold,
// // // //                                     ),
// // // //                                   ),
// // // //                                   Spacer(),
// // // //                                   IconButton(
// // // //                                     key: _iconKey,
// // // //                                     icon: Icon(Icons.more_vert, color: Colors.white),
// // // //                                     onPressed: () {
// // // //                                       _showPeriodMenu(_iconKey);
// // // //                                     },
// // // //                                   ),
// // // //                                 ],
// // // //                               ),
// // // //                             ),
// // // //                             // Bar Chart
// // // //                             Expanded(
// // // //                               child: BarChart(
// // // //                                 BarChartData(
// // // //                                   alignment: BarChartAlignment.spaceAround,
// // // //                                   maxY: getMaxY(),  // Adjust maxY based on selected period
// // // //                                   minY: getMinY(),
// // // //                                   barGroups: List.generate(
// // // //                                     inquiryValuesByPeriod[_selectedPeriod].length,
// // // //                                         (index) => _barData(index, inquiryValuesByPeriod[_selectedPeriod][index], Colors.white),
// // // //                                   ),
// // // //                                   titlesData: FlTitlesData(
// // // //                                     bottomTitles: AxisTitles(
// // // //                                       sideTitles: SideTitles(
// // // //                                         showTitles: true,
// // // //                                         getTitlesWidget: (value, meta) {
// // // //                                           return Text(
// // // //                                             labels[value.toInt()],
// // // //                                             style: TextStyle(
// // // //                                               color: Colors.white,
// // // //                                               fontSize: 12,
// // // //                                               fontFamily: "poppins_thin",
// // // //                                             ),
// // // //                                           );
// // // //                                         },
// // // //                                       ),
// // // //                                     ),
// // // //                                     leftTitles: AxisTitles(
// // // //                                       sideTitles: SideTitles(
// // // //                                         showTitles: true,
// // // //                                         getTitlesWidget: (value, meta) {
// // // //                                           // Adjust intervals for left axis
// // // //                                           final int interval = getLeftTitlesInterval();
// // // //                                           if (value % interval == 0) {
// // // //                                             return Text(
// // // //                                               value.toInt().toString(),
// // // //                                               style: TextStyle(
// // // //                                                 color: Colors.white,
// // // //                                                 fontFamily: "poppins_thin",
// // // //                                                 fontSize: 12,
// // // //                                               ),
// // // //                                             );
// // // //                                           }
// // // //                                           return SizedBox.shrink();  // No label for non-interval values
// // // //                                         },
// // // //                                         reservedSize: 32,
// // // //                                       ),
// // // //                                     ),
// // // //                                     rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
// // // //                                     topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
// // // //                                   ),
// // // //                                   borderData: FlBorderData(show: false),
// // // //                                   gridData: FlGridData(show: false),
// // // //                                   barTouchData: BarTouchData(
// // // //                                     touchTooltipData: BarTouchTooltipData(
// // // //                                       tooltipRoundedRadius: 12,
// // // //                                       getTooltipColor: (group) => Colors.white,
// // // //                                       getTooltipItem: (group, groupIndex, rod, rodIndex) {
// // // //                                         return BarTooltipItem(
// // // //                                           "${rod.toY.toInt()}",
// // // //                                           TextStyle(
// // // //                                               color: Colors.deepPurple,
// // // //                                               fontSize: 16,
// // // //                                               fontFamily: "poppins_thin"),
// // // //                                         );
// // // //                                       },
// // // //                                     ),
// // // //                                   ),
// // // //                                 ),
// // // //                               ),
// // // //                             ),
// // // //                           ],
// // // //                         ),
// // // //                       ),
// // // //                     ),
// // // //
// // // //                     // All Leads Section
// // // //                     Padding(
// // // //                       padding: const EdgeInsets.all(8.0),
// // // //                       child: AutoSizeText(
// // // //                         "All Leads",
// // // //                         style: TextStyle(
// // // //                           fontFamily: "poppins_thin",
// // // //                           fontSize: isLargeScreen ? 30 : 24,
// // // //                           color: Colors.black,
// // // //                         ),
// // // //                         maxLines: 1,
// // // //                         minFontSize: 22,
// // // //                       ),
// // // //                     ),
// // // //                     ListView(
// // // //                       shrinkWrap: true,
// // // //                       physics: NeverScrollableScrollPhysics(),
// // // //                       children: [
// // // //                         GestureDetector(
// // // //                           onTap: () {
// // // //                             Navigator.push(context, MaterialPageRoute(builder: (context) => FollowupAndCnrScreen(),));
// // // //                           },
// // // //                           child: CategoryCard(
// // // //                             icon: Icons.assignment,
// // // //                             title: 'Followup & CNR',
// // // //                           ),
// // // //                         ),
// // // //                         SizedBox(height: 12),
// // // //                         GestureDetector(
// // // //                           onTap: () {
// // // //                             Navigator.push(context, MaterialPageRoute(builder: (context) => AllInquiriesScreen(),));
// // // //                           },
// // // //                           child: CategoryCard(
// // // //                             icon: Icons.list_alt,
// // // //                             title: 'All Inquiries'
// // // //                           ),
// // // //                         ),
// // // //                         SizedBox(height: 12),
// // // //                         GestureDetector(
// // // //                           onTap: () {
// // // //                             Navigator.push(context, MaterialPageRoute(builder: (context) => DismissRequestScreen(),));
// // // //                           },
// // // //                           child: CategoryCard(
// // // //                             icon: Icons.cancel,
// // // //                             title: 'Dismiss Request',
// // // //                           ),
// // // //                         ),
// // // //                         SizedBox(height: 12),
// // // //                         GestureDetector(
// // // //                           onTap: () {
// // // //                             Navigator.push(context, MaterialPageRoute(builder: (context) => AssignToOtherScreen(),));
// // // //                           },
// // // //                           child: CategoryCard(
// // // //                             icon: Icons.swap_horiz,
// // // //                             title: 'Assign to Other'
// // // //                           ),
// // // //                         ),
// // // //                       ],
// // // //                     ),
// // // //                     // Task Containers
// // // //                     // Row(
// // // //                     //   children: [
// // // //                     //     // Left Column
// // // //                     //     Expanded(
// // // //                     //       child: Column(
// // // //                     //         children: [
// // // //                     //           GestureDetector(
// // // //                     //             onTap: () {
// // // //                     //               Navigator.push(
// // // //                     //                 context,
// // // //                     //                 MaterialPageRoute(
// // // //                     //                   builder: (context) => FollowupAndCnrScreen(),
// // // //                     //                 ),
// // // //                     //               );
// // // //                     //             },
// // // //                     //             child: TaskContainer(
// // // //                     //               title: 'Followup And \nCNR',
// // // //                     //               color: Colors.blue.shade100,
// // // //                     //               imagePath: 'asset/Inquiry_module/rating.png',
// // // //                     //               height: screenHeight * 0.25,
// // // //                     //               imageHeight: screenHeight * 0.08,
// // // //                     //               imageWidth: screenWidth * 0.2,
// // // //                     //             ),
// // // //                     //           ),
// // // //                     //           SizedBox(height: 16),
// // // //                     //           GestureDetector(
// // // //                     //             onTap: () {
// // // //                     //               Navigator.push(
// // // //                     //                 context,
// // // //                     //                 MaterialPageRoute(
// // // //                     //                   builder: (context) => AllInquiriesScreen(),
// // // //                     //                 ),
// // // //                     //               );
// // // //                     //             },
// // // //                     //             child: TaskContainer(
// // // //                     //               title: 'All Inquiries',
// // // //                     //               color: Colors.green.shade100,
// // // //                     //               imagePath: 'asset/Inquiry_module/all.png',
// // // //                     //               height: screenHeight * 0.18,
// // // //                     //               imageHeight: screenHeight * 0.06,
// // // //                     //               imageWidth: screenWidth * 0.18,
// // // //                     //             ),
// // // //                     //           ),
// // // //                     //         ],
// // // //                     //       ),
// // // //                     //     ),
// // // //                     //     SizedBox(width: 16),
// // // //                     //     // Right Column
// // // //                     //     Expanded(
// // // //                     //       child: Column(
// // // //                     //         children: [
// // // //                     //           GestureDetector(
// // // //                     //             onTap: () {
// // // //                     //               Navigator.push(
// // // //                     //                 context,
// // // //                     //                 MaterialPageRoute(
// // // //                     //                   builder: (context) => DismissRequestScreen(),
// // // //                     //                 ),
// // // //                     //               );
// // // //                     //             },
// // // //                     //             child: TaskContainer(
// // // //                     //               title: 'Dismiss \n Request',
// // // //                     //               color: Colors.purple.shade100,
// // // //                     //               imagePath: 'asset/Inquiry_module/job.png',
// // // //                     //               height: screenHeight * 0.22,
// // // //                     //               imageHeight: screenHeight * 0.06,
// // // //                     //               imageWidth: screenWidth * 0.18,
// // // //                     //             ),
// // // //                     //           ),
// // // //                     //           SizedBox(height: 16),
// // // //                     //           GestureDetector(
// // // //                     //             onTap: () {
// // // //                     //               Navigator.push(
// // // //                     //                 context,
// // // //                     //                 MaterialPageRoute(
// // // //                     //                   builder: (context) => AssignToOtherScreen(),
// // // //                     //                 ),
// // // //                     //               );
// // // //                     //             },
// // // //                     //             child: TaskContainer(
// // // //                     //               title: 'Assign to Other',
// // // //                     //               color: Colors.orange.shade100,
// // // //                     //               imagePath: 'asset/Inquiry_module/other.png',
// // // //                     //               height: screenHeight * 0.22,
// // // //                     //               imageHeight: screenHeight * 0.06,
// // // //                     //               imageWidth: screenWidth * 0.20,
// // // //                     //             ),
// // // //                     //           ),
// // // //                     //         ],
// // // //                     //       ),
// // // //                     //     ),
// // // //                     //   ],
// // // //                     // ),
// // // //                   ],
// // // //                 ),
// // // //               );
// // // //             },
// // // //           ),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // //
// // // //   // BarChartGroupData _barData(int x, double value, Color color) {
// // // //   //   return BarChartGroupData(
// // // //   //     x: x,
// // // //   //     barRods: [
// // // //   //       BarChartRodData(
// // // //   //         toY: value,
// // // //   //         width: 12,
// // // //   //         color: color,
// // // //   //         borderRadius: BorderRadius.circular(16),
// // // //   //         backDrawRodData: BackgroundBarChartRodData(
// // // //   //           show: true,
// // // //   //           toY: 250,
// // // //   //           color: Colors.white.withOpacity(0.2),
// // // //   //         ),
// // // //   //       ),
// // // //   //     ],
// // // //   //   );
// // // //   // }
// // // //   String _getPeriodName() {
// // // //     switch (_selectedPeriod) {
// // // //       case 0: return "Today";
// // // //       case 1: return "Last 7 Days";
// // // //       case 2: return "Last Month";
// // // //       case 3: return "Yearly";
// // // //       default: return "";
// // // //     }
// // // //   }
// // // //
// // // //   // Data for the bar chart
// // // //   BarChartGroupData _barData(int x, double value, Color color) {
// // // //     return BarChartGroupData(
// // // //       x: x,
// // // //       barRods: [
// // // //         BarChartRodData(
// // // //           toY: value,
// // // //           width: 12,
// // // //           color: color,
// // // //           borderRadius: BorderRadius.circular(16),
// // // //           backDrawRodData: BackgroundBarChartRodData(
// // // //             show: true,
// // // //             toY: getMaxY(),  // Set the background rod's maximum Y to match the chart's maxY
// // // //             color: Colors.white.withOpacity(0.2),
// // // //           ),
// // // //         ),
// // // //       ],
// // // //     );
// // // //   }
// // // //
// // // //   void _showPeriodMenu(GlobalKey key) async {
// // // //     final RenderBox renderBox = key.currentContext?.findRenderObject() as RenderBox;
// // // //     final position = renderBox.localToGlobal(Offset.zero); // Get the position of the icon
// // // //     final size = renderBox.size; // Get the size of the icon
// // // //
// // // //     final selectedPeriod = await showMenu<int>(
// // // //       context: context,
// // // //       position: RelativeRect.fromLTRB(
// // // //         position.dx, // The X position of the icon
// // // //         position.dy + size.height, // The Y position of the icon plus the height of the icon
// // // //         0,
// // // //         0,
// // // //       ),
// // // //       items: [
// // // //         PopupMenuItem<int>(value: 0, child: Text("Today")),
// // // //         PopupMenuItem<int>(value: 1, child: Text("Last 7 Days")),
// // // //         PopupMenuItem<int>(value: 2, child: Text("Last Month")),
// // // //         PopupMenuItem<int>(value: 3, child: Text("Yearly")),
// // // //       ],
// // // //     );
// // // //
// // // //     if (selectedPeriod != null) {
// // // //       setState(() {
// // // //         _selectedPeriod = selectedPeriod;
// // // //       });
// // // //     }
// // // //   }
// // // // }
// // // //
// // // import 'package:flutter/material.dart';
// // // import 'package:provider/provider.dart';
// // //
// // // import '../Provider/UserProvider.dart';
// // // import 'Model/Api Model/allInquiryModel.dart';
// // //
// // // class AllInquiriesScreen extends StatefulWidget {
// // //   const AllInquiriesScreen({super.key});
// // //
// // //   @override
// // //   State<AllInquiriesScreen> createState() => _AllInquiriesScreenState();
// // // }
// // //
// // // class _AllInquiriesScreenState extends State<AllInquiriesScreen> {
// // //   late ScrollController _scrollController;
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     Future.microtask(() {
// // //       Provider.of<UserProvider>(context, listen: false).fetchInquiries();
// // //     });
// // //
// // //     _scrollController = ScrollController();
// // //     _scrollController.addListener(_onScroll);
// // //   }
// // //
// // //   void _onScroll() {
// // //     if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
// // //       Provider.of<UserProvider>(context, listen: false).fetchInquiries();
// // //     }
// // //   }
// // //
// // //   @override
// // //   void dispose() {
// // //     _scrollController.dispose();
// // //     super.dispose();
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final inquiryProvider = Provider.of<UserProvider>(context);
// // //
// // //     return Scaffold(
// // //       appBar: AppBar(title: Text('Inquiries')),
// // //       body: RefreshIndicator(
// // //         onRefresh: () => inquiryProvider.refreshInquiries(),
// // //         child: ListView.builder(
// // //           controller: _scrollController,
// // //           itemCount: inquiryProvider.inquiries.length + (inquiryProvider.hasMore ? 1 : 0),
// // //           itemBuilder: (context, index) {
// // //             if (index < inquiryProvider.inquiries.length) {
// // //               Inquiry inquiry = inquiryProvider.inquiries[index];
// // //               return Card(
// // //                 child: ListTile(
// // //                   title: Text(inquiry.fullName),
// // //                   subtitle: Text("Mobile: ${inquiry.mobileno}\nRemark: ${inquiry.remark}"),
// // //                   trailing: Text(inquiry.createdAt),
// // //                 ),
// // //               );
// // //             } else {
// // //               return Center(child: CircularProgressIndicator());
// // //             }
// // //           },
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// // import 'package:dropdown_button2/dropdown_button2.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_animate/flutter_animate.dart';
// // import 'package:intl/intl.dart';
// // import 'package:provider/provider.dart';
// //
// // import '../Provider/UserProvider.dart';
// // // import 'Inquiry Management Screens/dismiss_request_Screen.dart';
// // // import 'Inquiry Management Screens/dismiss_request_Screen.dart';
// // import 'Model/Api Model/allInquiryModel.dart';
// // import 'Utils/Colors/app_Colors.dart';
// // import 'Utils/Custom widgets/add_lead_Screen.dart';
// // import 'Utils/Custom widgets/custom_buttons.dart';
// // import 'Utils/Custom widgets/custom_screen.dart';
// // import 'Utils/Custom widgets/quotation_Screen.dart';
// //
// // class Test extends StatefulWidget {
// //   const Test({super.key});
// //
// //   @override
// //   State<Test> createState() => _TestState();
// // }
// //
// // class _TestState extends State<Test> {
// //   late ScrollController _scrollController;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     Future.microtask(() {
// //       Provider.of<UserProvider>(context, listen: false).fetchInquiries();
// //     });
// //
// //     _scrollController = ScrollController();
// //     _scrollController.addListener(_onScroll);
// //   }
// //
// //   void _onScroll() {
// //     if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
// //       Provider.of<UserProvider>(context, listen: false).fetchInquiries();
// //     }
// //   }
// //
// //   @override
// //   void dispose() {
// //     _scrollController.dispose();
// //     super.dispose();
// //   }
// //   void toggleSelection(int index) {
// //     selectedCards[index] = !selectedCards[index];
// //     anySelected = selectedCards.contains(true);
// //     print("anySelected : $anySelected");
// //     setState(() {});
// //   }
// //   List<String> callList = ['Followup', 'Dismissed', 'Appointment', 'Cnr'];
// //   List<bool> selectedCards = [];
// //   bool anySelected = false;
// //
// //   final TextEditingController nextFollowupcontroller = TextEditingController();
// //   String selectedcallFilter = "Follow Up";
// //   @override
// //   Widget build(BuildContext context) {
// //     final inquiryProvider = Provider.of<UserProvider>(context);
// //     if (selectedCards.length != inquiryProvider.inquiries.length) {
// //       selectedCards = List<bool>.generate(
// //         inquiryProvider.inquiries.length,
// //             (index) => false,
// //       );
// //     }
// //
// //     return Scaffold(
// //       appBar: AppBar(title: Text('Inquiries')),
// //       body: RefreshIndicator(
// //         onRefresh: () => inquiryProvider.refreshInquiries(),
// //         child: ListView.builder(
// //           controller: _scrollController,
// //           itemCount: inquiryProvider.inquiries.length + (inquiryProvider.hasMore ? 1 : 0),
// //           itemBuilder: (context, index) {
// //             if (index < inquiryProvider.inquiries.length) {
// //               Inquiry inquiry = inquiryProvider.inquiries[index];
// //               return Card(
// //                 child: card(
// //                   id: inquiry.id,
// //                   name: inquiry.fullName,
// //                   username: inquiry.mobileno,
// //                   label: inquiry.InqType,
// //                   followUpDate: inquiry.createdAt,
// //                   nextFollowUpDate:
// //                   inquiry.nxtfollowup,
// //                   inquiryType: inquiry.mobileno,
// //                   phone: inquiry.mobileno,
// //                   email: inquiry.mobileno,
// //                   source: inquiry.mobileno,
// //                   isSelected: selectedCards[index],
// //                   onSelect: () {
// //                     toggleSelection(index);
// //                   },
// //                   callList: callList,
// //                   selectedcallFilter: selectedcallFilter,
// //                   data: inquiry,
// //                   isTiming: true,
// //                   nextFollowupcontroller:
// //                   nextFollowupcontroller,
// //                 ),
// //               );
// //             } else {
// //               return Center(child: CircularProgressIndicator());
// //             }
// //           },
// //         ),
// //       ),
// //
// //     );
// //   }
// // }
// // class card extends StatelessWidget {
// //   final String id;
// //   final String name;
// //   final String label;
// //   final String username;
// //   final String followUpDate;
// //   final String nextFollowUpDate;
// //   final String inquiryType;
// //   final String phone;
// //   final String email;
// //   final String source;
// //
// //   final bool isSelected; // Track if card is selected
// //   final VoidCallback onSelect; // Callback to toggle selection
// //
// //   // New parameters you need to pass to LeadDetailScreen
// //   final List<String> callList;
// //   final TextEditingController nextFollowupcontroller;
// //   final String? selectedcallFilter;
// //   final Inquiry data; // change here
// //   final bool isTiming;
// //   // Assuming data is a dynamic object with properties like product, apxbuying, services, etc.
// //
// //   const card({
// //     Key? key,
// //     required this.id,
// //     required this.name,
// //     required this.username,
// //     required this.label,
// //     required this.followUpDate,
// //     required this.nextFollowUpDate,
// //     required this.inquiryType,
// //     required this.phone,
// //     required this.email,
// //     required this.source,
// //     this.isSelected = false,
// //     required this.onSelect,
// //     required this.callList,
// //     required this.nextFollowupcontroller,
// //     this.selectedcallFilter,
// //     required this.data, required this.isTiming,
// //   }) : super(key: key);
// //
// //   Widget build(BuildContext context) {
// //     return GestureDetector(
// //       onLongPress: onSelect, // Trigger selection on long press
// //       child: Card(
// //         margin: EdgeInsets.all(10.0),
// //         shape: RoundedRectangleBorder(
// //           borderRadius: BorderRadius.circular(16.0),
// //         ),
// //         elevation: isSelected ? 14.0 : 4.0,
// //         color: isSelected?Colors.deepPurple.shade100:Colors.white,// Highlight selected card
// //         child: Padding(
// //           padding: const EdgeInsets.all(16.0),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Row(
// //                 children: [
// //                   CircleAvatar(
// //                     radius: 15,
// //                     backgroundColor: Colors.deepPurple.shade300,
// //                     child: Text(
// //                       id,
// //                       style: TextStyle(fontSize: 20, fontFamily: "poppins_thin", color: Colors.white),
// //                     ),
// //                   ),
// //                   SizedBox(width: 12),
// //                   Expanded(
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         Text(
// //                           name,
// //                           style: TextStyle(fontSize: 18, fontFamily: "poppins_thin"),
// //                         ),
// //                         SizedBox(height: 4),
// //                         Row(
// //                           children: [
// //                             Icon(Icons.person, size: 15),
// //                             Text(
// //                               ": $username",
// //                               style: TextStyle(fontSize: 14, fontFamily: "poppins_thin", color: Colors.grey.shade600),
// //                             ),
// //                           ],
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                   GestureDetector(
// //                     onTap: () {
// //                       Navigator.push(context, MaterialPageRoute(builder: (context) => LeaddetailScreen(
// //                         selectedApx: "1-2 Days",
// //                         selectedPurpose: "budget",
// //                         selectedTime: "12:00 AM",
// //                         data: data,
// //                         callList: callList,
// //                         selectedaction: "Package 1",
// //                         selectedButton: "Followup",
// //                         controller: nextFollowupcontroller,
// //                         isTiming: isTiming,),));
// //                     },
// //                     child: CircleAvatar(
// //                         backgroundColor: Colors.deepPurple.shade300,
// //                         child: Icon(Icons.call, color: Colors.white)),
// //                   ),
// //                   SizedBox(width: 6),
// //                   GestureDetector(
// //                     onTap: () {
// //                       Navigator.push(context, MaterialPageRoute(builder: (context) => QuotationScreen(),));
// //                     },
// //                     child: CircleAvatar(
// //                         backgroundColor: Colors.deepPurple.shade300,
// //                         child: Icon(Icons.library_books, color: Colors.white)),
// //                   ),
// //                   SizedBox(width: 6),
// //                   CircleAvatar(
// //                     backgroundColor: Colors.deepPurple.shade300,
// //                     child: PopupMenuButton<String>(
// //                       icon: Icon(Icons.more_vert,color: Colors.white,),
// //                       onSelected: (value) {
// //                         if (value == 'edit') {
// //                           // Handle Edit action
// //                           Navigator.push(context, MaterialPageRoute(builder: (context) => AddLeadScreen(isEdit: true,),));
// //                         } else if (value == 'delete') {
// //                           // Handle Delete action
// //                         }
// //                       },
// //                       offset: Offset(0, 20),
// //                       itemBuilder: (BuildContext context) {
// //                         return [
// //                           PopupMenuItem<String>(
// //                             value: 'edit',
// //                             child: Text(
// //                               'Edit',
// //                               style: TextStyle(fontFamily: "poppins_thin"),
// //                             ),
// //                           ),
// //                           PopupMenuItem<String>(
// //                             value: 'delete',
// //                             child: Text(
// //                               'Delete',
// //                               style: TextStyle(fontFamily: "poppins_thin"),
// //                             ),
// //                           ),
// //                         ];
// //                       },
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //               SizedBox(height: 12),
// //               Row(
// //                 children: [
// //                   Chip(
// //                     label: Text(
// //                       label,
// //                       style: TextStyle(color: Colors.white, fontFamily: "poppins_thin"),
// //                     ),
// //                     backgroundColor: _getLabelColor(label),
// //                   ),
// //                   SizedBox(width: 8),
// //                   Chip(
// //                     label: Text(
// //                       "Inq Type: $inquiryType",
// //                       style: TextStyle(color: Colors.blue, fontFamily: "poppins_thin"),
// //                     ),
// //                     backgroundColor: Colors.blue.shade50,
// //                   ),
// //                 ],
// //               ),
// //               SizedBox(height: 12),
// //               Container(
// //                 height: 50,
// //                 padding: EdgeInsets.all(10),
// //                 decoration: BoxDecoration(
// //                   borderRadius: BorderRadius.circular(18),
// //                   color: Colors.grey.shade300,
// //                 ),
// //                 child: Row(
// //                   children: [
// //                     Icon(Icons.phone, color: Colors.grey.shade600, size: 17),
// //                     SizedBox(width: 4),
// //                     Text("+91 $phone", style: TextStyle(fontFamily: "poppins_thin")),
// //                     Spacer(),
// //                     Icon(Icons.email, color: Colors.grey.shade600, size: 17),
// //                     SizedBox(width: 4),
// //                     Text(email, style: TextStyle(fontFamily: "poppins_thin")),
// //                   ],
// //                 ),
// //               ),
// //               SizedBox(height: 12),
// //               Text(
// //                 "Follow-up Date: $followUpDate",
// //                 style: TextStyle(color: Colors.grey.shade600, fontFamily: "poppins_thin"),
// //               ),
// //               Text(
// //                 "Next Follow-up: $nextFollowUpDate",
// //                 style: TextStyle(color: Colors.grey.shade600, fontFamily: "poppins_thin"),
// //               ),
// //               Row(
// //                 children: [
// //                   Text("Source: ", style: TextStyle(fontFamily: "poppins_thin")),
// //                   _buildSourceChip(source),
// //                   Spacer(),
// //                   CircleAvatar(
// //                     backgroundColor: Colors.deepPurple.shade300,
// //                     child: IconButton(onPressed: () {
// //                       // showdialog(context);
// //                     }, icon: Icon(Icons.info_outline,color: Colors.white,)),
// //                   )
// //                 ],
// //               ),
// //               if (isSelected) // Show checkbox when selected
// //                 Align(
// //                   alignment: Alignment.centerRight,
// //                   child: Checkbox(
// //                     value: isSelected,
// //                     onChanged: (bool? value) {
// //                       onSelect(); // Trigger onSelect callback
// //                     },
// //                   ),
// //                 ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Color _getLabelColor(String label) {
// //     switch (label.toLowerCase()) {
// //       case "fresh":
// //         return Colors.green;
// //       case "feedback":
// //         return Color(0xffff9e4d);
// //       case "negotiations":
// //         return Colors.blue;
// //       case "appointment":
// //         return Color(0xffff9e4d);
// //       case "qualified":
// //         return Colors.purple.shade300;
// //       default:
// //         return Colors.grey;
// //     }
// //   }
// //
// //   Widget _buildSourceChip(String source) {
// //     return Chip(
// //       label: Text(source, style: TextStyle(fontFamily: "poppins_thin")),
// //       backgroundColor: Colors.grey.shade200,
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
// //     );
// //   }
// // }
// // import 'package:flutter/material.dart';
// //
// // class LeadManagementScreen extends StatefulWidget {
// //   const LeadManagementScreen({super.key});
// //
// //   @override
// //   State<LeadManagementScreen> createState() => _LeadManagementScreenState();
// // }
// //
// // class _LeadManagementScreenState extends State<LeadManagementScreen> {
// //   String selectedMainFilter = "Live";
// //   List<String> selectedSubOptions = [];
// //
// //   // Mapping of filters to their corresponding sub-options
// //   final Map<String, List<String>> filterOptions = {
// //     "Live": [
// //       "Fresh",
// //       "Contacted",
// //       "Trial",
// //       "Negotiation",
// //       "Dismiss",
// //       "Dismissed Request",
// //       "Feedback",
// //       "Reappointment",
// //       "Re-trial",
// //       "Converted",
// //       "All"
// //     ],
// //     "Dismiss": [
// //       "Fresh",
// //       "Contacted",
// //       "Appointment",
// //       "Trial",
// //       "Negotiation",
// //       "Feedback",
// //       "Reappointment",
// //       "Re-trial",
// //       "Converted",
// //       "All"
// //     ],
// //     "Dismissed Request": [
// //       "Fresh",
// //       "Contacted",
// //       "Appointment",
// //       "Trial",
// //       "All"
// //     ],
// //     "Conversion Request": [
// //       "Trial",
// //       "Reappointment",
// //       "All"
// //     ],
// //     "Due Appo": [
// //       "Appointment",
// //       "All"
// //     ],
// //     "CNR": [
// //       "All"
// //     ],
// //   };
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     selectedSubOptions = filterOptions[selectedMainFilter] ?? [];
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text("Lead Management")),
// //       body: Column(
// //         children: [
// //           _buildMainButtonGroup(),
// //           SizedBox(height: 10),
// //           _buildSubButtonGroup(), // Displays the sub-options dynamically
// //         ],
// //       ),
// //     );
// //   }
// //
// //   // Widget to create the main category buttons
// //   Widget _buildMainButtonGroup() {
// //     return SingleChildScrollView(
// //       scrollDirection: Axis.horizontal,
// //       child: Padding(
// //         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
// //         child: Row(
// //           children: filterOptions.keys.map((filter) {
// //             return _buildMainButton(filter);
// //           }).toList(),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   // Widget to create the sub-category buttons dynamically based on selection
// //   Widget _buildSubButtonGroup() {
// //     return SingleChildScrollView(
// //       scrollDirection: Axis.horizontal,
// //       child: Padding(
// //         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
// //         child: Row(
// //           children: selectedSubOptions.map((option) {
// //             return _buildSubButton(option);
// //           }).toList(),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   // Main filter button UI
// //   Widget _buildMainButton(String text) {
// //     final bool isSelected = selectedMainFilter == text;
// //
// //     return Padding(
// //       padding: const EdgeInsets.only(right: 8.0),
// //       child: ElevatedButton(
// //         style: ElevatedButton.styleFrom(
// //           backgroundColor: isSelected ? Colors.deepPurple : Colors.white,
// //           foregroundColor: isSelected ? Colors.white : Colors.deepPurple,
// //           side: const BorderSide(color: Color(0xff6A0DAD)),
// //           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
// //         ),
// //         onPressed: () {
// //           setState(() {
// //             selectedMainFilter = text;
// //             selectedSubOptions = filterOptions[text] ?? [];
// //           });
// //         },
// //         child: Text(
// //           text,
// //           style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   // Sub filter button UI
// //   Widget _buildSubButton(String text) {
// //     return Padding(
// //       padding: const EdgeInsets.only(right: 8.0),
// //       child: ElevatedButton(
// //         style: ElevatedButton.styleFrom(
// //           backgroundColor: Colors.blue.shade100,
// //           foregroundColor: Colors.black,
// //           side: BorderSide(color: Colors.blue),
// //           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
// //         ),
// //         onPressed: () {
// //           // Handle sub-option selection
// //         },
// //         child: Text(
// //           text,
// //           style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
//
// import 'package:flutter/material.dart';
// class CombinedDropdownTextField extends StatefulWidget {
//   final List<String> options;
//
//   const CombinedDropdownTextField({super.key, required this.options});
//
//   @override
//   State<CombinedDropdownTextField> createState() =>
//       _CombinedDropdownTextFieldState();
// }
//
// class _CombinedDropdownTextFieldState extends State<CombinedDropdownTextField> {
//   final TextEditingController _controller = TextEditingController();
//   bool _isDropdownVisible = false;
//   List<String> _filteredOptions = [];
//   final FocusNode _focusNode = FocusNode();
//
//   @override
//   void initState() {
//     super.initState();
//     _focusNode.addListener(_onFocusChange);
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     _focusNode.removeListener(_onFocusChange);
//     _focusNode.dispose();
//     super.dispose();
//   }
//
//   void _onFocusChange() {
//     setState(() {
//       _isDropdownVisible = _focusNode.hasFocus;
//     });
//   }
//
//   void _filterOptions(String query) {
//     setState(() {
//       _filteredOptions = widget.options
//           .where((option) =>
//           option.toLowerCase().contains(query.toLowerCase()))
//           .toList();
//       _isDropdownVisible = true; //Show the dropdown when filtering
//     });
//   }
//
//   void _selectOption(String option) {
//     setState(() {
//       _controller.text = option;
//       _filteredOptions = [];
//       _isDropdownVisible = false;
//     });
//     _focusNode.unfocus(); // Close the keyboard
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         TextFormField(
//           controller: _controller,
//           focusNode: _focusNode,
//           decoration: InputDecoration(
//             labelText: 'Select or Type',
//             border: const OutlineInputBorder(),
//             suffixIcon: _isDropdownVisible
//                 ? IconButton(
//               icon: const Icon(Icons.arrow_drop_up),
//               onPressed: () {
//                 setState(() {
//                   _isDropdownVisible = false;
//                   _focusNode.unfocus();
//                 });
//               },
//             )
//                 : IconButton(
//               icon: const Icon(Icons.arrow_drop_down),
//               onPressed: () {
//                 setState(() {
//                   _isDropdownVisible = true;
//                   _focusNode.requestFocus();
//                   _filteredOptions = List.from(widget.options); // SHOW ALL OPTIONS
//                 });
//               },
//             ),
//           ),
//           onChanged: _filterOptions,
//           onTap: () {
//             setState(() {
//               _isDropdownVisible = true;
//               _focusNode.requestFocus();
//               _filteredOptions = List.from(widget.options); // SHOW ALL OPTIONS
//             });
//           },
//         ),
//         if (_isDropdownVisible)
//           Card(
//             elevation: 4,
//             child: ConstrainedBox(
//               constraints: const BoxConstraints(maxHeight: 200),
//               child: ListView.builder(
//                 padding: EdgeInsets.zero,
//                 shrinkWrap: true,
//                 itemCount: _filteredOptions.length,
//                 itemBuilder: (context, index) {
//                   final option = _filteredOptions[index];
//                   return InkWell(
//                     onTap: () => _selectOption(option),
//                     child: Padding(
//                       padding: const EdgeInsets.all(12.0),
//                       child: Text(option),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }
// // GestureDetector(
// // onTap: () async {
// // setState(() {
// // selectedList = "All";
// // selectedValue = "0";
// // selectedIndex = 0;
// // });
// //
// // final inquiryProvider = Provider.of<UserProvider>(context, listen: false);
// // final paginatedInquiries = inquiryProvider.paginatedInquiries;
// //
// // List<Categorymodel> filteredOptions = [
// // Categorymodel("All", paginatedInquiries?.totalRecords ?? 0),
// // ];
// //
// // if (selectedMainFilter == "Live") {
// // filteredOptions.addAll([
// // Categorymodel("Fresh", paginatedInquiries?.liveFresh ?? 0),
// // Categorymodel("Contacted", paginatedInquiries?.liveContacted ?? 0),
// // Categorymodel("Trial", paginatedInquiries?.liveVisited ?? 0),
// // Categorymodel("Negotiation", paginatedInquiries?.liveNegotiation ?? 0),
// // Categorymodel("Dismiss", paginatedInquiries?.liveFresh ?? 0),
// // Categorymodel("Dismissed Request", paginatedInquiries?.liveContacted ?? 0),
// // Categorymodel("Feedback", paginatedInquiries?.liveFeedback ?? 0),
// // Categorymodel("Reappointment", paginatedInquiries?.liveReAppointment ?? 0),
// // Categorymodel("Re-trail", paginatedInquiries?.liveFeedback ?? 0),
// // Categorymodel("Converted", paginatedInquiries?.liveConverted ?? 0),
// // ]);
// // } else if (selectedMainFilter == "Dismiss") {
// // filteredOptions.addAll([
// // Categorymodel("Fresh", paginatedInquiries?.dismissFresh ?? 0),
// // Categorymodel("Contacted", paginatedInquiries?.dismissContacted ?? 0),
// // Categorymodel("Trial", paginatedInquiries?.dismissVisited ?? 0),
// // Categorymodel("Negotiation", paginatedInquiries?.dismissNegotiation ?? 0),
// // Categorymodel("Dismiss", paginatedInquiries?.dismissFresh ?? 0),
// // Categorymodel("Dismissed Request", paginatedInquiries?.dismissContacted ?? 0),
// // Categorymodel("Feedback", paginatedInquiries?.dismissFeedback ?? 0),
// // Categorymodel("Reappointment", paginatedInquiries?.dismissReAppointment ?? 0),
// // Categorymodel("Re-trail", paginatedInquiries?.dismissFeedback ?? 0),
// // Categorymodel("Converted", paginatedInquiries?.dismissConverted ?? 0),
// // ]);
// // } else if (selectedMainFilter == "Dismissed Request") {
// // filteredOptions.addAll([
// // Categorymodel("Fresh", paginatedInquiries?.Fresh ?? 0),
// // Categorymodel("Contacted", paginatedInquiries?.Contacted ?? 0),
// // Categorymodel("Trial", paginatedInquiries?.Visited ?? 0),
// // Categorymodel("Negotiation", paginatedInquiries?.Negotiation ?? 0),
// // Categorymodel("Dismiss", paginatedInquiries?.Fresh ?? 0),
// // Categorymodel("Dismissed Request", paginatedInquiries?.Contacted ?? 0),
// // Categorymodel("Feedback", paginatedInquiries?.Feedback ?? 0),
// // Categorymodel("Reappointment", paginatedInquiries?.ReAppointment ?? 0),
// // Categorymodel("Re-trail", paginatedInquiries?.Feedback ?? 0),
// // Categorymodel("Converted", paginatedInquiries?.Converted ?? 0),
// // ]);
// // } else if (selectedMainFilter == "Conversion Request") {
// // filteredOptions.addAll([
// // CategoryModel("Trial", []),
// // CategoryModel("Reappointment", []),
// // ]);
// // } else if (selectedMainFilter == "Due Appo") {
// // filteredOptions.addAll([
// // CategoryModel("Appointment", []),
// // ]);
// // }
// //
// // final result = await Navigator.push(
// // context,
// // MaterialPageRoute(
// // builder: (context) => ListSelectionScreen(
// // initialSelectedIndex: 0,
// // optionList: filteredOptions,
// // ),
// // ),
// // );
// //
// // if (result != null && result is Map) {
// // setState(() {
// // selectedIndex = result["selectedIndex"];
// // CategoryModel selectedCategory = result["selectedCategory"];
// // selectedList = selectedCategory.title;
// // selectedValue = selectedCategory.leadCount.toString();
// //
// // final inquiryProvider = Provider.of<UserProvider>(context, listen: false);
// //
// // if (selectedCategory.title == "All") {
// // // Status filter logic
// // if (selectedMainFilter == "Live") {
// // filterLiveLeads();
// // } else if (selectedMainFilter == "Dismiss") {
// // filterDismissedLeads();
// // } else if (selectedMainFilter == "Dismissed Request") {
// // filterDismissedRequestLeads();
// // } else if (selectedMainFilter == "Conversion Request") {
// // filterConversionRequestLeads();
// // } else if (selectedMainFilter == "Due Appo") {
// // filterDueAppoLeads();
// // } else {
// // filterAllLeads(); // Default: show all
// // }
// // } else {
// // String? inquiryStage = getInquiryStageFromCategory(selectedCategory.title);
// //
// // // Update filteredLeads based on both InqStatus and InqStage
// //
// // filteredLeads = inquiryProvider.inquiries.where((inquiry) {
// // bool statusMatch = false;
// // if (selectedMainFilter == "Live") {
// // statusMatch = inquiry.InqStatus == "1";
// // } else if (selectedMainFilter == "Dismiss") {
// // statusMatch = inquiry.InqStatus == "2";
// // } else if (selectedMainFilter == "Dismissed Request") {
// // statusMatch = inquiry.InqStatus == "3";
// // } else if (selectedMainFilter == "Conversion Request") {
// // statusMatch = inquiry.InqStatus == "4";
// // } else if (selectedMainFilter == "Due Appo") {
// // statusMatch = inquiry.InqStatus == "5";
// // } else if (selectedMainFilter == "CNR") {
// // statusMatch = inquiry.InqStatus == "6";
// // }
// //
// // return statusMatch && inquiry.InqStage == inquiryStage;
// // }).toList();
// // }
// // });
// // }
// // },
import 'package:flutter/material.dart';
import 'package:hr_app/Inquiry_Management/Utils/Colors/app_Colors.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';

class AddVisitScreen extends StatefulWidget {
  @override
  _AddVisitScreenState createState() => _AddVisitScreenState();
}

class _AddVisitScreenState extends State<AddVisitScreen> {
  PageController _pageController = PageController();
  int _currentPage = 0;
  DateTime? nextFollowUp;
  final TextEditingController _dateController = TextEditingController();
  bool isLoanSelected = true;
  TextEditingController _followUpDateController = TextEditingController();
  void _nextPage() {
    if (_currentPage < 1) {
      setState(() => _currentPage++);
      _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() => _currentPage--);
      _pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visit Entry',style: TextStyle(fontFamily: "poppins_thin",color: Colors.white),),
        backgroundColor: AppColor.Buttoncolor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: Colors.white,),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.grey.shade200,
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          _buildCustomerInformationPage(),
          _buildInterestSuggestionPage(),
        ],
      ),
    );
  }

  Widget _buildCustomerInformationPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Text('Customer Information', style: TextStyle(fontSize: 20, fontFamily: "poppins_thin")),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  _buildTextField('Mobile No.', prefix: '+91'),
                  _buildTextField('Name'),
                  _buildTextField('Address'),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Text('Interest', style: TextStyle(fontSize: 20, fontFamily: "poppins_thin")),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  _buildTextField('Int Area*'),
                  _buildDropdown('Property Sub Type*'),
                  _buildTextField('Property Type*'),
                  _buildTextField('Budget*'),
                  _buildDropdown('Purpose of Buying*'),
                  _buildDropdown('Approx Buying Time*'),
                ],
              ),
            ),
          ),
          _buildNextButton(),
        ],
      ),
    );
  }

  Widget _buildInterestSuggestionPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Text('Suggestion', style: TextStyle(fontSize: 20, fontFamily: "poppins_thin")),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  _buildDropdown('Int Site*'),
                  _buildDropdown('Unit No'),
                  _buildTextField('Size'),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Text('Buying Information', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  _buildToggleSwitch(),
                  if (isLoanSelected) ...[
                    _buildTextField('DP Amount*'),
                    _buildTextField('Loan Amount*'),
                    _buildTextField('After Visit Status*'),
                    _buildDatePickerField('Next FollowupDate*'),
                    _buildDropdown('Select Time*'),
                  ] else ...[
                    _buildTextField('DP Amount*'),
                    _buildDropdown('Cash Payment Condition'),
                    _buildDropdown('Apx Time'),
                    _buildTextField('After Visit Status*'),
                    _buildDatePickerField('Next FollowupDate*'),
                    _buildDropdown('Select Time*'),
                  ],
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: _previousPage,
                child: Text('Back',style: TextStyle(fontFamily: "poppins_thin",color: Colors.white),),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple.shade300),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Submit',style: TextStyle(fontFamily: "poppins_thin",color: Colors.white),),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple.shade300),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, {String? prefix}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontFamily: "poppins_thin"),
          prefixText: prefix != null ? '$prefix ' : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
  Widget _buildDatePickerField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0,vertical: 10),
      child: TextFormField(
        controller: _dateController,
        decoration: InputDecoration(
          labelText: "Next Follow Up",
          labelStyle: const TextStyle(fontFamily: "poppins_thin"),
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        readOnly: true,
        onTap: () async {
          DateTime? picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          if (picked != null) {
            setState(() {
              nextFollowUp = picked;
              _dateController.text =
                  DateFormat('yyyy-MM-dd').format(nextFollowUp!);
              print('Next Follow Up changed to: $nextFollowUp');
            });
          }
        },
      ),
    );
  }

  Widget _buildDropdown(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontFamily: "poppins_thin",color: Colors.black),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        items: ['Option 1', 'Option 2', 'Option 3']
            .map((option) => DropdownMenuItem(value: option, child: Text(option)))
            .toList(),
        onChanged: (value) {},
      ),
    );
  }

  Widget _buildToggleSwitch() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: ToggleSwitch(

        initialLabelIndex: isLoanSelected ? 0 : 1,
        totalSwitches: 2,
        labels: ['Loan', 'Cash'],
        customTextStyles: [TextStyle(fontFamily: "poppins_thin")],
        activeBgColors: [[Colors.deepPurple.shade300], [Colors.deepPurple.shade300]],
        inactiveBgColor: Colors.grey[300],
        cornerRadius: BorderSide.strokeAlignCenter,
        onToggle: (index) {
          setState(() {
            isLoanSelected = index == 0;
          });
        },
      ),
    );
  }

  Widget _buildNextButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: ElevatedButton(
        onPressed: _nextPage,
        child: Text('Next',style: TextStyle(fontFamily: "poppins_thin",color: Colors.white),),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.deepPurple.shade300,
        ),
      ),
    );
  }
}

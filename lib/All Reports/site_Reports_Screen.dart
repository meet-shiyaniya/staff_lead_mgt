import 'package:flutter/material.dart';
import 'package:hr_app/All%20Reports/Models/fetch_Projects_Dropdown_Model.dart';
import 'package:hr_app/staff_HRM_module/Screen/Color/app_Color.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart'; // For pie chart
import 'package:shimmer/shimmer.dart'; // For shimmer effect
import '../Provider/UserProvider.dart';
import 'Models/fetch_Site_Reports_Model.dart';

// Site Reports Screen with TabBar
class SiteReportsScreen extends StatefulWidget {
  const SiteReportsScreen({super.key});

  @override
  _SiteReportsScreenState createState() => _SiteReportsScreenState();
}

class _SiteReportsScreenState extends State<SiteReportsScreen> with TickerProviderStateMixin {
  String? selectedProject;
  String? selectedProjectID;
  DateTime? fromDate;
  DateTime? toDate;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _fadeController.forward();

    _tabController = TabController(length: 3, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.fetchProjectsDropdown().then((_) {
        if (userProvider.projectsDropdownData != null &&
            userProvider.projectsDropdownData!.project.isNotEmpty) {
          setState(() {
            selectedProject = userProvider.projectsDropdownData!.project[0].productName;
            selectedProjectID = userProvider.projectsDropdownData!.project[0].id;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _selectProject(Project project) {
    setState(() {
      selectedProject = project.productName;
      selectedProjectID = project.id;
    });
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void _showInquiryPieChartDialog(BuildContext context, UserProvider userProvider) {
    final budgetData = userProvider.siteReportsData!.budgetCount;
    const colors = [
      Colors.purple,
      Colors.teal,
      Colors.orange,
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.indigo,
      Colors.deepPurple,
      Colors.amber,
      Colors.amberAccent,
      Colors.blueGrey,
      Colors.lightGreen,
      Colors.pink,
      Colors.lime
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: appColor.subFavColor,
          title: const Text(
            'Inquiry Analysis Chart',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),
            textAlign: TextAlign.center,
          ),
          content: Container(
            height: 260,
            width: 260,
            child: PieChart(
              PieChartData(
                sections: budgetData.asMap().entries.map((entry) {
                  int index = entry.key;
                  var budget = entry.value;
                  double value = double.parse(budget.inquiryCount.split('(')[0]);
                  String percentage = '${budget.inquiryCount.split('(')[1].split(')')[0]}%';
                  return PieChartSectionData(
                    color: colors[index % colors.length],
                    value: value,
                    title: '$percentage\n${budget.budgetRange}', // Enhanced hover info
                    radius: 120,
                    titleStyle: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    titlePositionPercentageOffset: 0.7, // Adjust title position
                  );
                }).toList(),
                sectionsSpace: 1.6,
                centerSpaceRadius: 0,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close', style: TextStyle(fontSize: 14, color: appColor.primaryColor, fontFamily: "poppins_thin"),),
            ),
          ],
        );
      },
    );
  }

  void _showPurposePieChartDialog(BuildContext context, UserProvider userProvider) {
    final purposeData = userProvider.siteReportsData!.purposeCount;
    const colors = [
      Colors.purple,
      Colors.teal,
      Colors.orange,
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.indigo,
      Colors.deepPurple,
      Colors.amber,
      Colors.amberAccent,
      Colors.blueGrey,
      Colors.lightGreen,
      Colors.pink,
      Colors.lime
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: appColor.subFavColor,
          title: const Text(
            'Purpose for Buying Chart',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),
            textAlign: TextAlign.center,
          ),
          content: Container(
            height: 260,
            width: 260,
            child: PieChart(
              PieChartData(
                sections: purposeData.asMap().entries.map((entry) {
                  int index = entry.key;
                  var purpose = entry.value;
                  double value = double.parse(purpose.total.split('(')[0]);
                  String percentage = purpose.total.split('(')[1].split(')')[0];
                  return PieChartSectionData(
                    color: colors[index % colors.length],
                    value: value,
                    title: '$value\n${purpose.purposeBuy}', // Enhanced hover info
                    radius: 120,
                    titleStyle: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    titlePositionPercentageOffset: 0.7,
                  );
                }).toList(),
                sectionsSpace: 1.6,
                centerSpaceRadius: 0,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: TextStyle(fontSize: 14, color: appColor.primaryColor, fontFamily: "poppins_thin"),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showVisitPieChartDialog(BuildContext context, UserProvider userProvider) {
    final budgetData = userProvider.siteReportsData!.visitBudgetCount;
    const colors = [
      Colors.purple,
      Colors.teal,
      Colors.orange,
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.indigo,
      Colors.deepPurple,
      Colors.amber,
      Colors.amberAccent,
      Colors.blueGrey,
      Colors.lightGreen,
      Colors.pink,
      Colors.lime
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: appColor.subFavColor,
          title: const Text(
            'Visit Analysis Chart',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),
            textAlign: TextAlign.center,
          ),
          content: Container(
            height: 260,
            width: 260,
            child: PieChart(
              PieChartData(
                sections: budgetData.asMap().entries.map((entry) {
                  int index = entry.key;
                  var budget = entry.value as Map<String, dynamic>;
                  String inquiryCount = budget['inquiry_count'] ?? '0(0%)';
                  double value = double.parse(inquiryCount.split('(')[0]);
                  String percentage = '${inquiryCount.split('(')[1].split(')')[0]}%';
                  return PieChartSectionData(
                    color: colors[index % colors.length],
                    value: value,
                    title: '$percentage\n${budget['budget_range'] ?? 'Unknown'}', // Enhanced hover info
                    radius: 120,
                    titleStyle: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    titlePositionPercentageOffset: 0.7,
                  );
                }).toList(),
                sectionsSpace: 1.6,
                centerSpaceRadius: 0,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: TextStyle(fontSize: 14, color: appColor.primaryColor, fontFamily: "poppins_thin"),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showVisitPurposePieChartDialog(BuildContext context, UserProvider userProvider) {
    final visitPurposeData = userProvider.siteReportsData!.visitPurposeWiseData;
    const colors = [
      Colors.purple,
      Colors.teal,
      Colors.orange,
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.indigo,
      Colors.deepPurple,
      Colors.amber,
      Colors.amberAccent,
      Colors.blueGrey,
      Colors.lightGreen,
      Colors.pink,
      Colors.lime
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: appColor.subFavColor,
          title: const Text(
            'Purpose for Buying Chart',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),
            textAlign: TextAlign.center,
          ),
          content: Container(
            height: 260,
            width: 260,
            child: PieChart(
              PieChartData(
                sections: visitPurposeData.asMap().entries.map((entry) {
                  int index = entry.key;
                  var purpose = entry.value as Map<String, dynamic>;
                  String total = purpose['Total'] ?? '0(0%)';
                  double value = double.parse(total.split('(')[0]);
                  return PieChartSectionData(
                    color: colors[index % colors.length],
                    value: value,
                    title: '$value\n${purpose['purpose_buy'] ?? 'Unknown'}', // Enhanced hover info
                    radius: 120,
                    titleStyle: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    titlePositionPercentageOffset: 0.7,
                  );
                }).toList(),
                sectionsSpace: 1.6,
                centerSpaceRadius: 0,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: TextStyle(fontSize: 14, color: appColor.primaryColor, fontFamily: "poppins_thin"),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showVisitAreaPieChartDialog(BuildContext context, UserProvider userProvider) {
    final areaData = userProvider.siteReportsData!.visitAreaWiseData;
    const colors = [
      Colors.purple,
      Colors.teal,
      Colors.orange,
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.indigo,
      Colors.deepPurple,
      Colors.amber,
      Colors.amberAccent,
      Colors.blueGrey,
      Colors.lightGreen,
      Colors.pink,
      Colors.lime
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: appColor.subFavColor,
          title: const Text(
            'Visit Area Wise Chart',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),
            textAlign: TextAlign.center,
          ),
          content: Container(
            height: 260,
            width: 260,
            child: PieChart(
              PieChartData(
                sections: areaData.asMap().entries.map((entry) {
                  int index = entry.key;
                  var area = entry.value as Map<String, dynamic>;
                  String total = area['Total'] ?? '0(0%)';
                  double value = double.parse(total.split('(')[0]);
                  return PieChartSectionData(
                    color: colors[index % colors.length],
                    value: value,
                    title: '$value\n${area['purpareaose_buy'] ?? 'Unknown'}', // Enhanced hover info
                    radius: 120,
                    titleStyle: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    titlePositionPercentageOffset: 0.7,
                  );
                }).toList(),
                sectionsSpace: 1.6,
                centerSpaceRadius: 0,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: TextStyle(fontSize: 14, color: appColor.primaryColor, fontFamily: "poppins_thin"),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showVisitSourcePieChartDialog(BuildContext context, UserProvider userProvider) {
    final sourceData = userProvider.siteReportsData!.visitSourceWiseData;
    const colors = [
      Colors.purple,
      Colors.teal,
      Colors.orange,
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.indigo,
      Colors.deepPurple,
      Colors.amber,
      Colors.amberAccent,
      Colors.blueGrey,
      Colors.lightGreen,
      Colors.pink,
      Colors.lime
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: appColor.subFavColor,
          title: const Text(
            'Visit Source Wise Chart',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),
            textAlign: TextAlign.center,
          ),
          content: Container(
            height: 260,
            width: 260,
            child: PieChart(
              PieChartData(
                sections: sourceData.asMap().entries.map((entry) {
                  int index = entry.key;
                  var source = entry.value as Map<String, dynamic>;
                  String total = source['Total'] ?? '0(0%)';
                  double value = double.parse(total.split('(')[0]);
                  String percentage = '${total.split('(')[1].split(')')[0]}%';
                  return PieChartSectionData(
                    color: colors[index % colors.length],
                    value: value,
                    title: '$percentage\n${source['source'] ?? 'Unknown'}', // Enhanced hover info
                    radius: 120,
                    titleStyle: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    titlePositionPercentageOffset: 0.7,
                  );
                }).toList(),
                sectionsSpace: 1.6,
                centerSpaceRadius: 0,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: TextStyle(fontSize: 14, color: appColor.primaryColor, fontFamily: "poppins_thin"),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showVisitSizePieChartDialog(BuildContext context, UserProvider userProvider) {
    final sizeData = userProvider.siteReportsData!.visitSizeWiseData;
    const colors = [
      Colors.purple,
      Colors.teal,
      Colors.orange,
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.indigo,
      Colors.deepPurple,
      Colors.amber,
      Colors.amberAccent,
      Colors.blueGrey,
      Colors.lightGreen,
      Colors.pink,
      Colors.lime
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: appColor.subFavColor,
          title: const Text(
            'Visit Size Wise Chart',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),
            textAlign: TextAlign.center,
          ),
          content: Container(
            height: 260,
            width: 260,
            child: PieChart(
              PieChartData(
                sections: sizeData.asMap().entries.map((entry) {
                  int index = entry.key;
                  var size = entry.value as Map<String, dynamic>;
                  String total = size['Total'] ?? '0(0%)';
                  double value = double.parse(total.split('(')[0]);
                  String percentage = '${total.split('(')[1].split(')')[0]}%';
                  return PieChartSectionData(
                    color: colors[index % colors.length],
                    value: value,
                    title: '$percentage\n${size['property_size'] ?? 'Unknown'}', // Enhanced hover info
                    radius: 120,
                    titleStyle: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    titlePositionPercentageOffset: 0.7,
                  );
                }).toList(),
                sectionsSpace: 1.6,
                centerSpaceRadius: 0,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: TextStyle(fontSize: 14, color: appColor.primaryColor, fontFamily: "poppins_thin"),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showConversionPieChartDialog(BuildContext context, UserProvider userProvider) {
    final budgetData = userProvider.siteReportsData!.bookingBudgetHtml;
    const colors = [
      Colors.purple,
      Colors.teal,
      Colors.orange,
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.indigo,
      Colors.deepPurple,
      Colors.amber,
      Colors.amberAccent,
      Colors.blueGrey,
      Colors.lightGreen,
      Colors.pink,
      Colors.lime
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: appColor.subFavColor,
          title: const Text(
            'Conversion Analysis Chart',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),
            textAlign: TextAlign.center,
          ),
          content: Container(
            height: 260,
            width: 260,
            child: PieChart(
              PieChartData(
                sections: budgetData.asMap().entries.map((entry) {
                  int index = entry.key;
                  BookingBudgetHtml budget = entry.value;
                  String inquiryCount = budget.inquiryCount ?? '0(0%)';
                  double value = double.parse(inquiryCount.split('(')[0]);
                  String percentage = '${inquiryCount.split('(')[1].split(')')[0]}%';
                  return PieChartSectionData(
                    color: colors[index % colors.length],
                    value: value,
                    title: '$percentage\n${budget.budgetRange ?? 'Unknown'}', // Enhanced hover info
                    radius: 120,
                    titleStyle: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    titlePositionPercentageOffset: 0.7,
                  );
                }).toList(),
                sectionsSpace: 1.6,
                centerSpaceRadius: 0,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: TextStyle(fontSize: 14, color: appColor.primaryColor, fontFamily: "poppins_thin"),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showBookingSourcePieChartDialog(BuildContext context, UserProvider userProvider) {
    final sourceData = userProvider.siteReportsData!.bookingSourceWiseData;
    const colors = [
      Colors.purple,
      Colors.teal,
      Colors.orange,
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.indigo,
      Colors.deepPurple,
      Colors.amber,
      Colors.amberAccent,
      Colors.blueGrey,
      Colors.lightGreen,
      Colors.pink,
      Colors.lime
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: appColor.subFavColor,
          title: const Text(
            'Booking Source Wise Chart',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),
            textAlign: TextAlign.center,
          ),
          content: Container(
            height: 260,
            width: 260,
            child: PieChart(
              PieChartData(
                sections: sourceData.asMap().entries.map((entry) {
                  int index = entry.key;
                  BookingSourceWiseDatum source = entry.value;
                  String total = source.total ?? '0(0%)';
                  double value = double.parse(total.split('(')[0]);
                  String percentage = '${total.split('(')[1].split(')')[0]}%';
                  return PieChartSectionData(
                    color: colors[index % colors.length],
                    value: value,
                    title: '$percentage\n${source.source ?? 'Unknown'}', // Enhanced hover info
                    radius: 120,
                    titleStyle: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    titlePositionPercentageOffset: 0.7,
                  );
                }).toList(),
                sectionsSpace: 1.6,
                centerSpaceRadius: 0,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: TextStyle(fontSize: 14, color: appColor.primaryColor, fontFamily: "poppins_thin"),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showBookingAreaPieChartDialog(BuildContext context, UserProvider userProvider) {
    final areaData = userProvider.siteReportsData!.bookingAreaWiseData;
    const colors = [
      Colors.purple,
      Colors.teal,
      Colors.orange,
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.indigo,
      Colors.deepPurple,
      Colors.amber,
      Colors.amberAccent,
      Colors.blueGrey,
      Colors.lightGreen,
      Colors.pink,
      Colors.lime
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: appColor.subFavColor,
          title: const Text(
            'Booking Area Wise Chart',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),
            textAlign: TextAlign.center,
          ),
          content: Container(
            height: 260,
            width: 260,
            child: PieChart(
              PieChartData(
                sections: areaData.asMap().entries.map((entry) {
                  int index = entry.key;
                  BookingAreaWiseDatum area = entry.value;
                  String total = area.total ?? '0(0%)';
                  double value = double.parse(total.split('(')[0]);
                  return PieChartSectionData(
                    color: colors[index % colors.length],
                    value: value,
                    title: '$value\n${area.area ?? 'Unknown'}', // Enhanced hover info
                    radius: 120,
                    titleStyle: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    titlePositionPercentageOffset: 0.7,
                  );
                }).toList(),
                sectionsSpace: 1.6,
                centerSpaceRadius: 0,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: TextStyle(fontSize: 14, color: appColor.primaryColor, fontFamily: "poppins_thin"),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showBookingSizePieChartDialog(BuildContext context, UserProvider userProvider) {
    final sizeData = userProvider.siteReportsData!.bookingSizeWiseData;
    const colors = [
      Colors.purple,
      Colors.teal,
      Colors.orange,
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.indigo,
      Colors.deepPurple,
      Colors.amber,
      Colors.amberAccent,
      Colors.blueGrey,
      Colors.lightGreen,
      Colors.pink,
      Colors.lime
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: appColor.subFavColor,
          title: const Text(
            'Booking Size Wise Chart',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),
            textAlign: TextAlign.center,
          ),
          content: Container(
            height: 260,
            width: 260,
            child: PieChart(
              PieChartData(
                sections: sizeData.asMap().entries.map((entry) {
                  int index = entry.key;
                  var size = entry.value as Map<String, dynamic>;
                  String total = size['Total'] ?? '0(0%)';
                  double value = double.parse(total.split('(')[0]);
                  String percentage = '${total.split('(')[1].split(')')[0]}%';
                  return PieChartSectionData(
                    color: colors[index % colors.length],
                    value: value,
                    title: '$percentage\n${size['property_size'] ?? 'Unknown'}', // Enhanced hover info
                    radius: 120,
                    titleStyle: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    titlePositionPercentageOffset: 0.7,
                  );
                }).toList(),
                sectionsSpace: 1.6,
                centerSpaceRadius: 0,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: TextStyle(fontSize: 14, color: appColor.primaryColor, fontFamily: "poppins_thin"),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProjectDropdown() {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return PopupMenuButton<Project>(
          color: Colors.white,
          offset: const Offset(0, 12),
          position: PopupMenuPosition.under,
          icon: const Icon(Icons.filter_list, color: Colors.white),
          onSelected: _selectProject,
          itemBuilder: (BuildContext context) {
            if (userProvider.isLoadingProjectsDropdown) {
              return [
                PopupMenuItem<Project>(
                  enabled: false,
                  child: Center(
                    child: CircularProgressIndicator(color: appColor.primaryColor),
                  ),
                ),
              ];
            }
            if (userProvider.projectsDropdownData == null ||
                userProvider.projectsDropdownData!.project.isEmpty) {
              return [
                PopupMenuItem<Project>(
                  enabled: false,
                  child: Text(
                    'No projects available',
                    style: TextStyle(
                      fontFamily: "poppins_thin",
                      fontSize: 13,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ];
            }
            return [
              PopupMenuItem<Project>(
                enabled: false,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: Scrollbar(
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      child: Column(
                        children: userProvider.projectsDropdownData!.project.map((Project project) {
                          bool isSelected = selectedProjectID == project.id;
                          return PopupMenuItem<Project>(
                            value: project,
                            child: Text(
                              project.productName,
                              style: TextStyle(
                                fontFamily: "poppins_thin",
                                fontSize: 13,
                                color: isSelected ? Colors.deepPurple : Colors.grey.shade700,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          tooltip: 'Select Project',
        );
      },
    );
  }

  Widget _buildDateRangePicker() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            style: const TextStyle(color: Colors.black54, fontFamily: "poppins_thin", fontSize: 12),
            readOnly: true,
            decoration: InputDecoration(
              hintText: 'From Date to To Date',
              hintStyle: const TextStyle(color: Colors.black54, fontFamily: "poppins_thin", fontSize: 13),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(color: Colors.black54),
              ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(color: Colors.black54),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(color: Colors.black54),
              ),
              suffixIcon: Icon(
                Icons.calendar_today,
                color: appColor.primaryColor,
                size: 20,
              ),
            ),
            onTap: () async {
              DateTimeRange? picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                initialDateRange: DateTimeRange(
                  start: DateTime.now(),
                  end: DateTime.now(),
                ),
              );
              if (picked != null) {
                setState(() {
                  fromDate = picked.start;
                  toDate = picked.end;
                });
              }
            },
            controller: TextEditingController(
              text: fromDate != null && toDate != null
                  ? '${fromDate!.toString().split(' ')[0]} to ${toDate!.toString().split(' ')[0]}'
                  : '',
            ),
          ),
        ),
        const SizedBox(width: 16.0),
        ElevatedButton(
          onPressed: () {
            if (selectedProjectID != null) {
              final userProvider = Provider.of<UserProvider>(context, listen: false);
              userProvider.fetchSiteReports(
                project: selectedProjectID!,
                fromDate: _formatDate(fromDate),
                toDate: _formatDate(toDate),
              );
              _fadeController.forward(from: 0);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please select a project')),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: appColor.primaryColor,
          ),
          child: const Text(
            'Submit',
            style: TextStyle(color: Colors.white, fontSize: 13.4, fontFamily: "poppins_thin"),
          ),
        ),
      ],
    );
  }

  Widget _buildChartIcon(VoidCallback onTap, bool isVisible) {
    return isVisible
        ? GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              spreadRadius: 3,
              blurRadius: 5,
              offset: const Offset(1, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(9),
        child: Icon(
          Icons.leaderboard_outlined,
          color: Colors.deepPurple.shade400,
          size: 20,
        ),
      ),
    )
        : const SizedBox.shrink();
  }

  Widget _buildShimmerTable(String title1, String title2) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Table(
            border: TableBorder.all(),
            children: [
              TableRow(
                decoration: BoxDecoration(color: appColor.primaryColor),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.white,
                      height: 20,
                      width: double.infinity,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.white,
                      height: 20,
                      width: double.infinity,
                    ),
                  ),
                ],
              ),
              ...List.generate(3, (index) => TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.white,
                      height: 20,
                      width: double.infinity,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.white,
                      height: 20,
                      width: double.infinity,
                    ),
                  ),
                ],
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInquiryAnalysisSection(UserProvider userProvider) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Inquiry Analysis',
                style: TextStyle(fontSize: 15, fontFamily: "poppins_thin"),
              ),
              _buildChartIcon(
                    () => _showInquiryPieChartDialog(context, userProvider),
                userProvider.siteReportsData != null && userProvider.siteReportsData!.budgetCount.isNotEmpty,
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          if (userProvider.isSiteRpLoading)
            _buildShimmerTable('Budget', 'Total')
          else if (userProvider.siteReportsData == null)
            _buildTable(title1: 'Budget', title2: 'Total', data: const [], total: '0')
          else
            _buildTable(
              title1: 'Budget',
              title2: 'Total',
              data: userProvider.siteReportsData!.budgetCount
                  .map((budget) => {'col1': budget.budgetRange, 'col2': budget.inquiryCount})
                  .toList(),
              total: userProvider.siteReportsData!.budgetCountTotal[0].budgetTotalCount.toString(),
            ),
        ],
      ),
    );
  }

  Widget _buildPurposeSection(UserProvider userProvider) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Purpose for Buying',
                style: TextStyle(fontSize: 15, fontFamily: "poppins_thin"),
              ),
              _buildChartIcon(
                    () => _showPurposePieChartDialog(context, userProvider),
                userProvider.siteReportsData != null && userProvider.siteReportsData!.purposeCount.isNotEmpty,
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          if (userProvider.isSiteRpLoading)
            _buildShimmerTable('Purpose for Buying', 'Total')
          else if (userProvider.siteReportsData == null)
            _buildTable(title1: 'Purpose for Buying', title2: 'Total', data: const [], total: '0')
          else
            _buildTable(
              title1: 'Purpose for Buying',
              title2: 'Total',
              data: userProvider.siteReportsData!.purposeCount
                  .map((purpose) => {'col1': purpose.purposeBuy, 'col2': purpose.total})
                  .toList(),
              total: userProvider.siteReportsData!.purposeCountTotal[0].purposeTotalCount.toString(),
            ),
        ],
      ),
    );
  }

  Widget _buildVisitAnalysisSection(UserProvider userProvider) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Visit Analysis',
                style: TextStyle(fontSize: 15, fontFamily: "poppins_thin"),
              ),
              _buildChartIcon(
                    () => _showVisitPieChartDialog(context, userProvider),
                userProvider.siteReportsData != null && userProvider.siteReportsData!.visitBudgetCount.isNotEmpty,
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          if (userProvider.isSiteRpLoading)
            _buildShimmerTable('Budget', 'Total')
          else if (userProvider.siteReportsData == null)
            _buildTable(title1: 'Budget', title2: 'Total', data: const [], total: '0')
          else
            _buildTable(
              title1: 'Budget',
              title2: 'Total',
              data: userProvider.siteReportsData!.visitBudgetCount
                  .map((visit) => {
                'col1': (visit as Map<String, dynamic>)['budget_range'] ?? 'Unknown',
                'col2': (visit as Map<String, dynamic>)['inquiry_count'] ?? '0',
              })
                  .toList(),
              total: userProvider.siteReportsData!.visitBudgetCountTotal[0].visitBudgetTotalCount.toString(),
            ),
        ],
      ),
    );
  }

  Widget _buildVisitPurposeSection(UserProvider userProvider) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Purpose for Buying',
                style: TextStyle(fontSize: 15, fontFamily: "poppins_thin"),
              ),
              _buildChartIcon(
                    () => _showVisitPurposePieChartDialog(context, userProvider),
                userProvider.siteReportsData != null && userProvider.siteReportsData!.visitPurposeWiseData.isNotEmpty,
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          if (userProvider.isSiteRpLoading)
            _buildShimmerTable('Purpose for Buying', 'Total')
          else if (userProvider.siteReportsData == null)
            _buildTable(title1: 'Purpose for Buying', title2: 'Total', data: const [], total: '0')
          else
            _buildTable(
              title1: 'Purpose for Buying',
              title2: 'Total',
              data: userProvider.siteReportsData!.visitPurposeWiseData
                  .map((purpose) => {
                'col1': (purpose as Map<String, dynamic>)['purpose_buy']?.isEmpty ?? true
                    ? 'Unknown'
                    : (purpose as Map<String, dynamic>)['purpose_buy'],
                'col2': (purpose as Map<String, dynamic>)['Total'] ?? '0',
              })
                  .toList(),
              total: userProvider.siteReportsData!.visitPurposeWiseDataTotal[0].visitPurposeTotalCount.toString(),
            ),
        ],
      ),
    );
  }

  Widget _buildVisitAreaSection(UserProvider userProvider) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Visit Area Wise Data',
                style: TextStyle(fontSize: 15, fontFamily: "poppins_thin"),
              ),
              _buildChartIcon(
                    () => _showVisitAreaPieChartDialog(context, userProvider),
                userProvider.siteReportsData != null && userProvider.siteReportsData!.visitAreaWiseData.isNotEmpty,
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          if (userProvider.isSiteRpLoading)
            _buildShimmerTable('Area', 'Total')
          else if (userProvider.siteReportsData == null)
            _buildTable(title1: 'Area', title2: 'Total', data: const [], total: '0')
          else
            _buildTable(
              title1: 'Area',
              title2: 'Total',
              data: userProvider.siteReportsData!.visitAreaWiseData
                  .map((area) => {
                'col1': (area as Map<String, dynamic>)['purpareaose_buy']?.isEmpty ?? true
                    ? 'Unknown'
                    : (area as Map<String, dynamic>)['purpareaose_buy'],
                'col2': (area as Map<String, dynamic>)['Total'] ?? '0',
              })
                  .toList(),
              total: userProvider.siteReportsData!.visitAreaWiseDatasTotal[0].visitAreaTotalCounts.toString(),
            ),
        ],
      ),
    );
  }

  Widget _buildVisitSourceSection(UserProvider userProvider) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Visit Source Wise Data',
                style: TextStyle(fontSize: 15, fontFamily: "poppins_thin"),
              ),
              _buildChartIcon(
                    () => _showVisitSourcePieChartDialog(context, userProvider),
                userProvider.siteReportsData != null && userProvider.siteReportsData!.visitSourceWiseData.isNotEmpty,
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          if (userProvider.isSiteRpLoading)
            _buildShimmerTable('Source', 'Total')
          else if (userProvider.siteReportsData == null)
            _buildTable(title1: 'Source', title2: 'Total', data: const [], total: '0')
          else
            _buildTable(
              title1: 'Source',
              title2: 'Total',
              data: userProvider.siteReportsData!.visitSourceWiseData
                  .map((source) => {
                'col1': (source as Map<String, dynamic>)['source']?.isEmpty ?? true
                    ? 'Unknown'
                    : (source as Map<String, dynamic>)['source'],
                'col2': (source as Map<String, dynamic>)['Total'] ?? '0',
              })
                  .toList(),
              total: userProvider.siteReportsData!.visitSourceWiseDataTotal[0].visitSourceTotalCount.toString(),
            ),
        ],
      ),
    );
  }

  Widget _buildVisitSizeSection(UserProvider userProvider) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Visit Size Wise Data',
                style: TextStyle(fontSize: 15, fontFamily: "poppins_thin"),
              ),
              _buildChartIcon(
                    () => _showVisitSizePieChartDialog(context, userProvider),
                userProvider.siteReportsData != null && userProvider.siteReportsData!.visitSizeWiseData.isNotEmpty,
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          if (userProvider.isSiteRpLoading)
            _buildShimmerTable('Property Size', 'Total')
          else if (userProvider.siteReportsData == null)
            _buildTable(title1: 'Property Size', title2: 'Total', data: const [], total: '0')
          else
            _buildTable(
              title1: 'Property Size',
              title2: 'Total',
              data: userProvider.siteReportsData!.visitSizeWiseData
                  .map((size) => {
                'col1': (size as Map<String, dynamic>)['property_size']?.isEmpty ?? true
                    ? 'Unknown'
                    : (size as Map<String, dynamic>)['property_size'],
                'col2': (size as Map<String, dynamic>)['Total'] ?? '0',
              })
                  .toList(),
              total: userProvider.siteReportsData!.visitSizeWiseDataTotal[0].visitSizeTotalCount.toString(),
            ),
        ],
      ),
    );
  }

  Widget _buildConversionAnalysisSection(UserProvider userProvider) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Conversion Analysis',
                style: TextStyle(fontSize: 15, fontFamily: "poppins_thin"),
              ),
              _buildChartIcon(
                    () => _showConversionPieChartDialog(context, userProvider),
                userProvider.siteReportsData != null && userProvider.siteReportsData!.bookingBudgetHtml.isNotEmpty,
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          if (userProvider.isSiteRpLoading)
            _buildShimmerTable('Budget', 'Total')
          else if (userProvider.siteReportsData == null)
            _buildTable(title1: 'Budget', title2: 'Total', data: const [], total: '0')
          else
            _buildTable(
              title1: 'Budget',
              title2: 'Total',
              data: userProvider.siteReportsData!.bookingBudgetHtml
                  .map((budget) => {
                'col1': budget.budgetRange ?? 'Unknown',
                'col2': budget.inquiryCount ?? '0',
              })
                  .toList(),
              total: userProvider.siteReportsData!.bookingBudgetHtmlTotal[0].bookingBudgetTotalCount.toString(),
            ),
        ],
      ),
    );
  }

  Widget _buildBookingSourceSection(UserProvider userProvider) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Booking Source Wise Data',
                style: TextStyle(fontSize: 15, fontFamily: "poppins_thin"),
              ),
              _buildChartIcon(
                    () => _showBookingSourcePieChartDialog(context, userProvider),
                userProvider.siteReportsData != null && userProvider.siteReportsData!.bookingSourceWiseData.isNotEmpty,
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          if (userProvider.isSiteRpLoading)
            _buildShimmerTable('Source', 'Total')
          else if (userProvider.siteReportsData == null)
            _buildTable(title1: 'Source', title2: 'Total', data: const [], total: '0')
          else
            _buildTable(
              title1: 'Source',
              title2: 'Total',
              data: userProvider.siteReportsData!.bookingSourceWiseData
                  .map((source) => {
                'col1': source.source?.isEmpty ?? true ? 'Unknown' : source.source,
                'col2': source.total ?? '0',
              })
                  .toList(),
              total: userProvider.siteReportsData!.bookingSourceWiseDataTotal[0].bookingSourceTotalCount.toString(),
            ),
        ],
      ),
    );
  }

  Widget _buildBookingAreaSection(UserProvider userProvider) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Booking Area Wise Data',
                style: TextStyle(fontSize: 15, fontFamily: "poppins_thin"),
              ),
              _buildChartIcon(
                    () => _showBookingAreaPieChartDialog(context, userProvider),
                userProvider.siteReportsData != null && userProvider.siteReportsData!.bookingAreaWiseData.isNotEmpty,
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          if (userProvider.isSiteRpLoading)
            _buildShimmerTable('Area', 'Total')
          else if (userProvider.siteReportsData == null)
            _buildTable(title1: 'Area', title2: 'Total', data: const [], total: '0')
          else
            _buildTable(
              title1: 'Area',
              title2: 'Total',
              data: userProvider.siteReportsData!.bookingAreaWiseData
                  .map((area) => {
                'col1': area.area.isEmpty ?? true ? 'Unknown' : area.area,
                'col2': area.total ?? '0',
              })
                  .toList(),
              total: userProvider.siteReportsData!.bookingAreaWiseDatasTotal[0].bookingAreaTotalCounts.toString(),
            ),
        ],
      ),
    );
  }

  Widget _buildBookingSizeSection(UserProvider userProvider) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Booking Size Wise Data',
                style: TextStyle(fontSize: 15, fontFamily: "poppins_thin"),
              ),
              _buildChartIcon(
                    () => _showBookingSizePieChartDialog(context, userProvider),
                userProvider.siteReportsData != null && userProvider.siteReportsData!.bookingSizeWiseData.isNotEmpty,
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          if (userProvider.isSiteRpLoading)
            _buildShimmerTable('Property Size', 'Total')
          else if (userProvider.siteReportsData == null)
            _buildTable(title1: 'Property Size', title2: 'Total', data: const [], total: '0')
          else
            _buildTable(
              title1: 'Property Size',
              title2: 'Total',
              data: userProvider.siteReportsData!.bookingSizeWiseData.map((size) {
                var sizeData = size as Map<String, dynamic>;
                return {
                  'col1': sizeData['property_size']?.isEmpty ?? true ? 'Unknown' : sizeData['property_size'],
                  'col2': sizeData['Total'] ?? '0',
                };
              }).toList(),
              total: userProvider.siteReportsData!.bookingSizeWiseDataTotal[0].bookingSizeTotalCount.toString(),
            ),
        ],
      ),
    );
  }

  Widget _buildTable({
    required String title1,
    required String title2,
    required List<Map<String, dynamic>> data,
    required String total,
  }) {
    return Table(
      border: TableBorder.all(),
      children: [
        TableRow(
          decoration: BoxDecoration(color: appColor.primaryColor),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title1,
                style: const TextStyle(color: Colors.white, fontFamily: "poppins_thin", fontSize: 13.1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title2,
                style: const TextStyle(color: Colors.white, fontFamily: "poppins_thin", fontSize: 13.1),
              ),
            ),
          ],
        ),
        ...data.map((row) => TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                row['col1']!,
                style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                row['col2']!,
                style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontSize: 12),
              ),
            ),
          ],
        )),
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Total',
                style: TextStyle(color: Colors.grey.shade800, fontFamily: "poppins_thin", fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                total,
                style: TextStyle(color: Colors.grey.shade800, fontFamily: "poppins_thin", fontSize: 12),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Site Reports',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
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
          _buildProjectDropdown(),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          labelStyle: const TextStyle(fontFamily: "poppins_thin", fontSize: 14, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontFamily: "poppins_thin", fontSize: 14),
          tabs: const [
            Tab(text: 'Inquiry'),
            Tab(text: 'Visit'),
            Tab(text: 'Conversion'),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selected Project: ${selectedProject ?? 'None'}',
              style: const TextStyle(fontSize: 14, fontFamily: "poppins_thin", color: Colors.black54),
            ),
            const SizedBox(height: 16.0),
            _buildDateRangePicker(),
            const SizedBox(height: 16.0),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Consumer<UserProvider>(
                    builder: (context, userProvider, child) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildInquiryAnalysisSection(userProvider),
                            const SizedBox(height: 32.0),
                            _buildPurposeSection(userProvider),
                          ],
                        ),
                      );
                    },
                  ),
                  Consumer<UserProvider>(
                    builder: (context, userProvider, child) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildVisitAnalysisSection(userProvider),
                            const SizedBox(height: 32.0),
                            _buildVisitPurposeSection(userProvider),
                            const SizedBox(height: 32.0),
                            _buildVisitAreaSection(userProvider),
                            const SizedBox(height: 32.0),
                            _buildVisitSourceSection(userProvider),
                            const SizedBox(height: 32.0),
                            _buildVisitSizeSection(userProvider),
                          ],
                        ),
                      );
                    },
                  ),
                  Consumer<UserProvider>(
                    builder: (context, userProvider, child) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildConversionAnalysisSection(userProvider),
                            const SizedBox(height: 32.0),
                            _buildBookingSourceSection(userProvider),
                            const SizedBox(height: 32.0),
                            _buildBookingAreaSection(userProvider),
                            const SizedBox(height: 32.0),
                            _buildBookingSizeSection(userProvider),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
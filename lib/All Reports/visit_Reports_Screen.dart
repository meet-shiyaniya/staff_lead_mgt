import 'package:flutter/material.dart';
import 'package:hr_app/All%20Reports/Models/fetch_Visit_Reports_Model.dart';
import 'package:hr_app/staff_HRM_module/Screen/Color/app_Color.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../Provider/UserProvider.dart';

class VisitReportsScreen extends StatefulWidget {
  @override
  _VisitReportsScreenState createState() => _VisitReportsScreenState();
}

class _VisitReportsScreenState extends State<VisitReportsScreen> {
  String selectedFilter = 'Last 12 Month';
  String selectedFilterKey = '';

  List<String> get filterOptions {
    final currentYear = DateTime.now().year;
    final options = ['Last 12 Month', currentYear.toString()];
    for (int i = 1; i <= 6; i++) {
      options.add((currentYear - i).toString());
    }
    return options;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false)
          .fetchVisitReports(year: selectedFilterKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        List<Map<String, dynamic>> siteWiseVisits = [];
        List<Map<String, dynamic>> userWiseVisits = [];
        List<Total> siteWiseTotals = [];
        List<Total> userWiseTotals = [];

        if (userProvider.visitReportsData != null) {
          siteWiseVisits = userProvider.visitReportsData!.productReport.data.map((product) {
            return {
              'name': product.userName, // Removed the dot here, will add it in the table
              'visits': product.months.map((month) => month.visitCount).toList(),
              'total': product.totalBooking,
              'isInactive': product.isInactive == "1", // Add isInactive status
            };
          }).toList();

          userWiseVisits = userProvider.visitReportsData!.userReport.data.map((user) {
            return {
              'name': user.switcherActive == 'active' ? user.userName : user.userName,
              'visits': user.months.map((month) => month.visitCount).toList(),
              'total': user.totalBooking,
              'isActive': user.switcherActive == 'active',
            };
          }).toList();

          siteWiseTotals = userProvider.visitReportsData!.productReport.totals;
          userWiseTotals = userProvider.visitReportsData!.userReport.totals;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Visit Report',
              style: TextStyle(
                color: Colors.white,
                fontFamily: "poppins_thin",
                fontSize: 18,
              ),
            ),
            backgroundColor: appColor.primaryColor,
            centerTitle: true,
            foregroundColor: Colors.white,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
            ),
            actions: [
              PopupMenuButton<String>(
                color: Colors.white,
                offset: Offset(0, 12),
                position: PopupMenuPosition.under,
                icon: Icon(Icons.filter_list, color: Colors.white),
                onSelected: (String value) {
                  setState(() {
                    selectedFilter = value;
                    selectedFilterKey = (value == 'Last 12 Month') ? '' : value;
                  });
                  userProvider.fetchVisitReports(year: selectedFilterKey);
                  print('Selected filter: $selectedFilter, Key: $selectedFilterKey');
                },
                itemBuilder: (BuildContext context) {
                  return filterOptions.map((String option) {
                    return PopupMenuItem<String>(
                      value: option,
                      child: Row(
                        children: [
                          Icon(
                            selectedFilter == option
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked,
                            color: selectedFilter == option
                                ? appColor.primaryColor
                                : Colors.grey,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            option,
                            style: TextStyle(
                              fontFamily: "poppins_thin",
                              fontSize: 13,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList();
                },
              ),
            ],
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Site Wise Visits',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: "poppins_thin",
                          color: Colors.black,
                        ),
                      ),
                      Icon(Icons.bar_chart, color: Colors.black, size: 20),
                    ],
                  ),
                  SizedBox(height: 10),
                  userProvider.isVisitRpLoading
                      ? _buildShimmerTable()
                      : _buildVisitsTable(siteWiseVisits, siteWiseTotals),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Swipe to see more →',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.swipe, size: 16, color: Colors.grey),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'User Wise Visits',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: "poppins_thin",
                          color: Colors.black,
                        ),
                      ),
                      Icon(Icons.bar_chart, color: Colors.black, size: 20),
                    ],
                  ),
                  SizedBox(height: 10),
                  userProvider.isVisitRpLoading
                      ? _buildShimmerTable()
                      : _buildUserWiseVisitsTable(userWiseVisits, userWiseTotals, userProvider),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Swipe to see more →',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.swipe, size: 16, color: Colors.grey),
                    ],
                  ),
                  SizedBox(height: 14),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildVisitsTable(List<Map<String, dynamic>> data, List<Total> totals) {
    if (data.isEmpty || totals.isEmpty) {
      return Center(
        child: Text(
          'No data available',
          style: TextStyle(
            fontFamily: "poppins_thin",
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      );
    }

    List<DataRow> rows = data.map((item) {
      return DataRow(
        cells: [
          DataCell(
            Row(
              children: [
                Text(
                  '● ',
                  style: TextStyle(
                    color: item['isInactive'] ? Colors.red.shade700 : Colors.green.shade700,
                    fontSize: 13,
                  ),
                ),
                Text(
                  item['name'],
                  style: TextStyle(
                    fontFamily: "poppins_thin",
                    fontSize: 13,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          ...List.generate(
            totals.length,
                (index) => DataCell(Text(item['visits'][index].toString())),
          ),
          DataCell(Text(item['total'].toString())),
        ],
      );
    }).toList();

    int finalTotal = totals.fold(0, (sum, total) => sum + total.totalBooking);

    rows.add(
      DataRow(
        cells: [
          DataCell(
            Text(
              'Total',
              style: TextStyle(
                fontFamily: "poppins_thin",
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          ...totals.map(
                (total) => DataCell(
              Text(
                total.totalBooking.toString(),
                style: TextStyle(
                  fontFamily: "poppins_thin",
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          DataCell(
            Text(
              finalTotal.toString(),
              style: TextStyle(
                fontFamily: "poppins_thin",
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );

    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          dataTextStyle: TextStyle(
            color: Colors.black,
            fontFamily: "poppins_thin",
            fontSize: 13,
          ),
          headingTextStyle: TextStyle(
            color: Colors.deepPurple.shade400,
            fontFamily: "poppins_thin",
            fontSize: 13.1,
          ),
          columnSpacing: 20,
          columns: [
            DataColumn(label: Text('Site Name')), // Changed label to 'Site Name'
            ...totals.map((total) => DataColumn(label: Text(total.month))),
            DataColumn(label: Text('Total')),
          ],
          rows: rows,
        ),
      ),
    );
  }

  Widget _buildUserWiseVisitsTable(List<Map<String, dynamic>> data, List<Total> totals, UserProvider userProvider) {
    if (data.isEmpty || totals.isEmpty) {
      return Center(
        child: Text(
          'No data available',
          style: TextStyle(
            fontFamily: "poppins_thin",
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      );
    }

    List<DataRow> rows = data.map((item) {
      return DataRow(
        cells: [
          DataCell(
            Row(
              children: [
                Text(
                  '● ',
                  style: TextStyle(
                    color: item['isActive'] ? Colors.green.shade700 : Colors.red.shade700,
                    fontSize: 13,
                  ),
                ),
                Text(
                  item['name'],
                  style: TextStyle(
                    fontFamily: "poppins_thin",
                    fontSize: 13,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          ...List.generate(
            totals.length,
                (index) => DataCell(Text(item['visits'][index].toString())),
          ),
          DataCell(Text(item['total'].toString())),
        ],
      );
    }).toList();

    DataRow totalRow = DataRow(
      cells: [
        DataCell(
          Text(
            'Total',
            style: TextStyle(
              fontFamily: "poppins_thin",
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        ...totals.map(
              (total) => DataCell(
            Text(
              total.totalBooking.toString(),
              style: TextStyle(
                fontFamily: "poppins_thin",
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        DataCell(
          Text(
            userProvider.visitReportsData!.userReport.finalTotalBooking.toString(),
            style: TextStyle(
              fontFamily: "poppins_thin",
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );

    rows.add(totalRow);

    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          dataTextStyle: TextStyle(
            color: Colors.black,
            fontFamily: "poppins_thin",
            fontSize: 13,
          ),
          headingTextStyle: TextStyle(
            color: Colors.deepPurple.shade400,
            fontFamily: "poppins_thin",
            fontSize: 13.1,
          ),
          columnSpacing: 20,
          columns: [
            DataColumn(label: Text('User Name')),
            ...totals.map((total) => DataColumn(label: Text(total.month))),
            DataColumn(label: Text('Total')),
          ],
          rows: rows,
        ),
      ),
    );
  }

  Widget _buildShimmerTable() {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: DataTable(
            columnSpacing: 20,
            columns: [
              DataColumn(label: Container(width: 100, height: 16, color: Colors.white)),
              DataColumn(label: Container(width: 60, height: 16, color: Colors.white)),
              DataColumn(label: Container(width: 60, height: 16, color: Colors.white)),
              DataColumn(label: Container(width: 60, height: 16, color: Colors.white)),
              DataColumn(label: Container(width: 60, height: 16, color: Colors.white)),
              DataColumn(label: Container(width: 60, height: 16, color: Colors.white)),
              DataColumn(label: Container(width: 60, height: 16, color: Colors.white)),
              DataColumn(label: Container(width: 60, height: 16, color: Colors.white)),
              DataColumn(label: Container(width: 60, height: 16, color: Colors.white)),
              DataColumn(label: Container(width: 60, height: 16, color: Colors.white)),
              DataColumn(label: Container(width: 60, height: 16, color: Colors.white)),
              DataColumn(label: Container(width: 60, height: 16, color: Colors.white)),
              DataColumn(label: Container(width: 60, height: 16, color: Colors.white)),
              DataColumn(label: Container(width: 60, height: 16, color: Colors.white)),
            ],
            rows: List.generate(
              3,
                  (_) => DataRow(
                cells: List.generate(
                  14,
                      (_) => DataCell(Container(width: 60, height: 16, color: Colors.white)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
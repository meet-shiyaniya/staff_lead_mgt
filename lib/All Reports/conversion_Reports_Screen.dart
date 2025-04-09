import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hr_app/staff_HRM_module/Screen/Color/app_Color.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../Provider/UserProvider.dart';
import 'Models/fetch_Conversions_Report_Model.dart';

class ConversionReportsScreen extends StatefulWidget {
  @override
  _ConversionReportsScreenState createState() =>
      _ConversionReportsScreenState();
}

class _ConversionReportsScreenState extends State<ConversionReportsScreen>
    with SingleTickerProviderStateMixin {
  String selectedFilter = 'Last 12 Month';
  String selectedFilterKey = '';
  late TabController _tabController;
  String? selectedUser; // New state variable to track selected user

  List<DataColumn> _generateColumns(SourceReport sourceReport) {
    // Get unique p_shortname values from the first source's data (assuming all sources have the same p_shortname order)
    List<String> uniquePShortNames = sourceReport.sourcedataWise.first.data
        .map((datum) => datum.pshortName.toString())
        .toList();

    // Add columns for each unique p_shortname
    List<DataColumn> columns = uniquePShortNames.map((pShortName) {
      return DataColumn(
        label: Text(
          pShortName,
          style: TextStyle(
            fontSize: 11.4,
            fontFamily: "poppins_thin",
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple[900],
          ),
        ),
      );
    }).toList();

    // Add the TOTAL column
    columns.add(
      DataColumn(
        label: Text(
          'TOTAL',
          style: TextStyle(
            fontSize: 11.4,
            fontFamily: "poppins_thin",
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple[900],
          ),
        ),
      ),
    );

    return columns;
  }

  List<DataRow> _generateRows(SourceReport sourceReport) {
    List<DataRow> rows = [];

    // Generate rows for each source
    rows.addAll(sourceReport.sourcedataWise.map((source) {
      List<DataCell> cells = source.data.map((data) {
        return DataCell(
          Text(
            data.cancelCount == "0" || data.cancelCount == 0
                ? data.liveCount.toString()
                : "${data.liveCount} (${data.cancelCount})",
            style: _cellTextStyle(),
          ),
        );
      }).toList();

      // Add the total for this source
      int sourceIndex = sourceReport.sourcedataWise.indexOf(source);
      cells.add(
        DataCell(
          Text(
            sourceReport.sourceTotal[sourceIndex].cancelCount == 0
                ? sourceReport.sourceTotal[sourceIndex].liveCount.toString()
                : "${sourceReport.sourceTotal[sourceIndex].liveCount} (${sourceReport.sourceTotal[sourceIndex].cancelCount})",
            style: _cellTextStyle(),
          ),
        ),
      );

      return DataRow(cells: cells);
    }).toList());

    // Add the final total row
    rows.add(
      DataRow(
        cells: _generateTotalRowCells(sourceReport),
      ),
    );

    return rows;
  }

  List<DataCell> _generateTotalRowCells(SourceReport sourceReport) {
    List<String> uniquePShortNames = sourceReport.sourcedataWise.first.data
        .map((datum) => datum.pshortName.toString())
        .toList();

    List<DataCell> totalCells = uniquePShortNames.map((pShortName) {
      String total = _calculateColumnTotal(
          sourceReport, uniquePShortNames.indexOf(pShortName));
      return DataCell(Text(total, style: _cellTextStyle()));
    }).toList();

    // Add the grand total
    totalCells.add(
      DataCell(
        Text(
          sourceReport.total.cancelCount == 0
              ? sourceReport.total.liveCount.toString()
              : "${sourceReport.total.liveCount} (${sourceReport.total.cancelCount})",
          style: _cellTextStyle(),
        ),
      ),
    );

    return totalCells;
  }

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
    _tabController = TabController(length: 3, vsync: this);

    // Fetch data when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false)
          .fetchConversionsReport(year: selectedFilterKey);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Conversion Report',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: "poppins_thin",
          ),
        ),
        backgroundColor: appColor.primaryColor,
        centerTitle: true,
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
        bottom: TabBar(
          // labelPadding: EdgeInsets.only(top: 10),
          controller: _tabController,
          tabs: [
            Tab(text: 'Site Wise\nConversions'),
            Tab(text: 'User Wise\nConversions'),
            Tab(text: 'Source Wise\nConversions'),
          ],
          labelStyle: TextStyle(fontSize: 13, fontFamily: "poppins_thin"),
          unselectedLabelStyle:
              TextStyle(fontSize: 12.4, fontFamily: "poppins_thin"),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey.shade200,
          indicatorColor: Colors.white,
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
              Provider.of<UserProvider>(context, listen: false)
                  .fetchConversionsReport(year: selectedFilterKey);
              print(
                  'Selected filter: $selectedFilter, Key: $selectedFilterKey');
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
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          // Site Wise Conversions Tab
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  if (userProvider.isConversionsRpLoading) {
                    return _buildShimmerEffect();
                  }
                  final siteReport =
                      userProvider.conversionsReportData?.siteReport;
                  if (siteReport == null || siteReport.data.isEmpty) {
                    return Center(
                      child: Text(
                        'No data found',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: "poppins_thin",
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Site Wise Conversions',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: "poppins_thin",
                              color: Colors.black,
                            ),
                          ),
                          Icon(Icons.bar_chart, color: Colors.black, size: 20),
                        ],
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 300,
                        child: Card(
                          elevation: 4,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: LineChart(
                              LineChartData(
                                gridData: FlGridData(show: false),
                                titlesData: FlTitlesData(
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        final months = siteReport.totals
                                            .map((e) => e.month)
                                            .toList();
                                        if (value.toInt() >= months.length)
                                          return Text('');

                                        // Split the month string (e.g., "Apr - 24" into "Apr" and "24")
                                        final monthString =
                                            months[value.toInt()];
                                        final parts = monthString.split(' - ');
                                        final month = parts[0]; // e.g., "Apr"
                                        final year = parts.length > 1
                                            ? parts[1]
                                            : ''; // e.g., "24"

                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              year,
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 8,
                                              ),
                                            ),
                                            Text(
                                              month,
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 8,
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        return Text(
                                          value.toInt().toString(),
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 10,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  rightTitles: AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                  topTitles: AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                ),
                                borderData: FlBorderData(show: false),
                                lineBarsData: siteReport.data.map((datum) {
                                  return LineChartBarData(
                                    spots: datum.months
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                      return FlSpot(
                                        entry.key.toDouble(),
                                        double.parse(
                                            entry.value.visitCount.toString()),
                                      );
                                    }).toList(),
                                    isCurved: true,
                                    color: datum.userName == 'Al Noor Bunglows'
                                        ? Color(0xfffeb019)
                                        : datum.userName ==
                                                'Bagh E Huda Heritage'
                                            ? Color(0xff00e396)
                                            : Color(0xff724ebf),
                                    barWidth: 2,
                                    dotData: FlDotData(show: false),
                                    belowBarData: BarAreaData(
                                      show: true,
                                      color: datum.userName ==
                                              'Al Noor Bunglows'
                                          ? Color(0xfffeb019).withOpacity(0.3)
                                          : datum.userName ==
                                                  'Bagh E Huda Heritage'
                                              ? Color(0xff00e396)
                                                  .withOpacity(0.3)
                                              : Color(0xff724ebf)
                                                  .withOpacity(0.2),
                                    ),
                                  );
                                }).toList(),
                                minX: 0,
                                maxX: siteReport.totals.length - 1.toDouble(),
                                minY: 0,
                                maxY: siteReport.data
                                        .expand((datum) => datum.months)
                                        .map((month) => double.parse(
                                            month.visitCount.toString()))
                                        .reduce((a, b) => a > b ? a : b) *
                                    1.2,
                                lineTouchData: LineTouchData(
                                  touchTooltipData: LineTouchTooltipData(
                                    getTooltipItems: (touchedSpots) {
                                      return touchedSpots.map((spot) {
                                        final projectName = siteReport
                                            .data[spot.barIndex].userName;
                                        return LineTooltipItem(
                                          '$projectName: ${spot.y}',
                                          TextStyle(
                                            color: spot.barIndex == 0
                                                ? Colors.deepPurple.shade100
                                                : Colors.teal.shade100,
                                            fontSize: 10,
                                            fontFamily: "poppins_thin",
                                          ),
                                        );
                                      }).toList();
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Card(
                        elevation: 3,
                        color: Colors.white,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 120,
                              child: Column(
                                children: [
                                  Container(
                                    height: 50,
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Project Name',
                                      style: TextStyle(
                                        fontSize: 11.4,
                                        fontFamily: "poppins_thin",
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurple[900],
                                      ),
                                    ),
                                  ),
                                  ...siteReport.data.map((datum) {
                                    return Container(
                                      height: 44,
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 6,
                                            height: 6,
                                            decoration: BoxDecoration(
                                              color: Colors.green.shade700,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Flexible(
                                            child: Text(
                                              datum.userName,
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontFamily: "poppins_thin",
                                                color: Colors.black87,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  Container(
                                    height: 44,
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 6,
                                          height: 6,
                                          decoration: BoxDecoration(
                                            color: Colors.green.shade700,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Total',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontFamily: "poppins_thin",
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columnSpacing: 20,
                                  dataRowHeight: 44,
                                  headingRowHeight: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.white60,
                                  ),
                                  columns: siteReport.totals.map((total) {
                                    return DataColumn(
                                      label: Text(
                                        total.month,
                                        style: TextStyle(
                                          fontSize: 11.4,
                                          fontFamily: "poppins_thin",
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepPurple[900],
                                        ),
                                      ),
                                    );
                                  }).toList()
                                    ..add(
                                      DataColumn(
                                        label: Text(
                                          'Total',
                                          style: TextStyle(
                                            fontSize: 11.4,
                                            fontFamily: "poppins_thin",
                                            fontWeight: FontWeight.bold,
                                            color: Colors.deepPurple[900],
                                          ),
                                        ),
                                      ),
                                    ),
                                  rows: [
                                    ...siteReport.data.map((datum) {
                                      // Explicitly define the cells list as List<DataCell>
                                      List<DataCell> cells =
                                          datum.months.map((month) {
                                        return DataCell(
                                          Text(
                                            month.cancelBookingCount == "0" ||
                                                    month.cancelBookingCount ==
                                                        0
                                                ? month.visitCount.toString()
                                                : "${month.visitCount} (${month.cancelBookingCount})",
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontFamily: "poppins_thin",
                                              color: Colors.black87,
                                            ),
                                          ),
                                        );
                                      }).toList();

                                      // Add the total cell separately
                                      cells.add(
                                        DataCell(
                                          Text(
                                            datum.totalCancel == "0" ||
                                                    datum.totalCancel == 0
                                                ? datum.totalBooking.toString()
                                                : "${datum.totalBooking} (${datum.totalCancel})",
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontFamily: "poppins_thin",
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      );

                                      return DataRow(cells: cells);
                                    }).toList(),
                                    // Total row
                                    DataRow(
                                      cells: () {
                                        List<DataCell> totalCells =
                                            siteReport.totals.map((total) {
                                          return DataCell(
                                            Text(
                                              total.totalCancel == "0" ||
                                                      total.totalCancel == 0
                                                  ? total.totalBooking
                                                      .toString()
                                                  : "${total.totalBooking} (${total.totalCancel})",
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontFamily: "poppins_thin",
                                                color: Colors.black87,
                                              ),
                                            ),
                                          );
                                        }).toList();
                                        totalCells.add(
                                          DataCell(
                                            Text(
                                              siteReport.finalTotalCancel ==
                                                          "0" ||
                                                      siteReport
                                                              .finalTotalCancel ==
                                                          0
                                                  ? siteReport.finalTotalBooking
                                                      .toString()
                                                  : "${siteReport.finalTotalBooking} (${siteReport.finalTotalCancel})",
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontFamily: "poppins_thin",
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                        );
                                        return totalCells;
                                      }(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                    ],
                  );
                },
              ),
            ),
          ),

          // User Wise Conversions Tab
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  final userReport =
                      userProvider.conversionsReportData?.userReport;
                  if (userReport == null || userReport.data.isEmpty) {
                    return Center(
                      child: Text(
                        'No data found',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: "poppins_thin",
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }

                  // Define colors for users dynamically
                  final userColors = [
                    Color(0xff724ebf), // Purple
                    Color(0xff00e396), // Green
                    Color(0xfffeb019), // Orange
                    Color(0xffff4560), // Red (e.g., for "Mitul Sosa")
                    Color(0xff775dd0), // Dark Purple
                    Color(0xff2596be),
                    Color(0xfff5cedf),
                    Color(0xfff76451),
                    Color(0xffdcc4f0),
                    Color(0xfff7e0a5),
                  ];

                  // Calculate maxY dynamically
                  double maxY;
                  if (selectedUser != null) {
                    final selectedUserData = userReport.data
                        .firstWhere((user) => user.userName == selectedUser);
                    maxY = selectedUserData.months
                            .map((month) =>
                                double.parse(month.bookingCount.toString()))
                            .reduce((a, b) => a > b ? a : b) *
                        1.2;
                  } else {
                    maxY = userReport.totals
                            .map((total) => total.totalBooking)
                            .reduce((a, b) => a > b ? a : b)
                            .toDouble() *
                        1.2;
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'User Wise Conversions',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: "poppins_thin",
                              color: Colors.black,
                            ),
                          ),
                          Icon(Icons.bar_chart, color: Colors.black, size: 20),
                        ],
                      ),
                      SizedBox(height: 20),
                      // Legend
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:
                              userReport.data.asMap().entries.map((entry) {
                            int idx = entry.key;
                            var user = entry.value;
                            final isSelected = selectedUser == user.userName;
                            return Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: _buildLegendItem(
                                user.userName,
                                userColors[idx % userColors.length],
                                isSelected: isSelected,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 20),
                      // Bar Chart with precise touch detection
                      SizedBox(
                        width: double.infinity,
                        height: 300,
                        child: Card(
                          elevation: 3,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: BarChart(
                              BarChartData(
                                alignment: BarChartAlignment.spaceAround,
                                maxY: maxY,
                                barTouchData: BarTouchData(
                                  enabled: true,
                                  touchTooltipData: BarTouchTooltipData(
                                    getTooltipItem:
                                        (group, groupIndex, rod, rodIndex) {
                                      // Get the color of the tapped rod stack item
                                      final touchedColor =
                                          rod.rodStackItems[rodIndex].color;

                                      // Find the user associated with this color
                                      final userIndex =
                                          userReport.data.indexWhere((user) {
                                        final colorIndex =
                                            userReport.data.indexOf(user) %
                                                userColors.length;
                                        return userColors[colorIndex] ==
                                            touchedColor;
                                      });

                                      if (userIndex != -1) {
                                        final user = userReport.data[userIndex];
                                        final bookingCount = user
                                            .months[groupIndex].bookingCount;
                                        return BarTooltipItem(
                                          '${user.userName}: $bookingCount',
                                          TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontFamily: "poppins_thin",
                                          ),
                                        );
                                      }
                                      return null; // Return null if no matching user is found
                                    },
                                  ),
                                  touchCallback: (FlTouchEvent event,
                                      BarTouchResponse? barTouchResponse) {
                                    if (event is FlTapUpEvent &&
                                        barTouchResponse != null &&
                                        barTouchResponse.spot != null) {
                                      final touchedRodData =
                                          barTouchResponse.spot!.touchedRodData;
                                      final touchedStackIndex = barTouchResponse
                                          .spot!.touchedStackItemIndex;

                                      if (touchedStackIndex >= 0 &&
                                          touchedStackIndex <
                                              touchedRodData
                                                  .rodStackItems.length) {
                                        final touchedColor = touchedRodData
                                            .rodStackItems[touchedStackIndex]
                                            .color;
                                        setState(() {
                                          final userIndex = userReport.data
                                              .indexWhere((user) {
                                            final colorIndex =
                                                userReport.data.indexOf(user) %
                                                    userColors.length;
                                            return userColors[colorIndex] ==
                                                touchedColor;
                                          });
                                          if (userIndex != -1) {
                                            final tappedUser = userReport
                                                .data[userIndex].userName;
                                            // Toggle: if same user tapped, reset to show all; otherwise, select the new user
                                            selectedUser =
                                                selectedUser == tappedUser
                                                    ? null
                                                    : tappedUser;
                                          }
                                        });
                                      }
                                    }
                                  },
                                ),
                                titlesData: FlTitlesData(
                                  show: true,
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget:
                                          (double value, TitleMeta meta) {
                                        final months = userReport.totals
                                            .map((e) => e.month)
                                            .toList();
                                        if (value.toInt() >= months.length)
                                          return Text('');
                                        return Text(
                                          months[value.toInt()].split(' - ')[0],
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 8,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        return Text(
                                          '${value.toInt()}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        );
                                      },
                                      interval: 2,
                                    ),
                                  ),
                                  topTitles: AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                  rightTitles: AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                ),
                                borderData: FlBorderData(show: false),
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: false,
                                  drawHorizontalLine: false,
                                ),
                                barGroups: List.generate(
                                    userReport.totals.length, (monthIndex) {
                                  List<BarChartRodStackItem> stackItems = [];
                                  double currentY = 0;

                                  final filteredUsers = selectedUser == null
                                      ? userReport.data
                                      : userReport.data
                                          .where((user) =>
                                              user.userName == selectedUser)
                                          .toList();

                                  for (int userIndex = 0;
                                      userIndex < filteredUsers.length;
                                      userIndex++) {
                                    final user = filteredUsers[userIndex];
                                    final bookingCount = double.parse(
                                      user.months[monthIndex].bookingCount
                                          .toString(),
                                    );
                                    if (bookingCount > 0) {
                                      final colorIndex =
                                          userReport.data.indexOf(user) %
                                              userColors.length;
                                      stackItems.add(
                                        BarChartRodStackItem(
                                          currentY,
                                          currentY + bookingCount,
                                          userColors[colorIndex],
                                        ),
                                      );
                                      currentY += bookingCount;
                                    }
                                  }

                                  return BarChartGroupData(
                                    x: monthIndex,
                                    barRods: [
                                      BarChartRodData(
                                        toY: currentY,
                                        width: 16,
                                        borderRadius: BorderRadius.circular(4),
                                        rodStackItems: stackItems,
                                      ),
                                    ],
                                  );
                                }),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      // Custom Data Table with Fixed Name Column and Scrollable Data
                      Card(
                        elevation: 3,
                        color: Colors.white,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Fixed Name Column
                            SizedBox(
                              width: 120,
                              child: Column(
                                children: [
                                  Container(
                                    height: 50,
                                    alignment: Alignment.center,
                                    child: Text(
                                      'User Name',
                                      style: TextStyle(
                                        fontSize: 11.4,
                                        fontFamily: "poppins_thin",
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurple[900],
                                      ),
                                    ),
                                  ),
                                  ...(selectedUser == null
                                          ? userReport.data
                                          : userReport.data.where((user) =>
                                              user.userName == selectedUser))
                                      .map((user) {
                                    return Container(
                                      height: 44,
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 6,
                                            height: 6,
                                            decoration: BoxDecoration(
                                              color: user.isActive
                                                  ? Colors.green.shade700
                                                  : Colors.red.shade700,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Flexible(
                                            child: Text(
                                              user.userName,
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontFamily: "poppins_thin",
                                                color: Colors.black87,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  Container(
                                    height: 44,
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 6,
                                          height: 6,
                                          decoration: BoxDecoration(
                                            color: Colors.green.shade700,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Total',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontFamily: "poppins_thin",
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Scrollable Columns
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columnSpacing: 20,
                                  dataRowHeight: 44,
                                  headingRowHeight: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.white60,
                                  ),
                                  columns: userReport.totals.map((total) {
                                    return DataColumn(
                                      label: Text(
                                        total.month,
                                        style: TextStyle(
                                          fontSize: 11.4,
                                          fontFamily: "poppins_thin",
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepPurple[900],
                                        ),
                                      ),
                                    );
                                  }).toList()
                                    ..add(
                                      DataColumn(
                                        label: Text(
                                          'Total',
                                          style: TextStyle(
                                            fontSize: 11.4,
                                            fontFamily: "poppins_thin",
                                            fontWeight: FontWeight.bold,
                                            color: Colors.deepPurple[900],
                                          ),
                                        ),
                                      ),
                                    ),
                                  rows: [
                                    ...(selectedUser == null
                                            ? userReport.data
                                            : userReport.data.where((user) =>
                                                user.userName == selectedUser))
                                        .map((user) {
                                      return DataRow(
                                        cells: user.months.map((month) {
                                          return DataCell(
                                            Text(
                                              month.cancelBookingCount == "0" ||
                                                      month.cancelBookingCount ==
                                                          0
                                                  ? month.bookingCount
                                                      .toString()
                                                  : "${month.bookingCount} (${month.cancelBookingCount})",
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontFamily: "poppins_thin",
                                                color: Colors.black87,
                                              ),
                                            ),
                                          );
                                        }).toList()
                                          ..add(
                                            DataCell(
                                              Text(
                                                user.totalCancel == "0" ||
                                                        user.totalCancel == 0
                                                    ? user.totalBooking
                                                        .toString()
                                                    : "${user.totalBooking} (${user.totalCancel})",
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontFamily: "poppins_thin",
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ),
                                          ),
                                      );
                                    }).toList(),
                                    DataRow(
                                      cells: userReport.totals.map((total) {
                                        return DataCell(
                                          Text(
                                            selectedUser == null
                                                ? (total.totalCancel == "0" ||
                                                        total.totalCancel == 0
                                                    ? total.totalBooking
                                                        .toString()
                                                    : "${total.totalBooking} (${total.totalCancel})")
                                                : (total.totalCancel == "0" ||
                                                        total.totalCancel == 0
                                                    ? "${userReport.data.firstWhere((user) => user.userName == selectedUser).months[userReport.totals.indexOf(total)].bookingCount}"
                                                    : "${userReport.data.firstWhere((user) => user.userName == selectedUser).months[userReport.totals.indexOf(total)].bookingCount} (${userReport.data.firstWhere((user) => user.userName == selectedUser).months[userReport.totals.indexOf(total)].cancelBookingCount})"),
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontFamily: "poppins_thin",
                                              color: Colors.black87,
                                            ),
                                          ),
                                        );
                                      }).toList()
                                        ..add(
                                          DataCell(
                                            Text(
                                              selectedUser == null
                                                  ? (userReport.finalTotalCancel ==
                                                              "0" ||
                                                          userReport
                                                                  .finalTotalCancel == 0
                                                      ? userReport
                                                          .finalTotalBooking
                                                          .toString()
                                                      : "${userReport.finalTotalBooking} (${userReport.finalTotalCancel})")
                                                  : (userReport.finalTotalCancel == "0" || userReport.finalTotalCancel == 0
                                                      ? userReport.data
                                                          .firstWhere((user) =>
                                                              user.userName ==
                                                              selectedUser)
                                                          .totalBooking
                                                          .toString()
                                                      : "${userReport.data.firstWhere((user) => user.userName == selectedUser).totalBooking.toString()} (${userReport.data.firstWhere((user) => user.userName == selectedUser).totalCancel.toString()})"),
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontFamily: "poppins_thin",
                                                color: Colors.black87,
                                              ),
                                            ),

                                            // Text(
                                            //   selectedUser == null
                                            //       ? userReport.finalTotalBooking.toString()
                                            //       : userReport.data
                                            //       .firstWhere((user) => user.userName == selectedUser)
                                            //       .totalBooking
                                            //       .toString(),
                                            //   style: TextStyle(
                                            //     fontSize: 10,
                                            //     fontFamily: "poppins_thin",
                                            //     color: Colors.black87,
                                            //   ),
                                            // ),
                                          ),
                                        ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                    ],
                  );
                },
              ),
            ),
          ),

          // Source Wise Conversions Tab
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  if (userProvider.isConversionsRpLoading) {
                    return _buildShimmerEffect();
                  }
                  final sourceReport =
                      userProvider.conversionsReportData?.sourceReport;
                  if (sourceReport == null ||
                      sourceReport.sourceArray.isEmpty ||
                      sourceReport.sourcedataWise.isEmpty ||
                      sourceReport.sourcedataWise
                          .every((source) => source.data.isEmpty)) {
                    return Center(
                      child: Text(
                        'No data available',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: "poppins_thin",
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }

                  // Define colors for sources dynamically
                  final sourceColors = [
                    Color(0xff008ffb), // Blue
                    Color(0xff00e396), // Green
                    Color(0xfffeb019), // Orange
                    Color(0xffff4560), // Red
                    Color(0xff775dd0), // Purple
                    Color(0xff00bcd4), // Cyan
                    Color(0xff8bc34a), // Light Green
                    Color(0xffff9800), // Deep Orange
                    Colors.lime,
                    Colors.indigo,
                    Colors.teal,
                    Colors.deepOrange,
                    Colors.deepOrangeAccent,
                    Colors.deepPurple,
                  ];

                  // Get unique p_shortname values
                  List<String> uniquePShortNames = sourceReport
                      .sourcedataWise.first.data
                      .map((datum) => datum.pshortName.toString())
                      .toList();

                  // Calculate maxY with a fallback
                  final liveCounts = sourceReport.sourcedataWise
                      .expand((source) => source.data.map(
                          (d) => double.tryParse(d.liveCount.toString()) ?? 0))
                      .toList();

                  double maxY = liveCounts.isNotEmpty
                      ? liveCounts.reduce((a, b) => a > b ? a : b) * 1.4
                      : 10.0; // Fallback value if no data

                  // Ensure lineBarsData matches sourceArray order
                  final orderedSourceData =
                      sourceReport.sourceArray.map((sourceName) {
                    final indexInSourcedataWise =
                        sourceReport.sourcedataWise.indexWhere(
                      (source) =>
                          sourceReport.sourceArray[
                                  sourceReport.sourcedataWise.indexOf(source)]
                              .trim() ==
                          sourceName.trim(),
                    );
                    return sourceReport.sourcedataWise[indexInSourcedataWise];
                  }).toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Source Wise Conversions',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: "poppins_thin",
                              color: Colors.black,
                            ),
                          ),
                          Icon(Icons.bar_chart, color: Colors.black, size: 20),
                        ],
                      ),
                      SizedBox(height: 20),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: sourceReport.sourceArray
                              .asMap()
                              .entries
                              .map((entry) {
                            int idx = entry.key;
                            String source = entry.value.trim();
                            return Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: _buildLegendItem(
                                source,
                                sourceColors[idx % sourceColors.length],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 20),
                      Card(
                        elevation: 3,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SizedBox(
                            height: 240,
                            width: double.infinity,
                            child: LineChart(
                              LineChartData(
                                gridData: FlGridData(show: false),
                                titlesData: FlTitlesData(
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      interval: 1,
                                      getTitlesWidget: (value, meta) {
                                        final int index = value.toInt();
                                        if (index >= 0 &&
                                            index < uniquePShortNames.length) {
                                          return Text(
                                            uniquePShortNames[index],
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 9,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          );
                                        }
                                        return Text('');
                                      },
                                      reservedSize: 22,
                                    ),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 50,
                                      interval: (maxY / 5).ceilToDouble(),
                                      getTitlesWidget: (value, meta) {
                                        if (value == 0 || value == maxY) {
                                          return Text(
                                            value.toInt().toString(),
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          );
                                        }
                                        return Text(
                                          value.toInt().toString(),
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  rightTitles: AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                  topTitles: AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                ),
                                borderData: FlBorderData(show: false),
                                lineTouchData: LineTouchData(
                                  enabled: true,
                                  touchTooltipData: LineTouchTooltipData(
                                    tooltipRoundedRadius: 8,
                                    tooltipPadding: const EdgeInsets.all(8),
                                    tooltipMargin: 4,
                                    fitInsideHorizontally: true,
                                    getTooltipItems:
                                        (List<LineBarSpot> touchedSpots) {
                                      return touchedSpots
                                          .map((LineBarSpot spot) {
                                        final lineIndex = spot.barIndex;
                                        final yValue = spot.y.toInt();
                                        return LineTooltipItem(
                                          '$yValue',
                                          TextStyle(
                                            color: sourceColors[lineIndex %
                                                sourceColors.length],
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        );
                                      }).toList();
                                    },
                                  ),
                                  handleBuiltInTouches: true,
                                ),
                                lineBarsData: orderedSourceData
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  int idx = entry.key;
                                  var sourceData = entry.value.data;
                                  return LineChartBarData(
                                    spots: sourceData
                                        .asMap()
                                        .entries
                                        .map((dataEntry) {
                                      int x = dataEntry.key;
                                      double y = double.tryParse(dataEntry
                                              .value.liveCount
                                              .toString()) ??
                                          0;
                                      return FlSpot(x.toDouble(), y);
                                    }).toList(),
                                    isCurved: true,
                                    color:
                                        sourceColors[idx % sourceColors.length],
                                    barWidth: 4,
                                    dotData: FlDotData(show: false),
                                    belowBarData: BarAreaData(
                                      show: false,
                                      color: sourceColors[
                                              idx % sourceColors.length]
                                          .withOpacity(0.3),
                                    ),
                                  );
                                }).toList(),
                                minX: 0,
                                maxX: (uniquePShortNames.length - 1).toDouble(),
                                minY: 0,
                                maxY: maxY,
                                extraLinesData: ExtraLinesData(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Card(
                        elevation: 3,
                        color: Colors.white,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 120,
                              child: Column(
                                children: [
                                  Container(
                                    height: 50,
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Source',
                                      style: TextStyle(
                                        fontSize: 11.4,
                                        fontFamily: "poppins_thin",
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurple[900],
                                      ),
                                    ),
                                  ),
                                  ...sourceReport.sourceArray.map((source) {
                                    return Container(
                                      height: 44,
                                      alignment: Alignment.center,
                                      child: Text(
                                        source.trim(),
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontFamily: "poppins_thin",
                                          color: Colors.black87,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                                  }).toList(),
                                  Container(
                                    height: 44,
                                    alignment: Alignment.center,
                                    child: Text(
                                      'TOTAL',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontFamily: "poppins_thin",
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columnSpacing: 20,
                                  dataRowHeight: 44,
                                  headingRowHeight: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.white60,
                                  ),
                                  columns: _generateColumns(sourceReport),
                                  rows: _generateRows(sourceReport),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _calculateColumnTotal(dynamic sourceReport, int columnIndex) {
    int totalLive = 0;
    int totalCancel = 0;

    for (var source in sourceReport.sourcedataWise) {
      final data = source.data[columnIndex];
      totalLive += int.parse(data.liveCount.toString());
      totalCancel += int.parse(data.cancelCount.toString());
    }

    return totalCancel == 0
        ? totalLive.toString()
        : "$totalLive ($totalCancel)";
  }

  Widget _buildLegendItem(String title, Color color,
      {bool isSelected = false}) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border:
                isSelected ? Border.all(color: Colors.black, width: 2) : null,
          ),
        ),
        SizedBox(width: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            fontFamily: "poppins_thin",
            color: Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  TextStyle _cellTextStyle() {
    return TextStyle(
      fontSize: 10,
      fontFamily: "poppins_thin",
      color: Colors.black87,
    );
  }

  Widget _buildShimmerEffect() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 150,
                  height: 15,
                  color: Colors.white,
                ),
                Container(
                  width: 20,
                  height: 20,
                  color: Colors.white,
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 300,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 150,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

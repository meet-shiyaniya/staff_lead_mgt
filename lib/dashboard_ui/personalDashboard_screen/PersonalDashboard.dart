import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../Provider/UserProvider.dart';
import '../../social_module/colors/colors.dart';
import '../../staff_HRM_module/Model/Realtomodels/Realtostaffprofilemodel.dart';
// import '../../staff_HRM_module/RealtosmartdashboardModel.dart';
import '../CustomAngleMenu.dart';
import '../DashboardModels/RealtosmartdashboardModel.dart';
import '../dashboard2/dashboard2.dart';
import '../main_dashboard/activity_screen.dart';
import '../main_dashboard/pending_followUp.dart';
import '../main_dashboard/report_ui.dart';

class PersonalDashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<PersonalDashboardScreen>
    with SingleTickerProviderStateMixin {
  String _selectedFilter = 'Monthly'; // Default is Monthly
  String _selectedCategory = 'Inquiry';
  late TabController _tabController;
  bool _isInitialLoad = true;
  // Track if it's the initial load
  bool _showAllLogs = false; // New state variable
  bool _showAllFollowups = false; // New state variable for follow-up report
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _isMenuOpen = false;

  List<Widget> _buildActivityLogs(RealtosmartdashboardModel? dashboardData) {
    if (dashboardData == null ||
        dashboardData.activityLogReport == null ||
        dashboardData.activityLogReport!.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            'No activity logs available',
            style: TextStyle(
              fontFamily: "poppins_thin",
              color: Colors.grey,
            ),
          ),
        ),
      ];
    }

    // Limit to 3 logs initially unless _showAllLogs is true
    final logsToShow = _showAllLogs
        ? dashboardData.activityLogReport!
        : dashboardData.activityLogReport!.take(3).toList();

    // Build the list of log tiles
    List<Widget> logWidgets = logsToShow.map((log) {
      String fullDateTime = log.createdDates ?? ''; // "1-3-25 10:58"
      List<String> dateTimeParts =
          fullDateTime.split(' '); // Splits into ["1-3-25", "10:58"]

      return _buildLogTile(
        date: dateTimeParts.isNotEmpty ? dateTimeParts[0] : '', // "1-3-25"
        time: dateTimeParts.length > 1 ? dateTimeParts[1] : '', // "10:58"
        id: log.inquiryId,
        name: log.usernamee ?? '',
        status: log.btnNameStage ?? '',
        type: log.btnName ?? '',
        description: log.inquiryLog ?? '',
      );
    }).toList();

    // Add "Show More" / "Show Less" icon if there are more than 3 logs
    if (dashboardData.activityLogReport!.length > 3) {
      logWidgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _showAllLogs =
                    !_showAllLogs; // Toggle between showing 3 and all logs
              });
            },
            child: Center(
              child: Icon(
                _showAllLogs
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down, // Change icon based on state
                size: 30,
                color: Colors.deepPurple,
              ),
            ),
          ),
        ),
      );
    }

    return logWidgets;
  }

  List<Widget> _buildFollowupReport(RealtosmartdashboardModel? dashboardData) {
    if (dashboardData == null ||
        dashboardData.followupReport == null ||
        dashboardData.followupReport!.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            'No follow-up reports available',
            style: TextStyle(
              fontFamily: "poppins_thin",
              color: Colors.grey,
            ),
          ),
        ),
      ];
    }

    final followupsToShow = _showAllFollowups
        ? dashboardData.followupReport!
        : dashboardData.followupReport!.take(3).toList();

    List<Widget> followupWidgets = followupsToShow.map((followup) {
      return _buildFollowupTile(
        id: followup.inquiryId.toString(), // Ensure String, safe even if null
        createdDate: followup.createdDates ?? '',
        username: followup.usernamee ?? '',
        stage: followup.inquiryStages ?? '',
        type: followup.inquiryTypeName ?? '',
        nextFollowupDate: followup.nxtfollowdate ?? '',
        remark: followup.remark ?? '',
      );
    }).toList();

    if (dashboardData.followupReport!.length > 3) {
      followupWidgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _showAllFollowups = !_showAllFollowups;
              });
            },
            child: Center(
              child: Icon(
                _showAllFollowups
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down, // Change icon based on state
                size: 30,
                color: Colors.teal.shade200,
              ),
            ),
          ),
        ),
      );
    }

    return followupWidgets;
  }

  Map<DateTime, Map<String, List<TDatum>>> _getCalendarEvents(
      RealtosmartdashboardModel? dashboardData) {
    final events = <DateTime, Map<String, List<TDatum>>>{};
    if (dashboardData?.calenderData == null) return events;

    void addEvent(DateTime date, String type, TDatum event) {
      events[date] = events[date] ?? {};
      events[date]![type] = events[date]![type] ?? [];
      events[date]![type]!.add(event);
    }

    for (var appointment
        in dashboardData!.calenderData!.appointmentData ?? []) {
      if (appointment.start != null) {
        final date = DateTime(appointment.start!.year, appointment.start!.month,
            appointment.start!.day);
        addEvent(date, 'appointment', appointment);
      }
    }

    for (var reappointment
        in dashboardData!.calenderData!.reappointmentData ?? []) {
      if (reappointment is Map<String, dynamic> &&
          reappointment['start'] != null) {
        final date = DateTime.parse(reappointment['start'] as String);
        addEvent(date, 'reappointment', TDatum.fromJson(reappointment));
      }
    }

    for (var visit in dashboardData!.calenderData!.visitData ?? []) {
      if (visit.start != null) {
        final date =
            DateTime(visit.start!.year, visit.start!.month, visit.start!.day);
        addEvent(date, 'visit', visit);
      }
    }

    for (var revisit in dashboardData!.calenderData!.revisitData ?? []) {
      if (revisit is Map<String, dynamic> && revisit['start'] != null) {
        final date = DateTime.parse(revisit['start'] as String);
        addEvent(date, 'revisit', TDatum.fromJson(revisit));
      }
    }

    return events;
  }

  Widget _buildCalendarContent(RealtosmartdashboardModel? dashboardData) {
    if (dashboardData == null) return SizedBox.shrink();
    final events = _getCalendarEvents(dashboardData);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Activity Calendar",
            style: TextStyle(
              fontSize: 18,
              fontFamily: "poppins_thin",
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: CalendarFormat.month,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: (day) {
              final date = DateTime(day.year, day.month, day.day);
              final dayEvents = events[date];
              if (dayEvents == null) return [];
              return [
                ...(dayEvents['appointment'] ?? []),
                ...(dayEvents['reappointment'] ?? []),
                ...(dayEvents['visit'] ?? []),
                ...(dayEvents['revisit'] ?? []),
              ];
            },
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'poppins_thin',
                  fontSize: 12),
              weekendStyle: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'poppins_thin',
                  fontSize: 12),
            ),
            headerStyle: HeaderStyle(
              titleTextStyle: TextStyle(
                fontSize: 16,
                fontFamily: "poppins_thin",
                color: Colors.black87,
              ),
              leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black87),
              rightChevronIcon:
                  Icon(Icons.chevron_right, color: Colors.black87),
              formatButtonVisible: false,
            ),
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              todayDecoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.4),
                shape: BoxShape.circle,
                // borderRadius: BorderRadius.circular(8),
                // border: Border.all(color: Colors.grey.shade200, width: 1), // Border for selected
              ),
              defaultTextStyle: TextStyle(
                  color: Colors.black,
                  fontFamily: "poppins_light",
                  fontWeight: FontWeight.bold),
              weekendTextStyle: TextStyle(
                  color: Colors.red.shade300, fontFamily: "poppins_thin"),
              outsideTextStyle: TextStyle(color: Colors.grey),
            ),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isNotEmpty) {
                  final typedEvents = events.cast<TDatum>();
                  final appointmentCount = typedEvents
                      .where((e) =>
                          e.start != null &&
                          dashboardData.calenderData!.appointmentData!
                              .contains(e))
                      .fold(
                          0,
                          (sum, e) =>
                              sum + (int.tryParse(e.title ?? '0') ?? 0));
                  final reappointmentCount = typedEvents
                      .where((e) =>
                          e.start != null &&
                          dashboardData.calenderData!.reappointmentData!
                              .contains(e))
                      .fold(
                          0,
                          (sum, e) =>
                              sum + (int.tryParse(e.title ?? '0') ?? 0));
                  final visitCount = typedEvents
                      .where((e) =>
                          e.start != null &&
                          dashboardData.calenderData!.visitData!.contains(e))
                      .fold(
                          0,
                          (sum, e) =>
                              sum + (int.tryParse(e.title ?? '0') ?? 0));
                  final revisitCount = typedEvents
                      .where((e) =>
                          e.start != null &&
                          dashboardData.calenderData!.revisitData!.contains(e))
                      .fold(
                          0,
                          (sum, e) =>
                              sum + (int.tryParse(e.title ?? '0') ?? 0));

                  return Positioned(
                    bottom: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (appointmentCount > 0)
                          _buildMarker("#cfbaf0", appointmentCount),
                        if (reappointmentCount > 0)
                          _buildMarker("#ffcfd2", reappointmentCount),
                        if (visitCount > 0) _buildMarker("#f1c0e8", visitCount),
                        if (revisitCount > 0)
                          _buildMarker("#b9fbc0", revisitCount),
                      ],
                    ),
                  );
                }
                return null;
              },
            ),
          ),
          SizedBox(height: 16),
          // Legend
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegendItem("#cfbaf0", "Appointments"),
                  SizedBox(width: 16),
                  _buildLegendItem("#ffcfd2", "Reappointments"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegendItem("#f1c0e8", "Visits"),
                  SizedBox(width: 16),
                  _buildLegendItem("#b9fbc0", "Revisits"),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          if (_selectedDay != null && events[_selectedDay] != null) ...[
            if (events[_selectedDay]!['appointment'] != null)
              ...events[_selectedDay]!['appointment']!
                  .map((e) => _buildEventTile(e, 'Appointment')),
            if (events[_selectedDay]!['reappointment'] != null)
              ...events[_selectedDay]!['reappointment']!
                  .map((e) => _buildEventTile(e, 'Reappointment')),
            if (events[_selectedDay]!['visit'] != null)
              ...events[_selectedDay]!['visit']!
                  .map((e) => _buildEventTile(e, 'Visit')),
            if (events[_selectedDay]!['revisit'] != null)
              ...events[_selectedDay]!['revisit']!
                  .map((e) => _buildEventTile(e, 'Revisit')),
          ],
        ],
      ),
    );
  }

  Widget _buildMarker(String colorHex, int count) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Color(int.parse(colorHex.replaceFirst('#', '0xff'))),
        shape: BoxShape.circle,
      ),
      child: Text(
        count.toString(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLegendItem(String colorHex, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: Color(int.parse(colorHex.replaceFirst('#', '0xff'))),
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontFamily: "poppins_thin",
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildEventTile(TDatum event, String type) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: Color(int.parse(event.color!.replaceFirst('#', '0xff'))),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$type: ${event.title ?? '0'}',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: "poppins_thin",
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  event.start != null ? event.start!.toString() : '',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: "poppins_thin",
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCalendarDialog(RealtosmartdashboardModel? dashboardData) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Calendar",
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.transparent,
          child: _buildCalendarContent(dashboardData),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: anim1.value,
          child: Opacity(
            opacity: anim1.value,
            child: child,
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Fetch initial data with 'month' as default
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.fetchDashboard(countwise: 'month'); // Ensure initial fetch
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<BarChartGroupData> _getBarChartData(UserProvider userProvider) {
    final dashboardData = userProvider.DashBoarddata;
    if (dashboardData == null ||
        dashboardData.chartCount == null ||
        dashboardData.chartCount!.isEmpty) return [];

    final Map<String, Color> colorMap = {
      'Inquiry': Colors.deepPurple,
      'Lead': Colors.blue.shade300,
      'Data': Colors.green.shade300,
      'Visit': Colors.orange.shade300,
      'Cancel Booking': Colors.red.shade300,
      'Conversion': Colors.teal.shade300,
    };

    return dashboardData.chartCount!.map((chart) {
      double value = 0.0;
      try {
        switch (_selectedCategory) {
          case 'Inquiry':
            value = double.parse(chart.inquiry ?? '0');
            break;
          case 'Lead':
            value = double.parse(chart.lead ?? '0');
            break;
          case 'Data':
            value = double.parse(chart.data ?? '0');
            break;
          case 'Visit':
            value = double.parse(chart.visit ?? '0');
            break;
          case 'Cancel Booking':
            value = double.parse(chart.cancleBooking ?? '0');
            break;
          case 'Conversion':
            value = double.parse(chart.booking ?? '0');
            break;
          default:
            value = double.parse(chart.inquiry ?? '0');
        }
      } catch (e) {
        value = 0.0;
        debugPrint('Error parsing chart data: $e');
      }

      return BarChartGroupData(
        x: dashboardData.chartCount!.indexOf(chart),
        barRods: [
          BarChartRodData(
            toY: value,
            color: colorMap[_selectedCategory] ?? Colors.deepPurple,
            width: 20,
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      );
    }).toList();
  }

  String _getBottomTitle(UserProvider userProvider, double value) {
    final dashboardData = userProvider.DashBoarddata;
    if (dashboardData == null ||
        dashboardData.chartCount == null ||
        dashboardData.chartCount!.isEmpty) return '';

    final index = value.toInt();
    if (index >= 0 && index < dashboardData.chartCount!.length) {
      final rawDate = dashboardData.chartCount![index].datefild ?? '';
      if (rawDate.isEmpty) return '';

      switch (_selectedFilter) {
        case 'Weekly':
          try {
            final date = DateTime.parse(rawDate);
            return DateFormat('dd-MM').format(date);
          } catch (e) {
            debugPrint('Weekly parsing error: $e');
            if (rawDate.length >= 10 && rawDate.contains('-')) {
              final parts = rawDate.split('-');
              if (parts.length == 3) return '${parts[2]}-${parts[1]}';
            }
            return '';
          }
        case 'Monthly':
          try {
            final date = DateTime.parse(rawDate.padRight(10, '-01'));
            return DateFormat('MMM').format(date);
          } catch (e) {
            debugPrint('Monthly parsing error: $e');
            if (rawDate.length >= 7 && rawDate.contains('-')) {
              final parts = rawDate.split('-');
              if (parts.length >= 2) {
                final monthNum = int.tryParse(parts[1]) ?? 1;
                return DateFormat('MMM').format(DateTime(2000, monthNum, 1));
              }
            }
            return '';
          }
        case 'Yearly':
          try {
            final date = DateTime.parse(rawDate.padRight(10, '-01'));
            return DateFormat('yyyy').format(date);
          } catch (e) {
            debugPrint('Yearly parsing error: $e');
            if (rawDate.length == 4) return rawDate;
            return '';
          }
        default:
          return '';
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildHeader(UserProvider userProvider) {
      final dashboardData = userProvider.DashBoarddata;
      final permissions = userProvider.dashboardpermissionModel;
      final appointmentCalendarPermission =
          // permissions?.appointmentCalender ?? false;
permissions?.appointmentCalender ?? true;

      final profile = userProvider.profileData;
      return Padding(
        padding: const EdgeInsets.only(left: 10, right: 6),
        child: Row(
          children: [
            Icon(Icons.person),
            SizedBox(width: 10),
            Text("My Task",
                   style: TextStyle(fontFamily: "poppins_thin", fontSize: 18)),
            Spacer(),
            if (appointmentCalendarPermission) // Only show if permitted
              GestureDetector(
                  onTap: () {
                    _showCalendarDialog(
                        dashboardData); // Open calendar in dialog
                  },
                  child: Image.asset("asset/Dashboard/Calendar.png",
                      height: 28, width: 28)),
          ],
        ),
      );
    }

    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final dashboardData = userProvider.DashBoarddata;
        final permissions = userProvider
            .dashboardpermissionModel; // Assuming this holds the permissions

        // Extract permissions with defaults (false if null)
        final todayTaskPermission = true;
        final performancePercentagePermission =
            true;
        final chatTablePermission = permissions?.dashbordChatTable ?? true;
        // final chatTablePermission = permissions?.dashbordChatTable ?? false;
        final pendingFollowupPermission =
            true;
        final siteConversationPermission =
            permissions?.dashbordSiteConversation ?? false;
        final upcomingTodayVisitPermission =
        true;
        final leadQualityPermission = permissions?.dashbordLeadQuality ?? false;
        final dismissInqReportPermission =
            permissions?.dashbordDismissInqReport ?? false;
        final followupsSectionPermission =
            true;
        final activitySectionPermission =
            true;
        final statusWiseInPermission =
            true;
        // final permissions = userProvider
        //     .dashboardpermissionModel; // Assuming this holds the permissions
        //
        // // Extract permissions with defaults (false if null)
        // final todayTaskPermission = permissions?.dashbordTodayTask ?? false;
        // final performancePercentagePermission =
        //     permissions?.dashbordPerfomancePercentage ?? false;
        // final chatTablePermission = permissions?.dashbordChatTable ?? false;
        // final pendingFollowupPermission =
        //     permissions?.dashbordPendingFollowup ?? false;
        // final siteConversationPermission =
        //     permissions?.dashbordSiteConversation ?? false;
        // final upcomingTodayVisitPermission =
        //     permissions?.upcomingTodayVisit ?? false;
        // final leadQualityPermission = permissions?.dashbordLeadQuality ?? false;
        // final dismissInqReportPermission =
        //     permissions?.dashbordDismissInqReport ?? false;
        // final followupsSectionPermission =
        //     permissions?.dashbordFollowupsSection ?? false;
        // final activitySectionPermission =
        //     permissions?.dashbordActivitySection ?? false;
        // final statusWiseInPermission =
        //     permissions?.dashbordStatusWiseIn ?? false;

        if (_isInitialLoad && userProvider.isLoading) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      _buildShimmerHeader(),
                      SizedBox(height: 10),
                      _buildShimmerSummaryCards(),
                      SizedBox(height: 10),
                      _buildShimmerPerformanceSection(),
                      SizedBox(height: 10),
                      _buildShimmerTabBar(),
                      SizedBox(height: 12),
                      _buildShimmerTabContent(),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        if (_isInitialLoad && userProvider.isLoading) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      _buildShimmerHeader(),
                      SizedBox(height: 10),
                      _buildShimmerSummaryCards(),
                      SizedBox(height: 10),
                      _buildShimmerPerformanceSection(),
                      SizedBox(height: 10),
                      _buildShimmerTabBar(),
                      SizedBox(height: 12),
                      _buildShimmerTabContent(),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        if (_isInitialLoad && !userProvider.isLoading) {
          _isInitialLoad = false;
        }

        return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (todayTaskPermission) ...[
                    _buildHeader(userProvider),
                    SizedBox(height: 10),
                  ],
                  if (pendingFollowupPermission) ...[
                    _buildSummaryCards(dashboardData),
                    SizedBox(height: 10),
                  ],
                  if (performancePercentagePermission) ...[
                    _buildPerformanceSection(userProvider),
                    SizedBox(height: 10),
                  ],
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 5.0, bottom: 10, right: 10),
                    child: Row(
                      children: [
                        Text(
                          'Performance',
                          style: TextStyle(
                              fontSize: 17,
                              fontFamily: "poppins_thin",
                              color: Colors.deepPurple[900]),
                        ),
                        Spacer(),
                        CustomAngleMenu(
                          mainIcon: Icons.bar_chart_outlined,
                          mainButtonColor: Colors.white60,
                          menuItems: [
                            CustomMenuItem(
                              angle: 138,
                              imagePath:
                                  'asset/Dashboard/pending_followup.png', // Replace with your image
                              onTap: () => print("pending followuplist"),
                            ),
                            CustomMenuItem(
                              angle: 92,
                              imagePath: 'asset/Dashboard/follow-up.png',
                              onTap: () => print("Folloup report"),
                            ),
                            CustomMenuItem(
                              angle: 180,
                              imagePath: 'asset/Dashboard/performance.png',
                              onTap: () => print("Performance"),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),

                  if (chatTablePermission) ...[
                    _buildPerformanceTab(dashboardData),
                    SizedBox(height: 10),
                  ],
                  if (statusWiseInPermission) ...[
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 4,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 5.0, bottom: 10, right: 10),
                            child: Row(
                              children: [
                                Text(
                                  'Status Wise Inq',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontFamily: "poppins_thin",
                                      color: Colors.deepPurple[900]),
                                ),
                                Spacer(),
                                Icon(Icons.leaderboard_outlined,
                                    color: Colors.deepPurple[400]),
                              ],
                            ),
                          ),
                          dashboardData != null &&
                                  dashboardData.getCountStatusWise != null
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount:
                                      dashboardData.getCountStatusWise!.length,
                                  itemBuilder: (context, index) {
                                    final status = dashboardData
                                        .getCountStatusWise![index];
                                    return _buildStatusTile(
                                      status.inqStatusName ?? 'Unknown',
                                      int.tryParse(status.totalInq ?? '0') ?? 0,
                                      _getStatusColor(
                                          status.inqStatusName ?? 'Unknown'),
                                    );
                                  },
                                )
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20.0),
                                  child: Text(
                                    'No status data available',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                  if (activitySectionPermission) ...[
                    Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Activity Logs(${dashboardData?.activityLogReport?.length ?? 0})',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "poppins_thin",
                                  color: Colors.black87,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Container(
                                  height: 30,
                                  width:
                                      MediaQuery.of(context).size.width / 3.6,
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurple.shade300,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "More Activities",
                                      style: TextStyle(
                                        fontFamily: "poppins_thin",
                                        fontSize: 11,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          ..._buildActivityLogs(dashboardData),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                  if (followupsSectionPermission) ...[
                    Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Follow-up Report(${dashboardData?.followupReport?.length ?? 0})',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "poppins_thin",
                                  color: Colors.black87,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // Add functionality for "More Follow Ups"
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple[300],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  minimumSize: Size(80, 30),
                                ),
                                child: Text(
                                  'More Follow Ups',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "poppins_thin",
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          ..._buildFollowupReport(dashboardData),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                  if (chatTablePermission) ...[
                    _buildUserDataPendingSection(dashboardData),
                    SizedBox(height: 10),
                  ],
                  // New Upcoming Visits Section
                  if (upcomingTodayVisitPermission &&
                      dashboardData != null) ...[
                    _buildUpcomingVisits(dashboardData),
                    SizedBox(height: 10),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmerHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        children: [
          Container(width: 24, height: 24, color: Colors.white),
          SizedBox(width: 10),
          Container(width: 100, height: 18, color: Colors.white),
          Spacer(),
          Container(width: 100, height: 50, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildShimmerSummaryCards() {
    return Row(
      children: List.generate(
        4,
        (index) => Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 5, right: 5),
            height: MediaQuery.of(context).size.height / 8.5,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15)),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerPerformanceSection() {
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
                Container(width: 100, height: 18, color: Colors.white),
                Spacer(),
                Container(width: 100, height: 40, color: Colors.white),
              ],
            ),
            SizedBox(height: 10),
            Container(height: 200, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerTabBar() {
    return Container(
      height: 45,
      margin: EdgeInsets.only(left: 15, right: 15),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
    );
  }

  Widget _buildShimmerTabContent() {
    return Container(
      height: MediaQuery.of(context).size.height / 2.5,
      color: Colors.white,
    );
  }

  Widget _buildSummaryCards(RealtosmartdashboardModel? dashboardData) {
    final totalLeads = dashboardData != null &&
            dashboardData.totalUserData != null &&
            dashboardData.totalUserData!.isNotEmpty
        ? dashboardData.totalUserData!.first.total?.toString() ?? '0'
        : '0';
    final visitCount = dashboardData?.visitCount?.toString() ?? '0';
    final bookingCount = dashboardData?.bookingCount?.toString() ?? '0';
    final pendingFollowupCount =
        dashboardData?.pendingFollowupCount?.toString() ?? '0';

    return Row(
      children: [
        Expanded(
            child: _buildSummaryCard(
                'asset/Dashboard/leads.png', totalLeads, Colors.blue.shade50)),
        Expanded(
            child: _buildSummaryCard('asset/Dashboard/visit.png', visitCount,
                Colors.yellow.shade50)),
        Expanded(
            child: _buildSummaryCard('asset/Dashboard/booking.png',
                bookingCount, Colors.green.shade50)),
        Expanded(
            child: _buildSummaryCard('asset/Dashboard/followUp.png',
                pendingFollowupCount, Colors.red.shade50)),
      ],
    );
  }

  Widget _buildSummaryCard(String image, String value, Color color) {
    return Container(
      margin: const EdgeInsets.only(left: 5, right: 5),
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
              spreadRadius: 1)
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(height: 10),
            Image.asset(image, height: 30, width: 30),
            Spacer(),
            Text(value,
                style: TextStyle(fontSize: 16, fontFamily: "poppins_thin")),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceSection(UserProvider userProvider) {
    final dashboardData = userProvider.DashBoarddata;
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
                      fontFamily: "poppins_thin",
                      color: Colors.deepPurple[900]),
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
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                            value: 'Inquiry',
                            child: Text('Inquiry',
                                style: TextStyle(fontFamily: "poppins_thin"))),
                        PopupMenuItem<String>(
                            value: 'Lead',
                            child: Text('Lead',
                                style: TextStyle(fontFamily: "poppins_thin"))),
                        PopupMenuItem<String>(
                            value: 'Data',
                            child: Text('Data',
                                style: TextStyle(fontFamily: "poppins_thin"))),
                        PopupMenuItem<String>(
                            value: 'Visit',
                            child: Text('Visit',
                                style: TextStyle(fontFamily: "poppins_thin"))),
                        PopupMenuItem<String>(
                            value: 'Cancel Booking',
                            child: Text('Cancel Booking',
                                style: TextStyle(fontFamily: "poppins_thin"))),
                        PopupMenuItem<String>(
                            value: 'Conversion',
                            child: Text('Conversion',
                                style: TextStyle(fontFamily: "poppins_thin"))),
                      ],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 8,
                      offset: Offset(0, 40),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                                color: Colors.deepPurple,
                                fontFamily: "poppins_thin",
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(Icons.arrow_drop_down,
                                color: Colors.deepPurple),
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
                            builder: (context) =>
                                _buildFilterOptions(userProvider),
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
              child: userProvider.isLoading && !_isInitialLoad
                  ? Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(height: 200, color: Colors.white),
                    )
                  : dashboardData == null ||
                          dashboardData.chartCount == null ||
                          dashboardData.chartCount!.isEmpty
                      ? Center(
                          child: Text('No chart data available',
                              style: TextStyle(color: Colors.grey)))
                      : BarChart(
                          BarChartData(
                            barGroups: _getBarChartData(userProvider),
                            borderData: FlBorderData(show: false),
                            titlesData: FlTitlesData(
                              show: true,
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  interval: 1,
                                  getTitlesWidget: (value, meta) => Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Transform.rotate(
                                      angle: -45 * 3.14159 / 180,
                                      child: Text(
                                        _getBottomTitle(userProvider, value),
                                        style: TextStyle(
                                            color: Colors.deepPurple[200],
                                            fontSize: 8),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              leftTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
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

  Widget _buildFilterOptions(UserProvider userProvider) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Select Time Filter',
              style: TextStyle(fontSize: 18, fontFamily: "poppins_thin")),
          SizedBox(height: 10),
          ...['Weekly', 'Monthly', 'Yearly']
              .map((filter) => ListTile(
                    leading:
                        Icon(_getFilterIcon(filter), color: Colors.deepPurple),
                    title: Text(filter,
                        style: TextStyle(
                            fontFamily: "poppins_light",
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                    onTap: () {
                      setState(() {
                        _selectedFilter = filter;
                        String countwise;
                        switch (filter) {
                          case 'Weekly':
                            countwise = 'week';
                            break;
                          case 'Monthly':
                            countwise = 'month';
                            break;
                          case 'Yearly':
                            countwise = 'year';
                            break;
                          default:
                            countwise = 'month';
                        }
                        userProvider.fetchDashboard(countwise: countwise);
                      });
                      Navigator.pop(context);
                    },
                  ))
              .toList(),
        ],
      ),
    );
  }

  IconData _getFilterIcon(String filter) {
    switch (filter) {
      case 'Weekly':
        return Icons.calendar_view_week;
      case 'Monthly':
        return Icons.calendar_view_month;
      case 'Yearly':
        return Icons.calendar_today;
      default:
        return Icons.calendar_view_month;
    }
  }

  // Widget _buildTabBar() {
  //   return Container(
  //     height: 45,
  //     margin: EdgeInsets.only(left: 15, right: 15),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(20),
  //       boxShadow: [BoxShadow(offset: Offset(1, 3), color: Colors.grey.shade300)],
  //     ),
  //     child: TabBar(
  //       controller: _tabController,
  //       indicatorSize: TabBarIndicatorSize.tab,
  //       indicator: BoxDecoration(color: Colors.deepPurple.withOpacity(0.9), borderRadius: BorderRadius.circular(8)),
  //       labelColor: Colors.white,
  //       unselectedLabelColor: Colors.deepPurple[900],
  //       tabs: [
  //         Tab(text: 'Performance'),
  //         Tab(text: 'Reports'),
  //         Tab(text: 'Activities'),
  //       ],
  //     ),
  //   );
  // }
  //
  // Widget _buildTabContent(RealtosmartdashboardModel? dashboardData) {
  //   return Container(
  //     height: MediaQuery.of(context).size.height / 2.5,
  //     child: TabBarView(
  //       controller: _tabController,
  //       children: [
  //         _buildPerformanceTab(dashboardData),
  //         ReportScreen(),
  //         InquiryDashboard(),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildPerformanceTab(RealtosmartdashboardModel? dashboardData) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Padding(
            //   padding: const EdgeInsets.only(left: 5.0, bottom: 10, right: 10),
            //   child: Row(
            //     children: [
            //       Text(
            //         'Performance',
            //         style: TextStyle(
            //             fontSize: 17,
            //             fontFamily: "poppins_thin",
            //             color: Colors.deepPurple[900]),
            //       ),
            //       Spacer(),
            //       CustomAngleMenu(
            //         mainIcon: Icons.bar_chart_outlined,
            //         mainButtonColor: Colors.white60,
            //         menuItems: [
            //           CustomMenuItem(
            //             angle: 138,
            //             imagePath: 'asset/Dashboard/pending_followup.png', // Replace with your image
            //             onTap: () => print("pending followuplist"),
            //           ),
            //           CustomMenuItem(
            //             angle: 92,
            //             imagePath: 'asset/Dashboard/follow-up.png',
            //             onTap: () => print("Folloup report"),
            //           ),
            //           CustomMenuItem(
            //             angle: 180,
            //             imagePath: 'asset/Dashboard/performance.png',
            //             onTap: () => print("Performance"),
            //           ),
            //         ],
            //
            //       )
            //     ],
            //   ),
            // ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 4,
                      blurRadius: 8,
                      offset: const Offset(0, 4)),
                ],
              ),
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Text('Date',
                          style: TextStyle(
                              fontFamily: "poppins_thin",
                              fontSize: 16,
                              color: Colors.blueGrey)),
                      Text('Leads',
                          style: TextStyle(
                              fontFamily: "poppins_thin",
                              fontSize: 16,
                              color: Colors.blueGrey)),
                      Text('Visits',
                          style: TextStyle(
                              fontFamily: "poppins_thin",
                              color: Colors.blueGrey)),
                      Text('Bookings',
                          style: TextStyle(
                              fontFamily: "poppins_thin",
                              color: Colors.blueGrey)),
                    ],
                  ),
                  const Divider(color: Colors.grey, thickness: 1),
                  if (dashboardData == null ||
                      dashboardData.perfomanceCount == null ||
                      dashboardData.perfomanceCount!.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Text('No performance data available',
                          style: TextStyle(color: Colors.grey)),
                    )
                  else
                    ...dashboardData.perfomanceCount!.map((data) {
                      // Parse coverstion_visit and coverstion_booking
                      String visitChangeText =
                          _extractPercentage(data.coverstionVisit ?? '');
                      bool isVisitDown =
                          (data.coverstionVisit ?? '').contains('↓');
                      String bookingChangeText =
                          _extractPercentage(data.coverstionBooking ?? '');
                      bool isBookingDown =
                          (data.coverstionBooking ?? '').contains('↓');

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(data.month ?? '',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black87)),
                            Text(data.leads ?? '0',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black87)),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(data.visit ?? '0',
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black87)),
                                const SizedBox(width: 4),
                                Row(
                                  children: [
                                    if (isVisitDown)
                                      Icon(Icons.arrow_downward,
                                          size: 12, color: Colors.red)
                                    else
                                      Icon(Icons.arrow_upward,
                                          size: 12, color: Colors.green),
                                    Text(
                                      visitChangeText,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isVisitDown
                                            ? Colors.red
                                            : Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(data.booking ?? '0',
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black87)),
                                const SizedBox(width: 4),
                                Row(
                                  children: [
                                    if (isBookingDown)
                                      Icon(Icons.arrow_downward,
                                          size: 12, color: Colors.red)
                                    else
                                      Icon(Icons.arrow_upward,
                                          size: 12, color: Colors.green),
                                    Text(
                                      bookingChangeText,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isBookingDown
                                            ? Colors.red
                                            : Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                  // // New Growth Section
                  // const Divider(color: Colors.grey, thickness: 1),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 3,),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //     children: [
                  //       Text(
                  //         'Growth',
                  //         style: TextStyle(
                  //             fontSize: 14,
                  //             fontFamily: "poppins_thin",
                  //             color: Colors.black87),
                  //       ),
                  //       Text(
                  //         dashboardData?.perfomanceGrowthCount?.isNotEmpty == true
                  //             ? dashboardData!
                  //             .perfomanceGrowthCount!.first.growthBoookings
                  //             .toString()
                  //             : '0',
                  //         style: TextStyle(
                  //             fontSize: 14,
                  //             fontFamily: "poppins_thin",
                  //             color: Colors.black87),
                  //       ),
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //         children: [
                  //           Text(
                  //             dashboardData!.perfomanceGrowthCount!.first.growthBoookings.toString(),
                  //             style: TextStyle(
                  //                 fontSize: 12,
                  //                 fontFamily: "poppins_thin",
                  //                 color: Colors.red),
                  //           ),
                  //         ],
                  //       ),
                  //       Row(
                  //         mainAxisSize: MainAxisSize.min,
                  //         children: [
                  //           Text(
                  //             dashboardData!.perfomanceGrowthCount!.first.growthVisits.toString(),
                  //             style: TextStyle(
                  //                 fontSize: 12,
                  //                 fontFamily: "poppins_thin",
                  //                 color: Colors.red),
                  //           ),
                  //
                  //         ],
                  //       ),
                  //       Text(
                  //         dashboardData!.perfomanceGrowthCount!.first.growthVisits.toString(),
                  //         style: TextStyle(
                  //             fontSize: 12,
                  //             fontFamily: "poppins_thin",
                  //             color: Colors.red),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to extract percentage from HTML-like string
  String _extractPercentage(String input) {
    final regex = RegExp(r'\((-?\d+\.\d+)\s*%\s*\)');
    final match = regex.firstMatch(input);
    return match != null ? match.group(0) ?? '(0.00%)' : '(0.00%)';
  }
}

// Helper function to assign colors to statuses based on the image
Color _getStatusColor(String status) {
  switch (status) {
    case 'Fresh':
      return Color(0xFF4FC3F7); // Light blue
    case 'Contacted':
      return Color(0xFF1976D2); // Dark blue
    case 'Appointment':
      return Color(0xFF1565C0); // Deeper blue
    case 'Trial':
      return Color(0xFF8D6E63); // Brown
    case 'Negotiations':
      return Color(0xFFAB47BC); // Purple
    case 'Feed Back':
      return Color(0xFF66BB6A); // Green
    case 'Re Appointment':
      return Color(0xFF1976D2); // Dark blue
    case 'Re Trial':
      return Color(0xFFFFCA28); // Amber
    case 'Converted':
      return Color(0xFF66BB6A); // Light green
    default:
      return Colors.grey;
  }
}

Widget _buildStatusTile(String status, int count, Color color) {
  return Container(
    decoration: BoxDecoration(
        // color: Colors.white,

        ),
    child: Padding(
      padding: const EdgeInsets.only(left: 5.0, bottom: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            status,
            style: TextStyle(
              fontSize: 13,
              fontFamily: "poppins_thin",
              color: Colors.black87,
            ),
          ),
          Container(
            width: 120, // Adjusted for mobile
            height: 30,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: "poppins_thin",
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildLogTile({
  String? date,
  String? time,
  String? id,
  String? name,
  String? status,
  String? type,
  String? age,
  String? description,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: Colors.deepPurple[100],
          radius: 12,
          child: Icon(Icons.circle, size: 10, color: Colors.deepPurple),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (date != null && time != null)
                Text(
                  '$date $time', // Shows "1-3-25 10:58"
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: "poppins_thin",
                    color: Colors.grey[600],
                  ),
                ),
              if (id != null && name != null)
                Text(
                  '$id > $name',
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: "poppins_thin",
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              if (status != null && type != null)
                Text(
                  '$status > $type',
                  style: TextStyle(
                    fontSize: 11,
                    fontFamily: "poppins_thin",
                    color: Colors.blue[900],
                  ),
                ),
              if (age != null)
                Text(
                  age,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: "poppins_thin",
                    color: Colors.grey[600],
                  ),
                ),
              if (description != null)
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: "poppins_thin",
                    color: Colors.grey[600],
                  ),
                ),
              Divider(color: Colors.grey[300], height: 16),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildFollowupTile({
  String? id,
  String? createdDate,
  String? username,
  String? stage,
  String? type,
  String? nextFollowupDate,
  String? remark,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 0.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: Colors.teal[100],
          radius: 12,
          child: Icon(Icons.schedule, size: 16, color: Colors.teal),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (createdDate != null)
                Text(
                  createdDate,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: "poppins_thin",
                    color: Colors.grey[600],
                  ),
                ),
              if (id != null && username != null)
                Text(
                  '$id > $username',
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: "poppins_thin",
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              if (stage != null && stage.isNotEmpty)
                Text(
                  'Stage: $stage',
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: "poppins_thin",
                    color: Colors.teal[800],
                  ),
                ),
              if (type != null && type.isNotEmpty)
                Text(
                  'Type: $type',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: "poppins_thin",
                    color: Colors.teal[600],
                  ),
                ),
              if (nextFollowupDate != null && nextFollowupDate.isNotEmpty)
                Row(
                  children: [
                    Icon(Icons.calendar_today,
                        size: 14, color: Colors.grey[600]),
                    SizedBox(width: 4),
                    Text(
                      'Next: $nextFollowupDate',
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: "poppins_thin",
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              if (remark != null && remark.isNotEmpty)
                Text(
                  'Remark: $remark',
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: "poppins_thin",
                    color: Colors.grey[600],
                  ),
                ),
              Divider(color: Colors.grey[300], height: 16),
            ],
          ),
        ),
      ],
    ),
  );
}

// New method to build Upcoming Visits section
Widget _buildUpcomingVisits(RealtosmartdashboardModel dashboardData) {
  final upcomingVisits = dashboardData.visitUpcomingData ?? [];

  return Container(
    padding: const EdgeInsets.all(12.0),
    margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Upcoming Visits (${upcomingVisits.length})',
              style: const TextStyle(
                fontSize: 16,
                fontFamily: "poppins_thin",
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        upcomingVisits.isNotEmpty
            ? ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: upcomingVisits.length,
          separatorBuilder: (context, index) => const Divider(
            height: 1,
            color: Colors.grey,
            thickness: 0.1,
          ),
          itemBuilder: (context, index) {
            final visit = upcomingVisits[index];
            return
              ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0),
              // leading: CircleAvatar(
              //   backgroundColor: Colors.deepPurple[100],
              //   radius: 20,
              //   child: Text(
              //     visit.pShortname.isNotEmpty ? visit.pShortname : '?',
              //     style: TextStyle(
              //       color: Colors.deepPurple[900],
              //       fontSize: 16,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
              title: Row(
                children: [
                  Icon(Icons.person,size: 20,color: Colors.grey.shade500,),
                  SizedBox(width: 5,),
                  Text(
                    visit.name.isNotEmpty ? visit.name : 'Unknown',
                    style: const TextStyle(
                      fontFamily: "poppins_thin",
                      fontSize: 15,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Row(
                  children: [
                    Icon(Icons.timer_sharp,
                        size: 20, color: Colors.grey[600]),
                    SizedBox(width: 5),

                    Expanded(
                      child: Text(
                        '${visit.time}',
                        style: TextStyle(
                          fontFamily: "poppins_thin",
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              trailing:   Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xff154889),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  visit.type,
                  style: const TextStyle(
                    fontFamily: "poppins_thin",
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

            );
          },
        )
            : Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Center(
            child: Text(
              'No upcoming visits',
              style: TextStyle(
                fontFamily: "poppins_thin",
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
Widget _buildUserDataPendingSection(RealtosmartdashboardModel? dashboardData) {
  return Container(
    padding: const EdgeInsets.all(10.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 4,
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Pending Followup List(${dashboardData?.userDataPending?.length ?? 0})',
              style: TextStyle(
                fontSize: 17,
                fontFamily: "poppins_thin",
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple[900],
              ),
            ),
            Icon(Icons.table_chart, color: Colors.deepPurple[900], size: 20),
          ],
        ),
        SizedBox(height: 10),
        if (dashboardData == null ||
            dashboardData.userDataPending == null ||
            dashboardData.userDataPending!.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Text(
              'No user data available',
              style: TextStyle(color: Colors.grey),
            ),
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fixed Name Column
              SizedBox(
                width: 120, // Fixed width for name column
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      alignment: Alignment.center,
                      child: Text(
                        'Name',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: "poppins_thin",
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple[900],
                        ),
                      ),
                    ),
                    ...dashboardData.userDataPending!.map((user) {
                      final statusColor = user.switcherActive == 'Green'
                          ? Colors.green
                          : Colors.red;
                      return Container(
                        height: 70,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: statusColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                user.firstname ?? '',
                                style: TextStyle(
                                  fontSize: 12,
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
                      height: 50,
                      alignment: Alignment.center,
                      child: Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: "poppins_thin",
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
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
                    columnSpacing: 16,
                    dataRowHeight: 70,
                    headingRowHeight: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors
                          .white60, // Changed background color (e.g., light blue-grey)
                    ),
                    columns: [
                      DataColumn(
                        label: Text(
                          'Pending',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: "poppins_thin",
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple[900],
                          ),
                        ),
                      ),
                      // DataColumn(
                      //   label: Text(
                      //     'Total',
                      //     style: TextStyle(
                      //       fontSize: 14,
                      //       fontFamily: "poppins_thin",
                      //       fontWeight: FontWeight.bold,
                      //       color: Colors.deepPurple[900],
                      //     ),
                      //   ),
                      // ),
                      DataColumn(
                        label: Text(
                          'Auto',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: "poppins_thin",
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple[900],
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Self',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: "poppins_thin",
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple[900],
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Today',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: "poppins_thin",
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple[900],
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Done',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: "poppins_thin",
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple[900],
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'CNR',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: "poppins_thin",
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple[900],
                          ),
                        ),
                      ),
                    ],
                    rows: [
                      ...dashboardData.userDataPending!.map((user) {
                        return DataRow(
                          cells: [
                            DataCell(
                              Text(
                                user.pending ?? '0',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "poppins_thin",
                                  color: Colors.red[700],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            // DataCell(
                            //   Text(
                            //     user.total.toString(),
                            //     style: TextStyle(
                            //       fontSize: 14,
                            //       fontFamily: "poppins_thin",
                            //       color: Colors.blue[700],
                            //       fontWeight: FontWeight.bold,
                            //     ),
                            //   ),
                            // ),
                            DataCell(
                              Text(
                                user.autoLeads ?? '0',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "poppins_thin",
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                user.selfLeads ?? '0',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "poppins_thin",
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                user.today ?? '0',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "poppins_thin",
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                user.userDone.toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "poppins_thin",
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                user.cnr ?? '0',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "poppins_thin",
                                  color: Colors.orange[700],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                      DataRow(
                        cells: [
                          DataCell(
                            Text(
                              dashboardData.userDataPending!
                                  .fold(
                                      0,
                                      (sum, user) =>
                                          sum +
                                          (int.tryParse(user.pending ?? '0') ??
                                              0))
                                  .toString(),
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: "poppins_thin",
                                color: Colors.red[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // DataCell(
                          //   Text(
                          //     dashboardData.userDataPending!
                          //         .fold(
                          //             0, (sum, user) => sum + (user.total ?? 0))
                          //         .toString(),
                          //     style: TextStyle(
                          //       fontSize: 14,
                          //       fontFamily: "poppins_thin",
                          //       color: Colors.blue[700],
                          //       fontWeight: FontWeight.bold,
                          //     ),
                          //   ),
                          // ),
                          DataCell(
                            Text(
                              dashboardData.userDataPending!
                                  .fold(
                                      0,
                                      (sum, user) =>
                                          sum +
                                          (int.tryParse(
                                                  user.autoLeads ?? '0') ??
                                              0))
                                  .toString(),
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: "poppins_thin",
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              dashboardData.userDataPending!
                                  .fold(
                                      0,
                                      (sum, user) =>
                                          sum +
                                          (int.tryParse(
                                                  user.selfLeads ?? '0') ??
                                              0))
                                  .toString(),
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: "poppins_thin",
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              dashboardData.userDataPending!
                                  .fold(
                                      0,
                                      (sum, user) =>
                                          sum +
                                          (int.tryParse(user.today ?? '0') ??
                                              0))
                                  .toString(),
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: "poppins_thin",
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              dashboardData.userDataPending!
                                  .fold(0,
                                      (sum, user) => sum + (user.userDone ?? 0))
                                  .toString(),
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: "poppins_thin",
                                color: Colors.green[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              dashboardData.userDataPending!
                                  .fold(
                                      0,
                                      (sum, user) =>
                                          sum +
                                          (int.tryParse(user.cnr ?? '0') ?? 0))
                                  .toString(),
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: "poppins_thin",
                                color: Colors.orange[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
      ],
    ),
  );
}
// // New Growth Section
// const Divider(color: Colors.grey, thickness: 1),
// Padding(
//   padding: const EdgeInsets.symmetric(vertical: 3,),
//   child: Row(
//     mainAxisAlignment: MainAxisAlignment.spaceAround,
//     children: [
//       Text(
//         'Growth',
//         style: TextStyle(
//             fontSize: 14,
//             fontFamily: "poppins_thin",
//             color: Colors.black87),
//       ),
//       Text(
//         dashboardData?.perfomanceGrowthCount?.isNotEmpty == true
//             ? dashboardData!
//             .perfomanceGrowthCount!.first.growthBoookings
//             .toString()
//             : '0',
//         style: TextStyle(
//             fontSize: 14,
//             fontFamily: "poppins_thin",
//             color: Colors.black87),
//       ),
//       Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           Text(
//             dashboardData!.perfomanceGrowthCount!.first.growthBoookings.toString(),
//             style: TextStyle(
//                 fontSize: 12,
//                 fontFamily: "poppins_thin",
//                 color: Colors.red),
//           ),
//         ],
//       ),
//       Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             dashboardData!.perfomanceGrowthCount!.first.growthVisits.toString(),
//             style: TextStyle(
//                 fontSize: 12,
//                 fontFamily: "poppins_thin",
//                 color: Colors.red),
//           ),
//
//         ],
//       ),
//       Text(
//         dashboardData!.perfomanceGrowthCount!.first.growthVisits.toString(),
//         style: TextStyle(
//             fontSize: 12,
//             fontFamily: "poppins_thin",
//             color: Colors.red),
//       ),
//     ],
//   ),
// ),

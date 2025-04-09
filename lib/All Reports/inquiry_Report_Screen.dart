import 'package:flutter/material.dart';
import 'package:hr_app/Provider/UserProvider.dart';
import 'package:hr_app/staff_HRM_module/Screen/Color/app_Color.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class InquiryReportScreen extends StatefulWidget {
  @override
  _InquiryReportScreenState createState() => _InquiryReportScreenState();
}

class _InquiryReportScreenState extends State<InquiryReportScreen> {
  late String _fromDate;
  late String _toDate;
  late String _displayFromDate;
  late String _displayToDate;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    _fromDate = DateTime(now.year, now.month, 1).toString().split(' ')[0];
    _toDate = now.toString().split(' ')[0];
    _displayFromDate = _fromDate;
    _displayToDate = _toDate;
    _fetchInquiryReports();
  }

  void _fetchInquiryReports() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.fetchInquiryReport(fromDate: _fromDate, toDate: _toDate);
  }

  void _showDateSelectionDialog(UserProvider userProvider) {
    String tempFromDate = _fromDate;
    String tempToDate = _toDate;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) { // Use a separate BuildContext for the dialog
        // Create controllers within the builder
        final fromDateController = TextEditingController(text: tempFromDate);
        final toDateController = TextEditingController(text: tempToDate);

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              title: Text('Select Date Range', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: TextStyle(fontSize: 13),
                          controller: fromDateController,
                          decoration: InputDecoration(
                            labelText: 'From',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            filled: true,
                            fillColor: Colors.grey[100],
                          ),
                          readOnly: true,
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.parse(tempFromDate),
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                              setDialogState(() { // Use setDialogState instead of setState
                                tempFromDate = picked.toString().split(' ')[0];
                                fromDateController.text = tempFromDate;
                              });
                            }
                          },
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          style: TextStyle(fontSize: 13),
                          controller: toDateController,
                          decoration: InputDecoration(
                            labelText: 'To',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            filled: true,
                            fillColor: Colors.grey[100],
                          ),
                          readOnly: true,
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.parse(tempToDate),
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                              setDialogState(() { // Use setDialogState instead of setState
                                tempToDate = picked.toString().split(' ')[0];
                                toDateController.text = tempToDate;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple.shade400,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      setState(() { // Update parent state
                        _fromDate = tempFromDate;
                        _toDate = tempToDate;
                        _displayFromDate = _fromDate;
                        _displayToDate = _toDate;
                      });
                      Navigator.pop(dialogContext); // Use dialogContext to close
                      _fetchInquiryReports();
                    },
                    child: Text('Submit', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: appColor.primaryColor,
              centerTitle: true,
              foregroundColor: Colors.white,
              leading: IconButton(

                onPressed: (){
                  Navigator.pop(context);
                },

                icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20,),

              ),
              title: Text('Inquiry Report', style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: "poppins_thin")),
              actions: [
                IconButton(
                  icon: Icon(Icons.filter_list, color: Colors.white),
                  onPressed: () => _showDateSelectionDialog(userProvider),
                ),
              ],
              bottom: TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.white,
                tabs: [
                  Tab(text: 'User Wise'),
                  Tab(text: 'Inquiry Type'),
                  Tab(text: 'Inquiry Source'),
                ],
              ),
            ),
            backgroundColor: Colors.white,
            body: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(8.0),
                  color: Colors.grey[100],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('From: $_displayFromDate', style: TextStyle(fontSize: 13),),
                      Text('To: $_displayToDate', style: TextStyle(fontSize: 13),),
                    ],
                  ),
                ),
                Expanded(child: _buildBody(userProvider)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(UserProvider userProvider) {
    if (userProvider.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 48),
            SizedBox(height: 16),
            Text(
              'Error: ${userProvider.errorMessage}',
              style: TextStyle(color: Colors.red, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: _fetchInquiryReports,
              child: Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    if (userProvider.inquiryReportData == null) {
      return _buildShimmerEffect();
    }

    return TabBarView(
      physics: NeverScrollableScrollPhysics(),
      children: [
        _buildUserWiseReport(userProvider),
        _buildInquiryTypeReport(userProvider),
        _buildInquirySourceReport(userProvider),
      ],
    );
  }

  Widget _buildShimmerEffect() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 40,
                color: Colors.white,
              ),
              SizedBox(height: 16),
              Container(
                width: double.infinity,
                height: 200,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserWiseReport(UserProvider userProvider) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            height: 42,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade300,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 2))],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'User Wise Report',
                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.bar_chart, color: Colors.white, size: 22,),
              ],
            ),
          ),
          SizedBox(height: 16),
          Card(
            elevation: 4,
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                dataTextStyle: TextStyle(color: Colors.black, fontFamily: "poppins_thin", fontSize: 13),
                headingTextStyle: TextStyle(color: Colors.deepPurple.shade400, fontFamily: "poppins_thin", fontSize: 13.1),
                columnSpacing: 20,
                columns: [
                  DataColumn(label: Text('User Name', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Fresh', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Contacted', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Appointment', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Visited', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Negotiations', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Dismissed', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Feedback', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Re app.', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Booking', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: [
                  ...userProvider.inquiryReportData!.userData.map((user) => DataRow(cells: [
                    DataCell(Text(user.firstname)),
                    DataCell(Text(user.fresh)),
                    DataCell(Text(user.contacted)),
                    DataCell(Text(user.appointment)),
                    DataCell(Text(user.visited)),
                    DataCell(Text(user.negotiations)),
                    DataCell(Text(user.dismissed)),
                    DataCell(Text(user.feedback)),
                    DataCell(Text(user.reappointment)),
                    DataCell(Text(user.booking)),
                    DataCell(Text(user.total)),
                  ])),
                  DataRow(cells: [
                    DataCell(Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataCell(Text(userProvider.inquiryReportData!.userDataTotal[0].fresh.toString())),
                    DataCell(Text(userProvider.inquiryReportData!.userDataTotal[0].contacted.toString())),
                    DataCell(Text(userProvider.inquiryReportData!.userDataTotal[0].appointment.toString())),
                    DataCell(Text(userProvider.inquiryReportData!.userDataTotal[0].visited.toString())),
                    DataCell(Text(userProvider.inquiryReportData!.userDataTotal[0].negotiations.toString())),
                    DataCell(Text(userProvider.inquiryReportData!.userDataTotal[0].dismissed.toString())),
                    DataCell(Text(userProvider.inquiryReportData!.userDataTotal[0].feedback.toString())),
                    DataCell(Text(userProvider.inquiryReportData!.userDataTotal[0].reappointment.toString())),
                    DataCell(Text(userProvider.inquiryReportData!.userDataTotal[0].booking.toString())),
                    DataCell(Text(userProvider.inquiryReportData!.userDataTotal[0].maintotal.toString())),
                  ]),
                ],
              ),
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('Swipe to see more →', style: TextStyle(color: Colors.grey, fontSize: 12, fontStyle: FontStyle.italic)),
              SizedBox(width: 4),
              Icon(Icons.swipe, size: 16, color: Colors.grey),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInquiryTypeReport(UserProvider userProvider) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            height: 42,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade300,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 2))],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Inquiry Type Report',
                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.bar_chart, color: Colors.white, size: 22,),
              ],
            ),
          ),
          SizedBox(height: 16),
          Card(
            elevation: 4,
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                dataTextStyle: TextStyle(color: Colors.black, fontFamily: "poppins_thin", fontSize: 13),
                headingTextStyle: TextStyle(color: Colors.deepPurple.shade400, fontFamily: "poppins_thin", fontSize: 13.1),
                columnSpacing: 20,
                columns: [
                  DataColumn(label: Text('Inquiry Type', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Live', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Close', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: [
                  ...userProvider.inquiryReportData!.inquiryTypeReport.map((type) => DataRow(cells: [
                    DataCell(Text(type.inquiryDetails ?? 'Unknown')),
                    DataCell(Text(type.live)),
                    DataCell(Text(type.close)),
                    DataCell(Text(type.total)),
                  ])),
                  DataRow(cells: [
                    DataCell(Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataCell(Text(userProvider.inquiryReportData!.inquiryTypeReportTotal[0].live)),
                    DataCell(Text(userProvider.inquiryReportData!.inquiryTypeReportTotal[0].close)),
                    DataCell(Text(userProvider.inquiryReportData!.inquiryTypeReportTotal[0].totalCount.toString())),
                  ]),
                ],
              ),
            ),
          ),
          SizedBox(height: 8),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     Text('Swipe to see more →', style: TextStyle(color: Colors.grey, fontSize: 12, fontStyle: FontStyle.italic)),
          //     SizedBox(width: 4),
          //     Icon(Icons.swipe, size: 16, color: Colors.grey),
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget _buildInquirySourceReport(UserProvider userProvider) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            height: 42,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade300,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 2))],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Inquiry Source Report',
                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.bar_chart, color: Colors.white, size: 22,),
              ],
            ),
          ),
          SizedBox(height: 16),
          Card(
            elevation: 4,
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                dataTextStyle: TextStyle(color: Colors.black, fontFamily: "poppins_thin", fontSize: 13),
                headingTextStyle: TextStyle(color: Colors.deepPurple.shade400, fontFamily: "poppins_thin", fontSize: 13.1),
                columnSpacing: 20,
                columns: [
                  DataColumn(label: Text('Source Type', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Inq source', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Live', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Close', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: [
                  ...userProvider.inquiryReportData!.inquirySourceReport.map((source) => DataRow(cells: [
                    DataCell(Text(source.source ?? 'Unknown')),
                    DataCell(Text(source.inquirySourceType ?? 'Unknown')),
                    DataCell(Text(source.live)),
                    DataCell(Text(source.close)),
                    DataCell(Text(source.total)),
                  ])),
                  DataRow(cells: [
                    DataCell(Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataCell(Text('')),
                    DataCell(Text(userProvider.inquiryReportData!.inquirySourceReportTotal[0].live.toString())),
                    DataCell(Text(userProvider.inquiryReportData!.inquirySourceReportTotal[0].close.toString())),
                    DataCell(Text(userProvider.inquiryReportData!.inquirySourceReportTotal[0].totalCount.toString())),
                  ]),
                ],
              ),
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('Swipe to see more →', style: TextStyle(color: Colors.grey, fontSize: 12, fontStyle: FontStyle.italic)),
              SizedBox(width: 4),
              Icon(Icons.swipe, size: 16, color: Colors.grey),
            ],
          ),
        ],
      ),
    );
  }
}
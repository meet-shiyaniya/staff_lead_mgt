import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Provider/UserProvider.dart';
import '../Utils/Colors/app_Colors.dart';
import '../Utils/Custom widgets/search_Screen.dart';
import 'Filters/inquiry_Filter_Screen.dart';
import 'Followup Screen/cnr_Screen.dart';
import 'Followup Screen/pending_Screen.dart';
import 'Followup Screen/todays_Lead_Screen.dart';

class FollowupAndCnrScreen extends StatefulWidget {
  final int initialTabIndex; // Accept tab index from navigation

  const FollowupAndCnrScreen(this.initialTabIndex, {super.key});

  @override
  State<FollowupAndCnrScreen> createState() => _FollowupAndCnrScreenState();
}

class _FollowupAndCnrScreenState extends State<FollowupAndCnrScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, String>> actionList = [];
  List<Map<String, String>> employeeList = [];
  String? selectedAction;
  String? selectedEmployee;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.index = widget.initialTabIndex; // Set initial tab index from constructor
    loadData();
  }

  Future<void> loadData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      await userProvider.fetchTransferInquiryData();
      final data = userProvider.transferInquiryData;

      if (data == null) {
        return;
      }

      setState(() {
        actionList = [];
        selectedAction = null;

        if (data.action != null) {
          actionList = [
            if (data.action!.assignFollowups != null)
              {'key': 'assign_followups', 'value': data.action!.assignFollowups!},
            if (data.action!.transferOwnership != null)
              {'key': 'transfer_ownership', 'value': data.action!.transferOwnership!},
          ];
          selectedAction = actionList.isNotEmpty ? actionList.first['value'] : null;
        }

        employeeList = (data.employee ?? [])
            .where((e) => e.id != null && e.firstname != null)
            .map((e) => {'id': e.id!, 'name': e.firstname!})
            .toList();
        selectedEmployee = employeeList.isNotEmpty ? employeeList.first['name'] : null;
      });
    } catch (e) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.MainColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white,size: 19,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          "Leads",
          style: TextStyle(color: Colors.white, fontFamily: "poppins_thin", fontSize: 19),
        ),
        actions: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.search,size: 20,),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchPage()),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => InquiryFilterScreen()));
                },
                icon: Icon(
                  size: 20,
                  Icons.filter_list_outlined,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(width: 4),
        ],
        bottom: TabBar(
          controller: _tabController, // Attach tab controller
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: [
            Tab(
              child: Text(
                "Today's Followup",
                style: TextStyle(fontSize: 12, fontFamily: "poppins_thin"),
                textAlign: TextAlign.center,
              ),
            ),
            Tab(
              child: Text(
                "Pending Followup",
                style: TextStyle(fontSize: 12, fontFamily: "poppins_thin"),
                textAlign: TextAlign.center,
              ),
            ),
            Tab(
              child: Text(
                "CNR",
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey.shade200,
      body: TabBarView(
        controller: _tabController, // Attach tab controller
        physics: NeverScrollableScrollPhysics(),
        children: [
          TodayScreen(),
          PendingScreen(),
          CnrScreenPage(),
        ],
      ),
    );
  }
}

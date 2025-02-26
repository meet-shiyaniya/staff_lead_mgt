import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hr_app/staff_HRM_module/Screen/Staff%20HR%20Screens/Staff%20Leave/all_Staff_Leaves_Screen.dart';
import '../../Color/app_Color.dart';
import 'Show Leave Details Screens/show_Leave_Option_Screen.dart';
import 'leave_Request_Screen.dart';

class staffLeaveHomeScreen extends StatefulWidget {
  const staffLeaveHomeScreen({super.key});

  @override
  State<staffLeaveHomeScreen> createState() => _staffLeaveHomeScreenState();
}

class _staffLeaveHomeScreenState extends State<staffLeaveHomeScreen> {

  int isSelectedIndex = 0;

  final List<Widget> screens = [
    allStaffLeavesScreen(),
    leaveRequestScreen(),
    showLeaveOptionScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: appColor.primaryColor,
        title: const Text(
          "Leave Form",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: "poppins_thin",
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 60,
            width: double.infinity,
            color: Colors.grey.shade100,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(3, (index) {
                    return _buildTab(index);
                  }),
                ),
              ),
            ),
          ),
          Expanded(child: screens[isSelectedIndex]),
          const SizedBox(height: 5),
        ],
      ),
    );
  }

  Widget _buildTab(int index) {
    List<String> titles = ["Leave Request", "My Leaves", "Leave Status"];
    List<IconData> icons = [
      FontAwesomeIcons.solidCalendarDays,
      FontAwesomeIcons.calendarPlus,
      FontAwesomeIcons.calendarCheck
    ];

    bool isSelected = isSelectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          isSelectedIndex = index;
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 8),
        height: 40,
        width: MediaQuery.of(context).size.width / 2.6,
        decoration: BoxDecoration(
          color: isSelected ? appColor.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? Colors.transparent : appColor.primaryColor, width: 1.5),
        ),
        child: Row(
          children: [
            const SizedBox(width: 1.6),
            Container(
              height: 34,
              width: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.white : appColor.boxColor,
              ),
              child: Center(child: Icon(icons[index], color: Colors.black, size: 16.5)),
            ),
            const SizedBox(width: 5),
            Text(
              titles[index],
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontFamily: "poppins_thin",
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
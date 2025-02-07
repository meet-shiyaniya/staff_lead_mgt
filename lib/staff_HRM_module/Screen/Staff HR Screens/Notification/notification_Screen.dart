import 'package:flutter/material.dart';
import 'package:hr_app/staff_HRM_module/Screen/Color/app_Color.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool showUnread = false;

  final List<Map<String, dynamic>> notifications = [
    {
      'icon': Icons.attach_money,
      'title': 'USDT Deposit received',
      'description': 'You received \$370 USDT from 0xDc9AE3A3E3c8AcA2768e1690D...',
      'isUnread': true,
    },
    {
      'icon': Icons.check_circle,
      'title': 'Donation Successful',
      'description': 'GTS foundation completes \$57,000 education fundraise.',
      'isUnread': false,
    },
    {
      'icon': Icons.campaign,
      'title': 'Campaign Completed',
      'description': 'GTS foundation completes \$57,000 education fundraise.',
      'isUnread': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade300,
        centerTitle: true,
        elevation: 0,
        foregroundColor: Colors.transparent,
        leading: IconButton(

          onPressed: (){
            Navigator.pop(context);
          },

          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20,),

        ),
        title: Text('Notifications', style: TextStyle(color: Colors.white,fontFamily: "poppins_thin", fontSize: 18)),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildTab('All', !showUnread),
                SizedBox(width: 16),
                _buildTab('Unread', showUnread),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: notifications
                    .where((notification) => !showUnread || notification['isUnread'])
                    .map((notification) => _buildNotificationCard(notification))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label, bool isActive) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showUnread = (label == 'Unread');
        });
      },
      child: Container(

        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black)
        ),
        padding: EdgeInsets.all(10),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontFamily: "poppins_thin",
            // fontWeight: FontWeight.bold,
            color: isActive ? Colors.deepPurple : Colors.grey,
            // decoration: isActive ? TextDecoration.underline : TextDecoration.none,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    return Container(
      height: 100,
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(

        color: appColor.subFavColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.shade400, blurRadius: 3, offset: Offset(1, 3))],

      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.deepPurple.shade50,
            child: Icon(notification['icon'], color: Colors.deepPurple),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification['title'],
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: "poppins_thin",
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  notification['description'],
                  style: TextStyle(fontSize: 13.5, color: Colors.grey.shade600,fontFamily: "poppins_light"),
                ),
              ],
            ),
          ),
          if (notification['isUnread'])
            Icon(Icons.circle, size: 10, color: Colors.deepPurple),
        ],
      ),
    );
  }
}
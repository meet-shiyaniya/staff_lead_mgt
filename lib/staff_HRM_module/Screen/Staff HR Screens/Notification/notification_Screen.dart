import 'package:flutter/material.dart';

import '../../Color/app_Color.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<Map<String, dynamic>> notifications = [
    {
      'icon': Icons.attach_money,
      'title': 'USDT Deposit received',
      'description': 'You received \$370 USDT from 0xDc9AE3A3E3c8AcA2768e1690D...',
      'isUnread': true,
      'isViewed': false,
    },
    {
      'icon': Icons.check_circle,
      'title': 'Donation Successful',
      'description': 'GTS foundation completes \$57,000 education fundraise.',
      'isUnread': true,
      'isViewed': false,
    },
    {
      'icon': Icons.campaign,
      'title': 'Campaign Completed',
      'description': 'GTS foundation completes \$57,000 education fundraise.',
      'isUnread': true,
      'isViewed': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade300,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
        ),
        title: Text('Notifications', style: TextStyle(color: Colors.white, fontSize: 18)),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Expanded(
          child: ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              return _buildNotificationCard(notifications[index], index);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          notifications[index]['isUnread'] = false;
          notifications[index]['isViewed'] = true;
        });
      },
      child: Container(
        height: 100,
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notification['isViewed'] ? Colors.deepPurple.shade50 : appColor.subFavColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.grey.shade400, blurRadius: 3, offset: Offset(1, 3))],
        ),
        child: Row(
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
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    notification['description'],
                    style: TextStyle(fontSize: 13.5, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            if (notification['isUnread'])
              Icon(Icons.circle, size: 10, color: Colors.deepPurple),
          ],
        ),
      ),
    );
  }
}
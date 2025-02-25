import 'package:flutter/material.dart';

class InquiryDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          height: MediaQuery.of(context).size.height/0.4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.all(16.0),
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
                          'Follow Ups(22)',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "poppins_thin",
                            fontWeight: FontWeight.bold,
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
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'More Follow Ups',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "poppins_thin",
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    ..._buildFollowUps(),
                  ],
                ),
              ),
              SizedBox(height: 16), // Spacing between sections

              // Activity Logs Section
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
                          'Activity Logs(38)',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "poppins_thin",
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width / 2.7,
                          decoration: BoxDecoration(
                            color: Colors.deepPurple.shade300,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Text(
                              "More Activities",
                              style: TextStyle(
                                fontFamily: "poppins_thin",
                                fontSize: 13,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    ..._buildActivityLogs(),
                  ],
                ),
              ),
              SizedBox(height: 16), // Spacing between sections

              Container(
                padding: EdgeInsets.all(16.0),
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
                    Text(
                      'Status Wise Inq',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: "poppins_thin",
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    _buildStatusTile('Fresh', 3, Colors.blue),
                    _buildStatusTile('Qualified', 8, Colors.blue[900]!),
                    _buildStatusTile('Visited', 3, Colors.brown),
                    _buildStatusTile('Feed Back', 2, Colors.green),
                    _buildStatusTile('Converted', 4, Colors.teal),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFollowUps() {
    return [
      _buildLogTile(
        date: '24-02-25',
        time: '11:48',
        id: '95526',
        name: 'akash kanani',
        status: 'Re Visited',
        type: 'Walk in',
        age: '28',
      ),
      _buildLogTile(
        date: '24-02-25',
        time: '11:46',
        id: '95526',
        name: 'akash kanani',
        status: 'Re Visited',
        type: 'Walk in',
        age: '28',
      ),
      _buildLogTile(
        date: '24-02-25',
        time: '11:45',
        id: '95526',
        name: 'akash kanani',
        status: 'Re Visited',
        type: 'Walk in',
        age: '28',
      ),
      _buildLogTile(
        date: '24-02-25',
        time: '11:45',
        id: '95526',
        name: 'akash kanani',
        status: 'Re Visited',
        type: 'Walk in',
        age: '28',
      ),
    ];
  }

  List<Widget> _buildActivityLogs() {
    return [
      _buildLogTile(
        date: '24-02-25',
        time: '02:10',
        name: 'akash kanani',
        description: 'Telecaller Manager, is logged-in',
      ),
      _buildLogTile(
        date: '24-02-25',
        time: '12:59',
        id: '95543',
        name: 'akash kanani',
        status: 'Qualified',
        type: 'Live',
        description: 'Fresh Qualified of SMIT By akash kanani',
      ),
      _buildLogTile(
        date: '24-02-25',
        time: '12:53',
        id: '95542',
        name: 'akash kanani',
        status: 'New',
        type: 'Live',
        description: 'Fresh Inquiry Added of krunal By demo_aakash',
      ),
      _buildLogTile(
        date: '24-02-25',
        time: '12:53',
        id: '95541',
        name: 'akash kanani',
        status: 'New',
        type: 'Live',
        description: 'Fresh Inquiry Added of krunal By demo_aakash',
      ),
      _buildLogTile(
        date: '24-02-25',
        time: '12:50',
        id: '95540',
        name: 'akash kanani',
        status: 'New',
        type: 'Live',
        description: 'Fresh Inquiry Added of 19-02-2025 By demo_aakash',
      ),
    ];
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
      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                    '$date $time',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: "poppins_thin",
                      color: Colors.grey[600],
                    ),
                  ),
                if (id != null && name != null)
                  Text(
                    '$id > $name',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "poppins_thin",
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                if (status != null && type != null)
                  Text(
                    '$status > $type',
                    style: TextStyle(
                      fontSize: 14,
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
                      fontSize: 14,
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

  Widget _buildStatusTile(String status, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            status,
            style: TextStyle(
              fontSize: 16,
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
                      fontSize: 14,
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
    );
  }
}
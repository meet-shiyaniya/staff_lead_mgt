import 'package:flutter/material.dart';

class PendingFollowUp extends StatefulWidget {
  const PendingFollowUp({super.key});

  @override
  State<PendingFollowUp> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PendingFollowUp> {
  // Sample data for performance metrics
  final List<Map<String, dynamic>> performanceData = [
    {'date': '2024-12', 'leads': 0, 'visits': 1, 'bookings': 0, 'visitChange': '(0.00%)', 'bookingChange': '(0.00%)'},
    {'date': '2025-01', 'leads': 14, 'visits': 3, 'bookings': 4, 'visitChange': '(200.00%)', 'bookingChange': '(0.00%)'},
    {'date': '2025-02', 'leads': 2, 'visits': 2, 'bookings': 0, 'visitChange': '(-33.33%)', 'bookingChange': '(0.00%)'},
    {'date': 'Growth', 'leads': 0, 'visits': 0.00, 'bookings': 0.00, 'visitChange': '(0.00%)', 'bookingChange': '(0.00%)'},
  ];

  // Sample data for pending follow-up list
  final List<Map<String, dynamic>> followUpList = [
    {'name': 'Abcbuildcon', 'autoLeads': 0, 'selfLeads': 0, 'today': 3, 'pending': 3, 'total': 3, 'done': 0},
    {'name': 'Ajaysa', 'autoLeads': 0, 'selfLeads': 0, 'today': 0, 'pending': 2, 'total': 2, 'done': 0},
    {'name': 'Jayesh Dhameliya', 'autoLeads': 0, 'selfLeads': 0, 'today': 0, 'pending': 1, 'total': 1, 'done': 0},
    {'name': 'Divya', 'autoLeads': 0, 'selfLeads': 0, 'today': 0, 'pending': 1, 'total': 1, 'done': 0},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light background for a modern look

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [



            // Pending Follow-up List with neumorphic design
            Padding(
              padding: const EdgeInsets.only(right: 10.0,left: 5),
              child: Row(
                children: [
                  Text(
                    'Pending Follow-up List',
                    style: TextStyle(fontSize: 17,fontFamily: "poppins_thin",color: Colors.deepPurple[900]),
                  ),
                  Spacer(),
                  Icon(Icons.pending,color: Colors.deepPurple[900],)
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
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
                  // Header Row
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children:  [
                        Container(
                            width: MediaQuery.of(context).size.width/3,
                            child: Text('UserName', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.blueGrey))),
                        Text('Today', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.blueGrey)),
                        Text('Pending', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.blueGrey)),
                        Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.blueGrey)),
                        Text('Done', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.blueGrey)),
                      ],
                    ),
                  ),
                  Divider(color: Colors.grey),
                  // List Items
                  ...followUpList.map((user) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                                width: MediaQuery.of(context).size.width/3,
                                child: Text(user['name'].toString(), style: const TextStyle(fontSize: 14, color: Colors.black87))),
                          ],
                        ),
                        Text(user['today'].toString(), style: const TextStyle(fontSize: 14, color: Colors.black87)),
                        Text(user['pending'].toString(), style: const TextStyle(fontSize: 14, color: Colors.black87)),
                        Text(user['total'].toString(), style: const TextStyle(fontSize: 14, color: Colors.black87)),
                        Text(user['done'].toString(), style: const TextStyle(fontSize: 14, color: Colors.black87)),
                      ],
                    ),
                  )),
                  // Total Row
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey)),
                        Text('0', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey)),
                        Text('0', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey)),
                        Text('3', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey)),
                        Text('9', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey)),
                        Text('9', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey)),
                        Text('0', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey)),
                      ],
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
}


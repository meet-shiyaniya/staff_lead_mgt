import 'package:flutter/material.dart';

class PerformanceScreen extends StatefulWidget {
  const PerformanceScreen({super.key});

  @override
  State<PerformanceScreen> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> {
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
    return Container(

        // height:MediaQuery.of(context).size.height/2.7,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Padding(
                padding: const EdgeInsets.only(left:5.0,bottom: 10,right: 10),
                child: Row(
                  children: [
                    Text(
                      'Performance',
                      style: TextStyle(fontSize: 17,fontFamily: "poppins_thin",color: Colors.deepPurple[900]),
                    ),
                    Spacer(),
                    Icon(Icons.leaderboard_outlined,color: Colors.deepPurple[900],)
                  ],
                ),
              ),

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
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        Text('Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey)),
                        Text('Leads', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey)),
                        Text('Visits', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey)),
                        Text('Bookings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey)),
                      ],
                    ),
                    const Divider(color: Colors.grey, thickness: 1),
                    ...performanceData.map((data) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(data['date'].toString(), style: const TextStyle(fontSize: 14, color: Colors.black87)),
                          Text(data['leads'].toString(), style: const TextStyle(fontSize: 14, color: Colors.black87)),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(data['visits'].toString(), style: const TextStyle(fontSize: 14, color: Colors.black87)),
                              const SizedBox(width: 4),
                              Text(
                                data['visitChange'].toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: data['visitChange'].toString().contains('-') ? Colors.red : Colors.green,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(data['bookings'].toString(), style: const TextStyle(fontSize: 14, color: Colors.black87)),
                              const SizedBox(width: 4),
                              Text(
                                data['bookingChange'].toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: data['bookingChange'].toString().contains('-') ? Colors.red : Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ),

            ],
          ),
        ),
      );




  }
}


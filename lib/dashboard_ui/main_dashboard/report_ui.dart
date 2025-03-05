import 'package:flutter/material.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  // Sample data for Lead Quality Report (can be expanded or replaced with real data)
  final List<Map<String, dynamic>> leadQualityData = [
    {
      'site': 'Site 1',
      'source': 'Source A',
      'lead': 10,
      'positive': 8,
      'appointment': 5,
      'visit': 3,
      'booking': 2,
      'dismiss': 1,
      'index': 90,
    },
  ];

  // State variables for dropdowns and inputs
  String selectedDate = 'Today';
  String selectedArea = 'Select Area';
  String selectedReason = 'Reason'; // Updated to dropdown value
  String selectedDismissPercentage = 'Dismiss(%)'; // Updated to dropdown value

  // Dropdown options
  final List<String> dateOptions = [
    'Today',
    'Yesterday',
    'This Week',
    'Last Week',
    'This Month',
    'Last Month',
  ];

  final List<String> areaOptions = [
    'Select Area',
    'Area 1',
    'Area 2',
    'Area 3',
    'Area 4',
    'Area 5',
  ];

  final List<String> reasonOptions = [
    'Reason',
    'Reason 1',
    'Reason 2',
    'Reason 3',
    'Reason 4',
    'Reason 5',
  ];

  final List<String> dismissPercentageOptions = [
    'Dismiss(%)',
    '0%',
    '10%',
    '20%',
    '30%',
    '40%',
    '50%',
    '60%',
    '70%',
    '80%',
    '90%',
    '100%',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light background for a modern look
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Lead Quality Report Section
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 4,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            'Lead Quality Report',
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: "poppins_thin",
                                color: Colors.deepPurple[900]),
                          ),
                          Spacer(),
                          Icon(Icons.leaderboard, color: Colors.deepPurple[900])
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Full-width dropdown for "Today" with no border, rounded corners, and reduced height
                    Container(
                      height: 50,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButton<String>(
                        value: selectedDate,
                        items: dateOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black87)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedDate = value!;
                          });
                        },
                        underline: const SizedBox(),
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.black87),
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                        dropdownColor: Colors.white,
                        isExpanded: true, // Ensures full width
                      ),
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal, // Horizontal scrolling for overflow
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: 40,
                          maxHeight: 100,
                          maxWidth: MediaQuery.of(context).size.width * 1.5,
                        ),
                        child: Table(
                          columnWidths: {
                            0: FlexColumnWidth(1), // Site
                            1: FlexColumnWidth(1.5), // Source
                            2: FlexColumnWidth(1), // Lead
                            3: FlexColumnWidth(1), // Positive
                            4: FlexColumnWidth(1.2), // Appointment
                            5: FlexColumnWidth(1), // Visit
                            6: FlexColumnWidth(1), // Booking
                            7: FlexColumnWidth(1), // Dismiss
                            8: FlexColumnWidth(1), // Index
                          },
                          children: [
                            // Table Header
                            TableRow(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.grey[100], // Light grey background for header
                              ),
                              children: [
                                _buildTableCell('Site', isHeader: true),
                                _buildTableCell('Source', isHeader: true),
                                _buildTableCell('Lead', isHeader: true),
                                _buildTableCell('Positive', isHeader: true),
                                _buildTableCell('Appointment', isHeader: true),
                                _buildTableCell('Visit', isHeader: true),
                                _buildTableCell('Booking', isHeader: true),
                                _buildTableCell('Dismiss', isHeader: true),
                                _buildTableCell('Index', isHeader: true),
                              ],
                            ),
                            // Table Data (no borders, subtle separators)
                            ...leadQualityData.map((data) => TableRow(
                              decoration: const BoxDecoration(
                                color: Colors.white, // White background for data rows
                              ),
                              children: [
                                _buildTableCell(data['site'].toString()),
                                _buildTableCell(data['source'].toString()),
                                _buildTableCell(data['lead'].toString()),
                                _buildTableCell(data['positive'].toString()),
                                _buildTableCell(data['appointment'].toString()),
                                _buildTableCell(data['visit'].toString()),
                                _buildTableCell(data['booking'].toString()),
                                _buildTableCell(data['dismiss'].toString()),
                                _buildTableCell(data['index'].toString()),
                              ],
                            )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Dismiss Inq Report Section
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 4,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Dismiss Inq Report',
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: "poppins_thin",
                              color: Colors.deepPurple[900]),
                        ),
                        Spacer(),
                        Icon(Icons.leaderboard, color: Colors.deepPurple[900])
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Full-width dropdown for "Select Area" with no border, rounded corners, and reduced height
                    Container(
                      height: MediaQuery.of(context).size.height / 15,
                      width: double.infinity,
                      padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        value: selectedArea,
                        items: areaOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black87)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedArea = value!;
                          });
                        },
                        underline: const SizedBox(),
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.black87),
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                        dropdownColor: Colors.white,
                        isExpanded: true, // Ensures full width
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Full-width dropdown for "Today" with no border, rounded corners, and reduced height
                    Container(
                      height: MediaQuery.of(context).size.height / 15,
                      width: double.infinity,
                      padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        value: selectedDate,
                        items: dateOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black87)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedDate = value!;
                          });
                        },
                        underline: const SizedBox(),
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.black87),
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                        dropdownColor: Colors.white,
                        isExpanded: true, // Ensures full width
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Full-width dropdown for "Reason" with no border, rounded corners, and reduced height
                    Container(
                      height: MediaQuery.of(context).size.height / 15,
                      width: double.infinity,
                      padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        value: selectedReason,
                        items: reasonOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black87)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedReason = value!;
                          });
                        },
                        underline: const SizedBox(),
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.black87),
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                        dropdownColor: Colors.white,
                        isExpanded: true, // Ensures full width
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Full-width dropdown for "Dismiss(%)" with no border, rounded corners, and reduced height
                    Container(
                      height: MediaQuery.of(context).size.height / 15,
                      width: double.infinity,
                      padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        value: selectedDismissPercentage,
                        items: dismissPercentageOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black87)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedDismissPercentage = value!;
                          });
                        },
                        underline: const SizedBox(),
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.black87),
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                        dropdownColor: Colors.white,
                        isExpanded: true, // Ensures full width
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Total Row
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Total',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.blueGrey)),
                          Text('0',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.blueGrey)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: isHeader ? 14 : 13,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color: isHeader ? Colors.black : Colors.black87,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
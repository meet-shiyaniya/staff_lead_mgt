import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:hr_app/Inquiry_Management/Utils/Colors/app_Colors.dart';
import 'package:hr_app/Provider/UserProvider.dart';

class MoreActivityLogScreen extends StatefulWidget {
  const MoreActivityLogScreen({Key? key}) : super(key: key);

  @override
  _MoreActivityLogScreenState createState() => _MoreActivityLogScreenState();
}

class _MoreActivityLogScreenState extends State<MoreActivityLogScreen> {
  DateTime? selectedDate;
  String? selectedEmployee;
  String? selectedEmployeeId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.fetchActivityData();
    });
  }

  Future<void> _fetchFilteredData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String formattedDate = selectedDate != null ? DateFormat('yyyy-MM-dd').format(selectedDate!) : '';
    await userProvider.fetchActivityData(
      date: formattedDate,
      employeeId: selectedEmployeeId != null ? int.parse(selectedEmployeeId!) : null,
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
      await _fetchFilteredData();
    }
  }

  void _showEmployeeDropdown(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      constraints: const BoxConstraints(maxHeight: 300),
      builder: (context) {
        return Consumer<UserProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (provider.errorMessage != null) {
              return Center(child: Text('Error: ${provider.errorMessage}'));
            } else if (provider.moreactivityResponse?.employees == null || provider.moreactivityResponse!.employees!.isEmpty) {
              return const Center(child: Text('No employees available'));
            } else {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Select Employee", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: provider.moreactivityResponse!.employees!.length,
                        itemBuilder: (context, index) {
                          final employee = provider.moreactivityResponse!.employees![index];
                          return ListTile(
                            title: Text(employee.firstname ?? 'Unnamed Employee', style: const TextStyle(fontSize: 14)),
                            onTap: () {
                              setState(() {
                                selectedEmployee = employee.firstname;
                                selectedEmployeeId = employee.userId;
                              });
                              Navigator.pop(context);
                              _fetchFilteredData();
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        );
      },
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Logs', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: AppColor.Buttoncolor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectDate(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[400]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedDate == null ? 'DD/MM/YYYY' : DateFormat('dd/MM/yyyy').format(selectedDate!),
                            style: const TextStyle(color: Colors.black87, fontSize: 14),
                          ),
                          Icon(Icons.calendar_today, color: Colors.grey[600], size: 16),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showEmployeeDropdown(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[400]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedEmployee != null
                                ? selectedEmployee!.split(' ')[0] // Show only first word (first name)
                                : 'Select employee',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Icon(Icons.arrow_drop_down, color: Colors.grey[600], size: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Activity Log List
          Expanded(
            child: Consumer<UserProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (provider.errorMessage != null) {
                  return Center(child: Text('Error: ${provider.errorMessage}'));
                } else if (provider.moreactivityResponse?.list == null || provider.moreactivityResponse!.list!.isEmpty) {
                  return const Center(child: Text('No activity logs available'));
                } else {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16.0), // Add padding around the list
                    itemCount: provider.moreactivityResponse!.list!.length,
                    itemBuilder: (context, index) {
                      final log = provider.moreactivityResponse!.list![index];
                      // Split createdDate into date and time (e.g., "6-3-25 10:16" -> "6-3-25" and "10:16")
                      final dateTimeParts = log.createdDate?.split(' ') ?? ['', ''];
                      final date = dateTimeParts[0];
                      final time = dateTimeParts.length > 1 ? dateTimeParts[1] : '';

                      return _buildLogTile(
                        date: date.isNotEmpty ? date : null,
                        time: time.isNotEmpty ? time : null,
                        id: log.inquiryId,
                        name: log.username,
                        status: log.status?.isNotEmpty ?? false ? log.status : null,
                        type: log.stage?.isNotEmpty ?? false ? log.stage : null,
                        description: log.inquiryLog,
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
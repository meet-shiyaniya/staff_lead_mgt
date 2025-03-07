import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:hr_app/Inquiry_Management/Utils/Colors/app_Colors.dart';
import 'package:hr_app/Provider/UserProvider.dart';

class MoreFollowupScreen extends StatefulWidget {
  const MoreFollowupScreen({Key? key}) : super(key: key);

  @override
  _MoreFollowupScreenState createState() => _MoreFollowupScreenState();
}

class _MoreFollowupScreenState extends State<MoreFollowupScreen> {
  DateTime? selectedDate;
  String? selectedEmployee;
  String? selectedEmployeeId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch initial employee list without filters
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.fetchFollowupData(); // New method to fetch employees (to be added in UserProvider)
    });
  }

  Future<void> _fetchFilteredData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String formattedDate = selectedDate != null ? DateFormat('yyyy-MM-dd').format(selectedDate!) : '';
    // Only fetch if an employee is selected
    if (selectedEmployeeId != null) {
      userProvider.fetchFollowupData(date: formattedDate, employeeId: int.parse(selectedEmployeeId!));
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
      await _fetchFilteredData(); // Fetch data after date selection
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
              return Center(child: Text(provider.errorMessage!));
            } else if (provider.activityResponse?.employees == null || provider.activityResponse!.employees!.isEmpty) {
              return const Center(child: Text('No employees available'));
            } else {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Select Employee",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: provider.activityResponse!.employees!.length,
                        itemBuilder: (context, index) {
                          final employee = provider.activityResponse!.employees![index];
                          return ListTile(
                            title: Text(
                              employee.firstname ?? 'Unnamed Employee',
                              style: const TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () {
                              setState(() {
                                selectedEmployee = employee.firstname;
                                selectedEmployeeId = employee.userId; // Store Employee ID
                              });
                              Navigator.pop(context);
                              _fetchFilteredData(); // Fetch data after employee selection
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Activity Logs',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColor.Buttoncolor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
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
                            selectedDate == null
                                ? 'DD/MM/YYYY'
                                : DateFormat('dd/MM/yyyy').format(selectedDate!),
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
          Expanded(
            child: Consumer<UserProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final activityList = provider.activityResponse?.activityData ?? [];

                if (activityList.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: _fetchFilteredData,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height - 200,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset(
                                'asset/Inquiry_module/no_result.json',
                                width: 300,
                                height: 300,
                              ),
                              const Text(
                                "No results found",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 22,
                                  fontFamily: "poppins_thin",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _fetchFilteredData,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: activityList.length,
                    itemBuilder: (context, index) {
                      final activity = activityList[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Text(
                            '${activity.inquiryId} > ${activity.createdDate}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Stage: ${activity.remark}, Status: ${activity.inquiryId}',
                          ),
                          trailing: Text(activity.createdDate ?? ''),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
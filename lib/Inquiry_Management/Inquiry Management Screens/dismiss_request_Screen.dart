import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:hr_app/Provider/UserProvider.dart';
import 'package:provider/provider.dart';

import '../Model/Api Model/dismiss_Model.dart';
import '../Utils/Custom widgets/custom_buttons.dart';

class DismissRequestCard extends StatelessWidget {
  final String id;
  final String name;
  final String username;
  final String label; // e.g., inquiry stage like "Dismissed"
  final String inquiryType; // e.g., interested product
  final String intArea; // e.g., interested site name
  final String nxtFollowup; //// e.g., budget
  final String source; // Source of the request
  final bool isSelected; // Track if card is selected
  final VoidCallback onSelect; // Callback to toggle selection
  final TooltipItem data; // Full TooltipItem data for details

  const DismissRequestCard({
    Key? key,
    required this.id,
    required this.name,
    required this.username,
    required this.label,
    required this.inquiryType,
    required this.intArea,
    required this.nxtFollowup,
    required this.source,
    this.isSelected = false,
    required this.onSelect,
    required this.data,
  }) : super(key: key);

  void showDialogDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Container(
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Details", style: TextStyle(fontFamily: "poppins_thin", fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text("Mobile: ${data.mobileno ?? 'N/A'}", style: TextStyle(fontFamily: "poppins_thin")),
                Text("Email: ${data.email ?? 'N/A'}", style: TextStyle(fontFamily: "poppins_thin")),
                Text("Address: ${data.address ?? 'N/A'}", style: TextStyle(fontFamily: "poppins_thin")),
                Text("Budget: ${data.budget ?? 'N/A'}", style: TextStyle(fontFamily: "poppins_thin")),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onSelect, // Trigger selection on long press
      child: Card(
        margin: EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: isSelected ? 14.0 : 4.0,
        color: isSelected ? Colors.deepPurple.shade100 : Colors.white, // Highlight selected card
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 9),
                        child: Text(
                          id,
                          style: TextStyle(fontSize: 13, fontFamily: "poppins_thin", color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(fontSize: 17, fontFamily: "poppins_thin"),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.person, size: 15),
                            Text(
                              ": ${data.assignId}",
                              style: TextStyle(fontSize: 14, fontFamily: "poppins_thin", color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialogDetails(context); // Show details on tap
                    },
                    child: Image.asset(
                      "asset/Inquiry_module/call-forwarding.png",
                      width: 30,
                      height: 30,
                    ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      // Add navigation or action for map
                    },
                    child: Image.asset(
                      "asset/Inquiry_module/map.png",
                      width: 25,
                      height: 25,
                    ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      // Add navigation or action for budget
                    },
                    child: Image.asset(
                      "asset/Inquiry_module/rupee.png",
                      width: 25,
                      height: 25,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    height: 30,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: getLabelColor(label),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(width: 1.0, color: getBorderColor(label)),
                    ),
                    child: Center(
                      child: Text(
                        label,
                        style: TextStyle(fontFamily: "poppins_thin", color: Colors.black, fontSize: 11),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    height: 30,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Color(0xffebf0f4),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(width: 1.0, color: Colors.white),
                    ),
                    child: Center(
                      child: Text(
                        "Inq Type: $inquiryType",
                        style: TextStyle(fontFamily: "poppins_thin", color: Colors.black, fontSize: 11),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(
                  "Next Followup: ${data.nxtFollowUp}",
                  style: TextStyle(color: Colors.grey.shade600, fontFamily: "poppins_thin", fontSize: 12),
                ),
              ),
              Row(
                children: [
                  Text("Source: ", style: TextStyle(fontFamily: "poppins_thin", fontSize: 12)),
                  _buildSourceContainer(source),
                  Image.asset("asset/Inquiry_module/calendar.png",height: 18,width: 18,),
                  SizedBox(width: 3,),

                  // Icon(Icons.calendar_month),
                  Text((data.daySkip ?? "").isNotEmpty ? data.daySkip! : "0"),
                  SizedBox(width: 10,),
                  Image.asset("asset/Inquiry_module/clock.png",height: 18,width: 18,),
                  SizedBox(width: 3,),

                  Text((data.hourSkip ?? "").isNotEmpty ? data.hourSkip! : "0"),

// Text(budget, style: TextStyle(fontFamily: "poppins_thin", fontSize: 12)),
                ],
              ),
              if (isSelected) // Show checkbox when selected
                Align(
                  alignment: Alignment.centerRight,
                  child: Checkbox(
                    value: isSelected,
                    onChanged: (bool? value) {
                      onSelect(); // Trigger onSelect callback
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color getLabelColor(String? stage) {
    switch (stage) {
      case "Dismissed":
        return Colors.red.shade200; // Custom color for dismissed
      case "Fresh":
        return Color(0xff33b5e5);
      case "Contacted":
        return Color(0xff4da8ff);
      case "Appointment":
        return Color(0xff3d70b2);
      case "Visited":
        return Color(0xff4da8ff);
      case "Negotiation":
        return Color(0xffc966c3);
      case "Feedback":
        return Color(0xff66d977);
      case "Re_Appointment":
        return Color(0xff3d6ca3);
      case "Re-Visited":
        return Color(0xfff1ba71);
      case "Converted":
        return Color(0xff73e0b3);
      default:
        return Colors.grey.shade300;
    }
  }

  Color getBorderColor(String? stage) {
    switch (stage) {
      case "Dismissed":
        return Colors.red.shade400; // Custom border for dismissed
      case "Fresh":
        return Color(0xff00c4ff);
      case "Contacted":
        return Color(0xff33aaff);
      case "Appointment":
        return Color(0xff2b70c9);
      case "Visited":
        return Color(0xff3399ff);
      case "Negotiation":
        return Color(0xffd94ed1);
      case "Feedback":
        return Color(0xff4cd964);
      case "Re_Appointment":
        return Color(0xff2e62b3);
      case "Re-Visited":
        return Color(0xffffca85);
      case "Converted":
        return Color(0xff73e0b3);
      default:
        return Colors.grey.shade600;
    }
  }

  Widget _buildSourceContainer(String source) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text(
        source,
        style: TextStyle(fontFamily: "poppins_thin", fontSize: 12),
      ),
    );
  }
}
class DismissRequestScreen extends StatefulWidget {
  const DismissRequestScreen({Key? key}) : super(key: key);

  @override
  _DismissRequestScreenState createState() => _DismissRequestScreenState();
}

class _DismissRequestScreenState extends State<DismissRequestScreen> {
  List<int> selectedIndices = [];
  int currentPage = 1;

  List<Map<String, String>> actionList = [];
  List<Map<String, String>> employeeList = [];
  String? selectedAction;
  String? selectedEmployee;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<UserProvider>(context, listen: false).fetchDismissData(currentPage);
        loadData(); // Load action and employee data
      }
    });
  }

  Future<void> loadData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      await userProvider.fetchTransferInquiryData();
      final data = userProvider.transferInquiryData;

      if (data == null) {
        print('No data received');
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
        } else {
          print('No action data available');
        }

        print('Actions Loaded: $actionList');
        print('Selected Action: $selectedAction');

        employeeList = (data.employee ?? [])
            .where((e) => e.id != null && e.firstname != null)
            .map((e) => {'id': e.id!, 'name': e.firstname!})
            .toList();
        selectedEmployee = employeeList.isNotEmpty ? employeeList.first['name'] : null;

        print('Employees Loaded: $employeeList');
        print('Selected Employee: $selectedEmployee');
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void toggleSelection(int index) {
    setState(() {
      if (selectedIndices.contains(index)) {
        selectedIndices.remove(index);
      } else {
        selectedIndices.add(index);
      }
    });
  }

  void handleAction(String action, String employee) {
    setState(() {
      selectedAction = null;
      selectedEmployee = null;
      selectedIndices.clear(); // Clear selections after action
    });
    print('Action: $action, Employee: $employee');
  }

  void showActionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        String? dialogSelectedAction = actionList.isNotEmpty ? actionList.first['value'] : null;
        String? dialogSelectedEmployee = employeeList.isNotEmpty ? employeeList.first['name'] : null;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text('Perform Action', style: TextStyle(fontWeight: FontWeight.w600)),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildDropdown(
                      label: "Select Action",
                      hint: "Choose Action",
                      value: dialogSelectedAction,
                      items: actionList.map((e) => e['value']!).toList(),
                      onChanged: (value) => setState(() => dialogSelectedAction = value),
                    ),
                    const SizedBox(height: 16),
                    _buildDropdown(
                      label: "Select Employee",
                      hint: "Choose Employee",
                      value: dialogSelectedEmployee,
                      items: employeeList.map((e) => e['name']!).toList(),
                      onChanged: (value) => setState(() => dialogSelectedEmployee = value),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text("Cancel"),
                ),
                GradientButton(
                  onPressed: () async {
                    if (dialogSelectedAction == null || dialogSelectedEmployee == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please select both action and employee")),
                      );
                      return;
                    }

                    // Get selected inquiry IDs using selectedIndices
                    final provider = Provider.of<UserProvider>(context, listen: false);
                    List<String> selectedInquiryIds = selectedIndices
                        .map((index) => provider.dismissmodel!.data![index].id ?? '')
                        .toList();

                    if (selectedInquiryIds.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("No inquiries selected")),
                      );
                      return;
                    }

                    String actionKey = actionList
                        .firstWhere((action) => action['value'] == dialogSelectedAction)['key'] ??
                        '';
                    String employeeId = employeeList
                        .firstWhere((e) => e['name'] == dialogSelectedEmployee)['id'] ??
                        '';

                    try {
                      await provider.sendTransferInquiry(
                        inqIds: selectedInquiryIds,
                        actionKey: actionKey,
                        employeeId: employeeId,
                      );
                      handleAction(dialogSelectedAction!, dialogSelectedEmployee!);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Inquiries transferred successfully")),
                      );
                      Navigator.of(dialogContext).pop();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Failed to transfer inquiries: $e")),
                      );
                    }
                  },
                  width: 100,
                  buttonText: "Submit",
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildDropdown({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    print('Building Dropdown: $label, Value: $value, Items: $items');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[800], fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.grey.shade100),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              isExpanded: true,
              hint: Text(hint, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
              value: value,
              onChanged: items.isEmpty ? null : onChanged,
              items: items.map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item, style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 13)),
              )).toList(),
              buttonStyleData: const ButtonStyleData(height: 40, width: double.infinity),
              iconStyleData: IconStyleData(icon: Icon(Icons.arrow_drop_down, color: Colors.grey[700])),
              dropdownStyleData: DropdownStyleData(
                maxHeight: 200,
                width: MediaQuery.of(context).size.width / 1.65,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dismissed Requests", style: TextStyle(fontFamily: "poppins_thin")),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Consumer<UserProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(provider.errorMessage!, style: TextStyle(fontFamily: "poppins_thin", fontSize: 16)),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => provider.fetchDismissData(currentPage),
                    child: Text("Retry"),
                  ),
                ],
              ),
            );
          }

          if (provider.dismissmodel == null || provider.dismissmodel!.data == null || provider.dismissmodel!.data!.isEmpty) {
            return Center(
              child: Text("No dismissed requests found", style: TextStyle(fontFamily: "poppins_thin", fontSize: 16)),
            );
          }

          // Ensure selectedCards is initialized with the correct length
          if (selectedIndices.length > provider.dismissmodel!.data!.length) {
            selectedIndices.removeRange(provider.dismissmodel!.data!.length, selectedIndices.length);
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 8),
            itemCount: provider.dismissmodel!.data!.length,
            itemBuilder: (context, index) {
              final item = provider.dismissmodel!.data![index];
              return DismissRequestCard(
                id: item.id ?? "N/A",
                name: item.fullName ?? "Unknown",
                username: item.userId ?? "N/A",
                label: _getStageLabel(item.inquiryStages),
                inquiryType: item.intrestedProduct ?? "N/A",
                intArea: item.interstedSiteName ?? item.area ?? "N/A",
                nxtFollowup: item.nxtFollowUp ?? "N/A",
                source: item.inquirySourceType ?? "N/A",
                isSelected: selectedIndices.contains(index),
                onSelect: () => toggleSelection(index),
                data: item,
              );
            },
          );
        },
      ),
      floatingActionButton: selectedIndices.isNotEmpty
          ? FloatingActionButton(
        onPressed: () => showActionDialog(context),
        child: Icon(Icons.check),
        backgroundColor: Colors.deepPurple,
      )
          : null,
    );
  }

  String _getStageLabel(String? stage) {
    switch (stage) {
      case "1":
        return "Fresh";
      case "2":
        return "Contacted";
      case "3":
        return "Dismissed";
      case "4":
        return "Appointment";
      case "5":
        return "Visited";
      default:
        return "Unknown";
    }
  }
}
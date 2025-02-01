import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../Model/category_Model.dart';
import '../Model/followup_Model.dart';
import '../Utils/Custom widgets/custom_buttons.dart';
import '../Utils/Custom widgets/custom_dialog.dart';
import '../Utils/Custom widgets/custom_search.dart';
import '../Utils/Custom widgets/filter_Bottomsheet.dart';
import '../Utils/Custom widgets/pending_Card.dart';
// import 'filter_modal.dart';
final TextEditingController nextFollowupcontroller = TextEditingController();
String selectedcallFilter = "Follow Up";
List<String> callList = ['Followup', 'Dismissed', 'Appointment', 'Cnr'];
String? selectedMembership;
String? selectedApx;
String? selectedPurpose;
String? selectedTime;
String selectedList = "All Leads";
String selectedValue = "15";
int? selectedIndex;
List<LeadModel> LeadList = [
  LeadModel("1", "abc", "leadmgt", "Feedback", '02-01-2025', '04-01-2025', "Fresh", "1232312311", "abc@gmail.com", "Facebook", 'table', '1-2 days', 'ielts', '3 months', "jaisdjshadkanadabcbcamnmnsaasddadsdsSS"),
  LeadModel("2", "xyz", "leadmgt", "Negotiations", '02-01-2025', '04-01-2025', "Fresh", "1232312311", "xyz@gmail.com", "Facebook", 'table', '1-2 days', 'ielts', '3 months', "NASDNAXNSXMN"),
  LeadModel("3", "pqr", "leadmgt", "Appointment", '02-01-2025', '04-01-2025', "Fresh", "1232312311", "pqr@gmail.com", "Facebook", 'table', '1-2 days', 'ielts', '3 months', "DJASHNDJNASN"),
  LeadModel("4", "lmn", "leadmgt", "Qualified", '02-01-2025', '04-01-2025', "Fresh", "1232312311", "lmn@gmail.com", "Facebook", 'table', '1-2 days', 'ielts', '3 months', "NANDNASMD"),
  LeadModel("5", "jkl", "leadmgt", "Fresh", '02-01-2025', '04-01-2025', "Fresh", "1232312311", "jkl@gmail.com", "Facebook", 'table', '1-2 days', 'ielts', '3 months', "DUIQOJSZ"),
  LeadModel("1", "abc", "leadmgt", "Feedback", '02-01-2025', '04-01-2025', "Fresh", "1232312311", "abc@gmail.com", "Facebook", 'table', '1-2 days', 'ielts', '3 months', "DJIJSAJKJ"),
  LeadModel("2", "xyz", "leadmgt", "Negotiations", '02-01-2025', '04-01-2025', "Fresh", "1232312311", "xyz@gmail.com", "Facebook", 'table', '1-2 days', 'ielts', '3 months', "UWIDHNXN"),
  LeadModel("3", "pqr", "leadmgt", "Appointment", '02-01-2025', '04-01-2025', "Fresh", "1232312311", "pqr@gmail.com", "Facebook", 'table', '1-2 days', 'ielts', '3 months', "IDUEIWYDJANXM"),
  LeadModel("4", "lmn", "leadmgt", "Qualified", '02-01-2025', '04-01-2025', "Fresh", "1232312311", "lmn@gmail.com", "Facebook", 'table', '1-2 days', 'ielts', '3 months', "JEIOJDNMKS"),
  LeadModel("5", "jkl", "leadmgt", "Fresh", '02-01-2025', '04-01-2025', "Fresh", "1232312311", "jkl@gmail.com", "Facebook", 'table', '1-2 days', 'ielts', '3 months', "EIOWJFDMKX"),
  LeadModel("1", "abc", "leadmgt", "Feedback", '02-01-2025', '04-01-2025', "Fresh", "1232312311", "abc@gmail.com", "Facebook", 'table', '1-2 days', 'ielts', '3 months', "E9UWJIODKSMX"),
  LeadModel("2", "xyz", "leadmgt", "Negotiations", '02-01-2025', '04-01-2025', "Fresh", "1232312311", "xyz@gmail.com", "Facebook", 'table', '1-2 days', 'ielts', '3 months', "EIJMFKDASJIED"),
  LeadModel("3", "pqr", "leadmgt", "Appointment", '02-01-2025', '04-01-2025', "Fresh", "1232312311", "pqr@gmail.com", "Facebook", 'table', '1-2 days', 'ielts', '3 months', "OIUJDISKAMX "),
  LeadModel("4", "lmn", "leadmgt", "Qualified", '02-01-2025', '04-01-2025', "Fresh", "1232312311", "lmn@gmail.com", "Facebook", 'table', '1-2 days', 'ielts', '3 months', "IEUWIOEJDSKMX"),
  LeadModel("5", "jkl", "leadmgt", "Fresh", '02-01-2025', '04-01-2025', "Fresh", "1232312311", "jkl@gmail.com", "Facebook", 'table', '1-2 days', 'ielts', '3 months', "IEDJSKMX"),
];
List<CategoryModel> categoryList = [];
List<LeadModel> filteredLeads = [];
List<bool> selectedCards = [];
bool anySelected = false;
String? selectedAction = null;
String? selectedEmployee = null;
final List<String> actions = ['markAsComplete', 'assignToUser', 'delete'];
final List<String> employees = ['employee 1', 'employee 2', 'employee 3'];

class DismissRequestScreen extends StatefulWidget {
  const DismissRequestScreen({super.key});

  @override
  State<DismissRequestScreen> createState() => _DismissRequestScreenState();
}

class _DismissRequestScreenState extends State<DismissRequestScreen> {
  void handleAction(String action, String employee) {
    setState(() {
      selectedAction = null;
      selectedEmployee = null;
    });
  }

  void toggleSelection(int index) {
    selectedCards[index] = !selectedCards[index];
    anySelected = selectedCards.contains(true);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    selectedCards = List.generate(LeadList.length, (index) => false);
    categoryList = [
      CategoryModel("Feedback", LeadList.where((lead) => lead.label == "Feedback").toList()),
      CategoryModel("Negotiations", LeadList.where((lead) => lead.label == "Negotiations").toList()),
      CategoryModel("Appointment", LeadList.where((lead) => lead.label == "Appointment").toList()),
      CategoryModel("Qualified", LeadList.where((lead) => lead.label == "Qualified").toList()),
      CategoryModel("Fresh", LeadList.where((lead) => lead.label == "Fresh").toList()),
      CategoryModel("All Lead", LeadList),
    ];
    filteredLeads = List.from(LeadList);
  }

  String? filteredId;
  Map<String, dynamic> appliedFilters = {};
  void _updateSearchResults(List<LeadModel> results) {
    setState(() {
      filteredLeads = results;
    });
  }
  void resetFilters() {
    setState(() {
      filteredLeads = List.from(LeadList); // Reset the list to the original
      appliedFilters.clear(); // Clear all applied filters
      filteredId = null; // Clear filtered ID
      filteredName = null; // Clear filtered Name
      filteredPhone = null;
      filteredStatus.clear(); // Clear filtered Status

    });
  }
  String? filteredPhone;

  void _updateAppliedFilters(Map<String, dynamic> filters) {
    setState(() {
      appliedFilters = filters;
      filteredId = filters['Id'];
      filteredName = filters['Name'];
      filteredPhone= filters['Mobile'];
      filteredStatus = List.from(filters['Status'] ?? []);
    });
  }

  void showBottomModalSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.6,
        child: FilterModal(
          onFilterApplied: (List<LeadModel> filteredList, Map<String, dynamic> filters) {
            _updateSearchResults(filteredList);
            _updateAppliedFilters(filters);
          },
          appliedFilters: appliedFilters,
        ),
      ),
    );
  }
  String? filteredName;
  List<String> filteredStatus = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dismiss Request", style: TextStyle(fontFamily: "poppins_thin", color: Colors.white)),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple.shade300,
        actions: [
          SearchBar1(onSearch: _updateSearchResults, items: LeadList),
          const SizedBox(width: 10),
          CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              onPressed: () => showBottomModalSheet(context),
              icon: const Icon(Icons.filter_list_outlined, color: Colors.black),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          // Action Selection Panel (when cards selected)
          if (anySelected)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade100,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 4,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        hint: Text(
                          'Select Action',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: "poppins_thin",
                          ),
                        ),
                        value: selectedAction,
                        onChanged: (value) {
                          setState(() {
                            selectedAction = value;
                          });
                        },
                        items: actions.map((action) => DropdownMenuItem(
                          value: action,
                          child: Text(action, style: const TextStyle(fontFamily: "poppins_thin")),
                        )).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade100,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 4,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        hint: Text(
                          'Select Employee',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: "poppins_thin",
                          ),
                        ),
                        value: selectedEmployee,
                        onChanged: (value) {
                          setState(() {
                            selectedEmployee = value;
                          });
                        },
                        items: employees
                            .map((employee) => DropdownMenuItem(
                          value: employee,
                          child: Text(employee, style: const TextStyle(fontFamily: "poppins_thin")),
                        ))
                            .toList(),
                      ),
                    ),
                  ),
                  const   SizedBox(height: 8.0),
                  Center(
                    child: SizedBox(
                      child: GradientButton(
                        buttonText: "Submit",
                        onPressed: () {
                          if (selectedAction == null || selectedEmployee == null) {
                            showsubmitdialog(context);
                          } else {
                            showConfirmationDialog(context);
                            handleAction(selectedAction!, selectedEmployee!);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          // Applied Filters UI
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Display ID filter if set
                if (filteredId != null)
                  FilterChip(
                    label: Text('ID: $filteredId'),
                    onDeleted: () {
                      setState(() {
                        filteredId = null;
                        appliedFilters.remove('Id');
                        filteredLeads = List.from(LeadList); // Reset the filtered leads
                      });
                    }, onSelected: (bool value) {  },
                  ),

                // Display Name filter if set
                if (filteredName != null)
                  FilterChip(
                    label: Text('Name: $filteredName'),
                    onDeleted: () {
                      setState(() {
                        filteredName = null;
                        appliedFilters.remove('Name');
                        filteredLeads = List.from(LeadList); // Reset the filtered leads
                      });
                    }, onSelected: (bool value) {  },
                  ),
                if (filteredPhone != null)
                  FilterChip(
                    label: Text('Phone: $filteredPhone'),
                    onDeleted: () {
                      setState(() {
                        filteredPhone = null;
                        appliedFilters.remove('Mobile');
                        filteredLeads = List.from(LeadList);
                      });
                    }, onSelected: (bool value) {  },
                  ),

                // Display Status filter if set
                if (filteredStatus.isNotEmpty)
                  FilterChip(
                    label: Text('Status: ${filteredStatus.join(', ')}'),
                    onDeleted: () {
                      setState(() {
                        filteredStatus.clear();
                        appliedFilters.remove('Status');
                        filteredLeads = List.from(LeadList);
                      });
                    }, onSelected: (bool value) {  },
                  ),
                const  Spacer(),

                // "Clear All" button
                ElevatedButton(
                  onPressed: resetFilters,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Clear All', style: TextStyle(fontFamily: 'poppins_thin')),
                ),
              ],
            ),
          ),


          // Display List of Leads or No Results
          Expanded(
            child: filteredLeads.isEmpty
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Lottie.asset('asset/Inquiry_module/no_result.json', fit: BoxFit.contain, width: 300, height: 300),
                ),
                Center(
                  child: Text(
                    "No results found",
                    style: TextStyle(color: Colors.red, fontSize: 26, fontFamily: "poppins_thin"),
                  ),
                ),
              ],
            )
                : ListView.builder(
              itemCount: filteredLeads.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onLongPress: () {
                    toggleSelection(index);
                  },
                  child: TestCard(
                    id: filteredLeads[index].id,
                    name: filteredLeads[index].name,
                    username: filteredLeads[index].username,
                    label: filteredLeads[index].label,
                    followUpDate: filteredLeads[index].followUpDate,
                    nextFollowUpDate: filteredLeads[index].nextFollowUpDate,
                    inquiryType: filteredLeads[index].inquiryType,
                    phone: filteredLeads[index].phone,
                    email: filteredLeads[index].email,
                    source: filteredLeads[index].source,
                    isSelected: selectedCards[index],
                    onSelect: () {
                      toggleSelection(index);
                    },
                    callList: ["Followup", "Dismissed", "Appointment", "Negotiation", "Feedback", "Cnr"],
                    selectedcallFilter: selectedcallFilter,
                    data: filteredLeads[index],
                    isTiming: true,
                    nextFollowupcontroller: nextFollowupcontroller,
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
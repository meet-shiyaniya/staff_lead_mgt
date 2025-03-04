import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_app/Inquiry_Management/Inquiry%20Management%20Screens/lead_Detail_Screen.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../Provider/UserProvider.dart';
import '../Model/Api Model/allInquiryModel.dart';
import '../Model/category_Model.dart';
import '../Utils/Colors/app_Colors.dart';
import '../Utils/Custom widgets/add_lead_Screen.dart';
import '../Utils/Custom widgets/custom_buttons.dart';
import '../Utils/Custom widgets/pending_Card.dart';
import '../Utils/Custom widgets/search_Screen.dart';
import 'Filters/inquiry_Filter_Screen.dart';

class AllInquiriesScreen extends StatefulWidget {
  const AllInquiriesScreen({Key? key});

  @override
  State<AllInquiriesScreen> createState() => _AllInquiriesScreenState();
}

class _AllInquiriesScreenState extends State<AllInquiriesScreen> {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  List<Map<String, String>> actionList = []; // Stores key-value pairs for actions
  List<Map<String, String>> employeeList = []; // Stores key-value pairs for employees
  String? selectedAction; // Stores selected action value
  String? selectedEmployee; // Stores selected employee name

  String selectedList = "All";
  String selectedValue = "0";
  int? selectedIndex;

  List<CategoryModel> categoryList = [];
  List<Inquiry> filteredLeads = [];
  List<bool> selectedCards = [];
  bool anySelected = false;

  late ScrollController _scrollController;

  bool isStatusFilterActive = false;
  String? currentStage;

  int currentStatus = 1; // Default to 1 (Live)

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

  Future<void> _sendTransferInquiry({
    required List<String> inqIds, // Changed to accept a list of IDs
    required String actionKey,
    required String employeeId,
  }) async {
    final url = Uri.parse("https://admin.dev.ajasys.com/api/people_assign_bulkapi");

    try {
      String? token = await _secureStorage.read(key: 'token');

      if (token == null) {
        Fluttertoast.showToast(msg: "No authentication token found");
        return;
      }

      // Join the inquiry IDs into a comma-separated string
      String inquiryIdsString = inqIds.join(',');

      Map<String, String> bodyData = {
        "token": token,
        "inquiry_id": inquiryIdsString, // Send as "123,456,789"
        "action_name": actionKey,
        "action": "assign",
        "assign_id": employeeId
      };

      print('Sending to backend: $bodyData'); // Debug print

      final response = await http.post(
        url,
        body: bodyData,
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Fluttertoast.showToast(msg: inqIds.toString());
        Fluttertoast.showToast(msg: "Inquiries transferred successfully");
      } else {
        Fluttertoast.showToast(
          msg: "Failed to transfer inquiries: ${response.statusCode}",
        );
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong: $e");
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadAllInquiries();
    });
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  Future<void> loadAllInquiries() async {
    final inquiryProvider = Provider.of<UserProvider>(context, listen: false);
    await inquiryProvider.fetchInquiries(status: currentStatus);
    setState(() {
      filteredLeads = _applyStageFilter(inquiryProvider.inquiries);
      selectedValue = filteredLeads.length.toString();
      isStatusFilterActive = currentStatus != 0 || currentStage != null;
      selectedMainFilter = "Live";
    });
  }

  void _onScroll() {
    final inquiryProvider = Provider.of<UserProvider>(context, listen: false);
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300 &&
        !inquiryProvider.isLoading &&
        inquiryProvider.hasMore) {
      inquiryProvider
          .fetchInquiries(isLoadMore: true, status: currentStatus)
          .then((_) {
        setState(() {
          filteredLeads.addAll(_applyStageFilter(
              inquiryProvider.inquiries.skip(filteredLeads.length).toList()));
          selectedValue = filteredLeads.length.toString();
        });
      });
    }
  }

  List<Inquiry> _applyStageFilter(List<Inquiry> inquiries) {
    if (currentStage == null) {
      return List.from(inquiries);
    }
    return inquiries.where((inquiry) => inquiry.InqStage == currentStage).toList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final inquiryProvider = Provider.of<UserProvider>(context);

    if (selectedCards.length != inquiryProvider.inquiries.length) {
      selectedCards = List<bool>.generate(
        inquiryProvider.inquiries.length,
            (index) => false,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> filterLeadsByStatus(int status) async {
    final inquiryProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() {
      currentStatus = status;
      currentStage = null;
    });
    await inquiryProvider.fetchInquiries(status: status);
    setState(() {
      filteredLeads = _applyStageFilter(inquiryProvider.inquiries);
      selectedValue = filteredLeads.length.toString();
      selectedList = "All";
      isStatusFilterActive = true;
      selectedMainFilter = status == 1
          ? "Live"
          : status == 2
          ? "Dismiss"
          : status == 3
          ? "Dismissed Request"
          : status == 4
          ? "Conversion Request"
          : status == 5
          ? "Due Appo"
          : "CNR";
    });
  }

  String? getInquiryStageFromCategory(String category) {
    switch (category) {
      case "Fresh":
        return "1";
      case "Contacted":
        return "2";
      case "Trial":
        return "3";
      case "Negotiation":
        return "4";
      case "Dismiss":
        return "5";
      case "Dismissed Request":
        return "6";
      case "Feedback":
        return "7";
      case "Reappointment":
        return "8";
      case "Re-trial":
        return "9";
      case "Converted":
        return "10";
      default:
        return null;
    }
  }

  void handleAction(String action, String employee) {
    setState(() {
      selectedAction = null;
      selectedEmployee = null;
    });
    print('Action: $action, Employee: $employee');
  }

  void toggleSelection(int index) {
    setState(() {
      selectedCards[index] = !selectedCards[index];
      anySelected = selectedCards.contains(true);
      print("anySelected: $anySelected");
    });
  }

  Future<void> filterLeadsByStage(String stage) async {
    final inquiryProvider = Provider.of<UserProvider>(context, listen: false);
    if (inquiryProvider.inquiries.isEmpty) {
      await inquiryProvider.fetchInquiries(status: currentStatus);
    }
    setState(() {
      currentStage = stage;
      filteredLeads = _applyStageFilter(inquiryProvider.inquiries);
      selectedValue = filteredLeads.length.toString();
      selectedList = getInquiryStageText(stage);
      isStatusFilterActive = true;
    });
  }

  final TextEditingController nextFollowupcontroller = TextEditingController();
  String selectedcallFilter = "Follow Up";
  List<String> callList = ['Followup', 'Dismissed', 'Appointment', 'Cnr'];

  String? selectedMembership;
  String? selectedApx;
  String? selectedPurpose;
  String? selectedTime;

  Map<String, dynamic> appliedFilters = {};

  void resetFilters() {
    final inquiryProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() {
      filteredLeads = List.from(inquiryProvider.inquiries);
      appliedFilters.clear();
    });
  }

  String? filteredPhone;
  String? filteredId;
  String? filteredName;
  String? filteredMobile;
  List<String> filteredStatus = [];

  void showActionDialog(
      BuildContext context,
      bool anySelected,
      Function(String, String) handleAction,
      List<String> actions,
      List<String> employeeNames,
      ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        String? dialogSelectedAction = actions.isNotEmpty ? actions.first : null;
        String? dialogSelectedEmployee =
        employeeNames.isNotEmpty ? employeeNames.first : null;

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
                      items: actions,
                      onChanged: (value) {
                        setState(() {
                          dialogSelectedAction = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildDropdown(
                      label: "Select Employee",
                      hint: "Choose Employee",
                      value: dialogSelectedEmployee,
                      items: employeeNames,
                      onChanged: (value) {
                        setState(() {
                          dialogSelectedEmployee = value;
                        });
                      },
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

                    // Get selected inquiry IDs
                    List<String> selectedInquiryIds = [];
                    for (int i = 0; i < selectedCards.length; i++) {
                      if (selectedCards[i]) {
                        selectedInquiryIds.add(filteredLeads[i].id ?? '');
                      }
                    }
                    print('Selected Inquiry IDs: $selectedInquiryIds');

                    if (selectedInquiryIds.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("No inquiries selected")),
                      );
                      return;
                    }

                    // Get the action key from the selected action value
                    String actionKey = actionList
                        .firstWhere((action) => action['value'] == dialogSelectedAction)['key'] ??
                        '';

                    // Get the employee ID from the selected employee name
                    String employeeId = employeeList
                        .firstWhere((e) => e['name'] == dialogSelectedEmployee)['id'] ??
                        '';

                    try {
                      // Send all IDs in a single request
                      await _sendTransferInquiry(
                        inqIds: selectedInquiryIds, // Pass the list of IDs
                        actionKey: actionKey,
                        employeeId: employeeId,
                      );
                      handleAction(dialogSelectedAction!, dialogSelectedEmployee!);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Inquiries transferred successfully")),
                      );
                      setState(() {
                        selectedCards = List<bool>.filled(filteredLeads.length, false);
                        anySelected = false;
                      });
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
        Text(label,
            style: TextStyle(color: Colors.grey[800], fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.shade100,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              isExpanded: true,
              hint: Text(hint, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
              value: value,
              onChanged: items.isEmpty ? null : onChanged,
              items: items.map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item,
                    style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 13)),
              )).toList(),
              buttonStyleData: const ButtonStyleData(height: 40, width: double.infinity),
              iconStyleData:
              IconStyleData(icon: Icon(Icons.arrow_drop_down, color: Colors.grey[700])),
              dropdownStyleData: DropdownStyleData(
                maxHeight: 200,
                width: MediaQuery.of(context).size.width.toDouble() / 1.65,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final inquiryProvider = Provider.of<UserProvider>(context);

    if (selectedCards.length != inquiryProvider.inquiries.length) {
      selectedCards = List<bool>.generate(
        inquiryProvider.inquiries.length,
            (index) => false,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "All Inquiries",
          style: TextStyle(fontFamily: "poppins_thin", color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple.shade300,
        actions: [
          if (anySelected)
            CircleAvatar(
              backgroundColor: Colors.white,
              child: GestureDetector(
                onTap: () async {
                  await loadData();
                  List<String> actionValues = actionList.map((action) => action['value']!).toList();
                  List<String> employeeNames = employeeList.map((e) => e['name']!).toList();
                  print(
                      'Calling showActionDialog with Actions: $actionValues, Employees: $employeeNames');
                  showActionDialog(
                    context,
                    anySelected,
                    handleAction,
                    actionValues,
                    employeeNames,
                  );
                },
                child: Image(
                  image: AssetImage("asset/Inquiry_module/fast-forward.png"),
                  height: 25,
                  width: 25,
                ),
              ),
            ),
          SizedBox(width: 10),
          CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchPage()),
                );
              },
            ),
          ),
          SizedBox(width: 10),
          CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => InquiryFilterScreen()));
              },
              icon: Icon(
                Icons.filter_list_outlined,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          _buildMainButtonGroup(),
          GestureDetector(
            onTap: () async {
              setState(() {
                selectedList = "All";
                selectedValue = "0";
                selectedIndex = 0;
              });

              final inquiryProvider = Provider.of<UserProvider>(context, listen: false);
              final paginatedInquiries = inquiryProvider.paginatedInquiries;

              List<Categorymodel> filteredOptions = [
                Categorymodel("All", paginatedInquiries?.totalRecords ?? 0),
              ];

              Map<String, int> stageCounts = inquiryProvider.stageCounts;

              if (selectedMainFilter == "Live") {
                filteredOptions.addAll([
                  Categorymodel("Fresh", stageCounts["Fresh"] ?? 0),
                  Categorymodel("Contacted", stageCounts["Contacted"] ?? 0),
                  Categorymodel("Appointment", stageCounts["Appointment"] ?? 0),
                  Categorymodel("Negotiation", stageCounts["Negotiation"] ?? 0),
                  Categorymodel("Feedback", stageCounts["Feedback"] ?? 0),
                  Categorymodel("Reappointment", stageCounts["Re-Appointment"] ?? 0),
                  Categorymodel("Re-trial", stageCounts["Re-Visited"] ?? 0),
                  Categorymodel("Converted", stageCounts["Converted"] ?? 0),
                ]);
              } else if (selectedMainFilter == "Dismiss") {
                filteredOptions.addAll([
                  Categorymodel("Fresh", stageCounts["Fresh"] ?? 0),
                  Categorymodel("Contacted", stageCounts["Contacted"] ?? 0),
                  Categorymodel("Appointment", stageCounts["Appointment"] ?? 0),
                  Categorymodel("Trial", stageCounts["Visited"] ?? 0),
                  Categorymodel("Negotiation", stageCounts["Negotiation"] ?? 0),
                  Categorymodel("Feedback", stageCounts["Feedback"] ?? 0),
                  Categorymodel("Reappointment", stageCounts["Re-Appointment"] ?? 0),
                  Categorymodel("Re-trial", stageCounts["Re-Visited"] ?? 0),
                  Categorymodel("Converted", stageCounts["Converted"] ?? 0),
                ]);
              } else if (selectedMainFilter == "Dismissed Request") {
                filteredOptions.addAll([
                  Categorymodel("Fresh", stageCounts["Fresh"] ?? 0),
                  Categorymodel("Contacted", stageCounts["Contacted"] ?? 0),
                  Categorymodel("Appointment", stageCounts["Appointment"] ?? 0),
                  Categorymodel("Trial", stageCounts["Visited"] ?? 0),
                  Categorymodel("Negotiation", stageCounts["Negotiation"] ?? 0),
                  Categorymodel("Feedback", stageCounts["Feedback"] ?? 0),
                  Categorymodel("Reappointment", stageCounts["Re-Appointment"] ?? 0),
                  Categorymodel("Re-trial", stageCounts["Re-Visited"] ?? 0),
                  Categorymodel("Converted", stageCounts["Converted"] ?? 0),
                ]);
              } else if (selectedMainFilter == "Conversion Request") {
                filteredOptions.addAll([
                  Categorymodel("Fresh", stageCounts["Fresh"] ?? 0),
                  Categorymodel("Contacted", stageCounts["Contacted"] ?? 0),
                  Categorymodel("Appointment", stageCounts["Appointment"] ?? 0),
                  Categorymodel("Trial", stageCounts["Visited"] ?? 0),
                  Categorymodel("Negotiation", stageCounts["Negotiation"] ?? 0),
                  Categorymodel("Feedback", stageCounts["Feedback"] ?? 0),
                  Categorymodel("Reappointment", stageCounts["Re-Appointment"] ?? 0),
                  Categorymodel("Re-trial", stageCounts["Re-Visited"] ?? 0),
                  Categorymodel("Converted", stageCounts["Converted"] ?? 0),
                ]);
              } else if (selectedMainFilter == "Due Appo") {
                filteredOptions.addAll([
                  Categorymodel("Fresh", stageCounts["Fresh"] ?? 0),
                  Categorymodel("Contacted", stageCounts["Contacted"] ?? 0),
                  Categorymodel("Appointment", stageCounts["Appointment"] ?? 0),
                  Categorymodel("Trial", stageCounts["Visited"] ?? 0),
                  Categorymodel("Negotiation", stageCounts["Negotiation"] ?? 0),
                  Categorymodel("Feedback", stageCounts["Feedback"] ?? 0),
                  Categorymodel("Reappointment", stageCounts["Re-Appointment"] ?? 0),
                  Categorymodel("Re-trial", stageCounts["Re-Visited"] ?? 0),
                  Categorymodel("Converted", stageCounts["Converted"] ?? 0),
                ]);
              } else if (selectedMainFilter == "CNR") {
                filteredOptions.addAll([
                  Categorymodel("Fresh", stageCounts["Fresh"] ?? 0),
                  Categorymodel("Contacted", stageCounts["Contacted"] ?? 0),
                  Categorymodel("Appointment", stageCounts["Appointment"] ?? 0),
                  Categorymodel("Trial", stageCounts["Visited"] ?? 0),
                  Categorymodel("Negotiation", stageCounts["Negotiation"] ?? 0),
                  Categorymodel("Feedback", stageCounts["Feedback"] ?? 0),
                  Categorymodel("Reappointment", stageCounts["Re-Appointment"] ?? 0),
                  Categorymodel("Re-trial", stageCounts["Re-Visited"] ?? 0),
                  Categorymodel("Converted", stageCounts["Converted"] ?? 0),
                ]);
              }

              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListSelectionscreen(
                    initialSelectedIndex: 0,
                    optionList: filteredOptions,
                  ),
                ),
              );
              if (result != null) {
                final selectedCategory = result["selectedCategory"] as Categorymodel;
                if (selectedCategory.title != "All") {
                  final stage = getInquiryStageFromCategory(selectedCategory.title);
                  if (stage != null) {
                    await filterLeadsByStage(stage);
                  }
                } else {
                  setState(() {
                    currentStage = null;
                    filteredLeads = inquiryProvider.inquiries
                        .where((inquiry) => inquiry.InqStatus == currentStatus.toString())
                        .toList();
                    selectedValue = filteredLeads.length.toString();
                    selectedList = "All";
                  });
                }
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
              child: Container(
                height: 60,
                padding: EdgeInsets.symmetric(horizontal: 26.0, vertical: 8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.deepPurple.shade100,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(selectedList,
                        style: TextStyle(fontFamily: "poppins_thin", fontSize: 16)),
                    Row(
                      children: [
                        Icon(Icons.group, color: Colors.black),
                        SizedBox(width: 8.0),
                        Text(selectedValue, style: TextStyle(fontFamily: "poppins_thin")),
                        Icon(Icons.arrow_drop_down, color: Colors.black),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      if (filteredId != null && filteredId!.isNotEmpty)
                        FilterChip(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          label: Text('ID: $filteredId'),
                          onDeleted: () {
                            setState(() {
                              filteredId = null;
                              appliedFilters.remove('Id');
                              loadAllInquiries();
                            });
                          },
                          onSelected: (bool value) {},
                        ),
                      SizedBox(width: 5),
                      if (filteredName != null && filteredName!.isNotEmpty)
                        FilterChip(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          label: Text('Name: $filteredName'),
                          onDeleted: () {
                            setState(() {
                              filteredName = null;
                              appliedFilters.remove('Name');
                              loadAllInquiries();
                            });
                          },
                          onSelected: (bool value) {},
                        ),
                      SizedBox(width: 5),
                      if (filteredPhone != null && filteredPhone!.isNotEmpty)
                        FilterChip(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          label: Text('Phone: $filteredPhone'),
                          onDeleted: () {
                            setState(() {
                              filteredPhone = null;
                              appliedFilters.remove('Mobile');
                              loadAllInquiries();
                            });
                          },
                          onSelected: (bool value) {},
                        ),
                      SizedBox(width: 5),
                      if (filteredStatus.isNotEmpty)
                        FilterChip(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          label: Text('Status: ${filteredStatus.join(', ')}'),
                          onDeleted: () {
                            setState(() {
                              filteredStatus.clear();
                              appliedFilters.remove('Status');
                              loadAllInquiries();
                            });
                          },
                          onSelected: (bool value) {},
                        ),
                      SizedBox(width: 5),
                    ],
                  ),
                ),
                if (filteredId != null ||
                    filteredName != null ||
                    filteredPhone != null ||
                    filteredStatus.isNotEmpty)
                  ElevatedButton(
                    onPressed: resetFilters,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple.shade300,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                    ),
                    child: const Text('Clear All',
                        style: TextStyle(fontFamily: 'poppins_thin', color: Colors.white)),
                  ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await loadAllInquiries();
              },
              child: Builder(
                builder: (context) {
                  if (inquiryProvider.isLoading && inquiryProvider.inquiries.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (filteredLeads.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Lottie.asset(
                              'asset/Inquiry_module/no_result.json',
                              fit: BoxFit.contain,
                              width: 300,
                              height: 300),
                        ),
                        Center(
                          child: Text(
                            "No results found",
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 26,
                                fontFamily: "poppins_thin"),
                          ),
                        ),
                      ],
                    );
                  } else {
                    if (selectedCards.length != filteredLeads.length) {
                      selectedCards = List<bool>.filled(filteredLeads.length, false);
                    }
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: filteredLeads.length + (inquiryProvider.isLoading ? 1 : 0),
                      itemBuilder: (BuildContext context, int index) {
                        if (index < filteredLeads.length) {
                          Inquiry inquiry = filteredLeads[index];
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return GestureDetector(
                                onLongPress: () {
                                  toggleSelection(index);
                                },
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LeadDetailScreen(
                                          InquiryInfoList: inquiry,
                                        ),
                                      ));
                                },
                                child: TestCard(
                                  id: inquiry.id,
                                  name: inquiry.fullName,
                                  username: inquiry.assign_id,
                                  label: getInquiryStageText(inquiry.InqStage),
                                  followUpDate: inquiry.createdAt,
                                  nextFollowUpDate: inquiry.nxtfollowup,
                                  inquiryType: inquiry.InqType,
                                  intArea: inquiry.InqArea,
                                  purposeBuy: inquiry.PurposeBuy,
                                  daySkip: inquiry.day_skip,
                                  hourSkip: inquiry.hour_skip,
                                  source: inquiry.inquiry_source_type,
                                  isSelected: selectedCards[index],
                                  onSelect: () => toggleSelection(index),
                                  callList: callList,
                                  selectedcallFilter: selectedcallFilter,
                                  data: inquiry,
                                  isTiming: true,
                                  nextFollowupcontroller: nextFollowupcontroller,
                                ),
                              );
                            },
                          );
                        } else {
                          return inquiryProvider.isLoading
                              ? Center(
                              child: Lottie.asset('asset/loader.json',
                                  fit: BoxFit.contain, width: 100, height: 100))
                              : SizedBox();
                        }
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddLeadScreen(
                  isEdit: false,
                ),
              ));
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.deepPurple.shade400,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        elevation: 20,
      ),
    );
  }

  Widget _buildMainButtonGroup() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildMainButton("Live"),
            _buildMainButton("Dismiss"),
            _buildMainButton("Dismissed Request"),
            _buildMainButton("Conversion Request"),
            _buildMainButton("Due Appo"),
            _buildMainButton("CNR"),
          ],
        ),
      ),
    );
  }

  String selectedMainFilter = "Live";

  Widget _buildMainButton(String text) {
    final bool isSelected = selectedMainFilter == text;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? AppColor.Buttoncolor : Colors.white,
          foregroundColor: isSelected ? Colors.white : AppColor.MainColor,
          side: const BorderSide(color: Color(0xff6A0DAD)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
        onPressed: () async {
          setState(() {
            selectedMainFilter = text;
            selectedList = "All";
            selectedValue = "0";
            selectedIndex = 0;
          });

          if (text == "Live") {
            await filterLeadsByStatus(1);
          } else if (text == "Dismiss") {
            await filterLeadsByStatus(2);
          } else if (text == "Dismissed Request") {
            await filterLeadsByStatus(3);
          } else if (text == "Conversion Request") {
            await filterLeadsByStatus(4);
          } else if (text == "Due Appo") {
            await filterLeadsByStatus(5);
          } else if (text == "CNR") {
            await filterLeadsByStatus(6);
          }
        },
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontFamily: "poppins_thin",
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  String getInquiryStageText(String? stage) {
    switch (stage) {
      case "1":
        return "Fresh";
      case "2":
        return "Contacted";
      case "3":
        return "Trial";
      case "4":
        return "Negotiation";
      case "5":
        return "Dismiss";
      case "6":
        return "Dismissed Request";
      case "7":
        return "Feedback";
      case "8":
        return "Reappointment";
      case "9":
        return "Re-trial";
      case "10":
        return "Converted";
      default:
        return "Unknown";
    }
  }
}

class ListSelectionscreen extends StatefulWidget {
  final int? initialSelectedIndex;
  final List<Categorymodel> optionList;

  ListSelectionscreen({
    this.initialSelectedIndex,
    required this.optionList,
  });

  @override
  _ListSelectionscreenState createState() => _ListSelectionscreenState();
}

class _ListSelectionscreenState extends State<ListSelectionscreen> {
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialSelectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade300,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: Text(
          "Choose Stage",
          style: TextStyle(fontFamily: "poppins_thin", color: Colors.white),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.optionList.length,
        itemBuilder: (context, index) {
          bool isSelected = selectedIndex == index;
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Card(
              elevation: isSelected ? 6 : 4,
              color: isSelected ? Colors.deepPurple.shade100 : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              child: ListTile(
                title: Text(
                  widget.optionList[index].title,
                  style: TextStyle(
                    color: isSelected ? Colors.deepPurple : Colors.black,
                    fontFamily: isSelected ? "poppins_thin" : "poppins_light",
                  ),
                ),
                leading: CircleAvatar(
                  backgroundColor:
                  isSelected ? Colors.deepPurple.shade300 : Colors.grey.shade200,
                  child: Text(
                    widget.optionList[index].title[0],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.group,
                      color: isSelected ? Colors.deepPurple : Colors.black,
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      widget.optionList[index].leads.toString(),
                      style: TextStyle(
                        color: isSelected ? Colors.deepPurple : Colors.black,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                  Navigator.pop(context, {
                    "selectedIndex": selectedIndex,
                    "selectedCategory": widget.optionList[index],
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
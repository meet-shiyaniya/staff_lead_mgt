import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:hr_app/Inquiry_Management/Model/Api%20Model/assignToOther_Model.dart';
import 'package:hr_app/Inquiry_Management/Utils/Custom%20widgets/textCard_assignToOther.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../Provider/UserProvider.dart';
import '../Model/category_Model.dart';
import '../Utils/Colors/app_Colors.dart';
import '../Utils/Custom widgets/add_lead_Screen.dart';
import '../Utils/Custom widgets/search_Screen.dart';
import 'Filters/inquiry_Filter_Screen.dart';


class AssignToOtherScreen extends StatefulWidget {
  const AssignToOtherScreen({Key? key});

  @override
  State<AssignToOtherScreen> createState() => _ShiftsListState();
}

class _ShiftsListState extends State<AssignToOtherScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedList = "All";
  String selectedValue = "0";
  int? selectedIndex = 0;

  List<Map<String, String>> actionList = [];
  List<Map<String, String>> employeeList = [];
  String? selectedAction;
  String? selectedEmployee;

  String? getStageValue(String stageTitle) {
    const stageMap = {
      "Fresh": "1",
      "Contacted": "2",
      "Appointment": "3",
      "Negotiations": "4",
      "Visited": "5",
      "FeedBack": "6",
      "Re_Appointment": "7",
      "Re_Visited": "8",
      "Converted": "9"
    };
    return stageMap[stageTitle];
  }

  List<Categorymodel> categoryList = [];
  List<InquiryFollowup> filteredLeads = [];
  List<bool> selectedCards = [];
  bool anySelected = false;

  late ScrollController _scrollController;

  bool isStatusFilterActive = false;
  String? currentStage;
  String currentFollowUpDay = 'assign_to_other'; // Default tab
  int currentStatus = 1; // 1 for Live, 5 for Due (only for Today and Pending)x
  int currentStatuscnr = 1; // 1 for Live, 5 for Due (only for Today and Pending)x

  String selectedMainFilter = "Live";

  @override
  void initState() {
    super.initState();
    // _tabController = TabController(length: 3, vsync: this);
    // _tabController.addListener(_handleTabSelection);

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadAllInquiriesFollowup();
      loadData();
    });

    Future.wait([userProvider.fetchAddLeadData()]);

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
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
        }

        employeeList = (data.employee ?? [])
            .where((e) => e.id != null && e.firstname != null)
            .map((e) => {'id': e.id!, 'name': e.firstname!})
            .toList();
        selectedEmployee = employeeList.isNotEmpty ? employeeList.first['name'] : null;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> loadAllInquiriesFollowup() async {
    final inquiryProvider = Provider.of<UserProvider>(context, listen: false);
    print('Loading inquiries: followUpDay=$currentFollowUpDay, status=$currentStatus, stages=$currentStage');
    await inquiryProvider.fetchInquiriesFollowup(
      status: currentFollowUpDay == 'cnr' ? 6 : currentStatus,
      stages: currentStage ?? "",
      followUpDay: currentFollowUpDay,
    );
    setState(() {
      filteredLeads = inquiryProvider.inquiriesFollowup;
      print('Loaded inquiries: ${filteredLeads.length} items');
      isStatusFilterActive = currentStatus != 0;
      selectedValue = inquiryProvider.fullStageCountFollowup["Total_Sum"] ?? "0"; // Use full counts
      selectedList = "All";
      selectedIndex = 0;
      selectedCards = List<bool>.generate(
        inquiryProvider.inquiriesFollowup.length,
            (index) => false,
      );
      anySelected = false;
    });
  }

  void _onScroll() {
    final inquiryProvider = Provider.of<UserProvider>(context, listen: false);
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300 &&
        !inquiryProvider.isLoadingFollowup &&
        inquiryProvider.hasMoreFollowup) {
      print('Loading more: followUpDay=$currentFollowUpDay, status=$currentStatus, stages=$currentStage');
      inquiryProvider
          .fetchInquiriesFollowup(
        isLoadMore: true,
        status: currentFollowUpDay == 'cnr' ? 9 : currentStatus, // null for CNR
        stages: currentStage ?? "",
        followUpDay: currentFollowUpDay,
      )
          .then((_) {
        setState(() {
          filteredLeads = inquiryProvider.inquiriesFollowup;
          print('Loaded more inquiries: ${filteredLeads.length} items');
        });
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final inquiryProvider = Provider.of<UserProvider>(context);
    if (selectedCards.length != inquiryProvider.inquiriesFollowup.length) {
      selectedCards = List<bool>.generate(
        inquiryProvider.inquiriesFollowup.length,
            (index) => false,
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> filterLeadsByStatus(int status) async {
    if (currentFollowUpDay == 'cnr') return; // No status filter for CNR

    final inquiryProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() {
      currentStatus = status; // Update the current status
      currentStage = ""; // Reset the stage
      selectedMainFilter = status == 1
          ? "Live"
          : status == 4
          ? "Conversion Request"
          : status == 5
          ? "Due Appo"
          : status == 6
          ? "CNR"
          : "Live";
    });

    await inquiryProvider.fetchInquiriesFollowup(
      status: status,
      stages: "",
      followUpDay: currentFollowUpDay,
    );

    setState(() {
      filteredLeads = inquiryProvider.inquiriesFollowup; // Update the filtered leads
      selectedList = "All"; // Reset the selected list
      selectedValue = inquiryProvider.stageCountsFollowup["Total_Sum"] ?? "0"; // Update the selected value
      isStatusFilterActive = true; // Enable status filter
    });
  }

  String? getInquiryStageFromCategory(String category) {
    switch (category) {
      case "Fresh":
        return "1";
      case "Contacted":
        return "2";
      case "Appointment":
        return "3";
      case "Visited":
        return "4";
      case "Negotiations":
        return "6";
      case "FeedBack":
        return "9";
      case "Re_Appointment":
        return "10";
      case "Re_Visited":
        return "11";
      case "Converted":
        return "12";
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
    });
  }

  Future<void> filterLeadsByStage(String stage) async {
    final inquiryProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() {
      currentStage = stage;
    });

    print('Filtering by stage: followUpDay=$currentFollowUpDay, status=$currentStatus, stages=$stage');
    await inquiryProvider.fetchInquiriesFollowup(
      status: currentFollowUpDay == 'cnr' ? 6 : currentStatus,
      stages: stage,
      followUpDay: currentFollowUpDay,
    );

    setState(() {
      filteredLeads = inquiryProvider.inquiriesFollowup;
      print('Filtered by stage: ${filteredLeads.length} items');
      selectedList = getInquiryStageText(stage);
      selectedValue = inquiryProvider.fullStageCountFollowup[selectedList] ?? "0"; // Use full counts
      isStatusFilterActive = true;
    });
  }
  final TextEditingController nextFollowupcontroller = TextEditingController();
  String selectedcallFilter = "Follow Up";
  List<String> callList = ['Followup', 'Dismissed', 'Appointment', 'Cnr'];
  Map<String, dynamic> appliedFilters = {};
  String? filteredId;
  String? filteredName;
  String? filteredPhone;
  List<String> filteredStatus = [];

  void resetFilters() {
    final inquiryProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() {
      filteredLeads = List.from(inquiryProvider.inquiriesFollowup);
      appliedFilters.clear();
      filteredId = null;
      filteredName = null;
      filteredPhone = null;
      filteredStatus.clear();
    });
  }

  void _updateAppliedFilters(Map<String, dynamic> filters) {
    setState(() {
      appliedFilters = filters;
      filteredId = (filters['Id'] != null && filters['Id'].toString().isNotEmpty)
          ? filters['Id']
          : null;
      filteredName = (filters['Name'] != null && filters['Name'].toString().isNotEmpty)
          ? filters['Name']
          : null;
      filteredPhone = (filters['Mobile'] != null && filters['Mobile'].toString().isNotEmpty)
          ? filters['Mobile']
          : null;
      filteredStatus = filters['Status'] != null && filters['Status'].isNotEmpty
          ? List.from(filters['Status'])
          : [];
    });
  }

  void showActionDialog(
      BuildContext context,
      bool anySelected,
      Function(String, String) handleAction,
      List<String> actions,
      List<String> employeeNames) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        String? dialogSelectedAction = actions.isNotEmpty ? actions.first : null;
        String? dialogSelectedEmployee =
        employeeNames.isNotEmpty ? employeeNames.first : null;
        bool isSubmitting = false;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter dialogSetState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text(
                'Perform Action',
                style: TextStyle(fontFamily: "poppins_thin", fontSize: 19, fontWeight: FontWeight.w600),
              ),
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
                      onChanged: (value) => dialogSetState(() => dialogSelectedAction = value),
                    ),
                    const SizedBox(height: 16),
                    _buildDropdown(
                      label: "Select Employee",
                      hint: "Choose Employee",
                      value: dialogSelectedEmployee,
                      items: employeeNames,
                      onChanged: (value) => dialogSetState(() => dialogSelectedEmployee = value),
                    ),
                  ],
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      child: const Text("Cancel", style: TextStyle(fontFamily: "poppins_thin", fontSize: 16, color: Colors.grey)),
                    ),
                    ElevatedButton(
                      onPressed: isSubmitting
                          ? null
                          : () async {
                        if (dialogSelectedAction == null || dialogSelectedEmployee == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Please select both action and employee", style: TextStyle(fontFamily: 'poppins_thin'))),
                          );
                          return;
                        }

                        List<String> selectedInquiryIds = [];
                        for (int i = 0; i < selectedCards.length; i++) {
                          if (selectedCards[i]) {
                            selectedInquiryIds.add(filteredLeads[i].id ?? '');
                          }
                        }

                        if (selectedInquiryIds.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("No inquiries selected", style: TextStyle(fontFamily: 'poppins_thin'))),
                          );
                          return;
                        }

                        String actionKey = actionList.firstWhere(
                                (action) => action['value'] == dialogSelectedAction,
                            orElse: () => {'key': ''})['key'] ??
                            '';
                        String employeeId = employeeList.firstWhere(
                                (e) => e['name'] == dialogSelectedEmployee,
                            orElse: () => {'id': ''})['id'] ??
                            '';

                        dialogSetState(() => isSubmitting = true);

                        try {
                          final userProvider = Provider.of<UserProvider>(context, listen: false);
                          await userProvider.sendTransferInquiry(
                            inqIds: selectedInquiryIds,
                            actionKey: actionKey,
                            employeeId: employeeId,
                          );

                          handleAction(dialogSelectedAction!, dialogSelectedEmployee!);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(color: Colors.deepPurple.shade700, strokeWidth: 2),
                                  ),
                                  SizedBox(width: 12),
                                  Text("Reloading follow-up inquiries...", style: TextStyle(fontFamily: 'poppins_thin')),
                                ],
                              ),
                              duration: Duration(days: 1),
                            ),
                          );

                          await loadAllInquiriesFollowup();

                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Follow-up inquiries transferred and reloaded successfully", style: TextStyle(fontFamily: 'poppins_thin')),
                              duration: Duration(seconds: 2),
                            ),
                          );

                          Navigator.of(dialogContext).pop();
                        } catch (e) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Failed to process follow-up inquiries: $e", style: TextStyle(fontFamily: 'poppins_thin'))),
                          );
                        } finally {
                          dialogSetState(() => isSubmitting = false);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple.shade100,
                        foregroundColor: Colors.deepPurple.shade700,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                        minimumSize: Size(100, 0),
                      ),
                      child: isSubmitting
                          ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.deepPurple.shade700, strokeWidth: 2))
                          : Text('Submit', style: TextStyle(fontFamily: 'poppins_thin', fontSize: 16, fontWeight: FontWeight.w500)),
                    ),
                  ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontFamily: 'poppins_thin', color: Colors.grey[800], fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.grey.shade100),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              isExpanded: true,
              hint: Text(hint, style: TextStyle(fontFamily: 'poppins_thin', color: Colors.grey[600], fontSize: 14)),
              value: value,
              onChanged: items.isEmpty ? null : onChanged,
              items: items.map((item) => DropdownMenuItem<String>(value: item, child: Text(item, style: TextStyle(fontFamily: 'poppins_thin', fontWeight: FontWeight.w400, fontSize: 13)))).toList(),
              buttonStyleData: const ButtonStyleData(height: 40, width: double.infinity),
              iconStyleData: IconStyleData(icon: Icon(Icons.arrow_drop_down, color: Colors.grey[700])),
              dropdownStyleData: DropdownStyleData(maxHeight: 200, width: MediaQuery.of(context).size.width / 1.65, decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white)),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final inquiryProvider = Provider.of<UserProvider>(context);

    if (selectedCards.length != inquiryProvider.inquiriesFollowup.length) {
      selectedCards = List<bool>.generate(inquiryProvider.inquiriesFollowup.length, (index) => false);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Assign To Other",style: TextStyle(fontFamily: "poppins_thin",color: Colors.white,fontWeight: FontWeight.bold),),
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
                  height: 23,
                  width: 23,
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
          if (currentFollowUpDay != 'cnr') _buildMainButtonGroup(), // Hide Live/Due for CNR
          GestureDetector(
            onTap: () async {
              final inquiryProvider = Provider.of<UserProvider>(context, listen: false);
              final Map<String, String> stageCounts = inquiryProvider.fullStageCountFollowup; // Use full counts

              List<Categorymodel> filteredOptions = [
                Categorymodel("All", int.tryParse(stageCounts["Total_Sum"] ?? "0") ?? 0),
              ];
              List<String> categoryTitles = [
                "Fresh",
                "Contacted",
                "Appointment",
                "Visited",
                "Negotiations",
                "FeedBack",
                "Re_Appointment",
                "Re_Visited",
                "Converted"
              ];
              filteredOptions.addAll(categoryTitles.map((title) => Categorymodel(title, int.tryParse(stageCounts[title] ?? "0") ?? 0)));

              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListSelectionscreen(
                    initialSelectedIndex: selectedIndex ?? 0,
                    optionList: filteredOptions,
                    currentStatus: currentStatus,
                  ),
                ),
              );

              if (result != null && result["selectedCategory"] != null) {
                final selectedCategory = result["selectedCategory"] as Categorymodel;
                setState(() {
                  selectedList = selectedCategory.title;
                  selectedValue = selectedCategory.leads.toString();
                  selectedIndex = result["selectedIndex"];
                });

                if (selectedCategory.title != "All") {
                  final stage = getInquiryStageFromCategory(selectedCategory.title);
                  if (stage != null) await filterLeadsByStage(stage);
                } else {
                  await loadAllInquiriesFollowup();
                }
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                height: 52,
                padding: EdgeInsets.symmetric(horizontal: 26.0, vertical: 8.0),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.deepPurple.shade100),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(selectedList, style: TextStyle(fontFamily: "poppins_thin", fontSize: 16)),
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
                              loadAllInquiriesFollowup();
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
                              loadAllInquiriesFollowup();
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
                              loadAllInquiriesFollowup();
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
                              loadAllInquiriesFollowup();
                            });
                          },
                          onSelected: (bool value) {},
                        ),
                      SizedBox(width: 5),
                    ],
                  ),
                ),
                if (filteredId != null || filteredName != null || filteredPhone != null || filteredStatus.isNotEmpty)
                  ElevatedButton(
                    onPressed: resetFilters,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple.shade300,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                    ),
                    child: const Text('Clear All', style: TextStyle(fontFamily: 'poppins_thin', color: Colors.white)),
                  ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => await loadAllInquiriesFollowup(),
              child: Builder(
                builder: (context) {
                  if (inquiryProvider.isLoadingFollowup && inquiryProvider.inquiriesFollowup.isEmpty) {
                    return ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(height: 160, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8))),
                          ),
                        );
                      },
                    );
                  } else if (filteredLeads.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: Lottie.asset('asset/Inquiry_module/no_result.json', fit: BoxFit.contain, width: 300, height: 300)),
                        Center(
                          child: Text(
                            "No follow-up inquiries found",
                            style: TextStyle(color: Colors.red, fontSize: 22, fontFamily: "poppins_thin"),
                          ),
                        ),
                      ],
                    );
                  } else {
                    if (selectedCards.length != filteredLeads.length) {
                      selectedCards = List<bool>.filled(filteredLeads.length, false);
                    }
                    return  ListView.builder(
                      controller: _scrollController,
                      itemCount: filteredLeads.length + (inquiryProvider.isLoadingFollowup ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index < filteredLeads.length) {
                          InquiryFollowup inquiry = filteredLeads[index];
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return GestureDetector(
                                onLongPress: () => toggleSelection(index),
                                onTap: () {
                                  // Uncomment if needed
                                  // Navigator.push(context, MaterialPageRoute(builder: (context) => LeadDetailScreen(InquiryInfoList: inquiry));
                                },
                                child: TestCardAssignToOther(
                                  id: inquiry.id,
                                  name: inquiry.fullName,
                                  username: inquiry.assignId,
                                  label: getInquiryStageText(inquiry.inquiryStages),
                                  followUpDate: inquiry.createdAt,
                                  nextFollowUpDate: inquiry.nextFollowUp,
                                  inquiryType: inquiry.inquiryType,
                                  intArea: inquiry.interestedArea,
                                  purposeBuy: inquiry.purposeBuy,
                                  daySkip: inquiry.daySkip,
                                  hourSkip: inquiry.hourSkip,
                                  source: inquiry.inquirySourceType,
                                  isSelected: selectedCards[index],
                                  onSelect: () => toggleSelection(index),
                                  callList: callList,
                                  selectedcallFilter: selectedcallFilter,
                                  data: inquiry,
                                  isTiming: true,
                                  nextFollowupcontroller: nextFollowupcontroller,
                                  // inquiryImage: AssetImage("asset/Inquiry_module/telephone.png"),
                                  // visitImage: AssetImage("asset/Inquiry_module/map.png"),
                                  // bookingImage: AssetImage("asset/Inquiry_module/booking2.png"),
                                  eyseImage: null,
                                ),
                              );
                            },
                          );
                        }
                        if (inquiryProvider.isLoadingFollowup) {
                          return Center(child: Lottie.asset('asset/loader.json', fit: BoxFit.contain, width: 60, height: 60));
                        }
                        return const SizedBox.shrink();
                      },
                    );                  }
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddLeadScreen(isEdit: false))),
        child: Icon(Icons.add, color: Colors.white),
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
            _buildMainButton("Live", 1),
            _buildMainButton("Conversion Request", 4),
            _buildMainButton("Due", 5),
            _buildMainButton("CNR", 6),
          ],
        ),
      ),
    );
  }

  Widget _buildMainButton(String text, int status) {
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
          await filterLeadsByStatus(status);
        },
        child: Text(
          text,
          style: TextStyle(fontSize: 14, fontFamily: "poppins_thin", fontWeight: FontWeight.w500),
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
        return "Appointment";
      case "4":
        return "Visited";
      case "6":
        return "Negotiations";
      case "9":
        return "FeedBack";
      case "10":
        return "Re_Appointment";
      case "11":
        return "Re_Visited";
      case "12":
        return "Converted";
      default:
        return "Unknown";
    }
  }
}

class ListSelectionscreen extends StatefulWidget {
  final int? initialSelectedIndex;
  final List<Categorymodel> optionList;
  final int currentStatus;

  ListSelectionscreen({
    this.initialSelectedIndex,
    required this.optionList,
    required this.currentStatus,
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade300,
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back_ios, color: Colors.white)),
        title: Text("Choose Stage", style: TextStyle(fontFamily: "poppins_thin", color: Colors.white, fontSize: 18)),
      ),
      body: ListView.builder(
        itemCount: widget.optionList.length,
        itemBuilder: (context, index) {
          bool isSelected = selectedIndex == index;
          bool isDisabled = widget.optionList[index].leads == 0;
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Card(
              elevation: isSelected ? 6 : 4,
              color: isDisabled ? Colors.grey.shade200 : isSelected ? Colors.deepPurple.shade100 : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
              child: ListTile(
                title: Text(
                  widget.optionList[index].title,
                  style: TextStyle(
                    color: isDisabled ? Colors.grey.shade600 : isSelected ? Colors.deepPurple : Colors.black,
                    fontFamily: isSelected ? "poppins_thin" : "poppins_light",
                    fontWeight: FontWeight.w600,
                  ),
                ),
                leading: CircleAvatar(
                  backgroundColor: isDisabled ? Colors.grey.shade400 : isSelected ? Colors.deepPurple.shade300 : Colors.grey.shade200,
                  child: Text(
                    widget.optionList[index].title[0],
                    style: TextStyle(color: isDisabled ? Colors.grey.shade600 : isSelected ? Colors.white : Colors.black),
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.group, color: isDisabled ? Colors.grey.shade600 : isSelected ? Colors.deepPurple : Colors.black),
                    SizedBox(width: 8.0),
                    Text(widget.optionList[index].leads.toString(), style: TextStyle(color: isDisabled ? Colors.grey.shade600 : isSelected ? Colors.deepPurple : Colors.black)),
                  ],
                ),
                onTap: isDisabled
                    ? null
                    : () {
                  setState(() => selectedIndex = index);
                  Navigator.pop(context, {"selectedIndex": selectedIndex, "selectedCategory": widget.optionList[index]});
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
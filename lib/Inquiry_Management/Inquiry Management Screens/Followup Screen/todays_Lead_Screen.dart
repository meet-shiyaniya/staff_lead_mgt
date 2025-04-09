import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_app/Inquiry_Management/Inquiry%20Management%20Screens/Followup%20Screen/Custome%20Cards/clock_Wise_Card.dart';
import 'package:hr_app/Inquiry_Management/Inquiry%20Management%20Screens/Followup%20Screen/Custome%20Cards/list_Wise_Card.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../Provider/UserProvider.dart';
import '../../Model/Api Model/assignToOther_Model.dart';
import '../../Model/category_Model.dart';
import '../../Utils/Colors/app_Colors.dart';
import 'Custome Cards/followup_Card.dart';
import '../../Utils/Custom widgets/lead_Details_Screen.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({Key? key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> with SingleTickerProviderStateMixin {

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
  String currentFollowUpDay = 'today';
  int currentStatus = 1;
  int currentStatuscnr = 1;

  String selectedMainFilter = "Live";

  bool showButtonGroup = false;
  int selectedButtonIndex = 1
  ;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await Future.wait([
          loadAllInquiriesFollowup(),
          loadData(),
          userProvider.fetchAddLeadData(),
        ]);
      } catch (e) {}
    });
  }

  void _handleTabSelection() {
    if (!_tabController.indexIsChanging) {
      setState(() {
        switch (_tabController.index) {
          case 0:
            currentFollowUpDay = 'today';
            break;
          case 1:
            currentFollowUpDay = 'pending';
            break;
          case 2:
            currentFollowUpDay = 'cnr';
            break;
        }
        currentStage = "";
        selectedList = "All";
      });
      loadAllInquiriesFollowup();
    }
  }

  bool isAnyCardSelected() {
    return selectedCards.contains(true);
  }

  Future<void> loadData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      await userProvider.fetchTransferInquiryData();
      final data = userProvider.transferInquiryData;

      if (data == null) {
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
    } catch (e) {}
  }

  Future<void> loadAllInquiriesFollowup() async {
    Fluttertoast.showToast(msg: "Data Fetch in process");
    final inquiryProvider = Provider.of<UserProvider>(context, listen: false);
    await inquiryProvider.fetchInquiriesFollowup(
      status: currentFollowUpDay == 'cnr' ? 6 : currentStatus,
      stages: currentStage ?? "",
      followUpDay: currentFollowUpDay,
    );
    setState(() {
      filteredLeads = inquiryProvider.inquiriesFollowup;
      isStatusFilterActive = currentStatus != 0;
      selectedValue = inquiryProvider.fullStageCountFollowup["Total_Sum"] ?? "0";
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
      inquiryProvider
          .fetchInquiriesFollowup(
        isLoadMore: true,
        status: currentFollowUpDay == 'cnr' ? 9 : currentStatus,
        stages: currentStage ?? "",
        followUpDay: currentFollowUpDay,
      )
          .then((_) {
        setState(() {
          filteredLeads = inquiryProvider.inquiriesFollowup;
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
    if (currentFollowUpDay == 'cnr') return;

    final inquiryProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() {
      currentStatus = status;
      currentStage = "";
      selectedMainFilter = status == 1 ? "Live" : "Due";
    });

    await inquiryProvider.fetchInquiriesFollowup(
      status: status,
      stages: "",
      followUpDay: currentFollowUpDay,
    );

    setState(() {
      filteredLeads = inquiryProvider.inquiriesFollowup;
      selectedList = "All";
      selectedValue = inquiryProvider.stageCountsFollowup["Total_Sum"] ?? "0";
      isStatusFilterActive = true;
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

    await inquiryProvider.fetchInquiriesFollowup(
      status: currentFollowUpDay == 'cnr' ? 6 : currentStatus,
      stages: stage,
      followUpDay: currentFollowUpDay,
    );

    setState(() {
      filteredLeads = inquiryProvider.inquiriesFollowup;
      selectedList = getInquiryStageText(stage);
      selectedValue = inquiryProvider.fullStageCountFollowup[selectedList] ?? "0";
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
                style: TextStyle(
                    fontFamily: "poppins_thin",
                    fontSize: 19,
                    fontWeight: FontWeight.w600),
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
                      onChanged: (value) =>
                          dialogSetState(() => dialogSelectedAction = value),
                    ),
                    const SizedBox(height: 16),
                    _buildDropdown(
                      label: "Select Employee",
                      hint: "Choose Employee",
                      value: dialogSelectedEmployee,
                      items: employeeNames,
                      onChanged: (value) =>
                          dialogSetState(() => dialogSelectedEmployee = value),
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
                      child: const Text("Cancel",
                          style: TextStyle(
                              fontFamily: "poppins_thin",
                              fontSize: 16,
                              color: Colors.grey)),
                    ),
                    ElevatedButton(
                      onPressed: isSubmitting
                          ? null
                          : () async {
                        if (dialogSelectedAction == null ||
                            dialogSelectedEmployee == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    "Please select both action and employee",
                                    style: TextStyle(
                                        fontFamily: 'poppins_thin'))),
                          );
                          return;
                        }

                        List<String> selectedInquiryIds = [];
                        for (int i = 0; i < selectedCards.length; i++) {
                          if (selectedCards[i]) {
                            selectedInquiryIds.add(filteredLeads[i].id);
                          }
                        }

                        if (selectedInquiryIds.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text("No inquiries selected",
                                    style: TextStyle(
                                        fontFamily: 'poppins_thin'))),
                          );
                          return;
                        }

                        String actionKey = actionList.firstWhere(
                                (action) =>
                            action['value'] == dialogSelectedAction,
                            orElse: () => {'key': ''})['key'] ??
                            '';
                        String employeeId = employeeList.firstWhere(
                                (e) => e['name'] == dialogSelectedEmployee,
                            orElse: () => {'id': ''})['id'] ??
                            '';

                        dialogSetState(() => isSubmitting = true);

                        try {
                          final userProvider = Provider.of<UserProvider>(
                              context,
                              listen: false);
                          await userProvider.sendTransferInquiry(
                            inqIds: selectedInquiryIds,
                            actionKey: actionKey,
                            employeeId: employeeId,
                          );

                          handleAction(
                              dialogSelectedAction!, dialogSelectedEmployee!);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                        color: Colors.deepPurple.shade700,
                                        strokeWidth: 2),
                                  ),
                                  SizedBox(width: 12),
                                  Text("Reloading follow-up inquiries...",
                                      style: TextStyle(
                                          fontFamily: 'poppins_thin')),
                                ],
                              ),
                              duration: Duration(days: 1),
                            ),
                          );

                          userProvider.clearInquiriesFollowup();
                          await loadAllInquiriesFollowup();

                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Inquiries transferred successfully',
                                style: TextStyle(
                                  fontFamily: 'poppins_thin',
                                  fontSize: 13,
                                  color: Colors.white,
                                ),
                              ),
                              backgroundColor: Colors.green.shade200,
                              behavior: SnackBarBehavior.floating,
                              margin: EdgeInsets.all(16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              duration: Duration(seconds: 3),
                            ),
                          );

                          Navigator.of(dialogContext).pop();
                        } catch (e) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    "Failed to process follow-up inquiries: $e",
                                    style: TextStyle(
                                        fontFamily: 'poppins_thin'))),
                          );
                        } finally {
                          dialogSetState(() => isSubmitting = false);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple.shade100,
                        foregroundColor: Colors.deepPurple.shade700,
                        padding:
                        EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                        minimumSize: Size(100, 0),
                      ),
                      child: isSubmitting
                          ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              color: Colors.deepPurple.shade700,
                              strokeWidth: 2))
                          : Text('Submit',
                          style: TextStyle(
                              fontFamily: 'poppins_thin',
                              fontSize: 16,
                              fontWeight: FontWeight.w500)),
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
        Text(label,
            style: TextStyle(
                fontFamily: 'poppins_thin',
                color: Colors.grey[800],
                fontSize: 16,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), color: Colors.grey.shade100),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              isExpanded: true,
              hint: Text(hint,
                  style:
                  TextStyle(fontFamily: 'poppins_thin', color: Colors.grey[600], fontSize: 14)),
              value: value,
              onChanged: items.isEmpty ? null : onChanged,
              items: items
                  .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item,
                      style: TextStyle(
                          fontFamily: 'poppins_thin',
                          fontWeight: FontWeight.w400,
                          fontSize: 13))))
                  .toList(),
              buttonStyleData: const ButtonStyleData(height: 40, width: double.infinity),
              iconStyleData:
              IconStyleData(icon: Icon(Icons.arrow_drop_down, color: Colors.grey[700])),
              dropdownStyleData: DropdownStyleData(
                  maxHeight: 200,
                  width: MediaQuery.of(context).size.width / 1.65,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8), color: Colors.white)),
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
      body: Column(
        children: [
          if (currentFollowUpDay != 'cnr') _buildMainButtonGroup(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: selectedButtonIndex == 0
                      ? SizedBox.shrink() // Hide the filter container in clockwise view
                      : GestureDetector(
                    onTap: () async {
                      final inquiryProvider = Provider.of<UserProvider>(context, listen: false);
                      final Map<String, String> stageCounts = inquiryProvider.fullStageCountFollowup;

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
                      filteredOptions.addAll(categoryTitles.map((title) => Categorymodel(
                          title, int.tryParse(stageCounts[title] ?? "0") ?? 0)));

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
                          if (selectedCategory.title == "All") {
                            currentStage = "";
                          }
                        });

                        if (selectedCategory.title != "All") {
                          final stage = getInquiryStageFromCategory(selectedCategory.title);
                          if (stage != null) await filterLeadsByStage(stage);
                        } else {
                          await loadAllInquiriesFollowup();
                        }
                      }
                    },
                    child: Container(
                      height: 44,
                      padding: EdgeInsets.symmetric(horizontal: 26.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: Colors.deepPurple.shade100,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(selectedList, style: TextStyle(fontFamily: "poppins_thin", fontSize: 15)),
                          Row(
                            children: [
                              Icon(Icons.group, color: Colors.black, size: 19),
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
                  padding: const EdgeInsets.only(left: 8.0),
                  child: PopupMenuButton<int>(
                    color: Colors.white,
                    offset: Offset(0, 12),
                    position: PopupMenuPosition.under,
                    onSelected: (int value) {
                      setState(() {
                        selectedButtonIndex = value;
                      });
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                      PopupMenuItem<int>(
                        value: 0,
                        child: Row(
                          children: [
                            Icon(Icons.access_time, color: Colors.black, size: 18),
                            SizedBox(width: 8),
                            Text('clock view', style: TextStyle(fontFamily: "poppins_thin", fontSize: 11.5)),
                          ],
                        ),
                      ),
                      PopupMenuItem<int>(
                        value: 1,
                        child: Row(
                          children: [
                            Icon(Icons.list, color: Colors.black, size: 18),
                            SizedBox(width: 8),
                            Text('list view', style: TextStyle(fontFamily: "poppins_thin", fontSize: 11.5)),
                          ],
                        ),
                      ),
                      PopupMenuItem<int>(
                        value: 2,
                        child: Row(
                          children: [
                            Icon(Icons.grid_view, color: Colors.black, size: 18),
                            SizedBox(width: 8),
                            Text('stages view', style: TextStyle(fontFamily: "poppins_thin", fontSize: 11.5)),
                          ],
                        ),
                      ),
                    ],
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 9, vertical: 9),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade100,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Icon(
                        selectedButtonIndex == 0
                            ? Icons.access_time
                            : selectedButtonIndex == 1
                            ? Icons.list
                            : Icons.grid_view,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
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
              color: Colors.deepPurple.shade700,
              onRefresh: () async {
                try {
                  // Reset filters and reload data
                  resetFilters();
                  await loadAllInquiriesFollowup();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Failed to refresh inquiries: $e", style: TextStyle(fontFamily: 'poppins_thin')),
                      backgroundColor: Colors.red.shade400,
                    ),
                  );
                }
              },
              child: Builder(
                builder: (context) {
                  if (inquiryProvider.isLoadingFollowup && inquiryProvider.inquiriesFollowup.isEmpty) {
                    return ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 160,
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (filteredLeads.isEmpty) {
                    return SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(), // Ensures pull-to-refresh works even with no data
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height - 200, // Adjust height to fill scrollable area
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Lottie.asset('asset/Inquiry_module/no_result.json',
                                  fit: BoxFit.contain, width: 300, height: 300),
                            ),
                            Center(
                              child: Text(
                                "No follow-up inquiries found",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 20,
                                  fontFamily: "poppins_thin",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    if (selectedCards.length != filteredLeads.length) {
                      selectedCards = List<bool>.filled(filteredLeads.length, false);
                    }

                    String getTimeSlot(String dateTimeString) {
                      try {
                        DateTime dateTime = DateTime.parse(dateTimeString);
                        int hour = dateTime.hour;
                        String period = dateTime.hour >= 12 ? 'PM' : 'AM';
                        int displayHour = hour % 12;
                        if (displayHour == 0) displayHour = 12;

                        String startTime = '$displayHour:00 $period';
                        int nextHour = (hour + 1) % 24;
                        String nextPeriod = nextHour >= 12 ? 'PM' : 'AM';
                        int displayNextHour = nextHour % 12;
                        if (displayNextHour == 0) displayNextHour = 12;
                        String endTime = '$displayNextHour:00 $nextPeriod';

                        return '$startTime to $endTime';
                      } catch (e) {
                        return 'Unknown Time Slot';
                      }
                    }

                    Map<String, List<InquiryFollowup>> groupInquiriesByTimeSlot(List<InquiryFollowup> inquiries) {
                      Map<String, List<InquiryFollowup>> groupedInquiries = {};
                      for (var inquiry in inquiries) {
                        String timeSlot = getTimeSlot(inquiry.nextFollowUp);
                        if (!groupedInquiries.containsKey(timeSlot)) {
                          groupedInquiries[timeSlot] = [];
                        }
                        groupedInquiries[timeSlot]!.add(inquiry);
                      }
                      return groupedInquiries;
                    }

                    Map<String, List<InquiryFollowup>> groupInquiriesByStage(List<InquiryFollowup> inquiries) {
                      Map<String, List<InquiryFollowup>> groupedInquiries = {};
                      for (var inquiry in inquiries) {
                        String stage = inquiry.inquiryStages ?? "1"; // Fallback to "1" if null
                        if (!groupedInquiries.containsKey(stage)) {
                          groupedInquiries[stage] = [];
                        }
                        groupedInquiries[stage]!.add(inquiry);
                      }
                      return groupedInquiries;
                    }

                    if (selectedButtonIndex == 0) {
                      Map<String, List<InquiryFollowup>> groupedInquiries = groupInquiriesByTimeSlot(filteredLeads);
                      List<String> sortedTimeSlots = groupedInquiries.keys.toList();
                      sortedTimeSlots.sort((a, b) {
                        try {
                          String startTimeA = a.split(' to ')[0];
                          String startTimeB = b.split(' to ')[0];
                          DateTime timeA = DateFormat('hh:mm a').parse(startTimeA);
                          DateTime timeB = DateFormat('hh:mm a').parse(startTimeB);
                          return timeA.compareTo(timeB);
                        } catch (e) {
                          return 0;
                        }
                      });

                      return ListView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
                        controller: _scrollController,
                        itemCount: sortedTimeSlots.length + (inquiryProvider.isLoadingFollowup ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index < sortedTimeSlots.length) {
                            String timeSlot = sortedTimeSlots[index];
                            List<InquiryFollowup> inquiriesInSlot = groupedInquiries[timeSlot]!;

                            DateTime currentTime = DateTime.now();
                            String startTimeStr = timeSlot.split(' to ')[0];
                            String endTimeStr = timeSlot.split(' to ')[1];
                            DateTime startTime = DateFormat('hh:mm a').parse(startTimeStr);
                            DateTime endTime = DateFormat('hh:mm a').parse(endTimeStr);

                            startTime = DateTime(
                              currentTime.year,
                              currentTime.month,
                              currentTime.day,
                              startTime.hour,
                              startTime.minute,
                            );
                            endTime = DateTime(
                              currentTime.year,
                              currentTime.month,
                              currentTime.day,
                              endTime.hour,
                              endTime.minute,
                            );

                            if (endTime.hour < 12 && startTime.hour >= 12) {
                              endTime = endTime.add(Duration(days: 1));
                            }

                            Color headerColor;
                            if (currentTime.isAfter(endTime)) {
                              headerColor = Colors.red.shade400;
                            } else if (currentTime.isAfter(startTime) && currentTime.isBefore(endTime)) {
                              headerColor = Colors.amber.shade600;
                            } else {
                              headerColor = Colors.green.shade400;
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: headerColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        timeSlot,
                                        style: TextStyle(
                                          fontFamily: "poppins_thin",
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                      CircleAvatar(
                                        radius: 12,
                                        backgroundColor: Colors.white,
                                        child: Text(
                                          inquiriesInSlot.length.toString(),
                                          style: TextStyle(
                                            fontFamily: "poppins_thin",
                                            fontSize: 11,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ...inquiriesInSlot.asMap().entries.map((entry) {
                                  int inquiryIndex = filteredLeads.indexOf(entry.value);
                                  InquiryFollowup inquiry = entry.value;

                                  return StatefulBuilder(
                                    builder: (context, setState) {
                                      return clockWiseCard(
                                        id: inquiry.id,
                                        name: inquiry.fullName,
                                        username: inquiry.assignId,
                                        followUpDate: inquiry.createdAt,
                                        nextFollowUpDate: inquiry.nextFollowUp,
                                        inquiryType: inquiry.inquiryType,
                                        intArea: inquiry.interestedArea,
                                        purposeBuy: inquiry.purposeBuy,
                                        isSelected: selectedCards[inquiryIndex],
                                        onSelect: () => toggleSelection(inquiryIndex),
                                        data: inquiry,
                                        // ontap: () {
                                        //   Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //       builder: (context) => LeadDetailFollowupScreen(InquiryInfoList: inquiry),
                                        //     ),
                                        //   );
                                        // },
                                        ontap: () async {
                                          final result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => LeadDetailFollowupScreen(InquiryInfoList: inquiry),
                                            ),
                                          );

                                          // Check if the result indicates a need to refresh
                                          if (result == true) {
                                            await loadAllInquiriesFollowup();
                                          }
                                        },
                                      );
                                    },
                                  );
                                }).toList(),
                              ],
                            );
                          }
                          if (inquiryProvider.isLoadingFollowup) {
                            return Center(
                              child: Lottie.asset('asset/loader.json', fit: BoxFit.contain, width: 60, height: 60),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      );
                    } else if (selectedButtonIndex == 1) {
                      return ListView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
                        controller: _scrollController,
                        itemCount: filteredLeads.length + (inquiryProvider.isLoadingFollowup ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index < filteredLeads.length) {
                            InquiryFollowup inquiry = filteredLeads[index];

                            String daySkip = "0";
                            String hourSkip = "0";
                            try {
                              DateTime followUpDateTime = DateTime.parse(inquiry.nextFollowUp);
                              DateTime now = DateTime.now();
                              Duration difference = followUpDateTime.difference(now);
                              daySkip = difference.inDays.toString();
                              hourSkip = (difference.inHours % 24).toString();
                            } catch (e) {
                              daySkip = "0";
                              hourSkip = "0";
                            }

                            String label = getInquiryStageText(currentStage ?? "1");

                            return StatefulBuilder(
                              builder: (context, setState) {
                                return TestCardFollowup(
                                  id: inquiry.id,
                                  name: inquiry.fullName,
                                  username: inquiry.assignId,
                                  label: label,
                                  followUpDate: inquiry.createdAt,
                                  nextFollowUpDate: inquiry.nextFollowUp,
                                  inquiryType: inquiry.inquiryType,
                                  intArea: inquiry.interestedArea,
                                  purposeBuy: inquiry.purposeBuy,
                                  daySkip: daySkip,
                                  hourSkip: hourSkip,
                                  source: inquiry.inquirySourceType,
                                  isSelected: selectedCards[index],
                                  onSelect: () => toggleSelection(index),
                                  callList: callList,
                                  nextFollowupcontroller: nextFollowupcontroller,
                                  selectedcallFilter: selectedcallFilter,
                                  data: inquiry,
                                  isTiming: true,
                                  inquiryImage: const AssetImage("asset/out time.png"),
                                  visitImage: const AssetImage("asset/out time.png"),
                                  bookingImage: const AssetImage("asset/out time.png"),
                                  eyseImage: const AssetImage("asset/out time.png"),
                                  ontap: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LeadDetailFollowupScreen(InquiryInfoList: inquiry),
                                      ),
                                    );
                                    if (result == true) {
                                      await loadAllInquiriesFollowup();
                                    }
                                  },
                                  onRefresh: () async {
                                    await loadAllInquiriesFollowup();
                                  }, // Pass the refresh callback
                                );
                              },
                            );
                          }
                          if (inquiryProvider.isLoadingFollowup) {
                            return Center(
                              child: Lottie.asset('asset/loader.json', fit: BoxFit.contain, width: 60, height: 60),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      );
                    } else {
                      Map<String, List<InquiryFollowup>> groupedInquiries = groupInquiriesByStage(filteredLeads);
                      List<String> sortedStages = groupedInquiries.keys.toList();
                      sortedStages.sort();

                      return ListView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
                        controller: _scrollController,
                        itemCount: sortedStages.length + (inquiryProvider.isLoadingFollowup ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index < sortedStages.length) {
                            String stage = sortedStages[index];
                            List<InquiryFollowup> inquiriesInStage = groupedInquiries[stage]!;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: getLabelColor(stage),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        getInquiryStageText(stage),
                                        style: TextStyle(
                                          fontFamily: "poppins_thin",
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                      CircleAvatar(
                                        radius: 12,
                                        backgroundColor: Colors.white,
                                        child: Text(
                                          inquiriesInStage.length.toString(),
                                          style: TextStyle(
                                            fontFamily: "poppins_thin",
                                            fontSize: 11,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ...inquiriesInStage.asMap().entries.map((entry) {
                                  int inquiryIndex = filteredLeads.indexOf(entry.value);
                                  InquiryFollowup inquiry = entry.value;

                                  return StatefulBuilder(
                                    builder: (context, setState) {
                                      return listWiseCard(
                                        id: inquiry.id,
                                        name: inquiry.fullName,
                                        username: inquiry.assignId,
                                        followUpDate: inquiry.createdAt,
                                        nextFollowUpDate: inquiry.nextFollowUp,
                                        inquiryType: inquiry.inquiryType,
                                        intArea: inquiry.interestedArea,
                                        purposeBuy: inquiry.purposeBuy,
                                        isSelected: selectedCards[inquiryIndex],
                                        onSelect: () => toggleSelection(inquiryIndex),
                                        data: inquiry,
                                        ontap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => LeadDetailFollowupScreen(InquiryInfoList: inquiry),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  );
                                }).toList(),
                              ],
                            );
                          }
                          if (inquiryProvider.isLoadingFollowup) {
                            return Center(
                              child: Lottie.asset('asset/loader.json', fit: BoxFit.contain, width: 60, height: 60),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      );
                    }
                  }
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: anySelected
          ? CircleAvatar(
        backgroundColor: AppColor.MainColor,
        radius: 28,
        child: GestureDetector(
          onTap: () async {
            List<String> actionValues = actionList.map((action) => action['value']!).toList();
            List<String> employeeNames = employeeList.map((e) => e['name']!).toList();
            showActionDialog(context, anySelected, handleAction, actionValues, employeeNames);
          },
          child: Image(
            image: AssetImage("asset/fast-forward.png"),
            height: 23,
            color: Colors.white,
            width: 23,
          ),
        ),
      )
          : null,
    );
  }

  // Widget _buildIconButton({
  //   required int index,
  //   required IconData icon,
  //   required String label,
  //   required VoidCallback onTap,
  // }) {
  //   final bool isSelected = selectedButtonIndex == index;
  //   return GestureDetector(
  //     onTap: onTap,
  //     child: Container(
  //       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  //       decoration: BoxDecoration(
  //         color: isSelected ? Colors.deepPurple.shade300 : Colors.deepPurple.shade100,
  //         borderRadius: BorderRadius.circular(18),
  //       ),
  //       child: Icon(
  //         icon,
  //         color: isSelected ? Colors.white : Colors.black,
  //         size: 20,
  //       ),
  //     ),
  //   );
  // }

  Widget _buildMainButtonGroup() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildMainButton("Live", 1),
            _buildMainButton("Due", 5),
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
          side: const BorderSide(color: Color(0xff8d47c1)),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        ),
        onPressed: () async {
          await filterLeadsByStatus(status);
        },
        child: Text(
          text,
          style: TextStyle(fontSize: 12, fontFamily: "poppins_thin"),
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

Color getLabelColor(String? stage) {
  switch (stage) {
    case "1":
      return const Color(0xff33b5e5);
    case "2":
      return const Color(0xff4da8ff);
    case "3":
      return const Color(0xff3d70b2);
    case "4":
      return const Color(0xff4da8ff);
    case "6":
      return const Color(0xffc966c3);
    case "9":
      return const Color(0xff66d977);
    case "10":
      return const Color(0xff3d6ca3);
    case "11":
      return const Color(0xfff1ba71);
    case "12":
      return const Color(0xff73e0b3);
    default:
      return Colors.grey.shade300;
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
        backgroundColor: AppColor.MainColor,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios, color: Colors.white)),
        title: Text("Choose Stage",
            style: TextStyle(
                fontFamily: "poppins_thin", color: Colors.white, fontSize: 17)),
      ),
      body: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: widget.optionList.length,
        itemBuilder: (context, index) {
          bool isSelected = selectedIndex == index;
          bool isDisabled = widget.optionList[index].leads == 0;
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Card(
              elevation: isSelected ? 6 : 4,
              color: isDisabled
                  ? Colors.grey.shade200
                  : isSelected
                  ? Colors.deepPurple.shade100
                  : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
              child: ListTile(
                title: Text(
                  widget.optionList[index].title,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDisabled
                        ? Colors.grey.shade600
                        : isSelected
                        ? Colors.deepPurple
                        : Colors.black,
                    fontFamily: isSelected ? "poppins_thin" : "poppins_light",
                    fontWeight: FontWeight.w600,
                  ),
                ),
                leading: CircleAvatar(
                  backgroundColor: isDisabled
                      ? Colors.grey.shade400
                      : isSelected
                      ? Colors.deepPurple.shade300
                      : Colors.grey.shade200,
                  child: Text(
                    widget.optionList[index].title[0],
                    style: TextStyle(
                        color: isDisabled
                            ? Colors.grey.shade600
                            : isSelected
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.group,
                        color: isDisabled
                            ? Colors.grey.shade600
                            : isSelected
                            ? Colors.deepPurple
                            : Colors.black),
                    SizedBox(width: 8.0),
                    Text(widget.optionList[index].leads.toString(),
                        style: TextStyle(
                            color: isDisabled
                                ? Colors.grey.shade600
                                : isSelected
                                ? Colors.deepPurple
                                : Colors.black)),
                  ],
                ),
                onTap: isDisabled
                    ? null
                    : () {
                  setState(() => selectedIndex = index);
                  Navigator.pop(context, {
                    "selectedIndex": selectedIndex,
                    "selectedCategory": widget.optionList[index]
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
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../Provider/UserProvider.dart';
import '../../Model/Api Model/allInquiryModel.dart';
import '../../Model/category_Model.dart';
import '../../Utils/Colors/app_Colors.dart';
import '../../Utils/Custom widgets/add_lead_Screen.dart';
import '../../Utils/Custom widgets/pending_Card.dart';

class ShiftsList extends StatefulWidget {
  const ShiftsList({Key? key});

  @override
  State<ShiftsList> createState() => _ShiftsListState();
}

class _ShiftsListState extends State<ShiftsList> {
  String selectedList = "All";
  String selectedValue = "0";
  int? selectedIndex = 0;

  List<Map<String, String>> actionList = []; // Stores key-value pairs for actions
  List<Map<String, String>> employeeList = []; // Stores key-value pairs for employees
  String? selectedAction; // Stores selected action value
  String? selectedEmployee; //

  String? getStageValue(String stageTitle) {
    const stageMap = {
      "Fresh": "1",
      "Contacted": "2",
      "Appointment": "3",
      "Negotiation": "4",
      "Visited": "5",
      "Feedback": "6",
      "Re_Appointment": "7",
      "reVisited": "8",
      "Converted": "9"
    };
    return stageMap[stageTitle];
  }

  List<CategoryModel> categoryList = [];
  List<Inquiry> filteredLeads = [];
  List<bool> selectedCards = [];
  bool anySelected = false;

  late ScrollController _scrollController;


  bool isStatusFilterActive = false;
  String? currentStage;
  int currentStatus = 1;
  String selectedMainFilter = "Live";
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


  @override
  void initState() {
    super.initState();

    // Load data in background first

    // Then schedule loadAllInquiries after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadAllInquiries();
      loadData();

    });

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  Future<void> loadAllInquiries() async {
    final inquiryProvider = Provider.of<UserProvider>(context, listen: false);
    await inquiryProvider.fetchInquiries(status: currentStatus, stages: '');
    setState(() {
      filteredLeads = inquiryProvider.inquiries;
      isStatusFilterActive = currentStatus != 0;
      selectedMainFilter = "Live";
      selectedValue = inquiryProvider.stageCounts["Total_Sum"]?.toString() ?? "0";
      selectedList = "All";
      selectedIndex = 0;
    });
  }

  void _onScroll() {
    final inquiryProvider = Provider.of<UserProvider>(context, listen: false);
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300 &&
        !inquiryProvider.isLoading &&
        inquiryProvider.hasMore) {
      inquiryProvider
          .fetchInquiries(
        isLoadMore: true,
        status: currentStatus,
        stages: currentStage ?? '',
      )
          .then((_) {
        setState(() {
          filteredLeads = inquiryProvider.inquiries;
        });
      });
    }
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
    await inquiryProvider.fetchInquiries(status: status, stages: '');
    setState(() {
      filteredLeads = inquiryProvider.inquiries;
      selectedList = "All";
      selectedValue = inquiryProvider.stageCounts["Total_Sum"]?.toString() ?? "0";
      selectedIndex = 0;
      isStatusFilterActive = true;
      selectedMainFilter = status == 1 ? "Live" : "Due";
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
      case "Negotiation":
        return "6";
      case "Feedback":
        return "9";
      case "Re_Appointment":
        return "10";
      case "reVisited":
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
      print("anySelected: $anySelected");
    });
  }


  Future<void> filterLeadsByStage(String stage) async {
    final inquiryProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() {
      currentStage = stage;
    });
    await inquiryProvider.fetchInquiries(
      status: currentStatus,
      stages: stage,
    );
    setState(() {
      filteredLeads = inquiryProvider.inquiries;
      selectedList = getInquiryStageText(stage);
      selectedValue = inquiryProvider.stageCounts[selectedList]?.toString() ?? "0";
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
  String? filteredId;
  String? filteredName;
  String? filteredPhone;
  List<String> filteredStatus = [];
  bool _isDialogLoading = false;
  bool _isSubmitting = false;

  void _updateSearchResults(List<Inquiry> results) {
    setState(() {
      filteredLeads = results;
    });
  }

  void resetFilters() {
    final inquiryProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() {
      filteredLeads = List.from(inquiryProvider.inquiries);
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
      filteredId =
      (filters['Id'] != null && filters['Id'].toString().isNotEmpty)
          ? filters['Id']
          : null;
      filteredName =
      (filters['Name'] != null && filters['Name'].toString().isNotEmpty)
          ? filters['Name']
          : null;
      filteredPhone =
      (filters['Mobile'] != null && filters['Mobile'].toString().isNotEmpty)
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
      List<String> employeeNames,
      ) {
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
                  fontWeight: FontWeight.w600,
                ),
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
                      onChanged: (value) {
                        dialogSetState(() {
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
                        dialogSetState(() {
                          dialogSelectedEmployee = value;
                        });
                      },
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
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          fontFamily: "poppins_thin",
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: isSubmitting
                          ? null
                          : () async {
                        if (dialogSelectedAction == null || dialogSelectedEmployee == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Please select both action and employee",
                                style: TextStyle(fontFamily: 'poppins_thin'),
                              ),
                            ),
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
                            SnackBar(
                              content: Text(
                                "No inquiries selected",
                                style: TextStyle(fontFamily: 'poppins_thin'),
                              ),
                            ),
                          );
                          return;
                        }

                        // Get the action key and employee ID
                        String actionKey = actionList
                            .firstWhere(
                                (action) => action['value'] == dialogSelectedAction,
                            orElse: () => {'key': ''})['key'] ??
                            '';
                        String employeeId = employeeList
                            .firstWhere(
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
                              content: Text(
                                "Inquiries transferred successfully",
                                style: TextStyle(fontFamily: 'poppins_thin'),
                              ),
                            ),
                          );
                          setState(() {
                            selectedCards = List<bool>.filled(filteredLeads.length, false);
                            anySelected = false;
                          });
                          Navigator.of(dialogContext).pop();
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Failed to transfer inquiries: $e",
                                style: TextStyle(fontFamily: 'poppins_thin'),
                              ),
                            ),
                          );
                        } finally {
                          dialogSetState(() => isSubmitting = false);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple.shade100,
                        foregroundColor: Colors.deepPurple.shade700,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        minimumSize: Size(100, 0),
                      ),
                      child: isSubmitting
                          ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.deepPurple.shade700,
                          strokeWidth: 2,
                        ),
                      )
                          : Text(
                        'Submit',
                        style: TextStyle(
                          fontFamily: 'poppins_thin',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
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
        Text(
          label,
          style: TextStyle(
            fontFamily: 'poppins_thin',
            color: Colors.grey[800],
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
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
              hint: Text(
                hint,
                style: TextStyle(
                  fontFamily: 'poppins_thin',
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              value: value,
              onChanged: items.isEmpty ? null : onChanged,
              items: items.map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: TextStyle(
                    fontFamily: 'poppins_thin',
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                  ),
                ),
              )).toList(),
              buttonStyleData: const ButtonStyleData(
                height: 40,
                width: double.infinity,
              ),
              iconStyleData: IconStyleData(
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey[700],
                ),
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: 200,
                width: MediaQuery.of(context).size.width / 1.65,
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
      backgroundColor: Colors.white,
      body: Column(
      children: [

        _buildMainButtonGroup(),
        GestureDetector(
          onTap: () async {
            final inquiryProvider = Provider.of<UserProvider>(context, listen: false);
            final Map<String, int> stageCounts = inquiryProvider.stageCounts;

            List<Categorymodel> filteredOptions = [
              Categorymodel("All", stageCounts["Total_Sum"] ?? 0),
            ];
            List<String> categoryTitles = [
              "Fresh",
              "Contacted",
              "Appointment",
              "Negotiation",
              "Visited",
              "Feedback",
              "Re_Appointment",
              "reVisited",
              "Converted"
            ];
            if ([
              "Live",
              "Dismiss",
              "Dismissed Request",
              "Conversion Request",
              "Due Appo",
              "CNR"
            ].contains(selectedMainFilter)) {
              filteredOptions.addAll(categoryTitles.map(
                      (title) => Categorymodel(title, stageCounts[title] ?? 0)));
            }

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
                await inquiryProvider.fetchInquiries(status: currentStatus, stages: '');
                setState(() {
                  filteredLeads = inquiryProvider.inquiries;
                  selectedValue = inquiryProvider.stageCounts["Total_Sum"]?.toString() ?? "0";
                });
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              height: 52,
              padding: EdgeInsets.symmetric(horizontal: 26.0, vertical: 8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.deepPurple.shade100,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedList,
                    style: TextStyle(fontFamily: "poppins_thin", fontSize: 16),
                  ),
                  Row(
                    children: [
                      Icon(Icons.group, color: Colors.black),
                      SizedBox(width: 8.0),
                      Text(
                        selectedValue,
                        style: TextStyle(fontFamily: "poppins_thin"),
                      ),
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
            onRefresh: () async => await loadAllInquiries(),
            child: Builder(
              builder: (context) {
                if (inquiryProvider.isLoading && inquiryProvider.inquiries.isEmpty) {
                  return ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 160,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (filteredLeads.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Lottie.asset(
                          'asset/Inquiry_module/no_result.json',
                          fit: BoxFit.contain,
                          width: 300,
                          height: 300,
                        ),
                      ),
                      Center(
                        child: Text(
                          "No results found",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 22,
                            fontFamily: "poppins_thin",
                          ),
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
                    itemBuilder: (context, index) {
                      if (index < filteredLeads.length) {
                        Inquiry inquiry = filteredLeads[index];
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return GestureDetector(
                              onLongPress: () => toggleSelection(index),
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => LeaddetailScreen(
                                //       InquiryInfoList: inquiry,
                                //     ),
                                //   ),
                                // );
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
                      }
                      if (inquiryProvider.isLoading) {
                        return Center(
                          child: Lottie.asset(
                            'asset/loader.json',
                            fit: BoxFit.contain,
                            width: 60,
                            height: 60,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
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
              builder: (context) => AddLeadScreen(isEdit: false),
            ),
          );
        },
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
            _buildMainButton("Live"),
            _buildMainButton("Due"),
            // _buildMainButton("Dismissed Request"),
            // _buildMainButton("Conversion Request"),
            // _buildMainButton("Due Appo"),
            // _buildMainButton("CNR"),
          ],
        ),
      ),
    );
  }

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
        return "Appointment";
      case "4":
        return "Visited";
      case "6":
        return "Negotiation";
      case "9":
        return "Feedback";
      case "10":
        return "Re_Appointment";
      case "11":
        return "reVisited";
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
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: Text(
          "Choose Stage",
          style: TextStyle(
              fontFamily: "poppins_thin", color: Colors.white, fontSize: 18),
        ),
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
              color: isDisabled
                  ? Colors.grey.shade200 // Light grey for disabled items
                  : isSelected
                  ? Colors.deepPurple.shade100
                  : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              child: ListTile(
                title: Text(
                  widget.optionList[index].title,
                  style: TextStyle(
                    color: isDisabled
                        ? Colors.grey.shade600 // Lighter text for disabled
                        : isSelected
                        ? Colors.deepPurple
                        : Colors.black,
                    fontFamily: isSelected ? "poppins_thin" : "poppins_light",
                    fontWeight: FontWeight.w600,
                  ),
                ),
                leading: CircleAvatar(
                  backgroundColor: isDisabled
                      ? Colors.grey.shade400 // Lighter avatar for disabled
                      : isSelected
                      ? Colors.deepPurple.shade300
                      : Colors.grey.shade200,
                  child: Text(
                    widget.optionList[index].title[0],
                    style: TextStyle(
                      color: isDisabled
                          ? Colors.grey.shade600 // Lighter text for disabled
                          : isSelected
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.group,
                      color: isDisabled
                          ? Colors.grey.shade600 // Lighter icon for disabled
                          : isSelected
                          ? Colors.deepPurple
                          : Colors.black,
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      widget.optionList[index].leads.toString(),
                      style: TextStyle(
                        color: isDisabled
                            ? Colors.grey.shade600 // Lighter text for disabled
                            : isSelected
                            ? Colors.deepPurple
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
                onTap: isDisabled
                    ? null // Disable tap for 0 leads
                    : () {
                  setState(() => selectedIndex = index);
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
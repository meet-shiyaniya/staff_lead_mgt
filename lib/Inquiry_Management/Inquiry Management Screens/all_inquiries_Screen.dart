import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:hr_app/Inquiry_Management/Inquiry%20Management%20Screens/lead_Detail_Screen.dart';
import 'package:hr_app/social_module/colors/colors.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../Provider/UserProvider.dart';
import '../Model/Api Model/allInquiryModel.dart';
import '../Model/category_Model.dart';
import '../Model/followup_Model.dart';
import '../Utils/Colors/app_Colors.dart';
import '../Utils/Custom widgets/add_lead_Screen.dart';
import '../Utils/Custom widgets/custom_buttons.dart';
import '../Utils/Custom widgets/custom_dialog.dart';
import '../Utils/Custom widgets/custom_search.dart';
import '../Utils/Custom widgets/filter_Bottomsheet.dart';
import '../Utils/Custom widgets/pending_Card.dart';
import '../Utils/Custom widgets/search_Screen.dart';
import 'Filters/inquiry_Filter_Screen.dart';
import 'Followup Screen/list_filter_Screen.dart';

class AllInquiriesScreen extends StatefulWidget {
  const AllInquiriesScreen({Key? key});

  @override
  State<AllInquiriesScreen> createState() => _AllInquiriesScreenState();
}

class _AllInquiriesScreenState extends State<AllInquiriesScreen> {
  String selectedList = "All";
  String selectedValue = "0";
  int? selectedIndex;

  List<CategoryModel> categoryList = [];
  List<Inquiry> filteredLeads = [];
  List<bool> selectedCards = [];
  bool anySelected = false;

  late ScrollController _scrollController;
  String? selectedAction = null;
  String? selectedEmployee = null;
  final List<String> actions = ['markAsComplete', 'assignToUser', 'delete'];
  final List<String> employees = ['employee 1', 'employee 2', 'employee 3'];

  bool isStatusFilterActive = false; // Flag to indicate if a status filter is active
  String? currentStage;

  int currentStatus = 1; // Default to 1 (Live) instead of 0

  @override
  void initState() {
    super.initState();
    // Load Live data immediately with status 1
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadAllInquiries();
    });
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  Future<void> loadAllInquiries() async {
    final inquiryProvider = Provider.of<UserProvider>(context, listen: false);
    await inquiryProvider.fetchInquiries(status: currentStatus); // Use currentStatus (default 1 for Live)
    setState(() {
      filteredLeads = _applyStageFilter(inquiryProvider.inquiries);
      selectedValue = filteredLeads.length.toString();
      isStatusFilterActive = currentStatus != 0 || currentStage != null;
      selectedMainFilter = "Live"; // Ensure the UI reflects "Live" as selected
    });
  }

  void _onScroll() {
    final inquiryProvider = Provider.of<UserProvider>(context, listen: false);
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300 && // Reduced threshold
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
      return List.from(inquiries); // Return all if no stage filter
    }
    return inquiries
        .where((inquiry) => inquiry.InqStage == currentStage)
        .toList();
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

  void filterLeads(String category) {}

  Future<void> filterLeadsByStatus(int status) async {
    final inquiryProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() {
      currentStatus = status; // Update the current status
      currentStage = null;
    });
    await inquiryProvider.fetchInquiries(status: status);
    setState(() {
      filteredLeads = _applyStageFilter(inquiryProvider.inquiries);
      selectedValue = filteredLeads.length.toString();
      selectedList = "All";
      isStatusFilterActive = true;
      selectedMainFilter = status == 1 ? "Live" :
      status == 2 ? "Dismiss" :
      status == 3 ? "Dismissed Request" :
      status == 4 ? "Conversion Request" :
      status == 5 ? "Due Appo" :
      "CNR"; // Update selectedMainFilter based on status
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
  }
  void toggleSelection(int index) {
    setState(() {
      selectedCards[index] = !selectedCards[index]; // Simply toggle the current card's state
      anySelected = selectedCards.contains(true);   // Update the anySelected flag
      print("anySelected : $anySelected");
    });
  }

  Future<void> filterLeadsByStage(String stage) async {
    final inquiryProvider = Provider.of<UserProvider>(context, listen: false);
    // Fetch all inquiries for the current status if not already loaded
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
    });
  }

  String? filteredPhone;

  void _updateAppliedFilters(Map<String, dynamic> filters) {
    setState(() {
      appliedFilters = filters;

      filteredId = (filters['Id'] != null && filters['Id'].toString().isNotEmpty)
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

  String? filteredId;
  String? filteredName;
  String? filteredMobile;
  List<String> filteredStatus = [];

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
              )),
          backgroundColor: Colors.deepPurple.shade300,
          actions: [
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
            SizedBox(
              width: 10,
            ),
            CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => inquiryFilterScreen(),));
                    // showBottomModalSheet(context);
                  },
                  icon: Icon(
                    Icons.filter_list_outlined,
                    color: Colors.black,
                  )),
            ),
            SizedBox(
              width: 10,
            )
          ]),
      body: Column(
        children: [
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
                        isExpanded: true, // Prevent full width
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
                        items: actions
                            .map((action) => DropdownMenuItem(
                          value: action,
                          child: Text(action,
                              style:
                              TextStyle(fontFamily: "poppins_thin")),
                        ))
                            .toList(),
                        buttonStyleData: ButtonStyleData(
                          height: 40,
                          padding: const EdgeInsets.only(left: 14, right: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        iconStyleData: const IconStyleData(
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 200,
                          padding: null,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          elevation: 8,
                          offset: const Offset(0, -4),
                          scrollbarTheme: ScrollbarThemeData(
                            radius: const Radius.circular(40),
                            thickness: MaterialStateProperty.all<double>(6),
                            thumbVisibility: MaterialStateProperty.all<bool>(true),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                          padding: EdgeInsets.only(left: 14, right: 14),
                        ),
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
                        isExpanded: true, // Prevent full width
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
                          child: Text(employee,
                              style:
                              TextStyle(fontFamily: "poppins_thin")),
                        ))
                            .toList(),
                        buttonStyleData: ButtonStyleData(
                          height: 40,
                          padding: const EdgeInsets.only(left: 14, right: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        iconStyleData: const IconStyleData(
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 200,
                          padding: null,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          elevation: 8,
                          offset: const Offset(0, -4),
                          scrollbarTheme: ScrollbarThemeData(
                            radius: const Radius.circular(40),
                            thickness: MaterialStateProperty.all<double>(6),
                            thumbVisibility: MaterialStateProperty.all<bool>(true),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                          padding: EdgeInsets.only(left: 14, right: 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
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
          _buildMainButtonGroup(),
          GestureDetector(
            onTap: () async {
              setState(() {
                selectedList = "All";
                selectedValue = "0";
                selectedIndex = 0;
              });

              final inquiryProvider = Provider.of<UserProvider>(context,
                  listen: false);

              final paginatedInquiries = inquiryProvider.paginatedInquiries;

              List<Categorymodel> filteredOptions = [
                Categorymodel("All", paginatedInquiries?.totalRecords ?? 0),
              ];

              // Access stageCounts directly from the provider
              Map<String, int> stageCounts = inquiryProvider.stageCounts;

              if (selectedMainFilter == "Live") {
                filteredOptions.addAll([
                  Categorymodel("Fresh", stageCounts["Fresh"] ?? 0),
                  Categorymodel("Contacted", stageCounts["Contacted"] ?? 0),
                  Categorymodel("Appointment", stageCounts["Appointment"] ?? 0),
                  // Categorymodel("Trial", stageCounts["Visited"] ?? 0),
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
                final selectedCategory =
                result["selectedCategory"] as Categorymodel;
                if (selectedCategory.title != "All") {
                  final stage =
                  getInquiryStageFromCategory(selectedCategory.title);
                  if (stage != null) {
                    await filterLeadsByStage(stage);
                  }
                } else {
                  setState(() {
                    currentStage = null;
                    filteredLeads = inquiryProvider.inquiries
                        .where((inquiry) =>
                    inquiry.InqStatus == currentStatus.toString())
                        .toList();
                    selectedValue = filteredLeads.length.toString();
                    selectedList = "All";
                  });
                }
              }
            },
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
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
                        Text(selectedValue,
                            style: TextStyle(fontFamily: "poppins_thin")),
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
            child: Column(children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    if (filteredId != null && filteredId!.isNotEmpty)
                      FilterChip(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
                        label: Text('ID: $filteredId'),
                        onDeleted: () {
                          setState(() {
                            filteredId = null;
                            appliedFilters.remove('Id');
                            loadAllInquiries(); // Reload all inquiries
                          });
                        },
                        onSelected: (bool value) {},
                      ),
                    SizedBox(
                      width: 5,
                    ),
                    if (filteredName != null && filteredName!.isNotEmpty)
                      FilterChip(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
                        label: Text('Name: $filteredName'),
                        onDeleted: () {
                          setState(() {
                            filteredName = null;
                            appliedFilters.remove('Name');
                            loadAllInquiries(); // Reload all inquiries
                          });
                        },
                        onSelected: (bool value) {},
                      ),
                    SizedBox(
                      width: 5,
                    ),
                    if (filteredPhone != null && filteredPhone!.isNotEmpty)
                      FilterChip(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
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
                    SizedBox(
                      width: 5,
                    ),
                    if (filteredStatus.isNotEmpty)
                      FilterChip(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
                        label: Text('Status: ${filteredStatus.join(', ')}'),
                        onDeleted: () {
                          setState(() {
                            filteredStatus.clear();
                            appliedFilters.remove('Status');
                            loadAllInquiries(); // Reload all inquiries
                          });
                        },
                        onSelected: (bool value) {},
                      ),
                    SizedBox(
                      width: 5,
                    ),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22)),
                  ),
                  child: const Text('Clear All',
                      style: TextStyle(fontFamily: 'poppins_thin', color: Colors.white)),
                ),
            ]),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await loadAllInquiries(); // Reload ALL inquiries on refresh
              },
              child: Builder(
                builder: (context) {
                  if (inquiryProvider.isLoading &&
                      inquiryProvider.inquiries.isEmpty) {
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
                      itemCount: filteredLeads.length +
                          (inquiryProvider.hasMore || inquiryProvider.isLoading
                              ? 1
                              : 0),
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
                                  username: inquiry.mobileno,
                                  label: getInquiryStageText(inquiry.InqStage),
                                  followUpDate: inquiry.createdAt,
                                  nextFollowUpDate: inquiry.nxtfollowup,
                                  inquiryType: inquiry.InqType,
                                  intArea: inquiry.InqArea,
                                  purposeBuy: inquiry.PurposeBuy,
                                  daySkip: inquiry.dayskip,
                                  hourSkip: inquiry.hourskip,
                                  source: inquiry.mobileno,
                                  isSelected: selectedCards[index],
                                  onSelect: () {
                                    toggleSelection(index);
                                  },
                                  callList: callList,
                                  selectedcallFilter: selectedcallFilter,
                                  data: inquiry,
                                  isTiming: true,
                                  nextFollowupcontroller:
                                  nextFollowupcontroller,
                                ),
                              );
                            },
                          );
                        } else {
                          return inquiryProvider.isLoading
                              ? Center(
                              child: Lottie.asset('asset/loader.json',
                                  fit: BoxFit.contain,
                                  width: 100,
                                  height: 100))
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
                  backgroundColor: isSelected
                      ? Colors.deepPurple.shade300
                      : Colors.grey.shade200,
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
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:hr_app/Inquiry_Management/Model/Api%20Model/followup_Cnr_Model.dart'; // Adjust path as needed
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../Provider/UserProvider.dart';
import '../../Model/category_Model.dart';
import '../../Utils/Colors/app_Colors.dart';
import '../../Utils/Custom widgets/add_lead_Screen.dart';
import '../../Utils/Custom widgets/booking_Screen.dart';
import '../../Utils/Custom widgets/inquiry_transfer_Screen.dart';

class CnrScreen extends StatefulWidget {
  const CnrScreen({Key? key}) : super(key: key);

  @override
  State<CnrScreen> createState() => _CnrScreenState();
}

class _CnrScreenState extends State<CnrScreen> {
  String selectedList = "All";
  String selectedValue = "0";
  int? selectedIndex = 0;
  final int currentStatus = 1; // Fixed to Live status (1) as per your design
  String? currentStage;

  List<FollowupInquiry> filteredLeads = [];
  List<bool> selectedCards = [];
  bool anySelected = false;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    final inquiryProvider = Provider.of<UserProvider>(context, listen: false);
    await inquiryProvider.fetchFollowupCnrInquiry(
      followupDay: "cnr",
      status: currentStatus,
      stages: '',
    );
    setState(() {
      filteredLeads = inquiryProvider.followupInquiries;
      selectedValue = inquiryProvider.stageCounts["Total_Sum"]?.toString() ?? "0";
      selectedCards = List<bool>.filled(filteredLeads.length, false);
    });
  }

  void _onScroll() {
    final inquiryProvider = Provider.of<UserProvider>(context, listen: false);
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300 &&
        !inquiryProvider.isLoading &&
        inquiryProvider.hasMore) {
      inquiryProvider.fetchFollowupCnrInquiry(
        followupDay: "cnr",
        isLoadMore: true,
        status: currentStatus,
        stages: currentStage ?? '',
      ).then((_) {
        setState(() {
          filteredLeads = inquiryProvider.followupInquiries;
          selectedCards = List<bool>.filled(filteredLeads.length, false);
        });
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _filterByStage(String stage) async {
    final inquiryProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() {
      currentStage = stage;
      selectedList = getInquiryStageText(stage);
    });
    await inquiryProvider.fetchFollowupCnrInquiry(
      followupDay: "cnr",
      status: currentStatus,
      stages: stage,
    );
    setState(() {
      filteredLeads = inquiryProvider.followupInquiries;
      selectedValue = inquiryProvider.stageCounts[selectedList]?.toString() ?? "0";
      selectedCards = List<bool>.filled(filteredLeads.length, false);
    });
  }

  void _toggleSelection(int index) {
    setState(() {
      selectedCards[index] = !selectedCards[index];
      anySelected = selectedCards.contains(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final inquiryProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildStageSelector(inquiryProvider),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadInitialData,
              child: _buildInquiryList(inquiryProvider),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddLeadScreen(isEdit: false)),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.deepPurple.shade400,
      ),
    );
  }

  Widget _buildStageSelector(UserProvider inquiryProvider) {
    return GestureDetector(
      onTap: () async {
        final stageCounts = inquiryProvider.stageCounts;
        final options = [
          Categorymodel("All", stageCounts["Total_Sum"] ?? 0),
          Categorymodel("Fresh", stageCounts["Fresh"] ?? 0),
          Categorymodel("Contacted", stageCounts["Contacted"] ?? 0),
          Categorymodel("Appointment", stageCounts["Appointment"] ?? 0),
          Categorymodel("Visited", stageCounts["Visited"] ?? 0),
          Categorymodel("Negotiation", stageCounts["Negotiation"] ?? 0),
          Categorymodel("Feedback", stageCounts["Feedback"] ?? 0),
          Categorymodel("Re_Appointment", stageCounts["Re_Appointment"] ?? 0),
          Categorymodel("Re_Visited", stageCounts["Re_Visited"] ?? 0), // Match provider key
          Categorymodel("Converted", stageCounts["Converted"] ?? 0),
        ];

        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ListSelectionscreen(
              initialSelectedIndex: selectedIndex ?? 0,
              optionList: options,
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
            final stage = _getStageValue(selectedCategory.title);
            if (stage != null) await _filterByStage(stage);
          } else {
            await _loadInitialData();
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 8.0),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.deepPurple.shade100),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(selectedList, style: const TextStyle(fontFamily: "poppins_thin", fontSize: 16)),
              Row(
                children: [
                  const Icon(Icons.group, color: Colors.black),
                  const SizedBox(width: 8.0),
                  Text(selectedValue, style: const TextStyle(fontFamily: "poppins_thin")),
                  const Icon(Icons.arrow_drop_down, color: Colors.black),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInquiryList(UserProvider inquiryProvider) {
    if (inquiryProvider.isLoading && filteredLeads.isEmpty) {
      return ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) => Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 160,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
      );
    } else if (filteredLeads.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('asset/Inquiry_module/no_result.json', width: 300, height: 300),
            const Text("No results found",
                style: TextStyle(color: Colors.red, fontSize: 22, fontFamily: "poppins_thin")),
          ],
        ),
      );
    } else {
      return ListView.builder(
        controller: _scrollController,
        itemCount: filteredLeads.length + (inquiryProvider.isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < filteredLeads.length) {
            final inquiry = filteredLeads[index];
            return TestCard(
              id: inquiry.id,
              name: inquiry.fullName ?? '',
              username: inquiry.assignId,
              label: getInquiryStageText(inquiry.inquiryStages),
              followUpDate: inquiry.createdAt,
              nextFollowUpDate: inquiry.nextFollowUp,
              inquiryType: inquiry.inquiryType,
              intArea: inquiry.area ?? '',
              purposeBuy: inquiry.purposeBuy ?? '',
              daySkip: inquiry.daySkip,
              hourSkip: inquiry.hourSkip,
              source: inquiry.inquirySourceType,
              isSelected: selectedCards[index],
              onSelect: () => _toggleSelection(index),
              callList: const ["Followup", "Dismissed", "Appointment", "Cnr"],
              nextFollowupcontroller: TextEditingController(),
              selectedcallFilter: "Followup",
              data: inquiry,
              isTiming: true,
            );
          }
          return inquiryProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : const SizedBox.shrink();
        },
      );
    }
  }

  String? _getStageValue(String stageTitle) {
    const stageMap = {
      "Fresh": "1",
      "Contacted": "2",
      "Appointment": "3",
      "Visited": "4",
      "Negotiation": "6",
      "Feedback": "9",
      "Re_Appointment": "10",
      "Re_Visited": "11", // Match provider key
      "Converted": "12",
    };
    return stageMap[stageTitle];
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
      case "5":
        return "Pending";
      case "6":
        return "Negotiation";
      case "9":
        return "Feedback";
      case "10":
        return "Re_Appointment";
      case "11":
        return "Re_Visited"; // Match provider key
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

  const ListSelectionscreen({
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
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: const Text(
          "Choose Stage",
          style: TextStyle(fontFamily: "poppins_thin", color: Colors.white, fontSize: 18),
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
                  ? Colors.grey.shade200
                  : isSelected
                  ? Colors.deepPurple.shade100
                  : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
              child: ListTile(
                title: Text(
                  widget.optionList[index].title,
                  style: TextStyle(
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
                          ? Colors.grey.shade600
                          : isSelected
                          ? Colors.deepPurple
                          : Colors.black,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      widget.optionList[index].leads.toString(),
                      style: TextStyle(
                        color: isDisabled
                            ? Colors.grey.shade600
                            : isSelected
                            ? Colors.deepPurple
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
                onTap: isDisabled
                    ? null
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

class TestCard extends StatelessWidget {
  final String id;
  final String name;
  final String label;
  final String username;
  final String followUpDate;
  final String nextFollowUpDate;
  final String inquiryType;
  final String intArea;
  final String purposeBuy;
  final String daySkip;
  final String hourSkip;
  final String source;
  final bool isSelected;
  final VoidCallback onSelect;
  final List<String> callList;
  final TextEditingController nextFollowupcontroller;
  final String? selectedcallFilter;
  final FollowupInquiry data;
  final bool isTiming;

  const TestCard({
    Key? key,
    required this.id,
    required this.name,
    required this.username,
    required this.label,
    required this.followUpDate,
    required this.nextFollowUpDate,
    required this.inquiryType,
    required this.intArea,
    required this.purposeBuy,
    required this.daySkip,
    required this.hourSkip,
    required this.source,
    this.isSelected = false,
    required this.onSelect,
    required this.callList,
    required this.nextFollowupcontroller,
    this.selectedcallFilter,
    required this.data,
    required this.isTiming,
  }) : super(key: key);

  void showDialogRemark(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Container(
            height: 150,
            child:
            Center(child: Text(data.remark ?? '', style: const TextStyle(fontFamily: "poppins_thin"))),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onSelect,
      child: Card(
        margin: const EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        elevation: isSelected ? 14.0 : 4.0,
        color: isSelected ? Colors.deepPurple.shade100 : Colors.white,
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
                          style: const TextStyle(fontSize: 13, fontFamily: "poppins_thin", color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: const TextStyle(fontSize: 17, fontFamily: "poppins_thin")),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.person, size: 15),
                            Text(": $username",
                                style: TextStyle(
                                    fontSize: 14, fontFamily: "poppins_thin", color: Colors.grey.shade600)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => InquiryScreen(inquiryId: id)));
                    },
                    child: const Image(
                        image: AssetImage("asset/Inquiry_module/call-forwarding.png"), width: 30, height: 30),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AddVisitScreen(inquiryId: id)));
                    },
                    child: const Image(image: AssetImage("asset/Inquiry_module/map.png"), width: 25, height: 25),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => BookingScreen(inquiryId: id)));
                    },
                    child: const Image(image: AssetImage("asset/Inquiry_module/rupee.png"), width: 25, height: 25),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 0, bottom: 0),
                    child: Container(
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
                          style: const TextStyle(fontFamily: "poppins_thin", color: Colors.black, fontSize: 11),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(right: 0, bottom: 0),
                    child: Container(
                      height: 30,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xffebf0f4),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(width: 1.0, color: Colors.white),
                      ),
                      child: Center(
                        child: Text(
                          "Inq Type: $inquiryType",
                          style: const TextStyle(fontFamily: "poppins_thin", color: Colors.black, fontSize: 11),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(
                  "Next Follow-up: $nextFollowUpDate",
                  style: TextStyle(color: Colors.grey.shade600, fontFamily: "poppins_thin", fontSize: 12),
                ),
              ),
              Row(
                children: [
                  const Text("Source: ", style: TextStyle(fontFamily: "poppins_thin", fontSize: 12)),
                  _buildSourceContainer(source),
                  const SizedBox(width: 7),
                  Image.asset("asset/Inquiry_module/calendar.png", height: 18, width: 18),
                  const SizedBox(width: 3),
                  Text(daySkip.isNotEmpty ? daySkip : "0"),
                  const SizedBox(width: 10),
                  Image.asset("asset/Inquiry_module/clock.png", height: 18, width: 18),
                  const SizedBox(width: 3),
                  Text(hourSkip.isNotEmpty ? hourSkip : "0"),
                  const Spacer(),
                ],
              ),
              if (isSelected)
                Align(
                  alignment: Alignment.centerRight,
                  child: Checkbox(
                    value: isSelected,
                    onChanged: (bool? value) {
                      onSelect();
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
      case "Fresh":
        return const Color(0xff33b5e5);
      case "Contacted":
        return const Color(0xff4da8ff);
      case "Appointment":
        return const Color(0xff3d70b2);
      case "Visited":
        return const Color(0xff4da8ff);
      case "Pending":
        return const Color(0xfff1c40f);
      case "Negotiation":
        return const Color(0xffc966c3);
      case "Feedback":
        return const Color(0xff66d977);
      case "Re_Appointment":
        return const Color(0xff3d6ca3);
      case "Re_Visited": // Match provider key
        return const Color(0xfff1ba71);
      case "Converted":
        return const Color(0xff73e0b3);
      default:
        return Colors.grey.shade300;
    }
  }

  Color getBorderColor(String? stage) {
    switch (stage) {
      case "Fresh":
        return const Color(0xff00c4ff);
      case "Contacted":
        return const Color(0xff33aaff);
      case "Appointment":
        return const Color(0xff2b70c9);
      case "Visited":
        return const Color(0xff3399ff);
      case "Pending":
        return const Color(0xffffd700);
      case "Negotiation":
        return const Color(0xffd94ed1);
      case "Feedback":
        return const Color(0xff4cd964);
      case "Re_Appointment":
        return const Color(0xff2e62b3);
      case "Re_Visited": // Match provider key
        return const Color(0xffffca85);
      case "Converted":
        return const Color(0xff73e0b3);
      default:
        return Colors.grey.shade600;
    }
  }

  Widget _buildSourceContainer(String source) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text(source, style: const TextStyle(fontFamily: "poppins_thin", fontSize: 12)),
    );
  }
}

// Placeholder for Categorymodel (ensure this matches your actual model)
class Categorymodel {
  final String title;
  final int leads;

  Categorymodel(this.title, this.leads);
}

// Placeholder for other screens (replace with your actual implementations)
class InquiryScreen extends StatelessWidget {
  final String inquiryId;
  const InquiryScreen({required this.inquiryId});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text("Inquiry: $inquiryId")));
}

class AddVisitScreen extends StatelessWidget {
  final String inquiryId;
  const AddVisitScreen({required this.inquiryId});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text("Visit: $inquiryId")));
}
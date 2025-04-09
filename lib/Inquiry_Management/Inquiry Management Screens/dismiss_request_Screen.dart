import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:hr_app/Inquiry_Management/Utils/Colors/app_Colors.dart';
import 'package:hr_app/Inquiry_Management/Utils/Custom%20widgets/dismiss_approval_Screen.dart';
import 'package:hr_app/Provider/UserProvider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../Model/Api Model/dismiss_Model.dart';
import '../Utils/Custom widgets/custom_buttons.dart';

class DismissRequestCard extends StatelessWidget {
  // ... (Your existing DismissRequestCard code remains unchanged)
  final String id;
  final String name;
  final String username;
  final String label;
  final String inquiryType;
  final String intArea;
  final String nxtFollowup;
  final String source;
  final bool isSelected;
  final VoidCallback onSelect;
  final DismissInquiry data;

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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: SizedBox(
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Details",
                    style: TextStyle(fontFamily: "poppins_thin", fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text("Mobile: ${data.mobileno ?? 'N/A'}",
                    style: const TextStyle(fontFamily: "poppins_thin")),
                Text("Email: ${data.email ?? 'N/A'}",
                    style: const TextStyle(fontFamily: "poppins_thin")),
                Text("Address: ${data.address ?? 'N/A'}",
                    style: const TextStyle(fontFamily: "poppins_thin")),
                Text("Budget: ${data.budget ?? 'N/A'}",
                    style: const TextStyle(fontFamily: "poppins_thin")),
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
                        child: Text(id,
                            style: const TextStyle(fontSize: 13, fontFamily: "poppins_thin", color: Colors.white)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name,
                            style: const TextStyle(fontSize: 17, fontFamily: "poppins_thin")),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.person, size: 15),
                            Text(": ${data.assignId ?? 'N/A'}",
                                style: TextStyle(fontSize: 14, fontFamily: "poppins_thin", color: Colors.grey.shade600)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DismissApprovalScreen(inquiryId: id)),
                      );
                    },
                    child: Image.asset("asset/Inquiry_module/request.png", width: 25, height: 25),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              const SizedBox(height: 12),
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
                      child: Text(label,
                          style: const TextStyle(fontFamily: "poppins_thin", color: Colors.black, fontSize: 11)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    height: 30,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xffebf0f4),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(width: 1.0, color: Colors.white),
                    ),
                    child: Center(
                      child: Text("Inq Type: $inquiryType",
                          style: const TextStyle(fontFamily: "poppins_thin", color: Colors.black, fontSize: 11)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text("Next Followup: ${data.nxtFollowUp ?? 'N/A'}",
                    style: TextStyle(color: Colors.grey.shade600, fontFamily: "poppins_thin", fontSize: 12)),
              ),
              Row(
                children: [
                  const Text("Source: ", style: TextStyle(fontFamily: "poppins_thin", fontSize: 12)),
                  _buildSourceContainer(source),
                  Image.asset("asset/Inquiry_module/calendar.png", height: 18, width: 18),
                  const SizedBox(width: 3),
                  Text((data.daySkip ?? "").isNotEmpty ? data.daySkip! : "0"),
                  const SizedBox(width: 10),
                  Image.asset("asset/Inquiry_module/clock.png", height: 18, width: 18),
                  const SizedBox(width: 3),
                  Text((data.hourSkip ?? "").isNotEmpty ? data.hourSkip! : "0"),
                ],
              ),
              if (isSelected)
                Align(
                  alignment: Alignment.centerRight,
                  child: Checkbox(
                    value: isSelected,
                    onChanged: (bool? value) => onSelect(),
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
        return Colors.red.shade200;
      case "Fresh":
        return const Color(0xff33b5e5);
      case "Contacted":
        return const Color(0xff4da8ff);
      case "Appointment":
        return const Color(0xff3d70b2);
      case "Visited":
        return const Color(0xff4da8ff);
      case "Negotiation":
        return const Color(0xffc966c3);
      case "Feedback":
        return const Color(0xff66d977);
      case "Re_Appointment":
        return const Color(0xff3d6ca3);
      case "Re-Visited":
        return const Color(0xfff1ba71);
      case "Converted":
        return const Color(0xff73e0b3);
      default:
        return Colors.grey.shade300;
    }
  }

  Color getBorderColor(String? stage) {
    switch (stage) {
      case "Dismissed":
        return Colors.red.shade400;
      case "Fresh":
        return const Color(0xff00c4ff);
      case "Contacted":
        return const Color(0xff33aaff);
      case "Appointment":
        return const Color(0xff2b70c9);
      case "Visited":
        return const Color(0xff3399ff);
      case "Negotiation":
        return const Color(0xffd94ed1);
      case "Feedback":
        return const Color(0xff4cd964);
      case "Re_Appointment":
        return const Color(0xff2e62b3);
      case "Re-Visited":
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
      child: Text(source,
          style: const TextStyle(fontFamily: "poppins_thin", fontSize: 12)),
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
  late List<bool> selectedCards;
  late ScrollController _scrollController;
  bool isLoadingMore = false;
  List<DismissInquiry> currentInquiries = [];

  List<Map<String, String>> actionList = [];
  List<Map<String, String>> employeeList = [];
  String? selectedAction;
  String? selectedEmployee;
  bool anySelected = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    selectedCards = []; // Initialize here to avoid null issues
    print('initState called');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _initializeData();
      }
    });
  }

  Future<void> _initializeData() async {
    final provider = Provider.of<UserProvider>(context, listen: false);
    print('Initializing data for page: $currentPage');
    await provider.fetchDismissData(currentPage);
    if (mounted) {
      setState(() {
        currentInquiries = provider.dismissedRequestmodel?.inquiryList ?? [];
        selectedCards = List<bool>.filled(currentInquiries.length, false);
      });
      loadData();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = Provider.of<UserProvider>(context, listen: false);
    if (provider.dismissedRequestmodel?.inquiryList != null && selectedCards.isEmpty) {
      print('didChangeDependencies: Initializing selectedCards');
      selectedCards = List<bool>.filled(provider.dismissedRequestmodel!.inquiryList!.length, false);
    }
  }

  Future<void> loadData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      await userProvider.fetchTransferInquiryData();
      final data = userProvider.transferInquiryData;

      if (data == null) return;

      if (mounted) {
        setState(() {
          actionList = [];
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
      }
    } catch (e) {
      print('Error fetching transfer inquiry data: $e');
    }
  }

  void _onScroll() {
    final provider = Provider.of<UserProvider>(context, listen: false);
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300 &&
        !isLoadingMore &&
        provider.hasMore) {
      setState(() {
        isLoadingMore = true;
      });
      _loadMoreData();
    }
  }

  Future<void> _loadMoreData() async {
    final provider = Provider.of<UserProvider>(context, listen: false);
    currentPage++;
    print('Loading more data for page: $currentPage, Current length: ${currentInquiries.length}');
    await provider.fetchDismissData(currentPage);
    if (mounted) {
      setState(() {
        isLoadingMore = false;
        if (provider.dismissedRequestmodel != null && provider.dismissedRequestmodel!.inquiryList != null) {
          currentInquiries.addAll(provider.dismissedRequestmodel!.inquiryList!
              .where((newItem) => !currentInquiries.any((existing) => existing.id == newItem.id)));
          selectedCards = List<bool>.filled(currentInquiries.length, false);
        }
        print('After load more, total length: ${currentInquiries.length}');
      });
    }
  }

  void toggleSelection(int index) {
    setState(() {
      if (selectedIndices.contains(index)) {
        selectedIndices.remove(index);
        selectedCards[index] = false;
      } else {
        selectedIndices.add(index);
        selectedCards[index] = true;
      }
      anySelected = selectedIndices.isNotEmpty;
    });
  }

  void handleAction(String action, String employee) {
    setState(() {
      selectedAction = null;
      selectedEmployee = null;
      selectedIndices.clear();
      selectedCards = List<bool>.filled(currentInquiries.length, false);
      anySelected = false;
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
        String? dialogSelectedEmployee = employeeNames.isNotEmpty ? employeeNames.first : null;
        bool isSubmitting = false;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter dialogSetState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text('Perform Action',
                  style: TextStyle(fontFamily: "poppins_thin", fontSize: 19, fontWeight: FontWeight.w600)),
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
                      child: const Text("Cancel",
                          style: TextStyle(fontFamily: "poppins_thin", fontSize: 16, color: Colors.grey)),
                    ),
                    ElevatedButton(
                      onPressed: isSubmitting
                          ? null
                          : () async {
                        if (dialogSelectedAction == null || dialogSelectedEmployee == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please select both action and employee",
                                  style: TextStyle(fontFamily: 'poppins_thin')),
                            ),
                          );
                          return;
                        }

                        final selectedInquiryIds = selectedCards
                            .asMap()
                            .entries
                            .where((entry) => entry.value)
                            .map((entry) => currentInquiries[entry.key].id ?? '')
                            .toList();

                        if (selectedInquiryIds.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("No inquiries selected",
                                  style: TextStyle(fontFamily: 'poppins_thin')),
                            ),
                          );
                          return;
                        }

                        final actionKey = actionList
                            .firstWhere((action) => action['value'] == dialogSelectedAction,
                            orElse: () => {'key': ''})['key'] ??
                            '';
                        final employeeId = employeeList
                            .firstWhere((e) => e['name'] == dialogSelectedEmployee,
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
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Inquiries transferred successfully",
                                    style: TextStyle(fontFamily: 'poppins_thin')),
                              ),
                            );
                            Navigator.of(dialogContext).pop();
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Failed to transfer inquiries: $e",
                                    style: const TextStyle(fontFamily: 'poppins_thin')),
                              ),
                            );
                          }
                        } finally {
                          dialogSetState(() => isSubmitting = false);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple.shade100,
                        foregroundColor: Colors.deepPurple.shade700,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                        minimumSize: const Size(100, 0),
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
                          : const Text('Submit',
                          style: TextStyle(fontFamily: 'poppins_thin', fontSize: 16, fontWeight: FontWeight.w500)),
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
              items: items
                  .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item, style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 13)),
              ))
                  .toList(),
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
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    print('dispose called');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Building DismissRequestScreen');
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dismissed Requests", style: TextStyle(fontFamily: "poppins_thin")),
        backgroundColor: Colors.deepPurple.shade300,
        foregroundColor: Colors.white,
        actions: [
          if (anySelected)
            CircleAvatar(
              backgroundColor: Colors.white,
              child: GestureDetector(
                onTap: () {
                  final actionValues = actionList.map((action) => action['value']!).toList();
                  final employeeNames = employeeList.map((e) => e['name']!).toList();
                  showActionDialog(context, anySelected, handleAction, actionValues, employeeNames);
                },
                child: const Image(
                  image: AssetImage("asset/Inquiry_module/fast-forward.png"),
                  height: 23,
                  width: 23,
                ),
              ),
            ),
          const SizedBox(width: 10),
        ],
      ),
      body: Consumer<UserProvider>(
        builder: (context, provider, child) {
          print(
              'Consumer build. isLoading: ${provider.isLoading}, CurrentInquiries length: ${currentInquiries.length}, selectedCards length: ${selectedCards.length}');

          // Initial loading with shimmer effect
          if (provider.isLoading && currentPage == 1 && currentInquiries.isEmpty) {
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
          }

          // Error handling
          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(provider.errorMessage!,
                      style: const TextStyle(fontFamily: "poppins_thin", fontSize: 16)),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _initializeData(),
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          // No data found with Lottie animation
          if (currentInquiries.isEmpty && !isLoadingMore) {
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
                const Center(
                  child: Text(
                    "No dismissed requests found",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 22,
                      fontFamily: "poppins_thin",
                    ),
                  ),
                ),
              ],
            );
          }

          // Ensure selectedCards matches currentInquiries length
          if (selectedCards.length != currentInquiries.length) {
            print('Adjusting selectedCards length from ${selectedCards.length} to ${currentInquiries.length}');
            selectedCards = List<bool>.filled(currentInquiries.length, false);
            selectedIndices.clear();
            anySelected = false;
          }

          // List with pagination and loader
          return RefreshIndicator(
            onRefresh: () async {
              currentPage = 1;
              currentInquiries.clear();
              selectedCards.clear();
              await provider.fetchDismissData(currentPage);
              if (mounted) {
                setState(() {
                  currentInquiries = provider.dismissedRequestmodel?.inquiryList ?? [];
                  selectedCards = List<bool>.filled(currentInquiries.length, false);
                  selectedIndices.clear();
                  anySelected = false;
                });
              }
            },
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: currentInquiries.length + (isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < currentInquiries.length) {
                  final item = currentInquiries[index];
                  return DismissRequestCard(
                    id: item.id ?? "N/A",
                    name: item.fullName ?? "Unknown",
                    username: item.userId ?? "N/A",
                    label: _getStageLabel(item.inquiryStages),
                    inquiryType: item.intrestedProduct ?? "N/A",
                    intArea: item.interstedSiteName ?? item.area ?? "N/A",
                    nxtFollowup: item.nxtFollowUp ?? "N/A",
                    source: item.inquirySourceType ?? "N/A",
                    isSelected: selectedCards[index],
                    onSelect: () => toggleSelection(index),
                    data: item,
                  );
                }
                if (isLoadingMore) {
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
            ),
          );
        },
      ),
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
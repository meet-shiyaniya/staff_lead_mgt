import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timelines_plus/timelines_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Provider/UserProvider.dart';
import '../../Model/Api Model/add_Lead_Model.dart';
import '../../Model/Api Model/inquiry_transfer_Model.dart';
import '../Colors/app_Colors.dart';
import 'custom_buttons.dart';

class InquiryScreen extends StatefulWidget {
  final String inquiryId;
  final bool followup;

  const InquiryScreen(
      {required this.inquiryId, required this.followup, Key? key})
      : super(key: key);

  @override
  _InquiryScreenState createState() => _InquiryScreenState();
}

class _InquiryScreenState extends State<InquiryScreen> {
  String selectedTab = "Follow Up";
  late List<String> tabs;
  bool isEditing = false;
  bool showCloseReasonOnly = false;

  Map<String, String> selectedArea = {'id': '', 'name': ''};
  Map<String, String> selectedSite = {'id': '', 'name': ''};
  Map<String, String> selectedUnitType = {'id': '', 'name': ''};
  Map<String, String> selectedBudget = {'id': '', 'name': ''};
  Map<String, String> selectedPurpose = {'id': '', 'name': ''};
  Map<String, String> selectedBuyingTime = {'id': '', 'name': ''};

  String? selectedApxFollowUp;
  String? selectedApxAppointment;
  String? selectedApxOther;
  String? selectedApxFeedback;
  bool _submitFailed = false; //

  bool isDismissed = false;
  final TextEditingController nextFollowUpController = TextEditingController();
  final TextEditingController otherActionController = TextEditingController();
  final TextEditingController FeedbackActionController =
      TextEditingController();

  final TextEditingController remarkController = TextEditingController();
  String? selectedCloseReason;
  String? selectedIntMembership;
  DateTime? appointmentDate;
  String? selectedProjectId;

  bool _isFollowUpLoading = false;
  bool _isAppointmentLoading = false;
  bool _isOtherLoading = false;
  bool _isInitialLoading = true; // New flag for initial loading
  final List<String> timeOptions = ["8:00", "9:00", "10:00", "11:00", "12:00"];
  final List<String> closeReasonOptions = [
    "Budget Problem",
    "Not Required",
    "Muscles"
  ];
  final List<String> intMembershipOptions = [
    "Package 1",
    "Package 2",
    "Package 3"
  ];

  void _fetchInitialSlots() {
    final provider = Provider.of<UserProvider>(context, listen: false);
    provider.fetchNextSlots(DateFormat('yyyy-MM-dd').format(DateTime.now()));
  }

  String maskMobileNumber(String? mobileNo) {
    if (mobileNo == null || mobileNo.isEmpty) return 'N/A';
    if (mobileNo.length <= 5)
      return mobileNo; // If number is too short, return as is
    return '${mobileNo.substring(0, mobileNo.length - 5)}*****';
  }

  @override
  void initState() {
    super.initState();
    tabs = ["Follow Up", "Dismissed", "Appointment", "CNR"];
    _fetchInitialSlots();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<UserProvider>(context, listen: false);
      provider.loadInquiryData(widget.inquiryId).then((_) {
        provider.fetchInquiryStatus();
        final inquiryModel = provider.inquiryModel;
        final dropdownData = provider.dropdownData;

        if (inquiryModel != null && dropdownData != null) {
          setState(() {
            final areaOptions = dropdownData.areaCityCountry ?? [];
            selectedArea = _initializeDropdownValue(
              areaOptions,
              inquiryModel.inquiryData.intrestedArea ?? '',
              (area) => area.area,
              (area) => {'id': area.id ?? '', 'name': area.area ?? ''},
            );

            final siteOptions = dropdownData.intSite ?? [];
            selectedSite = _initializeDropdownValue(
              siteOptions,
              inquiryModel.intrestedProduct ?? '',
              (site) => site.productName,
              (site) => {'id': site.id ?? '', 'name': site.productName ?? ''},
            );

            final unitOptions = dropdownData.propertyConfiguration ?? [];
            selectedUnitType = _initializeDropdownValue(
              unitOptions,
              inquiryModel.propertyConfigurationType ?? '',
              (unit) => unit.propertyType,
              (unit) => {'id': unit.id ?? '', 'name': unit.propertyType ?? ''},
            );

            selectedBudget =
                _initializeSimpleDropdownValue(inquiryModel.inquiryData.budget);
            selectedPurpose = _initializeSimpleDropdownValue(
                inquiryModel.inquiryData.purposeBuy);
            selectedBuyingTime = _initializeSimpleDropdownValue(
                inquiryModel.inquiryData.approxBuy);
            _isInitialLoading =
                false; // Set to false once initial data is loaded
          });
        } else {
          setState(() {
            selectedArea = {'id': '', 'name': ''};
            selectedSite = {'id': '', 'name': ''};
            selectedUnitType = {'id': '', 'name': ''};
            selectedBudget = {'id': '', 'name': ''};
            selectedPurpose = {'id': '', 'name': ''};
            selectedBuyingTime = {'id': '', 'name': ''};
            _isInitialLoading =
                false; // Even if data fails, stop initial loading
          });
        }
      }).catchError((error) {
        setState(() {
          selectedArea = {'id': '', 'name': ''};
          selectedSite = {'id': '', 'name': ''};
          selectedUnitType = {'id': '', 'name': ''};
          selectedBudget = {'id': '', 'name': ''};
          selectedPurpose = {'id': '', 'name': ''};
          selectedBuyingTime = {'id': '', 'name': ''};
          _isInitialLoading = false; // Even if data fails, stop initial loading
        });
      });
      provider.fetchAddLeadData();
    });
  }

  Map<String, String> _initializeSimpleDropdownValue(String? value) {
    return value != null && value.isNotEmpty
        ? {'id': value, 'name': value}
        : {'id': '', 'name': ''};
  }

  Map<String, String> _initializeDropdownValue<T>(
    List<T> options,
    String initialValue,
    String Function(T) displayString,
    Map<String, String> Function(T) mapper,
  ) {
    if (options.isEmpty) {
      return {'id': '', 'name': initialValue.isNotEmpty ? initialValue : ''};
    }
    if (initialValue.isEmpty) {
      return {'id': '', 'name': ''};
    }
    try {
      final selected = options.firstWhere(
        (option) => displayString(option) == initialValue,
        orElse: () => options[0],
      );
      return mapper(selected);
    } catch (e) {
      return {'id': '', 'name': initialValue};
    }
  }

  Map<String, String> formatCreatedAt(String createdAt) {
    try {
      DateTime parsedDate = DateTime.parse(createdAt);
      return {
        'date': DateFormat("dd MMM yyyy").format(parsedDate),
        'time': DateFormat("hh:mm a").format(parsedDate),
      };
    } catch (e) {
      return {'date': createdAt, 'time': '-'};
    }
  }

  String? selectedYesNo;

  void showDismissedConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final screenSize = MediaQuery.of(context).size;
        final double scaleFactor =
            screenSize.width / 375.0; // Base width: 375px
        final double fontScale =
            scaleFactor.clamp(0.8, 1.2); // Limit font scaling
        final double paddingScale =
            scaleFactor.clamp(0.7, 1.5); // Limit padding scaling

        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                12 * scaleFactor), // Smaller, scaled radius
          ),
          title: Text(
            "Dismiss Inquiry?",
            style: TextStyle(
              fontFamily: "poppins_thin",
              fontSize: 14 * fontScale, // Smaller title (default ~20 → 14)
              fontWeight: FontWeight.w600, // Slight boldness for emphasis
              color: Colors.black87,
            ),
          ),
          content: Container(
            color: Colors.white,
            height: screenSize.height * 0.25, // Reduced from 30% to 25%
            width:
                screenSize.width * 0.8, // 80% of screen width for compactness
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min, // Minimize vertical space
              children: [
                Lottie.asset(
                  "asset/Inquiry_module/errors.json",
                  height: screenSize.height * 0.15, // Reduced from 20% to 15%
                  width: screenSize.width * 0.3, // Reduced from 40% to 30%
                  fit: BoxFit.contain, // Ensure proper scaling
                ),
                SizedBox(height: 8 * paddingScale), // Smaller, scaled spacing
                Text(
                  "Did you have a conversation with this inquiry?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "poppins_thin",
                    fontSize: 12 * fontScale, // Smaller text (dynamic ~16 → 12)
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly, // Better spacing
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      isDismissed = true;
                      showCloseReasonOnly = false;
                      selectedYesNo = "Yes";
                    });
                    Navigator.pop(context);
                    _buildDismissedForm();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          8 * scaleFactor), // Smaller, scaled radius
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12 * paddingScale, // Smaller, scaled padding
                      vertical: 6 * paddingScale,
                    ),
                  ),
                  child: Text(
                    "Yes",
                    style: TextStyle(
                      fontFamily: "poppins_thin",
                      fontSize: 12 * fontScale, // Smaller text (17 → 12)
                      color: Colors.red,
                      fontWeight: FontWeight.w600, // Slight boldness
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      showCloseReasonOnly = true;
                      selectedYesNo = "No";
                    });
                    Navigator.pop(context);
                    _buildDismissedForm();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          8 * scaleFactor), // Smaller, scaled radius
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12 * paddingScale, // Smaller, scaled padding
                      vertical: 6 * paddingScale,
                    ),
                  ),
                  child: Text(
                    "No",
                    style: TextStyle(
                      fontFamily: "poppins_thin",
                      fontSize: 12 * fontScale, // Smaller text (17 → 12)
                      color: Colors.green,
                      fontWeight: FontWeight.w600, // Slight boldness
                    ),
                  ),
                ),
              ],
            ),
          ],
          contentPadding:
              EdgeInsets.all(12 * paddingScale), // Smaller, scaled padding
          actionsPadding: EdgeInsets.only(
            bottom: 8 * paddingScale, // Smaller, scaled padding
            left: 8 * paddingScale,
            right: 8 * paddingScale,
          ),
          elevation: 4 * scaleFactor, // Scaled, subtle elevation
        );
      },
    );
  }

  Future<void> _pickAppointmentDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          appointmentDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _handleTabChange(String value) {
    if (value == "Dismissed") {
      showDismissedConfirmationDialog();
    }
    setState(() {
      selectedTab = value;
      remarkController.clear();
      nextFollowUpController.clear();
      otherActionController.clear();
      selectedCloseReason = null;
      selectedIntMembership = null;
      appointmentDate = null;
      selectedProjectId = null;
      showCloseReasonOnly = false;
      selectedApxFollowUp = null;
      selectedApxAppointment = null;
      selectedApxOther = null;
    });
  }

  // Validation for personal/interested details
  bool _areDetailsValid() {
    return selectedArea['name']!.isNotEmpty &&
        selectedSite['name']!.isNotEmpty &&
        selectedUnitType['name']!.isNotEmpty &&
        selectedBudget['name']!.isNotEmpty &&
        selectedPurpose['name']!.isNotEmpty &&
        selectedBuyingTime['name']!.isNotEmpty;
  }

  // Validation for tab-specific fields
  bool _areTabFieldsValid() {
    switch (selectedTab.toLowerCase()) {
      // Ensure case-insensitive comparison
      case 'follow up':
        return remarkController.text.isNotEmpty &&
            nextFollowUpController.text.isNotEmpty &&
            selectedApxFollowUp != null;
      case 'dismissed':
        return (!showCloseReasonOnly && remarkController.text.isNotEmpty ||
                showCloseReasonOnly) &&
            selectedCloseReason != null;
      case 'appointment':
        return remarkController.text.isNotEmpty &&
            nextFollowUpController.text.isNotEmpty &&
            selectedApxAppointment != null &&
            appointmentDate != null &&
            selectedProjectId != null;
      case 'negotiations': // Match the tab name exactly as in tabs list
        return remarkController.text.isNotEmpty &&
            otherActionController.text.isNotEmpty &&
            selectedApxOther != null;
      case 'feedback':
        return remarkController.text.isNotEmpty &&
            FeedbackActionController.text.isNotEmpty &&
            selectedApxFeedback != null;
      case 'cnr':
        return true;
      default:
        return false;
    }
  }

  String _getMissingTabFields() {
    List<String> missingFields = [];
    switch (selectedTab.toLowerCase()) {
      // Ensure case-insensitive comparison
      case 'follow up':
        if (remarkController.text.isEmpty) missingFields.add("Remark");
        if (nextFollowUpController.text.isEmpty)
          missingFields.add("Next Follow Up");
        if (selectedApxFollowUp == null) missingFields.add("Follow Up Time");
        break;
      case 'dismissed':
        if (!showCloseReasonOnly && remarkController.text.isEmpty)
          missingFields.add("Remark");
        if (selectedCloseReason == null) missingFields.add("Close Reason");
        break;
      case 'appointment':
        if (remarkController.text.isEmpty) missingFields.add("Remark");
        if (nextFollowUpController.text.isEmpty)
          missingFields.add("Next Follow Up");
        if (selectedApxAppointment == null) missingFields.add("Follow Up Time");
        if (appointmentDate == null) missingFields.add("Appointment Date");
        if (selectedProjectId == null) missingFields.add("Project");
        break;
      case 'negotiations': // Match the tab name exactly as in tabs list
        if (remarkController.text.isEmpty) missingFields.add("Remark");
        if (otherActionController.text.isEmpty)
          missingFields.add("Next Follow Up");
        if (selectedApxOther == null) missingFields.add("Follow Up Time");
        break;
      case 'feedback':
        if (remarkController.text.isEmpty) missingFields.add("Remark");
        if (FeedbackActionController.text.isEmpty)
          missingFields.add("Next Follow Up");
        if (selectedApxFeedback == null) missingFields.add("Follow Up Time");
        break;
      // case 'cnr':
      //   if (remarkController.text.isEmpty) missingFields.add("Remark");
      //   if (nextFollowUpController.text.isEmpty)
      //     missingFields.add("Next Follow Up");
      //   if (selectedApxFollowUp == null) missingFields.add("Follow Up Time");
      //   break;
    }
    return missingFields.isNotEmpty
        ? "Missing: ${missingFields.join(', ')}"
        : "";
  }

  Widget _buildShimmerEffect() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Simulate an AppBar shimmer
            // Shimmer.fromColors(
            //   baseColor: Colors.grey[300]!,
            //   highlightColor: Colors.grey[100]!,
            //   child: Container(
            //     height: 50,
            //     width: double.infinity,
            //     decoration: BoxDecoration(
            //       color: Colors.white,
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //   ),
            // ),
            SizedBox(height: 10),

            // Simulate a list/card shimmer effect
            Expanded(
              child: ListView.builder(
                itemCount: 1, // Show shimmer for 5 items
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Column(
                        children: [
                          Container(
                            height: 230,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 100,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 90,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 80,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 60,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, inquiryProvider, child) {
        if (_isInitialLoading) {
          return _buildShimmerEffect(); // Show shimmer only during initial loading
        }
        final inquiryModel = inquiryProvider.inquiryModel;
        final dropdownData = inquiryProvider.dropdownData;

        if (inquiryModel == null) {
          return const Scaffold(
              body: Center(child: Text("Failed to load inquiry data")));
        }
        if (dropdownData == null) {
          return Scaffold(
            body: Center(
              child: Text(
                inquiryProvider.errorMessage ?? "Failed to load dropdown data",
              ),
            ),
          );
        }

        tabs = ["Follow Up", "Dismissed", "Appointment", "CNR"];
        final siteVisitCount =
            int.tryParse(inquiryModel.inquiryData.issitevisit ?? '0') ?? 0;
        if (siteVisitCount > 0) {
          tabs = [
            "Follow Up",
            "Dismissed",
            "Appointment",
            "CNR",
            "Negotiations",
            "Feedback"
          ];
        }

        bool showFullUI = inquiryModel.modelHeaderAccess == 1;

        final List<AreaCityCountry> areaOptions =
            dropdownData.areaCityCountry ?? [];
        final List<IntSite> siteOptions = dropdownData.intSite ?? [];
        final List<PropertyConfiguration> unitOptions =
            dropdownData.propertyConfiguration ?? [];
        final List<Map<String, String>> budgetOptions = dropdownData
                .budget?.values
                .split(',')
                .map((value) => value.trim())
                .where((value) => value.isNotEmpty)
                .map((b) => {'id': b, 'name': b})
                .toList() ??
            [];
        final List<Map<String, String>> purposeOptions =
            dropdownData.purposeOfBuying != null
                ? [
                    {
                      'id': dropdownData.purposeOfBuying!.investment ?? '',
                      'name': dropdownData.purposeOfBuying!.investment ?? ''
                    },
                    {
                      'id': dropdownData.purposeOfBuying!.personalUse ?? '',
                      'name': dropdownData.purposeOfBuying!.personalUse ?? ''
                    },
                  ].where((purpose) => purpose['name']!.isNotEmpty).toList()
                : [];
        final List<Map<String, String>> buyingTimeOptions = dropdownData
                .apxTime?.apxTimeData
                .split(',')
                .map((time) => time.trim())
                .where((time) => time.isNotEmpty)
                .map((t) => {'id': t, 'name': t})
                .toList() ??
            [];
        double _scaleFactor(BuildContext context) {
          final screenSize = MediaQuery.of(context).size;
          return screenSize.width / 375.0; // Base width: 375px
        }

        double _fontScale(BuildContext context) {
          return _scaleFactor(context).clamp(0.8, 1.2); // Limit font scaling
        }

        double _paddingScale(BuildContext context) {
          return _scaleFactor(context).clamp(0.7, 1.5); // Limit padding scaling
        }

        final double screenWidth = MediaQuery.of(context).size.width;
        final screenSize = MediaQuery.of(context).size;

        final double fontScale =
            screenWidth < 400 ? 0.85 : 0.9; // Responsive font scaling
        final double scaleFactor =
            screenSize.width / 375.0; // Base width: 375px

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text(
              "Inquiry Details",
              style: TextStyle(
                  fontFamily: "poppins_thin",
                  color: Colors.white,
                  fontSize: 18),
            ),
            backgroundColor: AppColor.MainColor,
            leading: IconButton(
              onPressed: () => Navigator.pop(context, true),
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Personal and Interested Details Card
                      Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              8 * _scaleFactor(context)), // Scaled radius
                        ),
                        elevation:
                            3 * _scaleFactor(context), // Scaled elevation
                        child: Padding(
                          padding: EdgeInsets.all(
                              12 * _paddingScale(context)), // Scaled padding
                          child: _buildPersonalAndInterestedDetails(
                            inquiryModel,
                            areaOptions,
                            siteOptions,
                            unitOptions,
                            budgetOptions,
                            purposeOptions,
                            buyingTimeOptions,
                          ),
                        ),
                      ),
                      if (showFullUI && widget.followup) ...[
                        SizedBox(
                            height:
                                10 * _paddingScale(context)), // Scaled spacing
                        // Tab Buttons
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: MainButtonGroup(
                            buttonTexts: tabs,
                            selectedButton: selectedTab,
                            onButtonPressed: _handleTabChange,
                          ),
                        ),
                        SizedBox(
                            height:
                                10 * _paddingScale(context)), // Scaled spacing
                        // Tab Content Card
                        Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                12 * _scaleFactor(context)), // Scaled radius
                          ),
                          elevation:
                              3 * _scaleFactor(context), // Scaled elevation
                          child: Padding(
                            padding: EdgeInsets.all(
                                18 * _paddingScale(context)), // Scaled padding
                            child: _buildTabContent(),
                          ),
                        ),
                      ],
                      SizedBox(
                          height:
                              20 * _paddingScale(context)), // Scaled spacing
                      // Remark Section Card
                      Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              12 * _scaleFactor(context)), // Scaled radius
                        ),
                        elevation:
                            2 * _scaleFactor(context), // Scaled elevation
                        child: Padding(
                          padding: EdgeInsets.all(
                              8 * _paddingScale(context)), // Scaled padding
                          child:
                              _remarkSection(inquiryModel.processedData ?? []),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (showFullUI && widget.followup)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GradientButton(
                    buttonText: _submitFailed
                        ? "Retry"
                        : "Submit", // Switch based on failure state
                    enable: _areDetailsValid() &&
                        _areTabFieldsValid(), // Ensure validation is checked
                    onPressed: () async {
                      if (selectedTab.toLowerCase() != 'cnr' &&
                          selectedTab.toLowerCase() != 'dismissed') {
                        if (!_areDetailsValid()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "Please complete all personal and interested details")),
                          );
                          return;
                        }
                      }
                      if (selectedTab.toLowerCase() == 'cnr') {
                        bool confirmCNR = await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(15 * scaleFactor),
                              ),
                              backgroundColor: Colors.white,
                              title: Text(
                                "Confirm CNR",
                                style: TextStyle(
                                  fontFamily: "poppins_thin",
                                  fontSize: 16 * fontScale,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              content: Text(
                                "Are you sure you want to mark this inquiry as CNR?",
                                style: TextStyle(
                                  fontFamily: "poppins_thin",
                                  fontSize: 14 * fontScale,
                                  color: Colors.black54,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, true); // Confirm
                                  },
                                  child: Text(
                                    "Yes",
                                    style: TextStyle(
                                      fontFamily: "poppins_thin",
                                      fontSize: 12 * fontScale,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, false); // Cancel
                                  },
                                  child: Text(
                                    "No",
                                    style: TextStyle(
                                      fontFamily: "poppins_thin",
                                      fontSize: 12 * fontScale,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );

                        if (confirmCNR != true)
                          return; // If the user taps "No", stop execution.
                      }

                      if (!_areTabFieldsValid()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  "Fill all fields: ${_getMissingTabFields()}")),
                        );
                        return;
                      }

                      Map<String, dynamic> formData = {
                        'remark': remarkController.text,
                      };

                      int interest = isEditing ? 1 : 0;

                      switch (selectedTab.toLowerCase()) {
                        case 'follow up':
                          formData.addAll({
                            'nextFollowUp': nextFollowUpController.text,
                            'callTime': selectedApxFollowUp ?? '',
                          });
                          break;
                        case 'dismissed':
                          formData.addAll({
                            'inquiry_close_reason': selectedCloseReason ?? '',
                          });
                          break;
                        case 'appointment':
                          formData.addAll({
                            'nextFollowUp': nextFollowUpController.text,
                            'callTime': selectedApxAppointment ?? '',
                            'appointDate': appointmentDate != null
                                ? DateFormat('yyyy-MM-dd HH:mm:ss')
                                    .format(appointmentDate!)
                                : '',
                            'interestedProduct': selectedProjectId ?? '',
                          });
                          break;
                        case 'negotiations':
                          formData.addAll({
                            'nextFollowUp': otherActionController.text,
                            'callTime': selectedApxOther.toString(),
                            'appointDate': appointmentDate != null
                                ? DateFormat('dd-MM-yyyy')
                                    .format(appointmentDate!)
                                : '',
                          });
                          break;
                        case 'feedback':
                          formData.addAll({
                            'nextFollowUp': FeedbackActionController.text,
                            'callTime': selectedApxFeedback ?? '',
                            'appointDate': appointmentDate != null
                                ? DateFormat('dd-MM-yyyy')
                                    .format(appointmentDate!)
                                : '',
                          });
                          break;
                        case 'cnr':
                          formData.addAll({});
                          break;
                      }

                      final provider =
                          Provider.of<UserProvider>(context, listen: false);
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) =>
                            const Center(child: CircularProgressIndicator()),
                      );

                      final success = await provider.updateInquiryStatus(
                        inquiryId: widget.inquiryId,
                        selectedTab: selectedTab,
                        formData: formData,
                        interestedProduct: selectedTab.toLowerCase() ==
                                'appointment'
                            ? (selectedProjectId ?? selectedSite['id'] ?? '')
                            : (selectedSite['id'] ?? ''),
                        isSiteVisit: int.tryParse(
                                inquiryModel!.inquiryData.issitevisit ?? '0') ??
                            0,
                        interest: interest,
                      );

                      Navigator.pop(context); // Close loading dialog

                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Status updated successfully")),
                        );
                        setState(() {
                          _submitFailed = false; // Reset on success
                          remarkController.clear();
                          nextFollowUpController.clear();
                          otherActionController.clear();
                          FeedbackActionController.clear();
                          selectedCloseReason = null;
                          appointmentDate = null;
                          selectedProjectId = null;
                          selectedApxFollowUp = null;
                          selectedApxAppointment = null;
                          selectedApxOther = null;
                          selectedApxFeedback = null;
                        });
                        Navigator.pop(
                            context, true); // Navigate back on success
                      } else {
                        setState(() {});
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Something went wrong: ${provider.error ?? 'Unknown error'}",
                            ),
                          ),
                        );
                      }
                    },
                  ),
                )
            ],
          ),
        );
      },
    );
  }

  Widget _buildPersonalAndInterestedDetails(
    InquiryModel model,
    List<AreaCityCountry> areaOptions,
    List<IntSite> siteOptions,
    List<PropertyConfiguration> unitOptions,
    List<Map<String, String>> budgetOptions,
    List<Map<String, String>> purposeOptions,
    List<Map<String, String>> buyingTimeOptions,
  ) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double fontScale =
        screenWidth < 400 ? 0.85 : 0.9; // Responsive font scaling
    bool showDropdowns = model.fillInterstCheck == 0 ||
        (model.fillInterstCheck == 1 && isEditing);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                child: Text(
                  model.inquiryData.id ?? 'N/A',
                  style: TextStyle(
                    fontSize: 12 * fontScale,
                    fontFamily: "poppins_thin",
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(width: screenWidth * 0.02),
            Text(
              model.inquiryData.fullName ?? 'N/A',
              style: TextStyle(
                fontSize: 16 * fontScale,
                fontWeight: FontWeight.bold,
                fontFamily: "poppins_thin",
              ),
            ),
            // const Spacer(),
            // if(widget.followup)
            // SpeedDial(
            //   icon: Icons.call_outlined,
            //   iconTheme: const IconThemeData(color: Colors.white),
            //   activeIcon: Icons.close,
            //   backgroundColor: Colors.deepPurple.shade300,
            //   buttonSize: Size(38.0 * fontScale, 38.0 * fontScale),
            //   overlayOpacity: 0.3,
            //   spaceBetweenChildren: 8 * fontScale,
            //   direction: SpeedDialDirection.down,
            //   children: [
            //     SpeedDialChild(
            //       child: Icon(Icons.call, color: Colors.white, size: 22 * fontScale),
            //       backgroundColor: Colors.green,
            //       onTap: () {
            //         _makeDirectPhoneCall(model.inquiryData.mobileno, context);
            //       },
            //     ),
            //     SpeedDialChild(
            //       child: Icon(Icons.message, color: Colors.white, size: 22 * fontScale),
            //       backgroundColor: Colors.blue,
            //       onTap: () async {
            //         String phoneNumber = model.inquiryData.mobileno;
            //         String message = "";
            //         await _launchSMS(phoneNumber, message);
            //       },
            //     ),
            //     SpeedDialChild(
            //       child: Icon(FontAwesomeIcons.whatsapp, color: Colors.white, size: 22 * fontScale),
            //       backgroundColor: Colors.green.shade600,
            //       onTap: () async {
            //         String phoneNumber = model.inquiryData.mobileno;
            //         String message = "";
            //         await _launchWhatsApp(phoneNumber, message);
            //       },
            //     ),
            //   ],
            // ),
          ],
        ),
        SizedBox(height: 6 * fontScale),
        Text(
          "\u260E ${!widget.followup ? maskMobileNumber(model.inquiryData.mobileno) : model.inquiryData.mobileno}",
          style: TextStyle(
            fontSize: 12 * fontScale,
            fontFamily: "poppins_thin",
          ),
        ),
        SizedBox(height: 12 * fontScale),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: screenWidth * 0.4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Int Area:",
                    style: TextStyle(
                      fontFamily: "poppins_thin",
                      fontSize: 14 * fontScale,
                    ),
                  ),
                  SizedBox(height: 5 * fontScale),
                  showDropdowns
                      ? CombinedDropdownTextField<AreaCityCountry>(
                          key: const ValueKey("intArea"),
                          options: areaOptions,
                          displayString: (area) => area.area ?? '',
                          onSelected: (AreaCityCountry selected) {
                            setState(() {
                              selectedArea = {
                                'id': selected.id ?? '',
                                'name': selected.area ?? ''
                              };
                            });
                          },
                          onTextChanged: (String text) {
                            setState(() {
                              selectedArea = {'id': '', 'name': text.trim()};
                            });
                          },
                          initialValue: areaOptions.isNotEmpty &&
                                  selectedArea['name']!.isNotEmpty
                              ? areaOptions.firstWhere(
                                  (area) => area.area == selectedArea['name'],
                                  orElse: () => AreaCityCountry(
                                    id: "",
                                    area: selectedArea['name'] ??
                                        model.inquiryData.intrestedArea ??
                                        "",
                                    city: "",
                                    state: "",
                                    country: "",
                                  ),
                                )
                              : AreaCityCountry(
                                  id: "",
                                  area: selectedArea['name']!.isNotEmpty
                                      ? selectedArea['name']!
                                      : (model.inquiryData.intrestedArea ?? ""),
                                  city: "",
                                  state: "",
                                  country: "",
                                ),
                          isRequired: true,
                          onEditingComplete: (text) {
                            setState(() {
                              selectedArea = {'id': '', 'name': text.trim()};
                            });
                          },
                        )
                      : Text(
                          selectedArea['name']!.isNotEmpty
                              ? selectedArea['name']!
                              : "N/A",
                          style: TextStyle(
                            fontFamily: "poppins_thin",
                            fontSize: 14 * fontScale,
                          ),
                        ),
                ],
              ),
            ),
            _infoTile<IntSite>(
              "Int Site",
              selectedSite['name']!.isNotEmpty
                  ? selectedSite['name']!
                  : (model.intrestedProduct ?? "N/A"),
              siteOptions,
              (newValue) {
                setState(() {
                  selectedSite = {
                    'id': newValue.id ?? '',
                    'name': newValue.productName ?? ''
                  };
                });
              },
              showDropdowns,
              (site) => site.productName ?? '',
              isRequired: true,
              fontScale: fontScale,
            ),
          ],
        ),
        SizedBox(height: 5 * fontScale),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _infoTile<PropertyConfiguration>(
              "Unit Type",
              selectedUnitType['name']!.isNotEmpty
                  ? selectedUnitType['name']!
                  : (model.propertyConfigurationType ?? "N/A"),
              unitOptions,
              (newValue) {
                setState(() {
                  selectedUnitType = {
                    'id': newValue.id ?? '',
                    'name': newValue.propertyType ?? ''
                  };
                });
              },
              showDropdowns,
              (unit) => unit.propertyType ?? '',
              isRequired: true,
              fontScale: fontScale,
            ),
            _infoTile<Map<String, String>>(
              "Budget",
              selectedBudget['name']!.isNotEmpty
                  ? selectedBudget['name']!
                  : (model.inquiryData.budget ?? "N/A"),
              budgetOptions,
              (newValue) {
                setState(() {
                  selectedBudget = {
                    'id': newValue['id'] ?? '',
                    'name': newValue['name'] ?? ''
                  };
                });
              },
              showDropdowns,
              (budget) => budget['name'] ?? '',
              isRequired: true,
              fontScale: fontScale,
            ),
          ],
        ),
        SizedBox(height: 5 * fontScale),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _infoTile<Map<String, String>>(
              "Purpose",
              selectedPurpose['name']!.isNotEmpty
                  ? selectedPurpose['name']!
                  : (model.inquiryData.purposeBuy ?? "N/A"),
              purposeOptions,
              (newValue) {
                setState(() {
                  selectedPurpose = {
                    'id': newValue['id'] ?? '',
                    'name': newValue['name'] ?? ''
                  };
                });
              },
              showDropdowns,
              (purpose) => purpose['name'] ?? '',
              isRequired: true,
              fontScale: fontScale,
            ),
            Row(
              children: [
                SizedBox(
                  width: screenWidth * 0.31,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Approx Buying:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14 * fontScale,
                          fontFamily: "poppins_thin",
                        ),
                      ),
                      SizedBox(height: 5 * fontScale),
                      showDropdowns
                          ? DropdownButton2<Map<String, String>>(
                              isExpanded: true,
                              hint: Text(
                                "Select Approx Buying",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.5 * fontScale,
                                  fontFamily: "poppins_thin",
                                ),
                              ),
                              value: buyingTimeOptions.isNotEmpty &&
                                      selectedBuyingTime['name']!.isNotEmpty &&
                                      selectedBuyingTime['name']! != "N/A"
                                  ? buyingTimeOptions.firstWhere(
                                      (option) =>
                                          option['name'] ==
                                          selectedBuyingTime['name'],
                                      orElse: () => buyingTimeOptions[0],
                                    )
                                  : null,
                              underline: const SizedBox(width: 0),
                              buttonStyleData: ButtonStyleData(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade300,
                                      blurRadius: 4 * fontScale,
                                      spreadRadius: 2 * fontScale,
                                    ),
                                  ],
                                ),
                              ),
                              dropdownStyleData: DropdownStyleData(
                                offset: const Offset(-5, -10),
                                maxHeight: 200 * fontScale,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20)),
                                elevation: 10,
                                scrollbarTheme: ScrollbarThemeData(
                                  radius: const Radius.circular(40),
                                  thickness:
                                      MaterialStateProperty.all(6 * fontScale),
                                  thumbVisibility:
                                      MaterialStateProperty.all(true),
                                ),
                              ),
                              items: buyingTimeOptions
                                  .map((Map<String, String> item) {
                                return DropdownMenuItem<Map<String, String>>(
                                  value: item,
                                  child: Text(
                                    item['name'] ?? '',
                                    style: TextStyle(
                                      fontFamily: "poppins_thin",
                                      fontSize: 15 * fontScale,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (Map<String, String>? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    selectedBuyingTime = {
                                      'id': newValue['id'] ?? '',
                                      'name': newValue['name'] ?? ''
                                    };
                                  });
                                }
                              },
                            )
                          : Text(
                              selectedBuyingTime['name']!.isNotEmpty
                                  ? selectedBuyingTime['name']!
                                  : (model.inquiryData.approxBuy ?? "N/A"),
                              style: TextStyle(
                                fontFamily: "poppins_light",
                                fontWeight: FontWeight.bold,
                                fontSize: 15 * fontScale,
                              ),
                            ),
                    ],
                  ),
                ),
                SizedBox(width: screenWidth * 0.02),
                CircleAvatar(
                  backgroundColor: AppColor.Buttoncolor,
                  radius: 18 * fontScale,
                  child: IconButton(
                    icon: Icon(
                      isEditing ? Icons.save : Icons.edit,
                      color: Colors.white,
                      size: 18 * fontScale,
                    ),
                    onPressed: () async {
                      setState(() {
                        isEditing = !isEditing;
                      });

                      if (!isEditing) {
                        if (!_areDetailsValid()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Please fill all personal and interested details before saving',
                                style: TextStyle(
                                  fontFamily:
                                      'poppins_thin', // Replace with your custom font family
                                  fontSize: 13,
                                  color: Colors.white,
                                ),
                              ),
                              backgroundColor: Colors
                                  .red.shade200, // Custom background color
                              behavior: SnackBarBehavior
                                  .floating, // Makes the SnackBar float
                              margin: EdgeInsets.all(
                                  16), // Adds margin for a better look
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    12), // Rounded corners
                              ),
                              duration:
                                  Duration(seconds: 3), // Auto dismiss time
                            ),

                            // const SnackBar(
                            //   content: Text("Please fill all personal and interested details before saving"),
                            // ),
                          );
                          setState(() {
                            isEditing = true;
                          });
                          return;
                        }

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) =>
                              const Center(child: CircularProgressIndicator()),
                        );

                        final provider =
                            Provider.of<UserProvider>(context, listen: false);
                        final inquiryData = model.inquiryData;

                        Map<String, dynamic> updatedData = {
                          'action': 'update',
                          'leadId': widget.inquiryId,
                          'fullName': inquiryData.fullName ?? '',
                          'mobileno': inquiryData.mobileno ?? '',
                          'altmobileno': '',
                          'email': '',
                          'houseno': '',
                          'society': '',
                          'area': inquiryData.area ?? '',
                          'city': inquiryData.city ?? '',
                          'countryCode': '',
                          'intrestedArea': selectedArea['name']!,
                          'intrestedAreaName': selectedArea['name']!,
                          'intrestedSiteId': selectedSite['id']!,
                          'budget': selectedBudget['id']!,
                          'purposeBuy': selectedPurpose['name']!,
                          'approxBuy': selectedBuyingTime['id']!,
                          'propertyConfiguration': selectedUnitType['id']!,
                          'inquiryType': inquiryData.inquiryType ?? '',
                          'inquirySourceType':
                              inquiryData.inquirySourceType ?? '',
                          'description': inquiryData.remark ?? '',
                          'intrestedProduct': selectedSite['id']!,
                          'nxtFollowUp': nextFollowUpController.text.isNotEmpty
                              ? nextFollowUpController.text
                              : inquiryData.nxtFollowUp ?? '',
                        };

                        final success = await provider.updateLead(
                          action: updatedData['action'] as String,
                          leadId: updatedData['leadId'] as String,
                          fullName: updatedData['fullName'] as String,
                          mobileno: updatedData['mobileno'] as String,
                          altmobileno: updatedData['altmobileno'] as String,
                          email: updatedData['email'] as String,
                          houseno: updatedData['houseno'] as String,
                          society: updatedData['society'] as String,
                          area: updatedData['area'] as String,
                          city: updatedData['city'] as String,
                          countryCode: updatedData['countryCode'] as String,
                          intrestedArea: updatedData['intrestedArea'] as String,
                          intrestedAreaName:
                              updatedData['intrestedAreaName'] as String,
                          interstedSiteName:
                              updatedData['intrestedSiteId'] as String,
                          budget: updatedData['budget'] as String,
                          purposeBuy: updatedData['purposeBuy'] as String,
                          approxBuy: updatedData['approxBuy'] as String,
                          propertyConfiguration:
                              updatedData['propertyConfiguration'] as String,
                          inquiryType: updatedData['inquiryType'] as String,
                          inquirySourceType:
                              updatedData['inquirySourceType'] as String,
                          description: updatedData['description'] as String,
                          intrestedProduct:
                              updatedData['intrestedProduct'] as String,
                          nxtFollowUp: updatedData['nxtFollowUp'] as String,
                        );

                        Navigator.pop(context);
                        if (!success ?? false) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Lead has been successfully updated',
                                style: TextStyle(
                                  fontFamily:
                                      'poppins_thin', // Replace with your custom font family
                                  fontSize: 13,
                                  color: Colors.white,
                                ),
                              ),
                              backgroundColor: Colors
                                  .green.shade200, // Custom background color
                              behavior: SnackBarBehavior
                                  .floating, // Makes the SnackBar float
                              margin: EdgeInsets.all(
                                  16), // Adds margin for a better look
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    12), // Rounded corners
                              ),
                              duration:
                                  Duration(seconds: 3), // Auto dismiss time
                            ),

                            // const SnackBar(content: Text("Lead updated successfully")),
                          );
                          provider.loadInquiryData(widget.inquiryId!).then((_) {
                            setState(() {
                              isEditing = false;
                            });
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Failed to update lead: ${provider.error ?? 'Unknown error'}",
                                style: TextStyle(
                                  fontFamily:
                                      'poppins_thin', // Replace with your custom font family
                                  fontSize: 13,
                                  color: Colors.white,
                                ),
                              ),
                              backgroundColor: Colors
                                  .red.shade200, // Custom background color
                              behavior: SnackBarBehavior
                                  .floating, // Makes the SnackBar float
                              margin: EdgeInsets.all(
                                  16), // Adds margin for a better look
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    12), // Rounded corners
                              ),
                              duration:
                                  Duration(seconds: 3), // Auto dismiss time
                            ),

                            // SnackBar(
                            //   content: Text(
                            //     "Failed to update lead: ${provider.error ?? 'Unknown error'}",
                            //   ),
                            // ),
                          );
                          setState(() {
                            isEditing = true;
                          });
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // Widget _buildPersonalAndInterestedDetails(
  //   InquiryModel model,
  //   List<AreaCityCountry> areaOptions,
  //   List<IntSite> siteOptions,
  //   List<PropertyConfiguration> unitOptions,
  //   List<Map<String, String>> budgetOptions,
  //   List<Map<String, String>> purposeOptions,
  //   List<Map<String, String>> buyingTimeOptions,
  // ) {
  //   bool showDropdowns = model.fillInterstCheck == 0 ||
  //       (model.fillInterstCheck == 1 && isEditing);
  //
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Row(
  //         children: [
  //           Container(
  //             decoration: BoxDecoration(
  //               color: Colors.deepPurple.shade300,
  //               borderRadius: BorderRadius.circular(8),
  //             ),
  //             child: Padding(
  //               padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
  //               child: Text(
  //                 model.inquiryData.id ?? 'N/A',
  //                 style: const TextStyle(
  //                   fontSize: 13,
  //                   fontFamily: "poppins_thin",
  //                   color: Colors.white,
  //                 ),
  //               ),
  //             ),
  //           ),
  //           const SizedBox(width: 10),
  //           Text(
  //             model.inquiryData.fullName ?? 'N/A',
  //             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //           ),
  //           const Spacer(),
  //           SpeedDial(
  //             icon: Icons.call_outlined,
  //             iconTheme:
  //                 const IconThemeData(color: Colors.white), // Change icon color
  //
  //             activeIcon: Icons.close,
  //             backgroundColor: Colors.deepPurple.shade300,
  //             buttonSize: const Size(38.0, 38.0), // Make main button smaller
  //             overlayOpacity: 0.3,
  //             spaceBetweenChildren: 8,
  //             direction: SpeedDialDirection.down,
  //             children: [
  //               SpeedDialChild(
  //                 child: Icon(Icons.call, color: Colors.white),
  //                 backgroundColor: Colors.green,
  //                 onTap: () {
  //                   _makeDirectPhoneCall(model.inquiryData.mobileno, context);
  //                 },
  //               ),
  //               SpeedDialChild(
  //                 child: Icon(Icons.message, color: Colors.white),
  //                 backgroundColor: Colors.blue,
  //                 onTap: () async {
  //                   String phoneNumber = model.inquiryData
  //                       .mobileno; // Replace with actual phone number
  //                   String message = ""; // Replace with actual message
  //                   await _launchSMS(phoneNumber, message);
  //                 },
  //               ),
  //               SpeedDialChild(
  //                 child: Icon(FontAwesomeIcons.whatsapp, color: Colors.white),
  //                 backgroundColor: Colors.green,
  //                 onTap: () async {
  //                   String phoneNumber = model.inquiryData
  //                       .mobileno; // Replace with actual phone number
  //                   String message = "Hello"; // Replace with actual message
  //                   await _launchWhatsApp(phoneNumber, message);
  //                 },
  //               ),
  //             ],
  //           )
  //         ],
  //       ),
  //       const SizedBox(height: 6),
  //       Text("\u260E ${model.inquiryData.mobileno ?? 'N/A'}"),
  //       const SizedBox(height: 12),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           SizedBox(
  //             width: MediaQuery.of(context).size.width * 0.4,
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 const Text("Int Area:",
  //                     style:
  //                         TextStyle(fontFamily: "poppins_thin", fontSize: 13)),
  //                 const SizedBox(height: 5),
  //                 showDropdowns
  //                     ? CombinedDropdownTextField<AreaCityCountry>(
  //                         key: const ValueKey("intArea"),
  //                         options: areaOptions,
  //                         displayString: (area) => area.area,
  //                         onSelected: (AreaCityCountry selected) {
  //                           setState(() {
  //                             selectedArea = {
  //                               'id': selected.id ?? '',
  //                               'name': selected.area ?? ''
  //                             };
  //                           });
  //                         },
  //                         onTextChanged: (String text) {
  //                           setState(() {
  //                             selectedArea = {'id': '', 'name': text.trim()};
  //                           });
  //                         },
  //                         initialValue: areaOptions.isNotEmpty &&
  //                                 selectedArea['name']!.isNotEmpty
  //                             ? areaOptions.firstWhere(
  //                                 (area) => area.area == selectedArea['name'],
  //                                 orElse: () => AreaCityCountry(
  //                                   id: "",
  //                                   area: selectedArea['name'] ??
  //                                       model.inquiryData.intrestedArea ??
  //                                       "",
  //                                   city: "",
  //                                   state: "",
  //                                   country: "",
  //                                 ),
  //                               )
  //                             : AreaCityCountry(
  //                                 id: "",
  //                                 area: selectedArea['name']!.isNotEmpty
  //                                     ? selectedArea['name']!
  //                                     : (model.inquiryData.intrestedArea ?? ""),
  //                                 city: "",
  //                                 state: "",
  //                                 country: "",
  //                               ),
  //                         isRequired: true, // Make all fields required
  //                         onEditingComplete: (text) {
  //                           setState(() {
  //                             selectedArea = {'id': '', 'name': text.trim()};
  //                           });
  //                         },
  //                       )
  //                     : Text(selectedArea['name']!.isNotEmpty
  //                         ? selectedArea['name']!
  //                         : "N/A"),
  //               ],
  //             ),
  //           ),
  //           _infoTile<IntSite>(
  //             "Int Site",
  //             selectedSite['name']!.isNotEmpty
  //                 ? selectedSite['name']!
  //                 : (model.intrestedProduct ?? "N/A"),
  //             siteOptions,
  //             (newValue) {
  //               setState(() {
  //                 selectedSite = {
  //                   'id': newValue.id ?? '',
  //                   'name': newValue.productName ?? ''
  //                 };
  //               });
  //             },
  //             showDropdowns,
  //             (site) => site.productName,
  //             isRequired: true,
  //           ),
  //         ],
  //       ),
  //       const SizedBox(height: 5),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           _infoTile<PropertyConfiguration>(
  //             "Unit Type",
  //             selectedUnitType['name']!.isNotEmpty
  //                 ? selectedUnitType['name']!
  //                 : (model.propertyConfigurationType ?? "N/A"),
  //             unitOptions,
  //             (newValue) {
  //               setState(() {
  //                 selectedUnitType = {
  //                   'id': newValue.id ?? '',
  //                   'name': newValue.propertyType ?? ''
  //                 };
  //               });
  //             },
  //             showDropdowns,
  //             (unit) => unit.propertyType,
  //             isRequired: true,
  //           ),
  //           _infoTile<Map<String, String>>(
  //             "Budget",
  //             selectedBudget['name']!.isNotEmpty
  //                 ? selectedBudget['name']!
  //                 : (model.inquiryData.budget ?? "N/A"),
  //             budgetOptions,
  //             (newValue) {
  //               setState(() {
  //                 selectedBudget = {
  //                   'id': newValue['id'] ?? '',
  //                   'name': newValue['name'] ?? ''
  //                 };
  //               });
  //             },
  //             showDropdowns,
  //             (budget) => budget['name'] ?? '',
  //             isRequired: true,
  //           ),
  //         ],
  //       ),
  //       const SizedBox(height: 5),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           _infoTile<Map<String, String>>(
  //             "Purpose",
  //             selectedPurpose['name']!.isNotEmpty
  //                 ? selectedPurpose['name']!
  //                 : (model.inquiryData.purposeBuy ?? "N/A"),
  //             purposeOptions,
  //             (newValue) {
  //               setState(() {
  //                 selectedPurpose = {
  //                   'id': newValue['id'] ?? '',
  //                   'name': newValue['name'] ?? ''
  //                 };
  //               });
  //             },
  //             showDropdowns,
  //             (purpose) => purpose['name'] ?? '',
  //             isRequired: true,
  //           ),
  //           Row(
  //             children: [
  //
  //
  //               SizedBox(
  //                 width: MediaQuery.of(context).size.width * 0.31,
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text("Approx Buying:", style: const TextStyle(fontWeight: FontWeight.bold)),
  //                     const SizedBox(height: 5),
  //                     showDropdowns
  //                         ? DropdownButton2<Map<String, String>>(
  //                       isExpanded: true,
  //                       hint: const Text(
  //                         "Select Approx Buying",
  //                         style: TextStyle(
  //                           color: Colors.black,
  //                           fontSize: 16,
  //                           fontFamily: "poppins_thin",
  //                         ),
  //                       ),
  //                       value: buyingTimeOptions.isNotEmpty &&
  //                           selectedBuyingTime['name']!.isNotEmpty &&
  //                           selectedBuyingTime['name']! != "N/A"
  //                           ? buyingTimeOptions.firstWhere(
  //                             (option) => option['name'] == selectedBuyingTime['name'],
  //                         orElse: () => buyingTimeOptions[0],
  //                       )
  //                           : null,
  //                       underline: const SizedBox(width: 0),
  //                       buttonStyleData: ButtonStyleData(
  //                         decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(10),
  //                           color: Colors.white,
  //                           boxShadow: [
  //                             BoxShadow(
  //                               color: Colors.grey.shade300,
  //                               blurRadius: 4,
  //                               spreadRadius: 2,
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       dropdownStyleData: DropdownStyleData(
  //                         offset: const Offset(-5, -10),
  //                         maxHeight: 200,
  //                         decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
  //                         elevation: 10,
  //                         scrollbarTheme: ScrollbarThemeData(
  //                           radius: const Radius.circular(40),
  //                           thickness: MaterialStateProperty.all(6),
  //                           thumbVisibility: MaterialStateProperty.all(true),
  //                         ),
  //                       ),
  //                       items: buyingTimeOptions.map((Map<String, String> item) {
  //                         return DropdownMenuItem<Map<String, String>>(
  //                           value: item,
  //                           child: Text(
  //                             item['name'] ?? '',
  //                             style: const TextStyle(fontFamily: "poppins_thin", fontSize: 13),
  //                           ),
  //                         );
  //                       }).toList(),
  //                       onChanged: (Map<String, String>? newValue) {
  //                         if (newValue != null) {
  //                           setState(() {
  //                             selectedBuyingTime = {
  //                               'id': newValue['id'] ?? '',
  //                               'name': newValue['name'] ?? ''
  //                             };
  //                           });
  //                         }
  //                       },
  //                     )
  //                         : Text(
  //                       selectedBuyingTime['name']!.isNotEmpty
  //                           ? selectedBuyingTime['name']!
  //                           : (model.inquiryData.approxBuy ?? "N/A"),
  //                       style: const TextStyle(
  //                           fontFamily: "poppins_light", fontWeight: FontWeight.bold),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //
  //               CircleAvatar(
  //                   backgroundColor: AppColor.Buttoncolor,
  //                   radius: 18,
  //                   child: IconButton(
  //                     icon: Icon(
  //                       isEditing ? Icons.save : Icons.edit,
  //                       color: Colors.white,
  //                       size: 20,
  //                     ),
  //                     onPressed: () async {
  //                       setState(() {
  //                         isEditing = !isEditing;
  //                       });
  //
  //                       if (!isEditing) {
  //                         if (!_areDetailsValid()) {
  //                           ScaffoldMessenger.of(context).showSnackBar(
  //                             const SnackBar(
  //                               content: Text(
  //                                   "Please fill all personal and interested details before saving"),
  //                             ),
  //                           );
  //                           setState(() {
  //                             isEditing = true; // Keep in edit mode if validation fails
  //                           });
  //                           return;
  //                         }
  //
  //                         showDialog(
  //                           context: context,
  //                           barrierDismissible: false,
  //                           builder: (_) =>
  //                           const Center(child: CircularProgressIndicator()),
  //                         );
  //
  //                         final provider =
  //                         Provider.of<UserProvider>(context, listen: false);
  //                         final inquiryData = model.inquiryData;
  //
  //                         Map<String, dynamic> updatedData = {
  //                           'action': 'update',
  //                           'leadId': widget.inquiryId,
  //                           'fullName': inquiryData.fullName ?? '',
  //                           'mobileno': inquiryData.mobileno ?? '',
  //                           'altmobileno': '',
  //                           'email': '',
  //                           'houseno': '',
  //                           'society': '',
  //                           'area': inquiryData.area ?? '',
  //                           'city': inquiryData.city ?? '',
  //                           'countryCode': '',
  //                           'intrestedArea': selectedArea['name']!,
  //                           'intrestedAreaName': selectedArea['name']!,
  //                           'intrestedSiteId': selectedSite['id']!,
  //                           'budget': selectedBudget['id']!,
  //                           'purposeBuy': selectedPurpose['name']!,
  //                           'approxBuy': selectedBuyingTime['id']!,
  //                           'propertyConfiguration': selectedUnitType['id']!,
  //                           'inquiryType': inquiryData.inquiryType ?? '',
  //                           'inquirySourceType': inquiryData.inquirySourceType ?? '',
  //                           'description': inquiryData.remark ?? '',
  //                           'intrestedProduct': selectedSite['id']!,
  //                           'nxtFollowUp': nextFollowUpController.text.isNotEmpty
  //                               ? nextFollowUpController.text
  //                               : inquiryData.nxtFollowUp ?? '',
  //                         };
  //
  //                         final success = await provider.updateLead(
  //                           action: updatedData['action'] as String,
  //                           leadId: updatedData['leadId'] as String,
  //                           fullName: updatedData['fullName'] as String,
  //                           mobileno: updatedData['mobileno'] as String,
  //                           altmobileno: updatedData['altmobileno'] as String,
  //                           email: updatedData['email'] as String,
  //                           houseno: updatedData['houseno'] as String,
  //                           society: updatedData['society'] as String,
  //                           area: updatedData['area'] as String,
  //                           city: updatedData['city'] as String,
  //                           countryCode: updatedData['countryCode'] as String,
  //                           intrestedArea: updatedData['intrestedArea'] as String,
  //                           intrestedAreaName:
  //                           updatedData['intrestedAreaName'] as String,
  //                           interstedSiteName: updatedData['intrestedSiteId'] as String,
  //                           budget: updatedData['budget'] as String,
  //                           purposeBuy: updatedData['purposeBuy'] as String,
  //                           approxBuy: updatedData['approxBuy'] as String,
  //                           propertyConfiguration:
  //                           updatedData['propertyConfiguration'] as String,
  //                           inquiryType: updatedData['inquiryType'] as String,
  //                           inquirySourceType:
  //                           updatedData['inquirySourceType'] as String,
  //                           description: updatedData['description'] as String,
  //                           intrestedProduct: updatedData['intrestedProduct'] as String,
  //                           nxtFollowUp: updatedData['nxtFollowUp'] as String,
  //                         );
  //
  //                         Navigator.pop(context);
  //                         if (!success ?? false) {
  //                           ScaffoldMessenger.of(context).showSnackBar(
  //                             const SnackBar(
  //                                 content: Text("Lead updated successfully")),
  //                           );
  //                           provider.loadInquiryData(widget.inquiryId).then((_) {
  //                             setState(() {
  //                               isEditing = false;
  //                             });
  //                           });
  //                         } else {
  //                           ScaffoldMessenger.of(context).showSnackBar(
  //                             SnackBar(
  //                               content: Text(
  //                                 "Failed to update lead: ${provider.error ?? 'Unknown error'}",
  //                               ),
  //                             ),
  //                           );
  //                           setState(() {
  //                             isEditing = true;
  //                           });
  //                         }
  //                       }
  //                     },
  //                   ),
  //                 ),
  //
  //
  //             ],
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }
  Widget _infoTile<T>(
    String title,
    String value,
    List<T> options,
    ValueChanged<T> onChanged,
    bool showDropdown,
    String Function(T) displayString, {
    bool isRequired = false,
    required double fontScale,
  }) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: screenWidth * 0.4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title:",
            style: TextStyle(
              fontSize: 15 * fontScale,
              fontFamily: "poppins_thin",
            ),
          ),
          SizedBox(height: 5 * fontScale),
          showDropdown
              ? DropdownButton2<T>(
                  isExpanded: true,
                  hint: Text(
                    "Select $title",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.5 * fontScale,
                      fontFamily: "poppins_thin",
                    ),
                  ),
                  value:
                      options.isNotEmpty && value.isNotEmpty && value != "N/A"
                          ? options.firstWhere(
                              (option) => displayString(option) == value,
                              orElse: () => options[0],
                            )
                          : null,
                  underline: const SizedBox(width: 0),
                  buttonStyleData: ButtonStyleData(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 4 * fontScale,
                          spreadRadius: 2 * fontScale,
                        ),
                      ],
                    ),
                  ),
                  dropdownStyleData: DropdownStyleData(
                    offset: const Offset(-5, -10),
                    maxHeight: 200 * fontScale,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    elevation: 10,
                    scrollbarTheme: ScrollbarThemeData(
                      radius: const Radius.circular(40),
                      thickness: MaterialStateProperty.all(6 * fontScale),
                      thumbVisibility: MaterialStateProperty.all(true),
                    ),
                  ),
                  items: options.map((T item) {
                    return DropdownMenuItem<T>(
                      value: item,
                      child: Text(
                        displayString(item),
                        style: TextStyle(
                          fontFamily: "poppins_thin",
                          fontSize: 14 * fontScale,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (T? newValue) {
                    if (newValue != null) {
                      onChanged(newValue);
                    }
                  },
                )
              : Text(
                  value.isNotEmpty ? value : "N/A",
                  style: TextStyle(
                    fontFamily: "poppins_light",
                    fontWeight: FontWeight.bold,
                    fontSize: 12 * fontScale,
                  ),
                ),
        ],
      ),
    );
  }
  // Widget _infoTile<T>(
  //   String title,
  //   String value,
  //   List<T> options,
  //   ValueChanged<T> onChanged,
  //   bool showDropdown,
  //   String Function(T) displayString, {
  //   bool isRequired = false,
  // }) {
  //   return SizedBox(
  //     width: MediaQuery.of(context).size.width * 0.4,
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text("$title:", style: const TextStyle(fontWeight: FontWeight.bold)),
  //         const SizedBox(height: 5),
  //         showDropdown
  //             ? DropdownButton2<T>(
  //                 isExpanded: true,
  //                 hint: Text(
  //                   "Select $title",
  //                   style: const TextStyle(
  //                     color: Colors.black,
  //                     fontSize: 16,
  //                     fontFamily: "poppins_thin",
  //                   ),
  //                 ),
  //                 value:
  //                     options.isNotEmpty && value.isNotEmpty && value != "N/A"
  //                         ? options.firstWhere(
  //                             (option) => displayString(option) == value,
  //                             orElse: () => options[0],
  //                           )
  //                         : null,
  //                 underline: const SizedBox(width: 0),
  //                 buttonStyleData: ButtonStyleData(
  //                   decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(10),
  //                     color: Colors.white,
  //                     boxShadow: [
  //                       BoxShadow(
  //                         color: Colors.grey.shade300,
  //                         blurRadius: 4,
  //                         spreadRadius: 2,
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 dropdownStyleData: DropdownStyleData(
  //                   offset: const Offset(-5, -10),
  //                   maxHeight: 200,
  //                   decoration:
  //                       BoxDecoration(borderRadius: BorderRadius.circular(20)),
  //                   elevation: 10,
  //                   scrollbarTheme: ScrollbarThemeData(
  //                     radius: const Radius.circular(40),
  //                     thickness: MaterialStateProperty.all(6),
  //                     thumbVisibility: MaterialStateProperty.all(true),
  //                   ),
  //                 ),
  //                 items: options.map((T item) {
  //                   return DropdownMenuItem<T>(
  //                     value: item,
  //                     child: Text(
  //                       displayString(item),
  //                       style: const TextStyle(
  //                           fontFamily: "poppins_thin", fontSize: 13),
  //                     ),
  //                   );
  //                 }).toList(),
  //                 onChanged: (T? newValue) {
  //                   if (newValue != null) {
  //                     onChanged(newValue);
  //                   }
  //                 },
  //               )
  //             : Text(
  //                 value.isNotEmpty ? value : "N/A",
  //                 style: TextStyle(
  //                     fontFamily: "poppins_light", fontWeight: FontWeight.bold),
  //               ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildTabContent() {
    final screenSize = MediaQuery.of(context).size;
    final double scaleFactor = screenSize.width / 375.0; // Base width: 375px
    final double fontScale = scaleFactor.clamp(0.8, 1.2);
    final double paddingScale = scaleFactor.clamp(0.7, 1.5);

    switch (selectedTab) {
      case "Follow Up":
        return _buildFollowUpForm();
      case "Dismissed":
        return _buildDismissedForm();
      case "Appointment":
        return _buildAppointmentForm();
      case "Negotiations":
        return _buildOtherActionForm();
      case "Feedback":
        return _buildFeedBackActionForm();
      case "CNR":
        return Container(
          color: Colors.transparent,
        );
      default:
        return Container(
          color: Colors.transparent,
        );
    }
  }

  Widget _buildFollowUpForm() {
    // Get screen size information
    final screenSize = MediaQuery.of(context).size;
    final double scaleFactor =
        screenSize.width / 375.0; // Based on standard mobile width
    final double fontScale = scaleFactor.clamp(0.8, 1.2); // Limit scaling
    final double paddingScale = scaleFactor.clamp(0.7, 1.5);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: remarkController,
          decoration: InputDecoration(
            labelText: "Remark *",
            labelStyle: TextStyle(fontSize: 12 * fontScale),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15 * scaleFactor),
            ),
            hintText: "Your Message here...",
            hintStyle: TextStyle(fontSize: 12 * fontScale),
            contentPadding: EdgeInsets.all(10 * paddingScale),
          ),
          maxLines: 3,
          style: TextStyle(fontSize: 14 * fontScale),
          validator: (value) => value!.isEmpty ? "Remark is required" : null,
        ),
        SizedBox(height: 12.0 * paddingScale),
        Text(
          "Next Follow Up*",
          style: TextStyle(
            fontSize: 13 * fontScale,
            fontFamily: "poppins_thin",
          ),
        ),
        Row(
          children: [
            Expanded(
              flex: 3, // Give more space to the date field
              child: TextFormField(
                controller: nextFollowUpController,
                decoration: InputDecoration(
                  hintText: "Select Next Follow Up Date",
                  hintStyle: TextStyle(
                    fontSize: 12 * fontScale,
                    fontFamily: "poppins_light",
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8 * scaleFactor),
                  ),
                  suffixIcon:
                      Icon(Icons.calendar_today, size: 18 * scaleFactor),
                  contentPadding: EdgeInsets.all(10 * paddingScale),
                ),
                style: TextStyle(fontSize: 14 * fontScale),
                readOnly: true,
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      nextFollowUpController.text =
                          DateFormat('dd-MM-yyyy').format(picked);
                      _isFollowUpLoading = true;
                    });
                    await Provider.of<UserProvider>(context, listen: false)
                        .fetchNextSlots(
                            DateFormat('yyyy-MM-dd').format(picked));
                    setState(() {
                      _isFollowUpLoading = false;
                      selectedApxFollowUp = null;
                    });
                  }
                },
                validator: (value) =>
                    value!.isEmpty ? "Next follow-up date is required" : null,
              ),
            ),
            if (_isFollowUpLoading) ...[
              SizedBox(width: 8 * paddingScale),
              SizedBox(
                height: 16 * scaleFactor,
                width: 16 * scaleFactor,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5 * scaleFactor,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: 12 * paddingScale),
        Text(
          "Follow Up Time*",
          style: TextStyle(
            fontSize: 13 * fontScale,
            fontFamily: "poppins_thin",
          ),
        ),
        SizedBox(height: 4 * paddingScale),
        Consumer<UserProvider>(
          builder: (context, provider, child) {
            return provider.isLoading
                ? SizedBox(
                    height: 16 * scaleFactor,
                    width: 16 * scaleFactor,
                    child: CircularProgressIndicator(
                        strokeWidth: 1.5 * scaleFactor),
                  )
                : FormField<String>(
                    initialValue: selectedApxFollowUp,
                    validator: (value) =>
                        value == null ? "Follow up time is required" : null,
                    builder: (FormFieldState<String> state) {
                      return DropdownButton2<String>(
                        isExpanded: true,
                        hint: Text(
                          'Select Time',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12 * fontScale,
                            fontFamily: "poppins_thin",
                          ),
                        ),
                        value: selectedApxFollowUp,
                        underline: const SizedBox(width: 0),
                        buttonStyleData: ButtonStyleData(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8 * paddingScale),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(8 * scaleFactor),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 3 * scaleFactor,
                                spreadRadius: 1 * scaleFactor,
                              ),
                            ],
                          ),
                        ),
                        dropdownStyleData: DropdownStyleData(
                          offset: Offset(-5 * scaleFactor, -8 * scaleFactor),
                          maxHeight:
                              screenSize.height * 0.3, // 30% of screen height
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(15 * scaleFactor),
                          ),
                          elevation: 8,
                          scrollbarTheme: ScrollbarThemeData(
                            radius: Radius.circular(30 * scaleFactor),
                            thickness:
                                MaterialStateProperty.all(4 * scaleFactor),
                            thumbVisibility: MaterialStateProperty.all(true),
                          ),
                        ),
                        items: provider.nextSlots.isEmpty
                            ? [
                                DropdownMenuItem(
                                  value: null,
                                  enabled: false,
                                  child: Text(
                                    'No slots available',
                                    style: TextStyle(
                                      fontSize: 12 * fontScale,
                                      fontFamily: "poppins_thin",
                                    ),
                                  ),
                                ),
                              ]
                            : provider.nextSlots.map((slot) {
                                return DropdownMenuItem<String>(
                                  value: slot.source,
                                  enabled: slot.disabled,
                                  child: Text(
                                    slot.source ?? '',
                                    style: TextStyle(
                                      fontFamily: "poppins_thin",
                                      fontSize: 12 * fontScale,
                                      color: slot.disabled
                                          ? Colors.black
                                          : Colors.grey,
                                    ),
                                  ),
                                );
                              }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              selectedApxFollowUp = value;
                              state.didChange(value);
                            });
                          }
                        },
                      );
                    },
                  );
          },
        ),
      ],
    );
  }

  Widget _buildDismissedForm() {
    final inquiryProvider = Provider.of<UserProvider>(context, listen: false);
    List<Map<String, String>> closeReasonOptions = [];
    final screenSize = MediaQuery.of(context).size;
    final double scaleFactor = screenSize.width / 375.0; // Base width: 375px
    final double fontScale = scaleFactor.clamp(0.8, 1.2);
    final double paddingScale = scaleFactor.clamp(0.7, 1.5);

    if (selectedYesNo == "Yes") {
      closeReasonOptions = inquiryProvider.inquiryStatus?.yes
              ?.map(
                  (e) => {'id': e.id ?? '', 'name': e.inquiryCloseReason ?? ''})
              .toList() ??
          [];
    } else if (selectedYesNo == "No") {
      closeReasonOptions = inquiryProvider.inquiryStatus?.no
              ?.map(
                  (e) => {'id': e.id ?? '', 'name': e.inquiryCloseReason ?? ''})
              .toList() ??
          [];
    }

    if (closeReasonOptions.isEmpty) {
      return Center(
        child: Text(
          "No close reasons available",
          style: TextStyle(
            fontFamily: "poppins_thin",
            fontSize: 14 * fontScale, // Smaller font
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!showCloseReasonOnly)
          TextFormField(
            controller: remarkController,
            decoration: InputDecoration(
              labelText: "Remark *",
              labelStyle: TextStyle(fontSize: 12 * fontScale), // Smaller label
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(15 * scaleFactor), // Scaled radius
              ),
              hintText: "Your Message here...",
              hintStyle: TextStyle(fontSize: 12 * fontScale), // Smaller hint
              contentPadding:
                  EdgeInsets.all(10 * paddingScale), // Scaled padding
            ),
            maxLines: 3,
            style: TextStyle(fontSize: 14 * fontScale), // Smaller input text
            validator: (value) => value!.isEmpty ? "Remark is required" : null,
          ),
        SizedBox(height: 12 * paddingScale), // Scaled spacing
        Text(
          "Close Reason*",
          style: TextStyle(
            fontSize: 13 * fontScale, // Smaller text
            fontFamily: "poppins_thin",
          ),
        ),
        SizedBox(height: 4 * paddingScale), // Scaled spacing
        FormField<String>(
          initialValue: selectedCloseReason,
          validator: (value) =>
              value == null ? "Close reason is required" : null,
          builder: (FormFieldState<String> state) {
            return DropdownButton2<String>(
              isExpanded: true,
              hint: Text(
                'Select Close Reason',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12 * fontScale, // Smaller hint
                  fontFamily: "poppins_thin",
                ),
              ),
              value: selectedCloseReason,
              underline: const SizedBox(width: 0),
              buttonStyleData: ButtonStyleData(
                padding: EdgeInsets.symmetric(horizontal: 8 * paddingScale),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(8 * scaleFactor), // Scaled radius
                  color: Colors.grey.shade200,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 3 * scaleFactor, // Scaled shadow
                      spreadRadius: 1 * scaleFactor,
                    ),
                  ],
                ),
              ),
              dropdownStyleData: DropdownStyleData(
                offset: Offset(-5 * scaleFactor, -10 * scaleFactor),
                maxHeight: screenSize.height * 0.3, // 30% of screen height
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(15 * scaleFactor), // Scaled radius
                ),
                elevation: 8,
                scrollbarTheme: ScrollbarThemeData(
                  radius: Radius.circular(30 * scaleFactor), // Scaled radius
                  thickness: MaterialStateProperty.all(4 * scaleFactor),
                  thumbVisibility: MaterialStateProperty.all(true),
                ),
              ),
              items: closeReasonOptions.map((Map<String, String> item) {
                return DropdownMenuItem<String>(
                  value: item['id'],
                  child: Text(
                    item['name'] ?? '',
                    style: TextStyle(
                      fontFamily: "poppins_thin",
                      fontSize: 12 * fontScale, // Smaller text
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCloseReason = value;
                  state.didChange(value);
                });
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildAppointmentForm() {
    final screenSize = MediaQuery.of(context).size;
    final double scaleFactor = screenSize.width / 375.0; // Base width: 375px
    final double fontScale = scaleFactor.clamp(0.8, 1.2);
    final double paddingScale = scaleFactor.clamp(0.7, 1.5);

    return Consumer<UserProvider>(
      builder: (context, provider, child) {
        final dropdownData = provider.dropdownData;
        final siteOptions = dropdownData?.intSite ?? [];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: remarkController,
              decoration: InputDecoration(
                labelText: "Remark *",
                labelStyle:
                    TextStyle(fontSize: 12 * fontScale), // Smaller label
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(15 * scaleFactor), // Scaled radius
                ),
                hintText: "Your Message here...",
                hintStyle: TextStyle(fontSize: 12 * fontScale), // Smaller hint
                contentPadding:
                    EdgeInsets.all(10 * paddingScale), // Scaled padding
              ),
              maxLines: 3,
              style: TextStyle(fontSize: 14 * fontScale), // Smaller input text
              validator: (value) =>
                  value!.isEmpty ? "Remark is required" : null,
            ),
            SizedBox(height: 12 * paddingScale), // Scaled spacing
            DropdownButton2<String>(
              isExpanded: true,
              hint: Text(
                'Select Project',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12 * fontScale, // Smaller hint
                  fontFamily: "poppins_thin",
                ),
              ),
              value: selectedProjectId,
              underline: const SizedBox(width: 0),
              buttonStyleData: ButtonStyleData(
                padding: EdgeInsets.symmetric(horizontal: 8 * paddingScale),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(8 * scaleFactor), // Scaled radius
                  color: Colors.grey.shade200,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 3 * scaleFactor, // Scaled shadow
                      spreadRadius: 1 * scaleFactor,
                    ),
                  ],
                ),
              ),
              dropdownStyleData: DropdownStyleData(
                offset: Offset(-5 * scaleFactor, -10 * scaleFactor),
                maxHeight: screenSize.height * 0.3, // 30% of screen height
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(15 * scaleFactor), // Scaled radius
                ),
                elevation: 8,
                scrollbarTheme: ScrollbarThemeData(
                  radius: Radius.circular(30 * scaleFactor), // Scaled radius
                  thickness: MaterialStateProperty.all(4 * scaleFactor),
                  thumbVisibility: MaterialStateProperty.all(true),
                ),
              ),
              items: siteOptions.map((IntSite site) {
                return DropdownMenuItem<String>(
                  value: site.id,
                  child: Text(
                    site.productName,
                    style: TextStyle(
                      fontFamily: "poppins_thin",
                      fontSize: 12 * fontScale, // Smaller text
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedProjectId = value;
                });
              },
            ),
            SizedBox(height: 12 * paddingScale), // Scaled spacing
            Text(
              "Next Follow Up*",
              style: TextStyle(
                fontSize: 13 * fontScale, // Smaller text
                fontFamily: "poppins_thin",
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 3, // More space for date field
                  child: TextFormField(
                    controller: nextFollowUpController,
                    decoration: InputDecoration(
                      hintText: "Select Next Follow Up Date",
                      hintStyle: TextStyle(
                        fontSize: 12 * fontScale, // Smaller hint
                        fontFamily: "poppins_light",
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            8 * scaleFactor), // Scaled radius
                      ),
                      suffixIcon:
                          Icon(Icons.calendar_today, size: 18 * scaleFactor),
                      contentPadding:
                          EdgeInsets.all(10 * paddingScale), // Scaled padding
                    ),
                    style: TextStyle(
                        fontSize: 14 * fontScale), // Smaller input text
                    readOnly: true,
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() {
                          nextFollowUpController.text =
                              DateFormat('dd-MM-yyyy').format(picked);
                          _isAppointmentLoading = true;
                        });
                        await Provider.of<UserProvider>(context, listen: false)
                            .fetchNextSlots(
                                DateFormat('yyyy-MM-dd').format(picked));
                        setState(() {
                          _isAppointmentLoading = false;
                          selectedApxAppointment = null;
                        });
                      }
                    },
                    validator: (value) => value!.isEmpty
                        ? "Next follow-up date is required"
                        : null,
                  ),
                ),
                if (_isAppointmentLoading) ...[
                  SizedBox(width: 8 * paddingScale), // Scaled spacing
                  SizedBox(
                    height: 16 * scaleFactor,
                    width: 16 * scaleFactor,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5 * scaleFactor, // Scaled stroke
                      color: Colors.deepPurple,
                    ),
                  ),
                ],
              ],
            ),
            SizedBox(height: 12 * paddingScale), // Scaled spacing
            Text(
              "Follow Up Time*",
              style: TextStyle(
                fontSize: 13 * fontScale, // Smaller text
                fontFamily: "poppins_thin",
              ),
            ),
            SizedBox(height: 4 * paddingScale), // Scaled spacing
            Consumer<UserProvider>(
              builder: (context, provider, child) {
                return provider.isLoading
                    ? SizedBox(
                        height: 16 * scaleFactor,
                        width: 16 * scaleFactor,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5 * scaleFactor, // Scaled stroke
                        ),
                      )
                    : FormField<String>(
                        initialValue: selectedApxAppointment,
                        validator: (value) =>
                            value == null ? "Follow up time is required" : null,
                        builder: (FormFieldState<String> state) {
                          return DropdownButton2<String>(
                            isExpanded: true,
                            hint: Text(
                              'Select Time',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12 * fontScale, // Smaller hint
                                fontFamily: "poppins_thin",
                              ),
                            ),
                            value: selectedApxAppointment,
                            underline: const SizedBox(width: 0),
                            buttonStyleData: ButtonStyleData(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8 * paddingScale),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    8 * scaleFactor), // Scaled radius
                                color: Colors.grey.shade200,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade300,
                                    blurRadius:
                                        3 * scaleFactor, // Scaled shadow
                                    spreadRadius: 1 * scaleFactor,
                                  ),
                                ],
                              ),
                            ),
                            dropdownStyleData: DropdownStyleData(
                              offset:
                                  Offset(-5 * scaleFactor, -10 * scaleFactor),
                              maxHeight: screenSize.height *
                                  0.3, // 30% of screen height
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    15 * scaleFactor), // Scaled radius
                              ),
                              elevation: 8,
                              scrollbarTheme: ScrollbarThemeData(
                                radius: Radius.circular(
                                    30 * scaleFactor), // Scaled radius
                                thickness:
                                    MaterialStateProperty.all(4 * scaleFactor),
                                thumbVisibility:
                                    MaterialStateProperty.all(true),
                              ),
                            ),
                            items: provider.nextSlots.isEmpty
                                ? [
                                    DropdownMenuItem(
                                      value: null,
                                      enabled: false,
                                      child: Text(
                                        'No slots available',
                                        style: TextStyle(
                                          fontFamily: "poppins_thin",
                                          fontSize:
                                              12 * fontScale, // Smaller text
                                        ),
                                      ),
                                    ),
                                  ]
                                : provider.nextSlots.map((slot) {
                                    return DropdownMenuItem<String>(
                                      value: slot.source,
                                      enabled: slot.disabled,
                                      child: Text(
                                        slot.source ?? '',
                                        style: TextStyle(
                                          fontFamily: "poppins_thin",
                                          fontSize:
                                              12 * fontScale, // Smaller text
                                          color: slot.disabled
                                              ? Colors.black
                                              : Colors.grey,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  selectedApxAppointment = value;
                                  state.didChange(value);
                                });
                              }
                            },
                          );
                        },
                      );
              },
            ),
            SizedBox(height: 12 * paddingScale), // Scaled spacing
            Text(
              "Appointment Date and Time*",
              style: TextStyle(
                fontSize: 13 * fontScale, // Smaller text
                fontFamily: "poppins_thin",
              ),
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: "Select Appointment Date and Time",
                hintStyle: TextStyle(
                  fontSize: 12 * fontScale, // Smaller hint
                  fontFamily: "poppins_light",
                ),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(8 * scaleFactor), // Scaled radius
                ),
                suffixIcon: Icon(Icons.calendar_today, size: 18 * scaleFactor),
                contentPadding:
                    EdgeInsets.all(10 * paddingScale), // Scaled padding
              ),
              controller: TextEditingController(
                text: appointmentDate != null
                    ? DateFormat('dd-MM-yyyy HH:mm').format(appointmentDate!)
                    : '',
              ),
              style: TextStyle(fontSize: 14 * fontScale), // Smaller input text
              readOnly: true,
              onTap: () async {
                await _pickAppointmentDate();
              },
              validator: (value) => value!.isEmpty
                  ? "Appointment date and time are required"
                  : null,
            ),
          ],
        );
      },
    );
  }

  Widget _buildOtherActionForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: remarkController,
          decoration: InputDecoration(
            labelText: "Remark *",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            hintText: "Your Message here...",
          ),
          maxLines: 3,
          validator: (value) => value!.isEmpty ? "Remark is required" : null,
        ),
        const SizedBox(height: 16.0),
        const Text(
          "Next Follow Up*",
          style: TextStyle(fontSize: 13, fontFamily: "poppins_thin"),
        ),
        TextFormField(
          controller: otherActionController,
          decoration: InputDecoration(
            hintText: "Select Next Follow Up Date",
            hintStyle: const TextStyle(fontFamily: "poppins_light"),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            suffixIcon: const Icon(Icons.calendar_today),
          ),
          readOnly: true,
          onTap: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              setState(() {
                otherActionController.text =
                    DateFormat('dd-MM-yyyy').format(picked);
                _isOtherLoading = true; // Show loading indicator
              });
              await Provider.of<UserProvider>(context, listen: false)
                  .fetchNextSlots(DateFormat('yyyy-MM-dd').format(picked));
              setState(() {
                _isOtherLoading = false;
                selectedApxOther =
                    null; // Reset to ensure user selects a new time
              });
            }
          },
          validator: (value) =>
              value!.isEmpty ? "Next follow-up date is required" : null,
        ),
        if (_isOtherLoading) ...[
          const SizedBox(height: 10),
          const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
                strokeWidth: 2, color: Colors.deepPurple),
          ),
        ],
        const SizedBox(height: 16),
        const Text(
          "Follow Up Time*",
          style: TextStyle(fontSize: 13, fontFamily: "poppins_thin"),
        ),
        const SizedBox(height: 5),
        Consumer<UserProvider>(
          builder: (context, provider, child) {
            return provider.isLoading || _isOtherLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : FormField<String>(
                    initialValue: selectedApxOther,
                    validator: (value) =>
                        value == null ? "Follow up time is required" : null,
                    builder: (FormFieldState<String> state) {
                      return DropdownButton2<String>(
                        isExpanded: true,
                        hint: const Text(
                          'Select Time',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                            fontFamily: "poppins_thin",
                          ),
                        ),
                        value: selectedApxOther,
                        underline: const SizedBox(width: 0),
                        buttonStyleData: ButtonStyleData(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade200,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 4,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                        dropdownStyleData: DropdownStyleData(
                          offset: const Offset(-5, -10),
                          maxHeight: 200,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          elevation: 10,
                          scrollbarTheme: ScrollbarThemeData(
                            radius: const Radius.circular(40),
                            thickness: MaterialStateProperty.all(6),
                            thumbVisibility: MaterialStateProperty.all(true),
                          ),
                        ),
                        items: provider.nextSlots.isEmpty
                            ? [
                                const DropdownMenuItem(
                                  value: null,
                                  enabled: false,
                                  child: Text(
                                    'No slots available',
                                    style:
                                        TextStyle(fontFamily: "poppins_thin"),
                                  ),
                                ),
                              ]
                            : provider.nextSlots.map((slot) {
                                return DropdownMenuItem<String>(
                                  value: slot.source,
                                  enabled: slot.disabled,
                                  child: Text(
                                    slot.source ?? '',
                                    style: TextStyle(
                                      fontFamily: "poppins_thin",
                                      fontSize: 16,
                                      color: slot.disabled
                                          ? Colors.black
                                          : Colors.grey,
                                    ),
                                  ),
                                );
                              }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              selectedApxOther = value;
                              state.didChange(value); // Update FormField state
                            });
                          }
                        },
                      );
                    },
                  );
          },
        ),
      ],
    );
  }

  Widget _buildFeedBackActionForm() {
    final screenSize = MediaQuery.of(context).size;
    final double scaleFactor = screenSize.width / 375.0; // Base width: 375px
    final double fontScale = scaleFactor.clamp(0.8, 1.2);
    final double paddingScale = scaleFactor.clamp(0.7, 1.5);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: remarkController,
          decoration: InputDecoration(
            labelText: "Remark *",
            labelStyle: TextStyle(fontSize: 12 * fontScale), // Smaller label
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(15 * scaleFactor), // Scaled radius
            ),
            hintText: "Your Message here...",
            hintStyle: TextStyle(fontSize: 12 * fontScale), // Smaller hint
            contentPadding: EdgeInsets.all(10 * paddingScale), // Scaled padding
          ),
          maxLines: 3,
          style: TextStyle(fontSize: 14 * fontScale), // Smaller input text
          validator: (value) => value!.isEmpty ? "Remark is required" : null,
        ),
        SizedBox(height: 12 * paddingScale), // Scaled spacing
        Text(
          "Next Follow Up*",
          style: TextStyle(
            fontSize: 13 * fontScale, // Smaller text
            fontFamily: "poppins_thin",
          ),
        ),
        TextFormField(
          controller: FeedbackActionController,
          decoration: InputDecoration(
            hintText: "Select Next Follow Up Date",
            hintStyle: TextStyle(
              fontSize: 12 * fontScale, // Smaller hint
              fontFamily: "poppins_light",
            ),
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(8 * scaleFactor), // Scaled radius
            ),
            suffixIcon: Icon(Icons.calendar_today, size: 18 * scaleFactor),
            contentPadding: EdgeInsets.all(10 * paddingScale), // Scaled padding
          ),
          style: TextStyle(fontSize: 14 * fontScale), // Smaller input text
          readOnly: true,
          onTap: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              setState(() {
                FeedbackActionController.text =
                    DateFormat('dd-MM-yyyy').format(picked);
                Provider.of<UserProvider>(context, listen: false)
                    .fetchNextSlots(DateFormat('yyyy-MM-dd').format(picked));
                selectedApxFeedback = null;
              });
            }
          },
          validator: (value) =>
              value!.isEmpty ? "Next follow-up date is required" : null,
        ),
        SizedBox(height: 12 * paddingScale), // Scaled spacing
        Text(
          "Follow Up Time*",
          style: TextStyle(
            fontSize: 13 * fontScale, // Smaller text
            fontFamily: "poppins_thin",
          ),
        ),
        SizedBox(height: 4 * paddingScale), // Scaled spacing
        Consumer<UserProvider>(
          builder: (context, provider, child) {
            return provider.isLoading
                ? SizedBox(
                    height: 16 * scaleFactor,
                    width: 16 * scaleFactor,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5 * scaleFactor, // Scaled stroke
                    ),
                  )
                : FormField<String>(
                    initialValue: selectedApxFeedback,
                    validator: (value) =>
                        value == null ? "Follow up time is required" : null,
                    builder: (FormFieldState<String> state) {
                      return DropdownButton2<String>(
                        isExpanded: true,
                        hint: Text(
                          'Select Time',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12 * fontScale, // Smaller hint
                            fontFamily: "poppins_thin",
                          ),
                        ),
                        value: selectedApxFeedback,
                        underline: const SizedBox(width: 0),
                        buttonStyleData: ButtonStyleData(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8 * paddingScale),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                8 * scaleFactor), // Scaled radius
                            color: Colors.grey.shade200,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 3 * scaleFactor, // Scaled shadow
                                spreadRadius: 1 * scaleFactor,
                              ),
                            ],
                          ),
                        ),
                        dropdownStyleData: DropdownStyleData(
                          offset: Offset(-5 * scaleFactor, -10 * scaleFactor),
                          maxHeight:
                              screenSize.height * 0.3, // 30% of screen height
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                15 * scaleFactor), // Scaled radius
                          ),
                          elevation: 8,
                          scrollbarTheme: ScrollbarThemeData(
                            radius: Radius.circular(
                                30 * scaleFactor), // Scaled radius
                            thickness:
                                MaterialStateProperty.all(4 * scaleFactor),
                            thumbVisibility: MaterialStateProperty.all(true),
                          ),
                        ),
                        items: provider.nextSlots.isEmpty
                            ? [
                                DropdownMenuItem(
                                  value: null,
                                  enabled: false,
                                  child: Text(
                                    'No slots available',
                                    style: TextStyle(
                                      fontFamily: "poppins_thin",
                                      fontSize: 12 * fontScale, // Smaller text
                                    ),
                                  ),
                                ),
                              ]
                            : provider.nextSlots.map((slot) {
                                return DropdownMenuItem<String>(
                                  value: slot.source,
                                  enabled: slot.disabled,
                                  child: Text(
                                    slot.source ?? '',
                                    style: TextStyle(
                                      fontFamily: "poppins_thin",
                                      fontSize: 12 * fontScale, // Smaller text
                                      color: slot.disabled
                                          ? Colors.black
                                          : Colors.grey,
                                    ),
                                  ),
                                );
                              }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              selectedApxFeedback = value;
                              state.didChange(value);
                            });
                          }
                        },
                      );
                    },
                  );
          },
        ),
      ],
    );
  }

  Widget _remarkSection(List<ProcessedData> processedData) {
    final screenSize = MediaQuery.of(context).size;
    final double scaleFactor = screenSize.width / 375.0; // Base width: 375px
    final double fontScale = scaleFactor.clamp(0.8, 1.2);
    final double paddingScale = scaleFactor.clamp(0.7, 1.5);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (processedData.isNotEmpty)
          Text(
            "Timeline",
            style: TextStyle(
              fontFamily: "poppins_thin",
              fontSize: 15 * fontScale, // Smaller text (18 → 16)
            ),
          ),
        if (processedData.isNotEmpty)
          SizedBox(
            width: double.infinity,
            child: Timeline.tileBuilder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              theme: TimelineThemeData(
                direction: Axis.vertical,
                connectorTheme: ConnectorThemeData(
                  color: Colors.grey.shade400, // Softer grey for a modern look
                  thickness: 2.0 * scaleFactor, // Scaled thickness
                ),
                indicatorTheme: IndicatorThemeData(
                  size: 10 * scaleFactor, // Smaller indicator
                  color: Colors.deepPurple, // Consistent color
                ),
                nodePosition: 0.1,
              ),
              builder: TimelineTileBuilder.connected(
                itemCount: processedData.length,
                connectionDirection: ConnectionDirection.before,
                indicatorBuilder: (_, index) => DotIndicator(
                  color: Colors.deepPurple,
                  size: 10 * scaleFactor, // Smaller indicator
                ),
                connectorBuilder: (_, index, __) => SolidLineConnector(
                  color: Colors.grey.shade400, // Matching connector color
                  thickness: 2 * scaleFactor, // Scaled thickness
                ),
                contentsBuilder: (context, index) {
                  final item = processedData[index];
                  final formattedDate = formatCreatedAt(item.createdAt ?? '');
                  final screenSize = MediaQuery.of(context).size;
                  final double scaleFactor =
                      screenSize.width / 375.0; // Base width: 375px
                  final double fontScale =
                      scaleFactor.clamp(0.8, 1.2); // Limit font scaling
                  final double paddingScale =
                      scaleFactor.clamp(0.7, 1.5); // Limit padding scaling

                  return Padding(
                    padding: EdgeInsets.only(
                      left: 16 * paddingScale,
                      right: 8 * paddingScale,
                      top: 8 * paddingScale,
                      bottom: 8 * paddingScale,
                    ),
                    child: Container(
                      width: screenSize.width -
                          (64 * scaleFactor), // Responsive width
                      padding:
                          EdgeInsets.all(12 * paddingScale), // Scaled padding
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                            12 * scaleFactor), // Scaled radius
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.grey.withOpacity(0.15), // Softer shadow
                            blurRadius: 6 * scaleFactor,
                            spreadRadius: 1 * scaleFactor,
                            offset: Offset(0, 3 * scaleFactor),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 4 * paddingScale,
                              horizontal: 8 * paddingScale,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade400,
                              borderRadius: BorderRadius.circular(
                                  8 * scaleFactor), // Scaled radius
                            ),
                            child: Text(
                              item.statusLabel ?? '-',
                              style: TextStyle(
                                fontFamily: "poppins_thin",
                                color: Colors.white,
                                fontSize: 10 * fontScale, // Smaller text
                                fontWeight: FontWeight.w500, // Slight boldness
                              ),
                            ),
                          ),
                          SizedBox(height: 6 * paddingScale), // Scaled spacing
                          Row(
                            children: [
                              Icon(
                                Icons.person,
                                size: 14 * scaleFactor, // Smaller icon
                                color: Colors.grey.shade600, // Softer grey
                              ),
                              SizedBox(width: 4 * paddingScale),
                              Text(
                                item.username ?? '-',
                                style: TextStyle(
                                  fontFamily: "poppins_thin",
                                  fontSize: 12 * fontScale, // Smaller text
                                  fontWeight:
                                      FontWeight.w600, // Bold for emphasis
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2 * paddingScale), // Scaled spacing
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 14 * scaleFactor, // Smaller icon
                                color: Colors.grey.shade600,
                              ),
                              SizedBox(width: 4 * paddingScale),
                              Text(
                                "Next: ${item.nxtFollowDate ?? '-'}",
                                style: TextStyle(
                                  fontFamily: "poppins_thin",
                                  fontSize: 10 * fontScale, // Smaller text
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6 * paddingScale), // Scaled spacing
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                size: 14 * scaleFactor, // Smaller icon
                                color: Colors.grey.shade600,
                              ),
                              SizedBox(width: 6 * paddingScale),
                              Expanded(
                                child: Text(
                                  item.remarkText ?? 'No remark',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: "poppins_thin",
                                    fontSize: 12 * fontScale, // Smaller text
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6 * paddingScale), // Scaled spacing
                          Text(
                            "${formattedDate['date']} - ${formattedDate['time']}",
                            style: TextStyle(
                              fontFamily: "poppins_thin",
                              fontSize: 10 * fontScale, // Smaller text
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          )
      ],
    );
  }
}

class CombinedDropdownTextField<T> extends StatelessWidget {
  final List<T> options;
  final String Function(T) displayString;
  final ValueChanged<T> onSelected;
  final ValueChanged<String> onTextChanged;
  final T initialValue;
  final bool isRequired;
  final ValueChanged<String> onEditingComplete;

  const CombinedDropdownTextField({
    Key? key,
    required this.options,
    required this.displayString,
    required this.onSelected,
    required this.onTextChanged,
    required this.initialValue,
    required this.isRequired,
    required this.onEditingComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton2<T>(
      isExpanded: true,
      hint: const Text(
        "Select Area",
        style: TextStyle(fontFamily: "poppins_thin", fontSize: 13),
      ),
      value: options.contains(initialValue) ? initialValue : null,
      underline: const SizedBox(), // Removes default underline
      buttonStyleData: ButtonStyleData(
        padding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: 8), // Matches `_infoTile`
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 4,
              spreadRadius: 2,
            ),
          ],
        ),
      ),
      dropdownStyleData: DropdownStyleData(
        offset: const Offset(10, 10), // Matches `_infoTile`
        maxHeight: 200, // Matches `_infoTile`
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        elevation: 10, // Matches `_infoTile`
        scrollbarTheme: ScrollbarThemeData(
          radius: const Radius.circular(40),
          thickness: MaterialStateProperty.all(6),
          thumbVisibility: MaterialStateProperty.all(true),
        ),
      ),
      items: options.map((T item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(
            displayString(item),
            style: const TextStyle(
              fontFamily: "poppins_thin",
              fontSize: 13.3,
            ),
          ),
        );
      }).toList(),
      onChanged: (T? newValue) {
        if (newValue != null) {
          onSelected(newValue);
        }
      },
    );
  }
}

class MainButtonGroup extends StatefulWidget {
  final List<String> buttonTexts;
  final String selectedButton;
  final ValueChanged<String> onButtonPressed;

  const MainButtonGroup({
    Key? key,
    required this.buttonTexts,
    required this.selectedButton,
    required this.onButtonPressed,
  }) : super(key: key);

  @override
  _MainButtonGroupState createState() => _MainButtonGroupState();
}

class _MainButtonGroupState extends State<MainButtonGroup> {
  late String _selectedButton;

  @override
  void initState() {
    super.initState();
    _selectedButton = widget.selectedButton;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: widget.buttonTexts.map((text) => _buildButton(text)).toList(),
    );
  }

  Widget _buildButton(String text) {
    final bool isSelected = _selectedButton == text;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isSelected ? Colors.deepPurple.shade100 : Colors.white,
          foregroundColor: isSelected ? Colors.deepPurple : Colors.black,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(
                color: isSelected ? Colors.deepPurple : Colors.grey.shade300),
          ),
        ),
        onPressed: () {
          setState(() {
            _selectedButton = text;
          });
          widget.onButtonPressed(text);
        },
        child: Text(text,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      ),
    );
  }
}

Future<void> _launchEmail({
  required String email,
  required String subject,
  required String body,
}) async {
  // Construct mailto URI with encoded subject and body
  String encodedSubject = Uri.encodeComponent(subject);
  String encodedBody = Uri.encodeComponent(body);
  String mailUri = 'mailto:$email?subject=$encodedSubject&body=$encodedBody';

  if (await canLaunchUrl(Uri.parse(mailUri))) {
    await launchUrl(Uri.parse(mailUri), mode: LaunchMode.externalApplication);
  } else {
    // Fallback: try without subject/body
    String fallbackUri = 'mailto:$email';

    if (await canLaunchUrl(Uri.parse(fallbackUri))) {
      await launchUrl(Uri.parse(fallbackUri),
          mode: LaunchMode.externalApplication);
    } else {}
  }
}

Future<void> _launchSMS(String phoneNumber, String message) async {
  String encodedMessage = Uri.encodeComponent(message);
  String smsUri = 'sms:$phoneNumber?body=$encodedMessage';

  if (await canLaunchUrl(Uri.parse(smsUri))) {
    await launchUrl(Uri.parse(smsUri), mode: LaunchMode.externalApplication);
  } else {
    await _tryFallback(phoneNumber, message);
  }
}

Future<void> _tryFallback(String phoneNumber, String message) async {
  String fallbackUri = 'sms:$phoneNumber';

  if (await canLaunchUrl(Uri.parse(fallbackUri))) {
    await launchUrl(Uri.parse(fallbackUri),
        mode: LaunchMode.externalApplication);
  } else {
    // Try SMSTO scheme as last resort
    String smstoUri = 'smsto:$phoneNumber?body=${Uri.encodeComponent(message)}';
    if (await canLaunchUrl(Uri.parse(smstoUri))) {
      await launchUrl(Uri.parse(smstoUri),
          mode: LaunchMode.externalApplication);
    } else {}
  }
}

Future<void> _makeDirectPhoneCall(
    String phoneNumber, BuildContext context) async {
  // Clean the phone number
  phoneNumber = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
  if (!phoneNumber.startsWith('+')) {
    phoneNumber = '$phoneNumber'; // Add country code if needed
  }

  // Request CALL_PHONE permission
  final permissionStatus = await Permission.phone.request();

  if (permissionStatus.isGranted) {
    final phoneUrl = Uri.parse('tel:$phoneNumber');
    try {
      await launchUrl(
          phoneUrl); // This will attempt to call directly on Android
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error making call: $e')),
      );
    }
  } else if (permissionStatus.isDenied) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Call permission denied')),
    );
  } else if (permissionStatus.isPermanentlyDenied) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Please enable call permission in settings')),
    );
    await openAppSettings(); // Prompt user to enable permission in settings
  }
}

// Function to launch WhatsApp
Future<void> _launchWhatsApp(String phoneNumber, String message) async {
  // Remove any non-digit characters except the leading '+' from phoneNumber
  String cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
  String encodedMessage = Uri.encodeComponent(message);
  // WhatsApp URL scheme: whatsapp://send?phone={number}&text={message}
  String whatsappUri =
      'whatsapp://send?phone=$cleanNumber&text=$encodedMessage';

  if (await canLaunchUrl(Uri.parse(whatsappUri))) {
    await launchUrl(Uri.parse(whatsappUri),
        mode: LaunchMode.externalApplication);
  } else {
    const SnackBar(content: Text('WhatsApp not available'));
  }
}

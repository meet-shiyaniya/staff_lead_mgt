import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:hr_app/Inquiry_Management/Utils/Custom%20widgets/custom_buttons.dart';
import 'package:hr_app/Provider/UserProvider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:timelines_plus/timelines_plus.dart';
import 'package:lottie/lottie.dart';
import 'dart:convert'; // For jsonEncode

import '../../Model/Api Model/add_Lead_Model.dart';
import '../../Model/Api Model/inquiry_transfer_Model.dart';
import '../Colors/app_Colors.dart';

class InquiryScreen extends StatefulWidget {
  final String inquiryId;

  const InquiryScreen({required this.inquiryId});

  @override
  _InquiryScreenState createState() => _InquiryScreenState();
}

class _InquiryScreenState extends State<InquiryScreen> {
  String selectedTab = "Follow Up";
  late List<String> tabs;
  bool isEditing = false;
  bool showCloseReasonOnly = false;

  Map<String, String>? selectedArea; // {id, name}
  Map<String, String>? selectedSite; // {id, name}
  Map<String, String>? selectedUnitType; // {id, name}
  Map<String, String>? selectedBudget; // {id, name}
  Map<String, String>? selectedPurpose; // {id, name}
  Map<String, String>? selectedBuyingTime; // {id, name}

  String? selectedApxFollowUp;
  String? selectedApxAppointment;
  String? selectedApxOther;
  bool isDismissed = false;
  final TextEditingController nextFollowUpController = TextEditingController();
  final TextEditingController otherActionController = TextEditingController();
  final TextEditingController remarkController = TextEditingController();
  String? selectedCloseReason;
  String? selectedIntMembership;
  DateTime? appointmentDate;
  String? selectedProjectId; // Changed to store ID

  final List<String> timeOptions = ["8:00", "9:00", "10:00", "11:00", "12:00"];
  final List<String> closeReasonOptions = ["Budget Problem", "Not Required", "Muscles"];
  final List<String> intMembershipOptions = ["Package 1", "Package 2", "Package 3"];

  void _fetchInitialSlots() {
    Provider.of<UserProvider>(context, listen: false)
        .fetchNextSlots(DateFormat('yyyy-MM-dd').format(DateTime.now()));
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
            selectedArea = {
              'id': areaOptions.isNotEmpty
                  ? areaOptions.firstWhere(
                    (area) => area.area == (inquiryModel.inquiryData.intrestedArea ?? ""),
                orElse: () => AreaCityCountry(id: "", area: "", city: "", state: "", country: ""),
              ).id
                  : "",
              'name': inquiryModel.inquiryData.intrestedArea ?? "",
            };
            print("Initial Selected Area: $selectedArea");
          });
        }
      });
      provider.fetchAddLeadData();
    });
  }

  Map<String, String> formatCreatedAt(String createdAt) {
    try {
      DateTime parsedDate = DateTime.parse(createdAt);
      return {
        'date': DateFormat("dd MMM yyyy").format(parsedDate),
        'time': DateFormat("hh:mm a").format(parsedDate),
      };
    } catch (e) {
      return {'date': createdAt, 'time': 'N/A'};
    }
  }

  String? selectedYesNo;

  void showDismissedConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Dismiss Inquiry?", style: TextStyle(fontFamily: "poppins_thin")),
          content: Container(
            height: 230,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset("asset/Inquiry_module/errors.json", height: 170, width: 170),
                Center(
                  child: Text(
                    "Did you have a conversation with this inquiry?",
                    style: TextStyle(fontFamily: "poppins_thin", fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  isDismissed = true;
                  showCloseReasonOnly = false;
                  selectedYesNo = "Yes"; // Set selected option to Yes
                });
                Navigator.pop(context);
                _buildDismissedForm(); // Open the reason selection dialog
              },
              child: const Text("Yes", style: TextStyle(fontFamily: "poppins_thin")),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  showCloseReasonOnly = true;
                  selectedYesNo = "No"; // Set selected option to No
                });
                Navigator.pop(context);
                _buildDismissedForm(); // Open the reason selection dialog
              },
              child: const Text("No", style: TextStyle(fontFamily: "poppins_thin")),
            ),
          ],
        );
      },
    );
  }


  Future<void> _pickAppointmentDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        appointmentDate = pickedDate;
      });
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
      selectedProjectId = null; // Changed from selectedProject
      showCloseReasonOnly = false;
      selectedApxFollowUp = null;
      selectedApxAppointment = null;
      selectedApxOther = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, inquiryProvider, child) {
        if (inquiryProvider.isLoading || inquiryProvider.isLoadingDropdown) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final inquiryModel = inquiryProvider.inquiryModel;
        final dropdownData = inquiryProvider.dropdownData;

        if (inquiryModel == null) {
          return Scaffold(body: Center(child: Text("Failed to load inquiry data")));
        }
        if (dropdownData == null) {
          return Scaffold(
              body: Center(
                  child: Text(
                      inquiryProvider.errorMessage ?? "Failed to load dropdown data")));
        }

        tabs = ["Follow Up", "Dismissed", "Appointment", "CNR"];
        if (inquiryModel.inquiryData.issitevisit != null) {
          try {
            int siteVisitCount = int.parse(inquiryModel.inquiryData.issitevisit);
            if (siteVisitCount > 0) {
              tabs = [
                "Follow Up",
                "Dismissed",
                "Appointment",
                "CNR",
                "Negotiations",
                "Feedback",
              ];
            }
          } catch (e) {
            print("Error parsing isSiteVisit: $e");
          }
        }

        bool showFullUI = inquiryModel.modelHeaderAccess == 1;
        bool isEditable = inquiryModel.fillInterstCheck == 1;

        final List<AreaCityCountry> areaOptions = dropdownData.areaCityCountry ?? [];
        final List<IntSite> siteOptions = dropdownData.intSite ?? [];
        final List<PropertyConfiguration> unitOptions =
            dropdownData.propertyConfiguration ?? [];
        final List<Map<String, String>> budgetOptions = dropdownData.budget?.values
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
        final List<Map<String, String>> buyingTimeOptions =
            dropdownData.apxTime?.apxTimeData
                .split(',')
                .map((time) => time.trim())
                .where((time) => time.isNotEmpty)
                .map((t) => {'id': t, 'name': t})
                .toList() ??
                [];

        if (!isEditable) {
          if (selectedSite == null) {
            selectedSite = {
              'id': siteOptions.firstWhere(
                    (site) => site.productName == (inquiryModel.intrestedProduct ?? ""),
                orElse: () => IntSite(id: "", productName: ""),
              ).id,
              'name': inquiryModel.intrestedProduct ?? "",
            };
          }
          if (selectedUnitType == null) {
            selectedUnitType = {
              'id': unitOptions.firstWhere(
                    (unit) =>
                unit.propertyType ==
                    (inquiryModel.propertyConfigurationType ?? "1 BHK"),
                orElse: () => PropertyConfiguration(id: "", propertyType: "1 BHK"),
              ).id,
              'name': inquiryModel.propertyConfigurationType ?? "1 BHK",
            };
          }
          if (selectedBudget == null) {
            selectedBudget = {
              'id': inquiryModel.inquiryData.budget ?? "",
              'name': inquiryModel.inquiryData.budget ?? "",
            };
          }
          if (selectedPurpose == null) {
            selectedPurpose = {
              'id': inquiryModel.inquiryData.purposeBuy ?? "",
              'name': inquiryModel.inquiryData.purposeBuy ?? "",
            };
          }
          if (selectedBuyingTime == null) {
            selectedBuyingTime = {
              'id': inquiryModel.inquiryData.approxBuy ?? "",
              'name': inquiryModel.inquiryData.approxBuy ?? "",
            };
          }
        }

        return Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            title: Text(
              "Inquiry Details",
              style: TextStyle(fontFamily: "poppins_thin", color: Colors.white),
            ),
            backgroundColor: AppColor.Buttoncolor,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: _buildPersonalAndInterestedDetails(
                            inquiryModel,
                            isEditable,
                            areaOptions,
                            siteOptions,
                            unitOptions,
                            budgetOptions,
                            purposeOptions,
                            buyingTimeOptions,
                          ),
                        ),
                      ),
                      if (showFullUI) ...[
                        SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: MainButtonGroup(
                            buttonTexts: tabs,
                            selectedButton: selectedTab,
                            onButtonPressed: _handleTabChange,
                          ),
                        ),
                        SizedBox(height: 10),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: _buildTabContent(),
                          ),
                        ),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: _remarkSection(inquiryModel.processedData),
                          ),
                        ),
                      ],
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GradientButton(
                  buttonText: "Submit",
                  onPressed: () async {
                    Map<String, dynamic> formData = {
                      'remark': remarkController.text,
                    };

                    int interest = isEditing ? 1 : 0;

                    switch (selectedTab.toLowerCase()) {
                      case 'follow up':
                        formData.addAll({
                          'nextFollowUp': nextFollowUpController.text,
                          'callTime': selectedApxFollowUp,
                        });
                        break;

                      case 'dismissed':
                        formData.addAll({
                          'inquiry_close_reason': selectedCloseReason ?? '', // Use the ID directly
                        });
                        break;

                      case 'appointment':
                        formData.addAll({
                          'nextFollowUp': nextFollowUpController.text,
                          'callTime': selectedApxAppointment,
                          'appointDate': appointmentDate != null
                              ? DateFormat('dd-MM-yyyy').format(appointmentDate!)
                              : '',
                          'interestedProduct': selectedProjectId, // Add selected project id
                        });
                        break;

                      case 'negotiation':
                      case 'feedback':
                        formData.addAll({
                          'nextFollowUp': otherActionController.text,
                          'callTime': selectedApxOther,
                          'appointDate': appointmentDate != null
                              ? DateFormat('dd-MM-yyyy').format(appointmentDate!)
                              : '',
                        });
                        break;

                      case 'cnr':
                        formData.addAll({
                          'nextFollowUp': nextFollowUpController.text,
                          'callTime': selectedApxFollowUp,
                          'appointDate': appointmentDate != null
                              ? DateFormat('dd-MM-yyyy').format(appointmentDate!)
                              : '',
                        });
                        break;
                    }

                    final provider = Provider.of<UserProvider>(context, listen: false);
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => Center(child: CircularProgressIndicator()),
                    );

                    final success = await provider.updateInquiryStatus(
                      inquiryId: widget.inquiryId,
                      selectedTab: selectedTab,
                      formData: formData,
                      interestedProduct: selectedTab.toLowerCase() == 'appointment'
                          ? selectedProjectId
                          : selectedSite?['id'],
                      isSiteVisit: int.tryParse(inquiryModel?.inquiryData.issitevisit ?? '0') ?? 0,
                      interest: interest,
                    );

                    Navigator.pop(context);

                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Status updated successfully")),
                      );
                      setState(() {
                        remarkController.clear();
                        nextFollowUpController.clear();
                        otherActionController.clear();
                        selectedCloseReason = null;
                        appointmentDate = null;
                        selectedProjectId = null;
                        selectedApxFollowUp = null;
                        selectedApxAppointment = null;
                        selectedApxOther = null;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Failed to update status: ${provider.error}")),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPersonalAndInterestedDetails(
      InquiryModel model,
      bool isEditable,
      List<AreaCityCountry> areaOptions,
      List<IntSite> siteOptions,
      List<PropertyConfiguration> unitOptions,
      List<Map<String, String>> budgetOptions,
      List<Map<String, String>> purposeOptions,
      List<Map<String, String>> buyingTimeOptions) {
    bool hasNullField = model.inquiryData.intrestedArea == null ||
        model.inquiryData.intrestedArea!.isEmpty ||
        model.intrestedProduct == null ||
        model.intrestedProduct!.isEmpty ||
        model.propertyConfigurationType == null ||
        model.propertyConfigurationType!.isEmpty ||
        model.inquiryData.budget == null ||
        model.inquiryData.budget!.isEmpty ||
        model.inquiryData.purposeBuy == null ||
        model.inquiryData.purposeBuy!.isEmpty ||
        model.inquiryData.approxBuy == null ||
        model.inquiryData.approxBuy!.isEmpty;

    // UPDATED: Set isEditing to true if fillInterstCheck is 1 and there are null fields
    if (hasNullField && model.fillInterstCheck == 1) {
      isEditing = true;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.deepPurple.shade300,
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                child: Text(
                  model.inquiryData.id,
                  style: TextStyle(
                      fontSize: 13, fontFamily: "poppins_thin", color: Colors.white),
                ),
              ),
            ),
            SizedBox(width: 10),
            Text(model.inquiryData.fullName,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Spacer(),
            // UPDATED: Show edit/save button only if fillInterstCheck is 1 or there are null fields
            if (model.fillInterstCheck == 1 || hasNullField)
              CircleAvatar(
                backgroundColor: AppColor.Buttoncolor,
                radius: 18,
                child: IconButton(
                  icon: Icon(
                    isEditing ? Icons.save : Icons.edit,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () async {
                    setState(() {
                      isEditing = !isEditing;
                    });

                    if (!isEditing) {
                      // UPDATED: Validate if all fields are filled before saving
                      if ((selectedArea == null || selectedArea!['name']!.isEmpty) ||
                          (selectedSite == null || selectedSite!['name']!.isEmpty) ||
                          (selectedUnitType == null || selectedUnitType!['name']!.isEmpty) ||
                          (selectedBudget == null || selectedBudget!['name']!.isEmpty) ||
                          (selectedPurpose == null || selectedPurpose!['name']!.isEmpty) ||
                          (selectedBuyingTime == null || selectedBuyingTime!['name']!.isEmpty)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please fill all fields before saving")),
                        );
                        setState(() {
                          isEditing = true; // Keep editing mode if validation fails
                        });
                        return;
                      }

                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => Center(child: CircularProgressIndicator()),
                      );

                      final provider = Provider.of<UserProvider>(context, listen: false);
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
                        'intrestedArea': selectedArea?['name'] ?? '',
                        'intrestedAreaName': selectedArea?['name'] ?? '',
                        'intrestedSiteId': selectedSite?['id'] ?? '',
                        'budget': selectedBudget?['id'] ?? '',
                        'purposeBuy': selectedPurpose?['name'] ?? '',
                        'approxBuy': selectedBuyingTime?['id'] ?? '',
                        'propertyConfiguration': selectedUnitType?['id'] ?? '',
                        'inquiryType': inquiryData.inquiryType ?? '',
                        'inquirySourceType': inquiryData.inquirySourceType ?? '',
                        'description': inquiryData.remark ?? '',
                        'intrestedProduct': selectedSite?['id'] ?? '',
                        'nxtFollowUp': nextFollowUpController.text.isNotEmpty
                            ? nextFollowUpController.text
                            : inquiryData.nxtFollowUp,
                      };

                      provider
                          .updateLead(
                        action: updatedData['action'],
                        leadId: updatedData['leadId'],
                        fullName: updatedData['fullName'],
                        mobileno: updatedData['mobileno'],
                        altmobileno: updatedData['altmobileno'],
                        email: updatedData['email'],
                        houseno: updatedData['houseno'],
                        society: updatedData['society'],
                        area: updatedData['area'],
                        city: updatedData['city'],
                        countryCode: updatedData['countryCode'],
                        intrestedArea: updatedData['intrestedArea'],
                        intrestedAreaName: updatedData['intrestedAreaName'],
                        interstedSiteName: updatedData['intrestedSiteId'],
                        budget: updatedData['budget'],
                        purposeBuy: updatedData['purposeBuy'],
                        approxBuy: updatedData['approxBuy'],
                        propertyConfiguration: updatedData['propertyConfiguration'],
                        inquiryType: updatedData['inquiryType'],
                        inquirySourceType: updatedData['inquirySourceType'],
                        description: updatedData['description'],
                        intrestedProduct: updatedData['intrestedProduct'],
                        nxtFollowUp: updatedData['nxtFollowUp'],
                      )
                          .then((success) {
                        Navigator.pop(context);
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Lead updated successfully")),
                          );
                          provider.loadInquiryData(widget.inquiryId).then((_) {
                            setState(() {
                              isEditing = false;
                            });
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Failed to update lead")),
                          );
                          setState(() {
                            isEditing = true;
                          });
                        }
                      });
                    }
                  },
                ),
              ),
          ],
        ),
        SizedBox(height: 6),
        Text("\u260E ${model.inquiryData.mobileno ?? 'N/A'}"),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Int Area:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  // UPDATED: Show dropdown only if isEditing is true
                  isEditing
                      ? CombinedDropdownTextField<AreaCityCountry>(
                    key: const ValueKey("intArea"),
                    options: areaOptions,
                    displayString: (area) => area.area,
                    onSelected: (AreaCityCountry selected) {
                      setState(() {
                        selectedArea = {'id': selected.id, 'name': selected.area};
                      });
                    },
                    onTextChanged: (String text) {
                      setState(() {
                        selectedArea = {'id': '', 'name': text.trim()};
                      });
                    },
                    initialValue: areaOptions.isNotEmpty
                        ? areaOptions.firstWhere(
                          (area) =>
                      area.area ==
                          (selectedArea?['name'] ??
                              model.inquiryData.intrestedArea ??
                              ""),
                      orElse: () => AreaCityCountry(
                          id: "",
                          area: selectedArea?['name'] ??
                              model.inquiryData.intrestedArea ??
                              "",
                          city: "",
                          state: "",
                          country: ""),
                    )
                        : AreaCityCountry(
                        id: "",
                        area: selectedArea?['name'] ??
                            model.inquiryData.intrestedArea ??
                            "",
                        city: "",
                        state: "",
                        country: ""),
                    isRequired: true,
                    onEditingComplete: (text) {
                      setState(() {
                        selectedArea = {'id': '', 'name': text.trim()};
                      });
                    },
                  )
                      : Text(selectedArea?['name'] ??
                      model.inquiryData.intrestedArea ??
                      "N/A"),
                ],
              ),
            ),
            _infoTile<IntSite>(
              "Int Site",
              selectedSite?['name'] ?? model.intrestedProduct ?? "N/A",
              siteOptions,
                  (newValue) {
                setState(() {
                  selectedSite = {'id': newValue.id, 'name': newValue.productName};
                });
              },
              isEditing, // UPDATED: Show dropdown only if isEditing is true
                  (site) => site.productName,
            ),
          ],
        ),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _infoTile<PropertyConfiguration>(
              "Unit Type",
              selectedUnitType?['name'] ?? model.propertyConfigurationType ?? "N/A",
              unitOptions,
                  (newValue) {
                setState(() {
                  selectedUnitType = {'id': newValue.id, 'name': newValue.propertyType};
                });
              },
              isEditing, // UPDATED: Show dropdown only if isEditing is true
                  (unit) => unit.propertyType,
            ),
            _infoTile<Map<String, String>>(
              "Budget",
              selectedBudget?['name'] ?? model.inquiryData.budget ?? "N/A",
              budgetOptions,
                  (newValue) {
                setState(() {
                  selectedBudget = {
                    'id': newValue['id'] ?? '',
                    'name': newValue['name'] ?? ''
                  };
                });
              },
              isEditing, // UPDATED: Show dropdown only if isEditing is true
                  (budget) => budget['name']!,
            ),
          ],
        ),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _infoTile<Map<String, String>>(
              "Purpose",
              selectedPurpose?['name'] ?? model.inquiryData.purposeBuy ?? "N/A",
              purposeOptions,
                  (newValue) {
                setState(() {
                  selectedPurpose = {
                    'id': newValue['id'] ?? '',
                    'name': newValue['name'] ?? ''
                  };
                });
              },
              isEditing, // UPDATED: Show dropdown only if isEditing is true
                  (purpose) => purpose['name']!,
            ),
            _infoTile<Map<String, String>>(
              "Approx Buying",
              selectedBuyingTime?['name'] ?? model.inquiryData.approxBuy ?? "N/A",
              buyingTimeOptions,
                  (newValue) {
                setState(() {
                  selectedBuyingTime = {
                    'id': newValue['id'] ?? '',
                    'name': newValue['name'] ?? ''
                  };
                });
              },
              isEditing, // UPDATED: Show dropdown only if isEditing is true
                  (time) => time['name']!,
            ),
          ],
        ),
      ],
    );
  }

  Widget _infoTile<T>(
      String title,
      String value,
      List<T> options,
      ValueChanged<T> onChanged,
      bool forceEditable,
      String Function(T) displayString) {
    return (isEditing || forceEditable)
        ? SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$title:", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          DropdownButton2<T>(
            isExpanded: true,
            hint: Text(
              "Select $title",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: "poppins_thin",
              ),
            ),
            value: options.isNotEmpty
                ? options.firstWhere(
                  (option) => displayString(option) == value,
              orElse: () => options.first,
            )
                : null,
            underline: SizedBox(width: 0),
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
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
              elevation: 10,
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
                    fontSize: 16,
                  ),
                ),
              );
            }).toList(),
            onChanged: (T? newValue) {
              if (newValue != null) {
                setState(() {
                  onChanged(newValue);
                });
              }
            },
          ),
        ],
      ),
    )
        : SizedBox(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$title:", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 5),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (selectedTab) {
      case "Follow Up":
        return _buildFollowUpForm();
      case "Dismissed":
        return _buildDismissedForm();
      case "Appointment":
        return _buildAppointmentForm();
      case "Negotiations":
      case "Feedback":
        return _buildOtherActionForm();
      case "CNR":
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Confirm CNR", style: TextStyle(fontFamily: "poppins_thin")),
                content: Text("Are you sure you want to mark this inquiry as CNR?",
                    style: TextStyle(fontFamily: "poppins_thin")),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      print("Inquiry marked as CNR");
                    },
                    child: Text("Yes", style: TextStyle(fontFamily: "poppins_thin")),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("No", style: TextStyle(fontFamily: "poppins_thin")),
                  ),
                ],
              );
            },
          );
        });
        return Container();
      default:
        return Container();
    }
  }

  Widget _buildFollowUpForm() {
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
        ),
        const SizedBox(height: 16.0),
        const Text(
          "Next Follow Up*",
          style: TextStyle(fontSize: 16, fontFamily: "poppins_thin"),
        ),
        TextFormField(
          controller: nextFollowUpController,
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
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              setState(() {
                nextFollowUpController.text = DateFormat('dd-MM-yyyy').format(picked);
                Provider.of<UserProvider>(context, listen: false)
                    .fetchNextSlots(DateFormat('yyyy-MM-dd').format(picked));
                selectedApxFollowUp = null;
              });
            }
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Next follow-up date is required";
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        const Text(
          "Follow Up Time*",
          style: TextStyle(fontSize: 16, fontFamily: "poppins_thin"),
        ),
        const SizedBox(height: 5),
        Consumer<UserProvider>(
          builder: (context, provider, child) {
            return provider.isLoading
                ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : FormField<String>(
              initialValue: selectedApxFollowUp,
              validator: (value) => value == null ? "This field is required" : null,
              builder: (FormFieldState<String> state) {
                return DropdownButton2<String>(
                  isExpanded: true,
                  hint: const Text(
                    'Select Time',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: "poppins_thin",
                    ),
                  ),
                  underline: const SizedBox(width: 0),
                  value: selectedApxFollowUp,
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
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
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
                        style: TextStyle(fontFamily: "poppins_thin"),
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
                          color: slot.disabled ? Colors.black : Colors.grey,
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

    // Get close reason options based on Yes/No selection with their IDs
    List<Map<String, String>> closeReasonOptions = [];
    if (selectedYesNo == "Yes") {
      closeReasonOptions = inquiryProvider.inquiryStatus?.yes
          ?.map((e) => {'id': e.id, 'name': e.inquiryCloseReason})
          ?.toList() ??
          [];
    } else if (selectedYesNo == "No") {
      closeReasonOptions = inquiryProvider.inquiryStatus?.no
          ?.map((e) => {'id': e.id, 'name': e.inquiryCloseReason})
          ?.toList() ??
          [];
    }

    if (closeReasonOptions.isEmpty) {
      return const Center(
        child: Text(
          "No close reasons available",
          style: TextStyle(fontFamily: "poppins_thin", fontSize: 16),
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
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              hintText: "Your Message here...",
            ),
            maxLines: 3,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Remark is required";
              }
              return null;
            },
          ),
        const SizedBox(height: 16),
        const Text(
          "Close Reason*",
          style: TextStyle(fontSize: 16, fontFamily: "poppins_thin"),
        ),
        const SizedBox(height: 5),
        FormField<String>(
          initialValue: selectedCloseReason,
          validator: (value) => value == null ? "Close reason is required" : null,
          builder: (FormFieldState<String> state) {
            return DropdownButton2<String>(
              isExpanded: true,
              hint: const Text(
                'Select Close Reason',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: "poppins_thin",
                ),
              ),
              value: selectedCloseReason, // This will now hold the ID
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
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                elevation: 10,
                scrollbarTheme: ScrollbarThemeData(
                  radius: const Radius.circular(40),
                  thickness: MaterialStateProperty.all(6),
                  thumbVisibility: MaterialStateProperty.all(true),
                ),
              ),
              items: closeReasonOptions.map((Map<String, String> item) {
                return DropdownMenuItem<String>(
                  value: item['id'], // Use the ID as the value
                  child: Text(
                    item['name']!, // Display the name
                    style: const TextStyle(fontFamily: "poppins_thin", fontSize: 16),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCloseReason = value; // Store the selected ID
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
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                hintText: "Your Message here...",
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16.0),
            DropdownButton2<String>(
              isExpanded: true,
              hint: const Text(
                'Select Project',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: "poppins_thin",
                ),
              ),
              value: selectedProjectId,
              underline: SizedBox(width: 0),
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
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                elevation: 10,
                scrollbarTheme: ScrollbarThemeData(
                  radius: const Radius.circular(40),
                  thickness: MaterialStateProperty.all(6),
                  thumbVisibility: MaterialStateProperty.all(true),
                ),
              ),
              items: siteOptions.map((IntSite site) {
                return DropdownMenuItem<String>(
                  value: site.id,
                  child: Text(
                    site.productName,
                    style: const TextStyle(fontFamily: "poppins_thin", fontSize: 16),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedProjectId = value;
                });
              },
            ),
            const SizedBox(height: 16.0),
            const Text(
              "Next Follow Up*",
              style: TextStyle(fontSize: 16, fontFamily: "poppins_thin"),
            ),
            TextFormField(
              controller: nextFollowUpController,
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
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() {
                    nextFollowUpController.text = DateFormat('dd-MM-yyyy').format(picked);
                    Provider.of<UserProvider>(context, listen: false)
                        .fetchNextSlots(DateFormat('yyyy-MM-dd').format(picked));
                    selectedApxAppointment = null;
                  });
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Next follow-up date is required";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            const Text(
              "Follow Up Time*",
              style: TextStyle(fontSize: 16, fontFamily: "poppins_thin"),
            ),
            SizedBox(height: 5),
            Consumer<UserProvider>(
              builder: (context, provider, child) {
                return provider.isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : FormField<String>(
                  initialValue: selectedApxAppointment,
                  validator: (value) => value == null ? "This field is required" : null,
                  builder: (FormFieldState<String> state) {
                    return DropdownButton2<String>(
                      isExpanded: true,
                      hint: const Text(
                        'Select Time',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: "poppins_thin",
                        ),
                      ),
                      underline: SizedBox(width: 0),
                      value: selectedApxAppointment,
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
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
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
                            style: TextStyle(fontFamily: "poppins_thin"),
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
                              color: slot.disabled ? Colors.black : Colors.grey,
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
            const SizedBox(height: 16.0),
            const Text(
              "Appointment Date*",
              style: TextStyle(fontSize: 16, fontFamily: "poppins_thin"),
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: "Select Appointment Date",
                hintStyle: const TextStyle(fontFamily: "poppins_light"),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                suffixIcon: const Icon(Icons.calendar_today),
              ),
              controller: TextEditingController(
                text: appointmentDate != null
                    ? DateFormat('dd-MM-yyyy').format(appointmentDate!)
                    : '',
              ),
              readOnly: true,
              onTap: () async {
                await _pickAppointmentDate();
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Appointment date is required";
                }
                return null;
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildOtherActionForm() {
    final isNegotiation = selectedTab.toLowerCase() == 'negotiation';
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
        ),
        const SizedBox(height: 16.0),
        const Text(
          "Next Follow Up*",
          style: TextStyle(fontSize: 16, fontFamily: "poppins_thin"),
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
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              setState(() {
                otherActionController.text = DateFormat('dd-MM-yyyy').format(picked);
                Provider.of<UserProvider>(context, listen: false)
                    .fetchNextSlots(DateFormat('yyyy-MM-dd').format(picked));
                selectedApxOther = null;
              });
            }
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Next follow-up date is required";
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        const Text(
          "Follow Up Time*",
          style: TextStyle(fontSize: 16, fontFamily: "poppins_thin"),
        ),
        SizedBox(height: 5),
        Consumer<UserProvider>(
          builder: (context, provider, child) {
            return provider.isLoading
                ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : FormField<String>(
              initialValue: selectedApxOther,
              validator: (value) => value == null ? "This field is required" : null,
              builder: (FormFieldState<String> state) {
                return DropdownButton2<String>(
                  isExpanded: true,
                  hint: const Text(
                    'Select Time',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: "poppins_thin",
                    ),
                  ),
                  underline: SizedBox(width: 0),
                  value: selectedApxOther,
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
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
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
                        style: TextStyle(fontFamily: "poppins_thin"),
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
                          color: slot.disabled ? Colors.black : Colors.grey,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedApxOther = value;
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Timeline",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: double.infinity,
          child: Timeline.tileBuilder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            theme: TimelineThemeData(
              direction: Axis.vertical,
              connectorTheme: ConnectorThemeData(color: Colors.grey, thickness: 2.0),
              indicatorTheme: IndicatorThemeData(size: 12.0, color: Colors.deepPurple),
              nodePosition: 0.1,
            ),
            builder: TimelineTileBuilder.connected(
              itemCount: processedData.length,
              connectionDirection: ConnectionDirection.before,
              indicatorBuilder: (_, index) => DotIndicator(
                color: Colors.deepPurple,
                size: 12.0,
              ),
              connectorBuilder: (_, index, __) => SolidLineConnector(
                color: Colors.grey,
              ),
              contentsBuilder: (context, index) {
                final item = processedData[index];
                final formattedDate = formatCreatedAt(item.createdAt);
                return Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 8.0, top: 8.0, bottom: 8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 64,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade400,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            item.statusLabel,
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.person, size: 16, color: Colors.grey),
                            SizedBox(width: 4),
                            Text(
                              item.username,
                              style:
                              TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                            SizedBox(width: 4),
                            Text(
                              "Next: ${item.nxtFollowDate}",
                              style: TextStyle(fontSize: 12, color: Colors.black54),
                            ),
                          ],
                        ),
                        SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.chat_bubble_outline,
                                size: 16, color: Colors.grey),
                            SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                item.remarkText,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 14, color: Colors.black87),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6),
                        Text(
                          "${formattedDate['date']} - ${formattedDate['time']}",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
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
          backgroundColor: isSelected ? Colors.deepPurple.shade100 : Colors.white,
          foregroundColor: isSelected ? Colors.deepPurple : Colors.black,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(color: isSelected ? Colors.deepPurple : Colors.grey.shade300),
          ),
        ),
        onPressed: () {
          setState(() {
            _selectedButton = text;
          });
          widget.onButtonPressed(text);
        },
        child: Text(text, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      ),
    );
  }
}

class CombinedDropdownTextField<T> extends StatefulWidget {
  final List<T> options;
  final String Function(T)? displayString;
  final Function(T) onSelected;
  final Function(String) onTextChanged;
  final bool isRequired;
  final T initialValue;
  final Function(String)? onEditingComplete;

  const CombinedDropdownTextField({
    super.key,
    required this.options,
    this.displayString,
    required this.onSelected,
    required this.onTextChanged,
    this.isRequired = false,
    required this.initialValue,
    this.onEditingComplete,
  });

  @override
  State<CombinedDropdownTextField<T>> createState() => _CombinedDropdownTextFieldState<T>();
}

class _CombinedDropdownTextFieldState<T> extends State<CombinedDropdownTextField<T>> {
  late TextEditingController _controller;
  bool _isDropdownVisible = false;
  late List<T> _filteredOptions;
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
        text: widget.displayString != null
            ? widget.displayString!(widget.initialValue)
            : widget.initialValue.toString());
    _focusNode.addListener(_onFocusChange);
    _filteredOptions = widget.options;
  }

  @override
  void didUpdateWidget(CombinedDropdownTextField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      _controller.text = widget.displayString != null
          ? widget.displayString!(widget.initialValue)
          : widget.initialValue.toString();
      _filteredOptions = widget.options;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _hideOverlay();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isDropdownVisible = _focusNode.hasFocus;
      if (_isDropdownVisible) {
        _filteredOptions = widget.options;
        _showOverlay(context);
      } else {
        _hideOverlay();
        widget.onTextChanged(_controller.text);
      }
    });
  }

  void _filterOptions(String query) {
    setState(() {
      _filteredOptions = widget.options
          .where((option) =>
          (widget.displayString != null
              ? widget.displayString!(option)
              : option.toString())
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  void _selectOption(T option) {
    setState(() {
      _controller.text = widget.displayString != null
          ? widget.displayString!(option)
          : option.toString();
      _filteredOptions = widget.options;
      _isDropdownVisible = false;
    });
    widget.onSelected(option);
    _focusNode.unfocus();
    _hideOverlay();
  }

  void _showOverlay(BuildContext context) {
    if (_overlayEntry != null) return;

    final overlayState = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 5.0),
          child: Card(
            elevation: 4,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                padding: EdgeInsets.all(8),
                shrinkWrap: true,
                itemCount: _filteredOptions.length,
                itemBuilder: (context, index) {
                  final option = _filteredOptions[index];
                  return InkWell(
                    onTap: () => _selectOption(option),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(widget.displayString != null
                          ? widget.displayString!(option)
                          : option.toString()),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    overlayState.insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _controller,
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: 'Select or Type',
              hintStyle: const TextStyle(fontFamily: "poppins_light"),
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              suffixIcon: _isDropdownVisible
                  ? IconButton(
                icon: const Icon(Icons.arrow_drop_up),
                onPressed: () {
                  setState(() {
                    _isDropdownVisible = false;
                    _focusNode.unfocus();
                    _hideOverlay();
                    widget.onTextChanged(_controller.text);
                  });
                },
              )
                  : IconButton(
                icon: const Icon(Icons.arrow_drop_down),
                onPressed: () {
                  setState(() {
                    _isDropdownVisible = true;
                    _focusNode.requestFocus();
                    _filteredOptions = widget.options;
                    _showOverlay(context);
                  });
                },
              ),
            ),
            onChanged: (text) {
              _filterOptions(text);
              widget.onTextChanged(text);
            },
            onTap: () {
              setState(() {
                _isDropdownVisible = true;
                _focusNode.requestFocus();
                _filteredOptions = widget.options;
                _showOverlay(context);
              });
            },
            onEditingComplete: () {
              widget.onEditingComplete?.call(_controller.text);
              _focusNode.unfocus();
            },
            validator: widget.isRequired
                ? (value) {
              if (value == null || value.isEmpty) {
                return "This field is required";
              }
              return null;
            }
                : null,
          ),
        ],
      ),
    );
  }
}
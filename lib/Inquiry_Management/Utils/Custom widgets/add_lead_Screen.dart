import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../Provider/UserProvider.dart';
import '../../Inquiry Management Screens/all_inquiries_Screen.dart';
import '../../Model/Api Model/add_Lead_Model.dart';
import '../Colors/app_Colors.dart';
import 'custom_buttons.dart';

class AddLeadScreen extends StatefulWidget {
  final bool? isEdit;
  const AddLeadScreen({super.key, this.isEdit});

  @override
  _AddLeadScreenState createState() => _AddLeadScreenState();
}

class _AddLeadScreenState extends State<AddLeadScreen> {
  int _currentStep = 0;
  String? _selectedCountryCode;
  String? _selectedArea;
  String? _selectedCity;
  InqType? _selectedInquiryType;
  String? _selectedInqSource;
  String? _selectedIntSite;
  String? _selectedBudget;
  String? _selectedPurpose;
  String? _selectedApxTime;
  String? _selectedPropertyConfiguration;
  String action = "insert";
  String? _selectedInterestedProduct = "1";
  DateTime? nextFollowUp;
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _houseController = TextEditingController();
  final TextEditingController _societyController = TextEditingController();
  final TextEditingController _altMobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedFollowUpTime;
  String? _fillInterest;

  final List<String> countryCodeOptions = ['+1', '+44', '+91'];

  final List<String> _steps = ["Personal Info", "CST & Inquiry", "Follow Up"];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.fetchAddLeadData().then((_) {
        setState(() {
          _fillInterest = userProvider.dropdownData?.cststatus.isNotEmpty == true
              ? userProvider.dropdownData!.cststatus.first.fillInterest
              : "0";
        });
      });
    });
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _fullNameController.dispose();
    _houseController.dispose();
    _societyController.dispose();
    _altMobileController.dispose();
    _emailController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _submitLead() async {
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(msg: "Please fill all required fields");
      return;
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final dropdownData = userProvider.dropdownData;

    if (dropdownData == null) {
      Fluttertoast.showToast(msg: "Dropdown data not loaded");
      return;
    }

    String formattedNextFollowUp = _dateController.text.isNotEmpty
        ? DateFormat('dd-MM-yyyy').format(DateTime.parse(_dateController.text))
        : "";

    String budgetId = dropdownData.budget != null && _selectedBudget != null
        ? dropdownData.budget!.values
        .split(',')
        .indexOf(_selectedBudget!)
        .toString()
        : "";
    String approxBuyId = dropdownData.apxTime != null && _selectedApxTime != null
        ? dropdownData.apxTime!.apxTimeData
        .split(',')
        .indexOf(_selectedApxTime!)
        .toString()
        : "";
    String inquiryTypeId = _selectedInquiryType?.id ?? "";
    String inquirySourceId = dropdownData.inqSource
        ?.firstWhere((source) => source.source == _selectedInqSource,
        orElse: () => InqSource(id: "", source: ""))
        .id ??
        "";
    String interestedAreaId = dropdownData.areaCityCountry
        ?.firstWhere((area) => area.area == _selectedArea,
        orElse: () => AreaCityCountry(id: "", area: "", city: "", state: "", country: ""))
        .id ??
        "";
    String interestedSiteId = dropdownData.intSite
        ?.firstWhere((site) => site.productName == _selectedIntSite,
        orElse: () => IntSite(id: "", productName: ""))
        .id ??
        "";
    String propertyConfigId = dropdownData.propertyConfiguration
        ?.firstWhere((prop) => prop.propertyType == _selectedPropertyConfiguration,
        orElse: () => PropertyConfiguration(id: "", propertyType: ""))
        .id ??
        "";
    String countryCodeId = _selectedCountryCode != null
        ? _selectedCountryCode!.replaceAll('+', '')
        : "";

    bool isLeadAdded = await userProvider.addLead(
      action: action,
      nxt_follow_up: formattedNextFollowUp,
      time: _selectedFollowUpTime ?? "",
      purpose_buy: _selectedPurpose ?? "",
      city: _selectedCity ?? "",
      country_code: countryCodeId,
      intrested_area: interestedAreaId,
      full_name: _fullNameController.text,
      budget: budgetId,
      approx_buy: approxBuyId,
      area: _selectedArea ?? "",
      mobileno: _mobileController.text,
      inquiry_type: inquiryTypeId,
      inquiry_source_type: inquirySourceId,
      intrested_area_name: interestedAreaId,
      intersted_site_name: interestedSiteId,
      PropertyConfiguration: propertyConfigId,
      society: _societyController.text,
      houseno: _houseController.text,
      altmobileno: _altMobileController.text,
      description: _descriptionController.text
    );

    if (isLeadAdded) {
      Fluttertoast.showToast(msg: "Lead added successfully");
      Navigator.pop(context, true);
    } else {
      Fluttertoast.showToast(msg: "This mobile number is already created");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEdit == true ? "Edit Lead" : "Add Lead",
          style: const TextStyle(
              fontFamily: "poppins_thin", color: Colors.white, fontSize: 20),
        ),
        backgroundColor: AppColor.MainColor,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (userProvider.isLoadingDropdown) {
            return const Center(child: CircularProgressIndicator());
          }

          final dropdownData = userProvider.dropdownData;
          if (dropdownData == null) {
            return const Center(child: Text("Failed to load dropdown options"));
          }

          final List<String> areaOptions = (dropdownData.areaCityCountry ?? [])
              .map<String>((area) => area.area)
              .where((area) => area.trim().isNotEmpty)
              .toSet()
              .toList();
          final List<String> cityOptions = (dropdownData.areaCityCountry ?? [])
              .map<String>((city) => city.city)
              .where((city) => city.trim().isNotEmpty)
              .toSet()
              .toList();
          final List<InqType> inquiryTypeOptions = dropdownData.inqType;
          final List<String> inquirySourceOptions = (dropdownData.inqSource ?? [])
              .map<String>((source) => source.source)
              .where((source) => source.trim().isNotEmpty)
              .toSet()
              .toList();
          final List<String> intSiteOptions = (dropdownData.intSite ?? [])
              .map<String>((site) => site.productName)
              .where((site) => site.trim().isNotEmpty)
              .toSet()
              .toList();
          final List<String> budgetOptions = dropdownData.budget?.values
              .split(',')
              .map<String>((value) => value.trim())
              .where((value) => value.isNotEmpty)
              .toSet()
              .toList() ??
              [];
          final List<String> purposeOptions = dropdownData.purposeOfBuying != null
              ? [
            dropdownData.purposeOfBuying!.investment,
            dropdownData.purposeOfBuying!.personalUse
          ].where((purpose) => purpose.trim().isNotEmpty).toList()
              : [];
          final List<String> apxTimeOptions = dropdownData.apxTime?.apxTimeData
              .split(',')
              .map<String>((time) => time.trim())
              .where((time) => time.isNotEmpty)
              .toSet()
              .toList() ??
              [];
          final List<String> propertyConfigurationOptions =
          (dropdownData.propertyConfiguration ?? [])
              .map<String>((prop) => prop.propertyType)
              .where((config) => config.trim().isNotEmpty)
              .toSet()
              .toList();

          return Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _buildFormContent(
                      countryCodeOptions,
                      areaOptions,
                      cityOptions,
                      inquiryTypeOptions,
                      inquirySourceOptions,
                      intSiteOptions,
                      budgetOptions,
                      purposeOptions,
                      apxTimeOptions,
                      propertyConfigurationOptions,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: _currentStep == 0
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentStep > 0)
                        GradientButton(
                          buttonText: "",
                          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                          width: 40.0,
                          onPressed: _goToPreviousStep,
                        ),
                      GradientButton(
                        buttonText: _currentStep == _steps.length - 1 ? "Submit" : "Next",
                        width: 120.0,
                        onPressed: _currentStep == _steps.length - 1
                            ? _submitLead
                            : _goToNextStep,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFormContent(
      List<String> countryCodeOptions,
      List<String> areaOptions,
      List<String> cityOptions,
      List<InqType> inquiryTypeOptions,
      List<String> inquirySourceOptions,
      List<String> intSiteOptions,
      List<String> budgetOptions,
      List<String> purposeOptions,
      List<String> apxTimeOptions,
      List<String> propertyConfigurationOptions,
      ) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_currentStep == 0) ...[
              const Text(
                "Personal Inquiry",
                style: TextStyle(fontSize: 24, fontFamily: "poppins_thin"),
              ),
              Card(
                child: _buildPersonalInquirySection(
                  countryCodeOptions,
                  areaOptions,
                  cityOptions,
                ),
              ),
            ],
            if (_currentStep == 1) ...[
              const Text(
                "CST Interest",
                style: TextStyle(fontSize: 24, fontFamily: "poppins_thin"),
              ),
              Card(
                child: _buildCSTInterestSection(
                  context,
                  areaOptions,
                  intSiteOptions,
                  budgetOptions,
                  purposeOptions,
                  apxTimeOptions,
                  propertyConfigurationOptions,
                  inquirySourceOptions,
                ),
              ),
            ],
            if (_currentStep == 2) ...[
              const SizedBox(height: 16),
              const Text(
                "Inquiry Information",
                style: TextStyle(fontSize: 24, fontFamily: "poppins_thin"),
              ),
              Card(
                child: _buildInquiryInformationSection(
                  inquiryTypeOptions,
                  inquirySourceOptions,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                "Follow Up",
                style: TextStyle(fontSize: 24, fontFamily: "poppins_thin"),
              ),
              Card(child: _buildFollowUpSection()),
            ],
          ],
        ),
      ),
    );
  }

  void _goToNextStep() {
    if (_formKey.currentState!.validate() && _currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
      });
    } else if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(msg: "Please fill all required fields");
    }
  }

  void _goToPreviousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  Widget _buildPersonalInquirySection(
      List<String> countryCodeOptions,
      List<String> areaOptions,
      List<String> cityOptions,
      ) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Mobile No.*",
            style: TextStyle(fontSize: 16, fontFamily: "poppins_thin"),
          ),
          Row(
            children: [
              SizedBox(
                width: 90,
                child: CombinedDropdownTextField<String>(
                  options: countryCodeOptions,
                  onSelected: (String value) {
                    setState(() {
                      _selectedCountryCode = value;
                    });
                  },
                  isRequired: true,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _mobileController,
                  decoration: InputDecoration(
                    hintText: "Enter Mobile No.",
                    hintStyle: const TextStyle(fontFamily: "poppins_light"),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Mobile number is required";
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            "Full Name*",
            style: TextStyle(fontSize: 16, fontFamily: "poppins_thin"),
          ),
          TextFormField(
            controller: _fullNameController,
            decoration: InputDecoration(
              hintText: "Enter Full Name",
              hintStyle: const TextStyle(fontFamily: "poppins_light"),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Full name is required";
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Area*",
                      style: TextStyle(fontSize: 16, fontFamily: "poppins_thin"),
                    ),
                    CombinedDropdownTextField<String>(
                      options: areaOptions,
                      onSelected: (String value) {
                        setState(() {
                          _selectedArea = value;
                        });
                      },
                      isRequired: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "City*",
                      style: TextStyle(fontSize: 16, fontFamily: "poppins_thin"),
                    ),
                    CombinedDropdownTextField<String>(
                      options: cityOptions,
                      onSelected: (String value) {
                        setState(() {
                          _selectedCity = value;
                        });
                      },
                      isRequired: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            "House",
            style: TextStyle(fontSize: 16, fontFamily: "poppins_thin"),
          ),
          TextFormField(
            controller: _houseController,
            decoration: InputDecoration(
              hintText: "Enter House",
              hintStyle: const TextStyle(fontFamily: "poppins_light"),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Society",
            style: TextStyle(fontSize: 16, fontFamily: "poppins_thin"),
          ),
          TextFormField(
            controller: _societyController,
            decoration: InputDecoration(
              hintText: "Enter Society",
              hintStyle: const TextStyle(fontFamily: "poppins_light"),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Alt. Mobile No.",
            style: TextStyle(fontSize: 16, fontFamily: "poppins_thin"),
          ),
          Row(
            children: [
              SizedBox(
                width: 80,
                child: CombinedDropdownTextField<String>(
                  options: countryCodeOptions,
                  onSelected: (String value) {
                    setState(() {
                      _selectedCountryCode = value; // Reuse for simplicity
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _altMobileController,
                  decoration: InputDecoration(
                    hintText: "Enter Alt. Mobile No.",
                    hintStyle: const TextStyle(fontFamily: "poppins_light"),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            "Email Address",
            style: TextStyle(fontSize: 16, fontFamily: "poppins_thin"),
          ),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              hintText: "Enter Email Address",
              hintStyle: const TextStyle(fontFamily: "poppins_light"),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
        ],
      ),
    );
  }

  Widget _buildCSTInterestSection(
      BuildContext context,
      List<String> areaOptions,
      List<String> intSiteOptions,
      List<String> budgetOptions,
      List<String> purposeOptions,
      List<String> apxTimeOptions,
      List<String> propertyConfigurationOptions,
      List<String> inquirySourceOptions,
      ) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Text(
            "Int Area",
            style: TextStyle(fontSize: 16, fontFamily: "poppins_thin"),
          ),
          CombinedDropdownTextField<String>(
            options: areaOptions,
            onSelected: (String selectedArea) {
              setState(() {
                _selectedArea = selectedArea;
              });
            },
            isRequired: _fillInterest == "1",
          ),
          const SizedBox(height: 16),
          const Text(
            "Int Site",
            style: TextStyle(fontSize: 16, fontFamily: "poppins_thin"),
          ),
          CombinedDropdownTextField<String>(
            options: intSiteOptions,
            onSelected: (String selectedIntSite) {
              setState(() {
                _selectedIntSite = selectedIntSite;
              });
            },
            isRequired: _fillInterest == "1",
          ),
          const SizedBox(height: 16),
          const Text(
            "Budget(In Lac)*",
            style: TextStyle(fontSize: 16, fontFamily: "poppins_thin"),
          ),
          CombinedDropdownTextField<String>(
            options: budgetOptions,
            onSelected: (String selectedBudget) {
              setState(() {
                _selectedBudget = selectedBudget;
              });
            },
            isRequired: true,
          ),
          const SizedBox(height: 16),
          const Text(
            "Purpose of Buying",
            style: TextStyle(fontSize: 16, fontFamily: "poppins_thin"),
          ),
          CombinedDropdownTextField<String>(
            options: purposeOptions,
            onSelected: (String selectedPurpose) {
              setState(() {
                _selectedPurpose = selectedPurpose;
              });
            },
            isRequired: _fillInterest == "1",
          ),
          const SizedBox(height: 16),
          const Text(
            "Apx Buying Time",
            style: TextStyle(fontSize: 16, fontFamily: "poppins_thin"),
          ),
          CombinedDropdownTextField<String>(
            options: apxTimeOptions,
            onSelected: (String selectedApxTime) {
              setState(() {
                _selectedApxTime = selectedApxTime;
              });
            },
            isRequired: _fillInterest == "1",
          ),
          const SizedBox(height: 16),
          const Text(
            "Property Configuration*",
            style: TextStyle(fontSize: 16, fontFamily: "poppins_thin"),
          ),
          CombinedDropdownTextField<String>(
            options: propertyConfigurationOptions,
            onSelected: (String selectedPropertyConfiguration) {
              setState(() {
                _selectedPropertyConfiguration = selectedPropertyConfiguration;
              });
            },
            isRequired: true,
          ),
        ],
      ),
    );
  }

  Widget _buildInquiryInformationSection(
      List<InqType> inquiryTypeOptions,
      List<String> inquirySourceOptions,
      ) {
    final nextSlotProvider = Provider.of<UserProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Inquiry Type*",
            style: TextStyle(fontSize: 16, fontFamily: "poppins_thin"),
          ),
          CombinedDropdownTextField<InqType>(
            options: inquiryTypeOptions,
            displayString: (InqType type) => type.inquiryDetails,
            onSelected: (InqType value) {
              setState(() {
                _selectedInquiryType = value;
              });
            },
            isRequired: true,
          ),
          const SizedBox(height: 16),
          const Text(
            "Inquiry Source*",
            style: TextStyle(fontSize: 16, fontFamily: "poppins_thin"),
          ),
          CombinedDropdownTextField<String>(
            options: inquirySourceOptions,
            onSelected: (String value) {
              setState(() {
                _selectedInqSource = value;
              });
            },
            isRequired: true,
          ),
          const SizedBox(height: 16),
          if (widget.isEdit == false) ...[
            const Text(
              "Next Follow Up*",
              style: TextStyle(fontSize: 16, fontFamily: "poppins_thin"),
            ),
            TextFormField(
              controller: _dateController,
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
                    nextFollowUp = picked;
                    _dateController.text = DateFormat('yyyy-MM-dd').format(nextFollowUp!);
                    nextSlotProvider.fetchNextSlots(_dateController.text);
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
            nextSlotProvider.isLoading
                ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : DropdownButton2<String>(
              isExpanded: true,
              hint: const Text(
                'Select Time',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: "poppins_thin",
                ),
              ),
              value: _selectedFollowUpTime,
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
              underline: const SizedBox(),
              dropdownStyleData: DropdownStyleData(
                offset: const Offset(-5, -10),
                maxHeight: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 10,
                scrollbarTheme: ScrollbarThemeData(
                  radius: const Radius.circular(40),
                  thickness: MaterialStateProperty.all(6),
                  thumbVisibility: MaterialStateProperty.all(true),
                ),
              ),
              items: nextSlotProvider.nextSlots.isEmpty
                  ? [
                const DropdownMenuItem(
                  value: 'None',
                  child: Text(
                    'No slots available',
                    style: TextStyle(fontFamily: "poppins_thin"),
                  ),
                ),
              ]
                  : nextSlotProvider.nextSlots.map((slot) {
                return DropdownMenuItem<String>(
                  value: slot.disabled ? slot.source : null,
                  enabled: slot.disabled,
                  child: Text(
                    slot.source ?? '',
                    style: TextStyle(
                      fontFamily: "poppins_thin",
                      color: slot.disabled ? Colors.black : Colors.grey,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedFollowUpTime = value;
                  });
                }
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFollowUpSection() {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Description",
            style: TextStyle(fontSize: 16, fontFamily: "poppins_thin"),
          ),
          TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(
              hintText: "Enter Description",
              hintStyle: const TextStyle(fontFamily: "poppins_light"),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}

class CombinedDropdownTextField<T> extends StatefulWidget {
  final List<T> options;
  final String Function(T)? displayString;
  final Function(T) onSelected;
  final bool isRequired;

  const CombinedDropdownTextField({
    super.key,
    required this.options,
    this.displayString,
    required this.onSelected,
    this.isRequired = false,
  });

  @override
  State<CombinedDropdownTextField<T>> createState() => _CombinedDropdownTextFieldState<T>();
}

class _CombinedDropdownTextFieldState<T> extends State<CombinedDropdownTextField<T>> {
  final TextEditingController _controller = TextEditingController();
  bool _isDropdownVisible = false;
  List<T> _filteredOptions = [];
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    _filteredOptions = widget.options;
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
        _showOverlay(context);
      } else {
        _hideOverlay();
      }
    });
  }

  void _filterOptions(String query) {
    setState(() {
      _filteredOptions = widget.options
          .where((option) => _getDisplayString(option)
          .toLowerCase()
          .contains(query.toLowerCase()))
          .toList();
    });
  }

  String _getDisplayString(T option) {
    return widget.displayString != null
        ? widget.displayString!(option)
        : option.toString();
  }

  void _selectOption(T option) {
    setState(() {
      _controller.text = _getDisplayString(option);
      _filteredOptions = [];
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
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _filteredOptions.length,
                itemBuilder: (context, index) {
                  final option = _filteredOptions[index];
                  return InkWell(
                    onTap: () => _selectOption(option),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(_getDisplayString(option)),
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
                  });
                },
              )
                  : IconButton(
                icon: const Icon(Icons.arrow_drop_down),
                onPressed: () {
                  setState(() {
                    _isDropdownVisible = true;
                    _focusNode.requestFocus();
                    _filterOptions(_controller.text);
                    _showOverlay(context);
                  });
                },
              ),
            ),
            onChanged: _filterOptions,
            onTap: () {
              setState(() {
                _isDropdownVisible = true;
                _focusNode.requestFocus();
                _filterOptions(_controller.text);
                _showOverlay(context);
              });
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
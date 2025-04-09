import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../Provider/UserProvider.dart'; // Adjust path
import '../../Inquiry Management Screens/all_inquiries_Screen.dart'; // Adjust path
import '../../Model/Api Model/add_Lead_Model.dart'; // Adjust path
import '../../Model/Api Model/edit_Lead_Model.dart'; // Adjust path
import '../Colors/app_Colors.dart'; // Adjust path
import 'custom_buttons.dart'; // Adjust path

class AddLeadScreen extends StatefulWidget {
  final bool? isEdit;
  final String? leadId;
  const AddLeadScreen({super.key, this.isEdit, this.leadId});

  @override
  _AddLeadScreenState createState() => _AddLeadScreenState();
}

class _AddLeadScreenState extends State<AddLeadScreen> {
  int _currentStep = 0;
  String? _selectedCountryCode;
  String? _selectedArea;
  String? _selectedCity;
  InqType? _selectedInquiryType;
  String? _selectedInqSource; // Display value
  String? _selectedInqSourceId; // ID for API
  String? _selectedIntSite; // Display value
  String? _selectedIntSiteId;
  String? _selectedBudget;
  String? _selectedPurpose;
  String? _selectedApxTime;
  String? _selectedPropertyConfiguration; // Display value
  String? _selectedPropertyConfigId;
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
  EditLeadData? editLeadData;

  final List<String> countryCodeOptions = ['+1', '+44', '+91'];
  final List<String> _steps = ["Personal Info", "CST & Inquiry", "Follow Up"];

  void initState() {
    super.initState();
    if (widget.isEdit != true) {
      _selectedCountryCode = '+91';
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.fetchAddLeadData().then((_) {
        if (mounted) { // Check if widget is still mounted
          setState(() {
            _fillInterest = userProvider.dropdownData?.cststatus.isNotEmpty == true
                ? userProvider.dropdownData!.cststatus.first.fillInterest
                : "0";
          });
        }

        if (widget.isEdit == true && widget.leadId != null) {
          action = "edit";
          userProvider.fetchEditLeadData(widget.leadId!).then((data) {
            if (mounted && data != null) { // Check if mounted and data is not null
              setState(() {
                editLeadData = data;
                _populateEditData();
                print(
                    "Edit Data Loaded: Area = $_selectedArea, City = $_selectedCity, CountryCode = $_selectedCountryCode");
              });
            } else if (data == null) {
              Fluttertoast.showToast(msg: "No edit data received from server");
            }
          }).catchError((error) {
            print("Error fetching edit data: $error");
            if (mounted) {
              Fluttertoast.showToast(msg: "Failed to load edit data: Server Error");
            }
          });
        }
      }).catchError((error) {
        print("Error fetching add lead data: $error");
        if (mounted) {
          Fluttertoast.showToast(msg: "Failed to load initial data");
        }
      });
    });
  }
  void _populateEditData() {
    if (editLeadData == null) return;

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final dropdownData = userProvider.dropdownData;


    _mobileController.text = editLeadData!.mobileno ?? '';
    _fullNameController.text = editLeadData!.fullName ?? '';
    _houseController.text = editLeadData!.houseno ?? '';
    _societyController.text = editLeadData!.society ?? '';
    _altMobileController.text = editLeadData!.altmobileno ?? '';
    _emailController.text = editLeadData!.email ?? '';
    _descriptionController.text = editLeadData!.inquiryDescription ?? '';
    _selectedCountryCode = editLeadData!.countryCode != null
        ? '+' + editLeadData!.countryCode
        : '+91';

    _selectedArea = editLeadData!.area;
    _selectedCity = editLeadData!.city;

    // Budget mapping
    if (dropdownData?.budget != null) {
      List<String> budgetValues = dropdownData!.budget!.values.split(',');
      int budgetIndex = int.tryParse(editLeadData!.budget) ?? 0;
      if (budgetIndex >= 0 && budgetIndex < budgetValues.length) {
        _selectedBudget = budgetValues[budgetIndex];
      }
    }

    _selectedPurpose = editLeadData!.purposeBuy;

    // Apx Buying Time mapping
    if (dropdownData?.apxTime != null) {
      List<String> apxTimeValues = dropdownData!.apxTime!.apxTimeData.split(',');
      int apxTimeIndex = int.tryParse(editLeadData!.approxBuy) ?? -1;
      if (apxTimeIndex >= 0 && apxTimeIndex < apxTimeValues.length) {
        _selectedApxTime = apxTimeValues[apxTimeIndex];
      } else {
        _selectedApxTime = apxTimeValues.isNotEmpty ? apxTimeValues.first : null;
      }
    }

    // Interested Site mapping (use ID and name)
    final List<IntSite> intSiteList = dropdownData?.intSite ?? [];
    if (intSiteList.isNotEmpty) {
      final selectedSite = intSiteList.firstWhere(
            (site) => site.id == editLeadData!.interstedSiteName,
        orElse: () => intSiteList.first,
      );
      _selectedIntSiteId = selectedSite.id;
      _selectedIntSite = selectedSite.productName;
    }

    // Property Configuration mapping (use ID and name)
    final List<PropertyConfiguration> propertyConfigList =
        dropdownData?.propertyConfiguration ?? [];
    if (propertyConfigList.isNotEmpty) {
      final selectedConfig = propertyConfigList.firstWhere(
            (prop) => prop.id == editLeadData!.propertyConfiguration,
        orElse: () => propertyConfigList.first,
      );
      _selectedPropertyConfigId = selectedConfig.id;
      _selectedPropertyConfiguration = selectedConfig.propertyType;
    }

    // Inquiry Type mapping
    final List<InqType> inquiryTypeOptions = dropdownData?.inqType ?? [];
    _selectedInquiryType = inquiryTypeOptions.isNotEmpty
        ? inquiryTypeOptions.firstWhere(
          (type) => type.id == editLeadData!.inquiryType,
      orElse: () => inquiryTypeOptions.first,
    )
        : null;

    // Inquiry Source mapping (use ID and name)
    final List<InqSource> inqSourceList = dropdownData?.inqSource ?? [];
    if (inqSourceList.isNotEmpty) {
      final selectedSource = inqSourceList.firstWhere(
            (source) => source.id == editLeadData!.inquirySourceType,
        orElse: () => inqSourceList.first,
      );
      _selectedInqSourceId = selectedSource.id;
      _selectedInqSource = selectedSource.source;
    }

    // Follow-up date and time
    if (editLeadData!.nxtFollowUp != '0000-00-00 00:00:00') {
      _dateController.text =
          DateFormat('yyyy-MM-dd').format(DateTime.parse(editLeadData!.nxtFollowUp));
      _selectedFollowUpTime =
          DateFormat('HH:mm:ss').format(DateTime.parse(editLeadData!.nxtFollowUp));
    }

    // Debug print
    print("Populated Int Site: $_selectedIntSite (ID: $_selectedIntSiteId)");
    print("Populated Property Config: $_selectedPropertyConfiguration (ID: $_selectedPropertyConfigId)");
    print("Populated Inquiry Source: $_selectedInqSource (ID: $_selectedInqSourceId)");
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
        ? dropdownData.budget!.values.split(',').indexOf(_selectedBudget!).toString()
        : editLeadData?.budget ?? "";
    String approxBuyId = dropdownData.apxTime != null && _selectedApxTime != null
        ? dropdownData.apxTime!.apxTimeData.split(',').indexOf(_selectedApxTime!).toString()
        : editLeadData?.approxBuy ?? "";
    String inquiryTypeId = _selectedInquiryType?.id ?? editLeadData?.inquiryType ?? "";
    String interestedAreaId = dropdownData.areaCityCountry
        ?.firstWhere((area) => area.area == _selectedArea,
        orElse: () => AreaCityCountry(id: "", area: "", city: "", state: "", country: ""))
        .id ??
        editLeadData?.intrestedArea ??
        "";
    String countryCodeId = _selectedCountryCode != null
        ? _selectedCountryCode!.replaceAll('+', '')
        : editLeadData?.countryCode ?? "";
    String interestedProductId = _selectedInterestedProduct ?? "1";

    String interestedSiteId = _selectedIntSiteId ?? editLeadData?.interstedSiteName ?? "";
    String propertyConfigId = _selectedPropertyConfigId ?? editLeadData?.propertyConfiguration ?? "";
    String inquirySourceId = _selectedInqSourceId ?? editLeadData?.inquirySourceType ?? "";

    print("Submitting Lead Data:");
    print("Full Name: ${_fullNameController.text}");
    print("Mobile No: ${_mobileController.text}");
    print("Alt Mobile No: ${_altMobileController.text}");
    print("Email: ${_emailController.text}");
    print("House No: ${_houseController.text}");
    print("Society: ${_societyController.text}");
    print("Area: $_selectedArea");
    print("City: $_selectedCity");
    print("Country Code: $countryCodeId");
    print("Interested Area ID: $interestedAreaId");
    print("Interested Site ID: $interestedSiteId");
    print("Budget ID: $budgetId");
    print("Purpose Buy: $_selectedPurpose");
    print("Approx Buy ID: $approxBuyId");
    print("Property Config ID: $propertyConfigId");
    print("Inquiry Type ID: $inquiryTypeId");
    print("Inquiry Source ID: $inquirySourceId");
    print("Description: ${_descriptionController.text}");
    print("Interested Product ID: $interestedProductId");
    print("Next Follow Up: ${widget.isEdit == true ? editLeadData!.nxtFollowUp : formattedNextFollowUp}");
    print("Time: $_selectedFollowUpTime");

    if (widget.isEdit == true) {
      bool isLeadUpdated = await userProvider.updateLead(
        action: "update",
        leadId: widget.leadId!,
        fullName: _fullNameController.text,
        mobileno: _mobileController.text,
        altmobileno: _altMobileController.text,
        email: _emailController.text,
        houseno: _houseController.text,
        society: _societyController.text,
        area: _selectedArea ?? "",
        city: _selectedCity ?? "",
        countryCode: countryCodeId,
        intrestedArea: interestedAreaId,
        intrestedAreaName: interestedAreaId,
        interstedSiteName: interestedSiteId,
        budget: budgetId,
        purposeBuy: _selectedPurpose ?? "",
        approxBuy: approxBuyId,
        propertyConfiguration: propertyConfigId,
        inquiryType: inquiryTypeId,
        inquirySourceType: inquirySourceId,
        description: _descriptionController.text,
        intrestedProduct: interestedProductId,
        nxtFollowUp: editLeadData!.nxtFollowUp,
      );

      if (isLeadUpdated == false) {
        Fluttertoast.showToast(msg: "Lead updated successfully");
        Navigator.pop(context, true);
      } else {
        Fluttertoast.showToast(msg: "Failed to update lead. Check server logs for details.");
      }
    } else {
      bool isLeadAdded = await userProvider.addLead(
        action: "insert",
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
        description: _descriptionController.text,
      );

      if (isLeadAdded) {
        Fluttertoast.showToast(msg: "Lead added successfully");
        Navigator.pop(context, true);
      } else {
        Fluttertoast.showToast(msg: "This mobile number is already created");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEdit == true ? "Edit Lead" : "Add Lead",
          style: const TextStyle(fontFamily: "poppins_thin", color: Colors.white, fontSize: 20),
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

          print("Area Options: $areaOptions");
          print("City Options: $cityOptions");
          print("Selected Area: $_selectedArea, Selected City: $_selectedCity");
          print("Int Site Options: $intSiteOptions");
          print("Selected Int Site: $_selectedIntSite");
          print("Property Config Options: $propertyConfigurationOptions");
          print("Selected Property Config: $_selectedPropertyConfiguration");
          print("Inquiry Type Options: $inquiryTypeOptions");
          print("Selected Inquiry Type: ${_selectedInquiryType?.id}");
          print("Inquiry Source Options: $inquirySourceOptions");
          print("Selected Inquiry Source: $_selectedInqSource");

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
                    mainAxisAlignment:
                    _currentStep == 0 ? MainAxisAlignment.end : MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentStep > 0)
                        GradientButton(
                          buttonText: "",
                          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                          width: 40.0,
                          onPressed: _goToPreviousStep,
                        ),
                      GradientButton(
                        buttonText: _currentStep == _steps.length - 1
                            ? (widget.isEdit == true ? "Done" : "Submit")
                            : "Next",
                        width: 120.0,
                        onPressed: _currentStep == _steps.length - 1 ? _submitLead : _goToNextStep,
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
      List<String> propertyConfigurationOptions) {
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
      List<String> cityOptions) {
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
                  key: ValueKey(_selectedCountryCode),
                  options: countryCodeOptions,
                  onSelected: (String value) {
                    setState(() {
                      _selectedCountryCode = value;
                    });
                  },
                  isRequired: true,
                  initialValue: _selectedCountryCode,
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
                  enabled: widget.isEdit != true,
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
                      key: ValueKey(_selectedArea),
                      options: areaOptions,
                      onSelected: (String value) {
                        setState(() {
                          _selectedArea = value;
                        });
                      },
                      isRequired: true,
                      initialValue: _selectedArea,
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
                      key: ValueKey(_selectedCity),
                      options: cityOptions,
                      onSelected: (String value) {
                        setState(() {
                          _selectedCity = value;
                        });
                      },
                      isRequired: true,
                      initialValue: _selectedCity,
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
                  key: ValueKey(_selectedCountryCode),
                  options: countryCodeOptions,
                  onSelected: (String value) {
                    setState(() {
                      _selectedCountryCode = value;
                    });
                  },
                  initialValue: _selectedCountryCode,
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
      List<String> inquirySourceOptions) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final dropdownData = userProvider.dropdownData;

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
            key: ValueKey(_selectedArea),
            options: areaOptions,
            onSelected: (String selectedArea) {
              setState(() {
                _selectedArea = selectedArea;
              });
            },
            isRequired: _fillInterest == "1",
            initialValue: _selectedArea,
          ),
          const SizedBox(height: 16),
          const Text(
            "Int Site",
            style: TextStyle(fontSize: 16, fontFamily: "poppins_thin"),
          ),
          SizedBox(height: 5),
          FormField<String>(
            initialValue: _selectedIntSite,
            validator: _fillInterest == "1"
                ? (value) => value == null || value.isEmpty ? "This field is required" : null
                : null,
            builder: (FormFieldState<String> state) {
              final effectiveIntSiteOptions = dropdownData?.intSite
                  ?.map((site) => site.productName)
                  .toList() ??
                  ['No sites available'];

              return DropdownButton2<String>(
                isExpanded: true,
                hint: const Text(
                  'Select Int Site',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: "poppins_thin",
                  ),
                ),
                value: effectiveIntSiteOptions.contains(_selectedIntSite) ? _selectedIntSite : null,
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
                items: effectiveIntSiteOptions.map((String item) {
                  final isSelected = item == _selectedIntSite;
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(
                        fontFamily: "poppins_thin",
                        fontSize: 16,
                        color: isSelected ? Colors.black : Colors.grey.shade600,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedIntSite = value;
                    if (value != null && dropdownData?.intSite != null) {
                      final selectedSite = dropdownData!.intSite!.firstWhere(
                            (site) => site.productName == value,
                        orElse: () => IntSite(id: "", productName: ""),
                      );
                      _selectedIntSiteId = selectedSite.id;
                    }
                    state.didChange(value);
                  });
                },
              );
            },
          ),
          const SizedBox(height: 16),
          const Text(
            "Budget(In Lac)*",
            style: TextStyle(fontSize: 16, fontFamily: "poppins_thin"),
          ),
          SizedBox(height: 5),
          FormField<String>(
            initialValue: _selectedBudget,
            validator: (value) => value == null ? "This field is required" : null,
            builder: (FormFieldState<String> state) {
              return DropdownButton2<String>(
                isExpanded: true,
                hint: const Text(
                  'Select Budget',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: "poppins_thin",
                  ),
                ),
                underline: SizedBox(width: 0),
                value: budgetOptions.contains(_selectedBudget) ? _selectedBudget : null,
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
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 10,
                  scrollbarTheme: ScrollbarThemeData(
                    radius: const Radius.circular(40),
                    thickness: MaterialStateProperty.all(6),
                    thumbVisibility: MaterialStateProperty.all(true),
                  ),
                ),
                items: budgetOptions.map((String item) {
                  final isSelected = item == _selectedBudget;
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(
                        fontFamily: "poppins_thin",
                        fontSize: 16,
                        color: isSelected ? Colors.black : Colors.grey.shade600,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBudget = value;
                    state.didChange(value);
                  });
                },
              );
            },
          ),
          const SizedBox(height: 16),
          const Text(
            "Purpose of Buying",
            style: TextStyle(fontSize: 16, fontFamily: "poppins_thin"),
          ),
          SizedBox(height: 5),
          FormField<String>(
            initialValue: _selectedPurpose,
            validator: _fillInterest == "1"
                ? (value) => value == null ? "This field is required" : null
                : null,
            builder: (FormFieldState<String> state) {
              return DropdownButton2<String>(
                isExpanded: true,
                hint: const Text(
                  'Select Purpose',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: "poppins_thin",
                  ),
                ),
                underline: SizedBox(width: 0),
                value: purposeOptions.contains(_selectedPurpose) ? _selectedPurpose : null,
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
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 10,
                  scrollbarTheme: ScrollbarThemeData(
                    radius: const Radius.circular(40),
                    thickness: MaterialStateProperty.all(6),
                    thumbVisibility: MaterialStateProperty.all(true),
                  ),
                ),
                items: purposeOptions.map((String item) {
                  final isSelected = item == _selectedPurpose;
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(
                        fontFamily: "poppins_thin",
                        fontSize: 16,
                        color: isSelected ? Colors.black : Colors.grey.shade600,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPurpose = value;
                    state.didChange(value);
                  });
                },
              );
            },
          ),
          const SizedBox(height: 16),
          const Text(
            "Apx Buying Time",
            style: TextStyle(fontSize: 16, fontFamily: "poppins_thin"),
          ),
          SizedBox(height: 5),
          FormField<String>(
            initialValue: _selectedApxTime,
            validator: _fillInterest == "1"
                ? (value) => value == null ? "This field is required" : null
                : null,
            builder: (FormFieldState<String> state) {
              return DropdownButton2<String>(
                isExpanded: true,
                hint: const Text(
                  'Select Apx Buying Time',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: "poppins_thin",
                  ),
                ),
                underline: SizedBox(width: 0),
                value: apxTimeOptions.contains(_selectedApxTime) ? _selectedApxTime : null,
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
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 10,
                  scrollbarTheme: ScrollbarThemeData(
                    radius: const Radius.circular(40),
                    thickness: MaterialStateProperty.all(6),
                    thumbVisibility: MaterialStateProperty.all(true),
                  ),
                ),
                items: apxTimeOptions.map((String item) {
                  final isSelected = item == _selectedApxTime;
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(
                        fontFamily: "poppins_thin",
                        fontSize: 16,
                        color: isSelected ? Colors.black : Colors.grey.shade600,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedApxTime = value;
                    state.didChange(value);
                  });
                },
              );
            },
          ),
          const SizedBox(height: 16),
          const Text(
            "Property Configuration*",
            style: TextStyle(fontSize: 16, fontFamily: "poppins_thin"),
          ),
          SizedBox(height: 5),
          FormField<String>(
            initialValue: _selectedPropertyConfiguration,
            validator: (value) => value == null || value.isEmpty ? "This field is required" : null,
            builder: (FormFieldState<String> state) {
              final effectivePropertyConfigOptions = dropdownData?.propertyConfiguration
                  ?.map((prop) => prop.propertyType)
                  .toList() ??
                  ['No configurations available'];

              return DropdownButton2<String>(
                isExpanded: true,
                hint: const Text(
                  'Select Property Configuration',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: "poppins_thin",
                  ),
                ),
                value: effectivePropertyConfigOptions.contains(_selectedPropertyConfiguration)
                    ? _selectedPropertyConfiguration
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
                items: effectivePropertyConfigOptions.map((String item) {
                  final isSelected = item == _selectedPropertyConfiguration;
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(
                        fontFamily: "poppins_thin",
                        fontSize: 16,
                        color: isSelected ? Colors.black : Colors.grey.shade600,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPropertyConfiguration = value;
                    if (value != null && dropdownData?.propertyConfiguration != null) {
                      final selectedConfig = dropdownData!.propertyConfiguration!.firstWhere(
                            (prop) => prop.propertyType == value,
                        orElse: () => PropertyConfiguration(id: "", propertyType: ""),
                      );
                      _selectedPropertyConfigId = selectedConfig.id;
                    }
                    state.didChange(value);
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInquiryInformationSection(
      List<InqType> inquiryTypeOptions,
      List<String> inquirySourceOptions) {
    final nextSlotProvider = Provider.of<UserProvider>(context);
    final dropdownData = nextSlotProvider.dropdownData;

    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Inquiry Type*",
            style: TextStyle(fontSize: 16, fontFamily: "poppins_thin"),
          ),
          SizedBox(height: 5),
          FormField<InqType>(
            initialValue: _selectedInquiryType,
            validator: (value) => value == null ? "This field is required" : null,
            builder: (FormFieldState<InqType> state) {
              final effectiveInquiryTypeOptions = inquiryTypeOptions.isNotEmpty
                  ? inquiryTypeOptions
                  : [InqType(id: "0", inquiryDetails: "No inquiry types available")];

              return DropdownButton2<InqType>(
                isExpanded: true,
                hint: const Text(
                  'Select Inquiry Type',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: "poppins_thin",
                  ),
                ),
                value: _selectedInquiryType,
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
                items: effectiveInquiryTypeOptions.map((InqType item) {
                  final isSelected = item == _selectedInquiryType;
                  return DropdownMenuItem<InqType>(
                    value: item,
                    child: Text(
                      item.inquiryDetails,
                      style: TextStyle(
                        fontFamily: "poppins_thin",
                        fontSize: 16,
                        color: isSelected ? Colors.black : Colors.grey.shade600,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedInquiryType = value;
                    state.didChange(value);
                  });
                },
              );
            },
          ),
          const SizedBox(height: 16),
          const Text(
            "Inquiry Source*",
            style: TextStyle(fontSize: 16, fontFamily: "poppins_thin"),
          ),
          SizedBox(height: 5),
          FormField<String>(
            initialValue: _selectedInqSource,
            validator: (value) => value == null || value.isEmpty ? "This field is required" : null,
            builder: (FormFieldState<String> state) {
              final effectiveInquirySourceOptions = dropdownData?.inqSource
                  ?.map((source) => source.source)
                  .toList() ??
                  ['No sources available'];

              return DropdownButton2<String>(
                isExpanded: true,
                hint: const Text(
                  'Select Inquiry Source',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: "poppins_thin",
                  ),
                ),
                value: effectiveInquirySourceOptions.contains(_selectedInqSource)
                    ? _selectedInqSource
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
                items: effectiveInquirySourceOptions.map((String item) {
                  final isSelected = item == _selectedInqSource;
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(
                        fontFamily: "poppins_thin",
                        fontSize: 16,
                        color: isSelected ? Colors.black : Colors.grey.shade600,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedInqSource = value;
                    if (value != null && dropdownData?.inqSource != null) {
                      final selectedSource = dropdownData!.inqSource!.firstWhere(
                            (source) => source.source == value,
                        orElse: () => InqSource(id: "", source: ""),
                      );
                      _selectedInqSourceId = selectedSource.id;
                    }
                    state.didChange(value);
                  });
                },
              );
            },
          ),
          widget.isEdit == false ? SizedBox(height: 16) : SizedBox(height: 0),
          widget.isEdit == false
              ? Text(
            "Next Follow Up*",
            style: TextStyle(fontSize: 16, fontFamily: "poppins_thin"),
          )
              : SizedBox(height: 0),
          widget.isEdit == false
              ? TextFormField(
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
          )
              : SizedBox(height: 0),
          const SizedBox(height: 16),
          widget.isEdit == false
              ? Text(
            "Follow Up Time*",
            style: TextStyle(fontSize: 16, fontFamily: "poppins_thin"),
          )
              : SizedBox(height: 0),
          SizedBox(height: 5),
          widget.isEdit == false
              ? nextSlotProvider.isLoading
              ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
              : FormField<String>(
            initialValue: _selectedFollowUpTime,
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
                  final isSelected = slot.source == _selectedFollowUpTime;
                  return DropdownMenuItem<String>(
                    value: slot.disabled ? slot.source : null,
                    enabled: slot.disabled,
                    child: Text(
                      slot.source ?? '',
                      style: TextStyle(
                        fontFamily: "poppins_thin",
                        fontSize: 16,
                        color: isSelected
                            ? Colors.black
                            : (slot.disabled ? Colors.black : Colors.grey.shade600),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedFollowUpTime = value;
                      state.didChange(value);
                    });
                  }
                },
              );
            },
          )
              : SizedBox(height: 0),
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
  final T? initialValue;

  const CombinedDropdownTextField({
    super.key,
    required this.options,
    this.displayString,
    required this.onSelected,
    this.isRequired = false,
    this.initialValue,
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
    if (widget.initialValue != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.text = _getDisplayString(widget.initialValue as T);
        print("CombinedDropdown Initial Value: ${_controller.text}");
      });
    }
  }

  @override
  void didUpdateWidget(CombinedDropdownTextField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue && widget.initialValue != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.text = _getDisplayString(widget.initialValue as T);
        _filteredOptions = widget.options;
        print("CombinedDropdown Updated Value: ${_controller.text}");
      });
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
      }
    });
  }

  void _filterOptions(String query) {
    setState(() {
      _filteredOptions = widget.options
          .where((option) => _getDisplayString(option).toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  String _getDisplayString(T option) {
    return widget.displayString != null ? widget.displayString!(option) : option.toString();
  }

  void _selectOption(T option) {
    setState(() {
      _controller.text = _getDisplayString(option);
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
              border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
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
                    _filteredOptions = widget.options;
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
                _filteredOptions = widget.options;
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
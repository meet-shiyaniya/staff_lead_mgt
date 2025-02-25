import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../Provider/UserProvider.dart';
import '../../Inquiry Management Screens/all_inquiries_Screen.dart';
import '../Colors/app_Colors.dart';
import 'custom_buttons.dart';

class AddLeadScreen extends StatefulWidget {
  final bool? isEdit;
  AddLeadScreen({super.key, this.isEdit});

  @override
  _AddLeadScreenState createState() => _AddLeadScreenState();
}

class _AddLeadScreenState extends State<AddLeadScreen> {
  int _currentStep = 0;
  String? _selectedCountryCode;
  String? _selectedArea;
  String? _selectedCity;
  String? _selectedInquiryType;
  String? _selectedInqSource;
  String? _selectedIntSite;
  String? _selectedBudget;
  String? _selectedPurpose;
  String? _selectedApxTime;
  String? _selectedPropertyConfiguration;

  bool _isCSTInterestVisible = false;
  String? _selectedCSTType = 'Service';
  String? selectedBuyingTime;
  String? selectedDuration;
  DateTime? dateOfBirth;
  DateTime? anniversaryDate;
  DateTime? nextFollowUp;
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _anniversaryController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String selectedType = "Service";
  String? selectedProduct;
  String? selectedService;
  String approxBuying = "";
  String serviceDuration = "";

  final List<String> _steps = ["Personal Info", "CST & Inquiry", "Follow Up"];

  @override
  void initState() {
    super.initState();
    // Fetch dropdown options when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.fetchAddLeadData().then((_) {
        setState(() {});
      });
    });
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
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (userProvider.isLoadingDropdown) {
            return const Center(child: CircularProgressIndicator());
          }

          final dropdownData = userProvider.dropdownData;
          if (dropdownData == null) {
            print("Dropdown data is null");
            return const Center(child: Text("Failed to load dropdown options"));
          }

          // Extract data from AddLeadDataModel with null safety and filtering
          final countryCodes = ['+1', '+44', '+91']; // Hardcoded for now; update from API if available
          final areas = dropdownData.areaCityCountry.map((area) => area.area).where((area) => area.trim().isNotEmpty || area == 'Surat' || area == 'Varachha').toList();
          final cities = dropdownData.areaCityCountry.map((city) => city.city).where((city) => city.trim().isNotEmpty || city == 'Surat').toList();
          final inquiryTypes = dropdownData.inqType.map((inq) => inq.inquiryDetails).where((type) => type.trim().isNotEmpty).toList();
          final inquirySources = dropdownData.inqSource.map((source) => source.source).where((source) => source.trim().isNotEmpty).toList();
          final buyingTimes = dropdownData.apxTime?.apxTimeData.split(',').map((e) => e.trim()).where((time) => time.isNotEmpty).toList() ?? ['2-3 days', '1 week', '1 month'];
          final budgets = dropdownData.budget?.values.split(',').map((value) => value.trim()).where((value) => value.isNotEmpty).toList() ?? ['0-10', '10-20', '20-50'];
          final purposes = dropdownData.purposeOfBuying != null
              ? [dropdownData.purposeOfBuying!.investment, dropdownData.purposeOfBuying!.personalUse].where((purpose) => purpose.isNotEmpty).toList()
              : ['Investment', 'Personal Use'];
          final propertyConfigurations = dropdownData.propertyConfiguration.map((prop) => prop.propertyType).where((config) => config.trim().isNotEmpty).toList();
          final intSites = dropdownData.intSite.map((site) => site.productName).where((site) => site.trim().isNotEmpty).toList();

          print("Areas: $areas");
          print("Cities: $cities");
          print("Buying Times: $buyingTimes");
          print("Budgets: $budgets");
          print("Purposes: $purposes");
          print("Property Configurations: $propertyConfigurations");
          print("Int Sites: $intSites");
          print("Inquiry Types: $inquiryTypes");
          print("Inquiry Sources: $inquirySources");

          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildFormContent(countryCodes, areas, cities, inquiryTypes, inquirySources, buyingTimes, budgets, purposes, propertyConfigurations, intSites),
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
                          ? () {
                        Navigator.pop(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AllInquiriesScreen(),
                          ),
                        );
                      }
                          : _goToNextStep,
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildFormContent(List<String> countryCodes, List<String> areas, List<String> cities, List<String> inquiryTypes, List<String> inquirySources, List<String> buyingTimes, List<String> budgets, List<String> purposes, List<String> propertyConfigurations, List<String> intSites) {
    // Filter out empty strings, but allow non-empty strings (including "Surat" or numbers)
    final filteredAreas = areas.where((area) => area.trim().isNotEmpty || area == 'Surat' || area == 'Varachha').toList(); // Allow specific non-empty values
    final filteredCities = cities.where((city) => city.trim().isNotEmpty || city == 'Surat').toList(); // Allow specific non-empty values
    final filteredIntSites = intSites.where((site) => site.trim().isNotEmpty).toList();
    final filteredPropertyConfigurations = propertyConfigurations.where((config) => config.trim().isNotEmpty).toList();
    final filteredInquiryTypes = inquiryTypes.where((type) => type.trim().isNotEmpty).toList();
    final filteredInquirySources = inquirySources.where((source) => source.trim().isNotEmpty).toList();

    // Handle Budget: Split the comma-separated string into a list of numbers
    final filteredBudgets = budgets.isNotEmpty && budgets[0].isNotEmpty
        ? budgets[0].split(',').map((value) => value.trim()).where((value) => value.isNotEmpty).toList()
        : ['0-10', '10-20', '20-50']; // Default values if empty

    // Handle Buying Times: Split the comma-separated string and filter non-empty
    final filteredBuyingTimes = buyingTimes.isNotEmpty
        ? buyingTimes.where((time) => time.trim().isNotEmpty).toList()
        : ['2-3 days', '1 week', '1 month']; // Default values if empty

    print("Filtered Areas: $filteredAreas");
    print("Filtered Cities: $filteredCities");
    print("Filtered Buying Times: $filteredBuyingTimes");
    print("Filtered Budgets: $filteredBudgets");
    print("Filtered Purposes: $purposes");
    print("Filtered Property Configurations: $filteredPropertyConfigurations");
    print("Filtered Int Sites: $filteredIntSites");
    print("Filtered Inquiry Types: $filteredInquiryTypes");
    print("Filtered Inquiry Sources: $filteredInquirySources");

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
              Card(child: _buildPersonalInquirySection(countryCodes, filteredAreas, filteredCities)),
            ],
            if (_currentStep == 1) ...[
              const Text(
                "CST Interest",
                style: TextStyle(fontSize: 24, fontFamily: "poppins_thin"),
              ),
              Card(
                child: _buildCSTInterestSection(context, filteredAreas, filteredIntSites, filteredBudgets, purposes, filteredBuyingTimes, filteredPropertyConfigurations, filteredInquirySources),
              ),
            ],
            if (_currentStep == 2) ...[
              const SizedBox(height: 16),
              const Text(
                "Inquiry Information",
                style: TextStyle(fontSize: 24, fontFamily: "poppins_thin"),
              ),
              Card(child: _buildInquiryInformationSection(filteredInquiryTypes, filteredInquirySources)),
              SizedBox(height: 15,),
              Text(
                "Follow up",
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
    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
        print("Navigating to next step: $_currentStep");
      });
    }
  }

  void _goToPreviousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
        print("Navigating to next step: $_currentStep");
      });
    }
  }

  Widget _buildPersonalInquirySection(List<String> countryCodes, List<String> areas, List<String> cities) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        children: [
          Row(
            children: [
              // Country Code Dropdown
              SizedBox(
                width: 80,
                child: DropdownButton2(
                  isExpanded: true,
                  hint: Text('+91',
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: "poppins_thin")),
                  value: _selectedCountryCode,
                  buttonStyleData: ButtonStyleData(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Colors.grey.shade200,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 4,
                            spreadRadius: 2)
                      ],
                    ),
                  ),
                  underline: const Center(),
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    elevation: 10,
                  ),
                  items: countryCodes.map((code) => DropdownMenuItem(
                    value: code,
                    child: Text(code, style: const TextStyle(fontFamily: "poppins_thin")),
                  )).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCountryCode = value;
                      print('Country Code Dropdown changed to: $_selectedCountryCode');
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Mobile No.",
                    labelStyle: const TextStyle(fontFamily: "poppins_thin"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Full Name",
                    labelStyle: const TextStyle(fontFamily: "poppins_thin"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DropdownButton2(
                  isExpanded: true,
                  hint: Text('Area',
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: "poppins_thin")),
                  value: _selectedArea,
                  buttonStyleData: ButtonStyleData(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Colors.grey.shade200,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 4,
                            spreadRadius: 2)
                      ],
                    ),
                  ),
                  underline: const Center(),
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    elevation: 10,
                  ),
                  items: areas.map((area) => DropdownMenuItem(
                    value: area,
                    child: Text(area, style: const TextStyle(fontFamily: "poppins_thin")),
                  )).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedArea = value;
                      print('Area Dropdown changed to: $_selectedArea');
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButton2(
                  isExpanded: true,
                  hint: Text('City',
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: "poppins_thin")),
                  value: _selectedCity,
                  buttonStyleData: ButtonStyleData(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Colors.grey.shade200,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 4,
                            spreadRadius: 2)
                      ],
                    ),
                  ),
                  underline: const Center(),
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    elevation: 10,
                  ),
                  items: cities.map((city) => DropdownMenuItem(
                    value: city,
                    child: Text(city, style: const TextStyle(fontFamily: "poppins_thin")),
                  )).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCity = value;
                      print('City Dropdown changed to: $_selectedCity');
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: "House",
                  labelStyle: const TextStyle(fontFamily: "poppins_thin"),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Society",
                  labelStyle: const TextStyle(fontFamily: "poppins_thin"),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              // Country Code Dropdown
              SizedBox(
                width: 80,
                child: DropdownButton2(
                  isExpanded: true,
                  hint: Text('+91',
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: "poppins_thin")),
                  value: _selectedCountryCode,
                  buttonStyleData: ButtonStyleData(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Colors.grey.shade200,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 4,
                            spreadRadius: 2)
                      ],
                    ),
                  ),
                  underline: const Center(),
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    elevation: 10,
                  ),
                  items: countryCodes.map((code) => DropdownMenuItem(
                    value: code,
                    child: Text(code, style: const TextStyle(fontFamily: "poppins_thin")),
                  )).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCountryCode = value;
                      print('Country Code Dropdown changed to: $_selectedCountryCode');
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: " Alt. Mobile No.",
                    labelStyle: const TextStyle(fontFamily: "poppins_thin"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Email Address",
                  labelStyle: const TextStyle(fontFamily: "poppins_thin"),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Society",
                  labelStyle: const TextStyle(fontFamily: "poppins_thin"),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _dobController,
                  decoration: InputDecoration(
                    labelText: "Date of Birth",
                    labelStyle: const TextStyle(fontFamily: "poppins_thin"),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        dateOfBirth = picked;
                        _dobController.text = DateFormat('dd/MM/yyyy').format(dateOfBirth!);
                        print('Date of Birth changed to: $dateOfBirth');
                      });
                    }
                  },
                ),
              ),
              const SizedBox(width: 10,),
              Expanded(
                child: TextFormField(
                  controller: _anniversaryController,
                  decoration: InputDecoration(
                    labelText: "Anniversary Date",
                    labelStyle: const TextStyle(fontFamily: "poppins_thin"),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() {
                        anniversaryDate = picked;
                        _anniversaryController.text = DateFormat('dd/MM/yyyy').format(anniversaryDate!);
                        print('Anniversary Date changed to: $anniversaryDate');
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCSTInterestSection(BuildContext context, List<String> areas, List<String> intSites, List<String> budgets, List<String> purposes, List<String> buyingTimes, List<String> propertyConfigurations, List<String> inquirySources) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          // Int Area and Int Site
          Column(
            children: [
              Row( // Use Row as the parent
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Int Area*", style: TextStyle(fontSize: 16, fontFamily: "poppins_thin")),
                        DropdownButton2(
                          isExpanded: true,
                          hint: Text('Select Int Area',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: "poppins_thin")),
                          value: _selectedArea,
                          buttonStyleData: ButtonStyleData(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: Colors.grey.shade200,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade300,
                                    blurRadius: 4,
                                    spreadRadius: 2)
                              ],
                            ),
                          ),
                          underline: const Center(),
                          dropdownStyleData: DropdownStyleData(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 2),
                            ),
                            elevation: 10,
                          ),
                          items: areas.map((area) => DropdownMenuItem(
                            value: area,
                            child: Text(area, style: const TextStyle(fontFamily: "poppins_thin")),
                          )).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedArea = value;
                              print('Int Area Dropdown changed to: $_selectedArea');
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Int Site*", style: TextStyle(fontSize: 16, fontFamily: "poppins_thin")),
                  DropdownButton2(
                    isExpanded: true,
                    hint: Text('Select Int Site',
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: "poppins_thin")),
                    value: _selectedIntSite,
                    buttonStyleData: ButtonStyleData(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: Colors.grey.shade200,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 4,
                              spreadRadius: 2)
                        ],
                      ),
                    ),
                    underline: const Center(),
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      elevation: 10,
                    ),
                    items: intSites.map((site) => DropdownMenuItem(
                      value: site,
                      child: Text(site, style: const TextStyle(fontFamily: "poppins_thin")),
                    )).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedIntSite = value;
                        print('Int Site Dropdown changed to: $_selectedIntSite');
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Budget and Purpose
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Budget(In Lac)*",
                        style: TextStyle(fontSize: 16, fontFamily: "poppins_thin")),
                    DropdownButton2(
                      isExpanded: true,
                      hint: Text('Select Budget',
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: "poppins_thin")),
                      value: _selectedBudget,
                      buttonStyleData: ButtonStyleData(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Colors.grey.shade200,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 4,
                                spreadRadius: 2)
                          ],
                        ),
                      ),
                      underline: const Center(),
                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                        elevation: 10,
                      ),
                      items: budgets.map((budget) => DropdownMenuItem(
                        value: budget.isNotEmpty ? budget : null,
                        child: Text(budget, style: const TextStyle(fontFamily: "poppins_thin")),
                      )).where((item) => item.value != null).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedBudget = value;
                          print('Budget Dropdown changed to: $_selectedBudget');
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Purpose of Buying*",
                  style: TextStyle(fontSize: 16, fontFamily: "poppins_thin")),
              DropdownButton2(
                isExpanded: true,
                hint: Text('Select Purpose',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: "poppins_thin")),
                value: _selectedPurpose,
                buttonStyleData: ButtonStyleData(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.grey.shade200,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 4,
                          spreadRadius: 2)
                    ],
                  ),
                ),
                underline: const Center(),
                dropdownStyleData: DropdownStyleData(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  elevation: 10,
                ),
                items: purposes.where((purpose) => purpose.isNotEmpty).map((purpose) => DropdownMenuItem(
                  value: purpose,
                  child: Text(purpose, style: const TextStyle(fontFamily: "poppins_thin")),
                )).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPurpose = value;
                    print('Purpose Dropdown changed to: $_selectedPurpose');
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 16,),
          // Apx Buying Time and Property Configuration
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Apx Buying Time : *",
                        style: TextStyle(fontSize: 16, fontFamily: "poppins_thin")),
                    DropdownButton2(
                      isExpanded: true,
                      hint: Text('Select Apx Buying Time',
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: "poppins_thin")),
                      value: _selectedApxTime,
                      buttonStyleData: ButtonStyleData(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Colors.grey.shade200,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 4,
                                spreadRadius: 2)
                          ],
                        ),
                      ),
                      underline: const Center(),
                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                        elevation: 10,
                      ),
                      items: buyingTimes.map((time) => DropdownMenuItem(
                        value: time,
                        child: Text(time, style: const TextStyle(fontFamily: "poppins_thin")),
                      )).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedApxTime = value;
                          print('Apx Buying Time Dropdown changed to: $_selectedApxTime');
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Property Configuration*",
                  style: TextStyle(fontSize: 16, fontFamily: "poppins_thin")),
              DropdownButton2(
                isExpanded: true,
                hint: Text('Select Property Configuration',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: "poppins_thin")),
                value: _selectedPropertyConfiguration,
                buttonStyleData: ButtonStyleData(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.grey.shade200,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 4,
                          spreadRadius: 2)
                    ],
                  ),
                ),
                underline: const Center(),
                dropdownStyleData: DropdownStyleData(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  elevation: 10,
                ),
                items: propertyConfigurations.map((config) => DropdownMenuItem(
                  value: config,
                  child: Text(config, style: const TextStyle(fontFamily: "poppins_thin")),
                )).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPropertyConfiguration = value;
                    print('Property Configuration Dropdown changed to: $_selectedPropertyConfiguration');
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 15,),
          // Inq Source
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Inq Source*", style: TextStyle(fontSize: 16, fontFamily: "poppins_thin")),
              DropdownButton2(
                isExpanded: true,
                hint: Text('Select Inq Source',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: "poppins_thin")),
                value: _selectedInqSource,
                buttonStyleData: ButtonStyleData(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.grey.shade200,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 4,
                          spreadRadius: 2)
                    ],
                  ),
                ),
                underline: const Center(),
                dropdownStyleData: DropdownStyleData(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  elevation: 10,
                ),
                items: inquirySources.map((source) => DropdownMenuItem(
                  value: source,
                  child: Text(source, style: const TextStyle(fontFamily: "poppins_thin")),
                )).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedInqSource = value;
                    print('Inq Source Dropdown changed to: $_selectedInqSource');
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInquiryInformationSection(List<String> inquiryTypes, List<String> inquirySources) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Center(
        child: Column(
          children: [
            DropdownButton2(
              isExpanded: true,
              hint: Text('Inquiry Type',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: "poppins_thin")),
              value: _selectedInquiryType,
              buttonStyleData: ButtonStyleData(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: Colors.grey.shade200,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 4,
                        spreadRadius: 2)
                  ],
                ),
              ),
              underline: const Center(),
              dropdownStyleData: DropdownStyleData(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                ),
                elevation: 10,
              ),
              items: inquiryTypes.map((type) => DropdownMenuItem(
                value: type,
                child: Text(type, style: const TextStyle(fontFamily: "poppins_thin")),
              )).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedInquiryType = value;
                  print('Inquiry Type Dropdown changed to: $_selectedInquiryType');
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButton2(
              isExpanded: true,
              hint: Text('Inq Source',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: "poppins_thin")),
              value: _selectedInqSource,
              buttonStyleData: ButtonStyleData(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: Colors.grey.shade200,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 4,
                        spreadRadius: 2)
                  ],
                ),
              ),
              underline: const Center(),
              dropdownStyleData: DropdownStyleData(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                ),
                elevation: 10,
              ),
              items: inquirySources.map((source) => DropdownMenuItem(
                value: source,
                child: Text(source, style: const TextStyle(fontFamily: "poppins_thin")),
              )).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedInqSource = value;
                  print('Inq Source Dropdown changed to: $_selectedInqSource');
                });
              },
            ),
            const SizedBox(height: 16),
            widget.isEdit == false
                ? TextFormField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: "Next Follow Up",
                labelStyle: const TextStyle(fontFamily: "poppins_thin"),
                border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
                    _dateController.text =
                        DateFormat('yyyy-MM-dd').format(nextFollowUp!);
                    print('Next Follow Up changed to: $nextFollowUp');
                  });
                }
              },
            )
                : const SizedBox(
              height: 0,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFollowUpSection() {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: "Description",
          labelStyle: const TextStyle(fontFamily: "poppins_thin"),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        maxLines: 3,
      ),
    );
  }
}
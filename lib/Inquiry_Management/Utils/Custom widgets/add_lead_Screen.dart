import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:inquiry_management_ui/Utils/Colors/app_Colors.dart';
import 'package:intl/intl.dart';

import '../../Inquiry Management Screens/all_inquiries_Screen.dart';
import '../../test.dart';
import '../Colors/app_Colors.dart';
import 'custom_buttons.dart';

// import 'Utils/Custom widgets/custom_buttons.dart';

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

  // List Options
  final List<String> products = ['Laptop', 'Mobile Phone', 'Tablet'];
  final List<String> services = ['IELTS (UK)', 'IELTS (US)', 'TOEFL'];
  final List<String> areas = ['Area 1', 'Area 2', 'Area 3'];
  final List<String> cities = ['City A', 'City B', 'City C'];
  final List<String> countryCodes = ['+1', '+44', '+91'];
  final List<String> inquiryTypes = ['Type A', 'Type B', 'Type C'];
  final List<String> inquirySources = ['Source 1', 'Source 2', 'Source 3'];
  final List<String> buyingTimes = ['Now', 'Soon', 'Later'];
  final List<String> durations = ['1-month', '3-month', '6-month', '12-month'];

  final List<String> _steps = ["Personal Info", "CST & Inquiry", "Follow Up"];

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
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildFormContent(),
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
                  buttonText:
                  _currentStep == _steps.length - 1 ? "Submit" : "Next",
                  width: 120.0,
                  onPressed: _currentStep == _steps.length - 1
                      ? () {
                    Navigator.pop(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        const AllInquiriesScreen(), // Navigate
                      ),
                    );
                  }
                      : _goToNextStep,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFormContent() {
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
              Card(child: _buildPersonalInquirySection()),
            ],
            if (_currentStep == 1) ...[
              const Text(
                "CST Interest",
                style: TextStyle(fontSize: 24, fontFamily: "poppins_thin"),
              ),
              Card(
                child: _buildCSTInterestSection(context),
              ),

            ],
            if (_currentStep == 2) ...[
              const SizedBox(height: 16),
              const Text(
                "Inquiry Information",
                style: TextStyle(fontSize: 24, fontFamily: "poppins_thin"),
              ),
              Card(child: _buildInquiryInformationSection()),
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
        print("Navigating to previous step: $_currentStep");
      });
    }
  }


  Widget _buildCSTInterestSection(BuildContext context) {
    return   Padding(
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
                        CombinedDropdownTextField(
                          options: areaOptions,
                          onSelected: (String selectedArea) {
                            setState(() {
                              _selectedArea = selectedArea;
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
                  CombinedDropdownTextField(
                    options: intSiteOptions,
                    onSelected: (String selectedIntSite) {
                      setState(() {
                        _selectedIntSite = selectedIntSite;
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
                        style: TextStyle(fontSize: 16,fontFamily: "poppins_thin")),
                    CombinedDropdownTextField(
                      options: budgetOptions,
                      onSelected: (String selectedBudget) {
                        setState(() {
                          _selectedBudget = selectedBudget;
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
                  style: TextStyle(fontSize: 16,fontFamily: "poppins_thin")),
              CombinedDropdownTextField(
                options: purposeOptions,
                onSelected: (String selectedPurpose) {
                  setState(() {
                    _selectedPurpose = selectedPurpose;
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
                        style: TextStyle(fontSize: 16,fontFamily: "poppins_thin")),
                    CombinedDropdownTextField(
                      options: apxTimeOptions,
                      onSelected: (String selectedApxTime) {
                        setState(() {
                          _selectedApxTime = selectedApxTime;
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
                  style: TextStyle(fontSize: 16,fontFamily: "poppins_thin")),
              CombinedDropdownTextField(
                options: propertyConfigurationOptions,
                onSelected: (String selectedPropertyConfiguration) {
                  setState(() {
                    _selectedPropertyConfiguration =
                        selectedPropertyConfiguration;
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
              const Text("Inq Source*", style: TextStyle(fontSize: 16,fontFamily: "poppins_thin")),
              CombinedDropdownTextField(
                options: inqSourceOptions,
                onSelected: (String selectedInqSource) {
                  setState(() {
                    _selectedInqSource = selectedInqSource;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }



  // String? _selectedArea;
  String? _selectedIntSite;
  String? _selectedBudget;
  String? _selectedPurpose;
  String? _selectedApxTime;
  String? _selectedPropertyConfiguration;
  // String? _selectedInqSource;

  // Define lists of options for each dropdown
  List<String> areaOptions = ['Area 1', 'Area 2', 'Area 3']; // Replace with your actual data
  List<String> intSiteOptions = ['Site A', 'Site B', 'Site C']; // Replace with your actual data
  List<String> budgetOptions = ['50-75 Lac', '75-100 Lac', '100+ Lac']; // Replace with your actual data
  List<String> purposeOptions = ['Investment', 'Self Use', 'Rental Income']; // Replace with your actual data
  List<String> apxTimeOptions = ['2-3 Days', 'Week'];
  List<String> propertyConfigurationOptions = ['Apartment', 'Villa', 'Land']; // Replace with your actual data
  List<String> inqSourceOptions = ['Website', 'Referral', 'Social Media']; // Replace with your actual data

  Widget _buildPersonalInquirySection() {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        children: [
          Row(
            children: [
              // Country Code Dropdown
              SizedBox(
                width: 90,
                child: DropdownButton2(
                  isExpanded: true,
                  hint: Text('+91',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
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
                  items: const [
                    DropdownMenuItem(
                        value: '+87',
                        child: Text('+87',
                            style: TextStyle(fontFamily: "poppins_thin"))),
                    DropdownMenuItem(
                        value: '+78',
                        child: Text('+91',
                            style: TextStyle(fontFamily: "poppins_thin"))),
                    DropdownMenuItem(
                        value: '+73',
                        child: Text('+85',
                            style: TextStyle(fontFamily: "poppins_thin"))),
                  ],
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
                  items: const [
                    DropdownMenuItem(
                        value: 'Area 1',
                        child: Text('Area 1',
                            style: TextStyle(fontFamily: "poppins_thin"))),
                    DropdownMenuItem(
                        value: 'Area 2',
                        child: Text('Area 2',
                            style: TextStyle(fontFamily: "poppins_thin"))),
                    DropdownMenuItem(
                        value: 'Area 3',
                        child: Text('Area 3',
                            style: TextStyle(fontFamily: "poppins_thin"))),
                  ],
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
                  items: const [
                    DropdownMenuItem(
                        value: 'Surat',
                        child: Text('Surat',
                            style: TextStyle(fontFamily: "poppins_thin"))),
                    DropdownMenuItem(
                        value: 'Ahmedabad',
                        child: Text('Ahmedabad',
                            style: TextStyle(fontFamily: "poppins_thin"))),
                    DropdownMenuItem(
                        value: 'Vadodara',
                        child: Text('Vadodara',
                            style: TextStyle(fontFamily: "poppins_thin"))),
                  ],
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
                  items: const [
                    DropdownMenuItem(
                        value: '+87',
                        child: Text('+87',
                            style: TextStyle(fontFamily: "poppins_thin"))),
                    DropdownMenuItem(
                        value: '+78',
                        child: Text('+91',
                            style: TextStyle(fontFamily: "poppins_thin"))),
                    DropdownMenuItem(
                        value: '+73',
                        child: Text('+85',
                            style: TextStyle(fontFamily: "poppins_thin"))),
                  ],
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

  Widget _buildInquiryInformationSection() {
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
              items: const [
                DropdownMenuItem(
                    value: 'Telephone',
                    child: Text('Telephone',
                        style: TextStyle(fontFamily: "poppins_thin"))),
                DropdownMenuItem(
                    value: 'Website',
                    child: Text('Website',
                        style: TextStyle(fontFamily: "poppins_thin"))),
                DropdownMenuItem(
                    value: 'Facebook',
                    child: Text('Facebook',
                        style: TextStyle(fontFamily: "poppins_thin"))),
              ],
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
              items: const [
                DropdownMenuItem(
                    value: 'Events',
                    child: Text('Events',
                        style: TextStyle(fontFamily: "poppins_thin"))),
                DropdownMenuItem(
                    value: 'Website',
                    child: Text('Website',
                        style: TextStyle(fontFamily: "poppins_thin"))),
                DropdownMenuItem(
                    value: 'Facebook',
                    child: Text('Facebook',
                        style: TextStyle(fontFamily: "poppins_thin"))),
              ],
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
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter/material.dart';

class CombinedDropdownTextField extends StatefulWidget {
  final List<String> options;
  final Function(String) onSelected;

  const CombinedDropdownTextField({
    super.key,
    required this.options,
    required this.onSelected,
  });

  @override
  State<CombinedDropdownTextField> createState() =>
      _CombinedDropdownTextFieldState();
}

class _CombinedDropdownTextFieldState extends State<CombinedDropdownTextField> {
  final TextEditingController _controller = TextEditingController();
  bool _isDropdownVisible = false;
  List<String> _filteredOptions = [];
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink(); // Define LayerLink here

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
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
          .where((option) =>
          option.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _selectOption(String option) {
    setState(() {
      _controller.text = option;
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
          link: _layerLink, // Use defined _layerLink
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 5.0), // Adjust as needed
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
                      child: Text(option),
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
    return CompositedTransformTarget( // Wrap TextField with CompositedTransformTarget
      link: _layerLink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _controller,
            focusNode: _focusNode,
            decoration: InputDecoration(
              // labelText: 'Select or Type',
              hintText: 'Select or Type',
              hintStyle: TextStyle(fontFamily: "poppins_light"),
              border: const OutlineInputBorder(),
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
          ),
        ],
      ),
    );
  }
}
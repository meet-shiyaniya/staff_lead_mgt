import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:inquiry_management_ui/Utils/Colors/app_Colors.dart';
import 'package:intl/intl.dart';

import '../../Inquiry Management Screens/all_inquiries_Screen.dart';
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
  // Separate variables for different DropdownButton2 widgets
  String? _selectedCountryCode;
  String? _selectedArea;
  String? _selectedCity;
  String? _selectedInquiryType;
  String? _selectedInqSource;

  bool _isCSTInterestVisible = false;
  String? _selectedCSTType; // Initialize here
  // String? selectedProduct;
  String? selectedBuyingTime;
  // String? selectedService;
  String? selectedDuration;
  DateTime? dateOfBirth;
  DateTime? anniversaryDate;
  DateTime? nextFollowUp;
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _anniversaryController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String selectedType = "Service"; // Default selection
  String? selectedProduct;
  String? selectedService;
  String approxBuying = "";
  String serviceDuration = "";

  final List<String> products = ['Laptop', 'Mobile Phone', 'Tablet'];
  final List<String> services = ['IELTS (UK)', 'IELTS (US)', 'TOEFL'];

  final List<String> _steps = ["Personal Info", "CST & Inquiry"];

  final List<String> durations = ['1-month', '3-month', '6-month', '12-month'];

  @override
  void initState() {
    super.initState();
    _selectedCSTType = 'Service'; // Initialize to "Service" by default
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(


          widget.isEdit == true ? "Edit Lead" : "Add Lead",
          style: const TextStyle(fontFamily: "poppins_thin", color: Colors.white,fontSize: 20),
        ),
        backgroundColor: AppColor.MainColor,
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios,color: Colors.white,)),
      ),
      body: Column(
        children: [
          // const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildFormContent(), // Single content builder
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: _currentStep == 0
                  ? MainAxisAlignment.end // Aligns "Next" to the end when no "Back" button
                  : MainAxisAlignment.spaceBetween, // Distributes "Back" and "Next" when both exist
              children: [
                if (_currentStep > 0)
                  GradientButton(
                    buttonText: "",
                    icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                    width: 40.0, // Adjust the width as needed
                    onPressed: _goToPreviousStep,
                  ),
                GradientButton(
                  buttonText: _currentStep == _steps.length - 1 ? "Submit" : "Next",
                  width: 120.0, // Adjust the width as needed
                  onPressed: _currentStep == _steps.length - 1
                      ? () {
                    // Navigate to the next screen when "Submit" is pressed
                    Navigator.pop(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllInquiriesScreen(), // Replace with your target screen
                      ),
                    );
                  }
                      : _goToNextStep, // Otherwise, go to the next step
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
            // Personal Info Section
            if (_currentStep == 0) ...[
              const Text(
                "Personal Inquiry",
                style: TextStyle(fontSize: 24, fontFamily: "poppins_thin"),
              ),
              Card(child: _buildPersonalInquirySection()),
              // )_buildCSTInterestSection(context),
            ],
            // CST & Inquiry Section
            if (_currentStep == 1) ...[
              Text(
                "CST Interest",
                style: TextStyle(fontSize: 24, fontFamily: "poppins_thin"),
              ),
              Card(
                child: _buildCSTInterestSection(context),),


              const SizedBox(height: 16),
              const Text(
                "Inquiry Information",
                style: TextStyle(fontSize: 24, fontFamily: "poppins_thin"),
              ),
              Card(child: _buildInquiryInformationSection()),
              SizedBox(height: 10,),
              Text(
                "Follow up",
                style: TextStyle(fontSize: 24, fontFamily: "poppins_thin"),
              ),
              Card(child: _buildFollowUpSection(),)
            ],

          ],
        ),
      ),
    );
  }

  Widget _buildCSTInterestSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            'Select Type:',
            style: TextStyle(fontFamily: "poppins_thin"),
          ),
          Row(
            children: [
              Radio(
                value: 'Product',
                groupValue: selectedType,
                onChanged: (value) {
                  setState(() {
                    selectedType = value.toString();
                    selectedService = null;
                    selectedDuration = null;
                    selectedProduct = null;
                  });
                },
              ),
              Text(
                'Product',
                style: TextStyle(fontFamily: "poppins_thin"),
              ),
              Radio(
                value: 'Service',
                groupValue: selectedType,
                onChanged: (value) {
                  setState(() {
                    selectedType = value.toString();
                    selectedService = null;
                    selectedDuration = null;
                    selectedProduct = null;
                  });
                },
              ),
              Text(
                'Service',
                style: TextStyle(fontFamily: "poppins_thin"),
              ),
            ],
          ),
          SizedBox(height: 20),
          if (selectedType == 'Service') ...[
            Text(
              'Services *',
              style: TextStyle(fontFamily: "poppins_thin"),
            ),
            SizedBox(
              height: 10,
            ),
            DropdownButton2(
              isExpanded: true,
              hint: Text('Select Services',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: "poppins_thin")),
              value: selectedService,
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
                    value: 'battry panel',
                    child: Text('Battery Panel',
                        style: TextStyle(fontFamily: "poppins_thin"))),
                DropdownMenuItem(
                    value: 'electricity',
                    child: Text('Electricity',
                        style: TextStyle(fontFamily: "poppins_thin"))),
                DropdownMenuItem(
                    value: 'IELTS (UK)',
                    child: Text('IELTS (UK)',
                        style: TextStyle(fontFamily: "poppins_thin"))),
              ],
              onChanged: (value) {
                setState(() {
                  selectedService = value;
                  // print('Country Code Dropdown changed to: $_selectedCountryCode');
                });
              },
            ),
            SizedBox(height: 20),
            Text(
              'Service Duration *',
              style: TextStyle(fontFamily: "poppins_thin"),
            ),
            SizedBox(
              height: 10,
            ),
            Form(
              key: _formKey,
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Duration",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintStyle: TextStyle(fontFamily: "poppins_thin"),
                ),
              ),
            ),
          ] else if (selectedType == 'Product') ...[
            Text(
              "Product*",
              style: TextStyle(fontFamily: "poppins_thin"),
            ),
            SizedBox(
              height: 10,
            ),
            DropdownButton2(
              isExpanded: true,
              hint: Text('Select Product',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: "poppins_thin")),
              value: selectedProduct,
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
                    value: 'table(wooden)',
                    child: Text('Table (Wooden)',
                        style: TextStyle(fontFamily: "poppins_thin"))),
                DropdownMenuItem(
                    value: 'bowl(steel)',
                    child: Text('Bowl(Steel)',
                        style: TextStyle(fontFamily: "poppins_thin"))),
                DropdownMenuItem(
                    value: 'sofa(still)',
                    child: Text('Sofa(Still)',
                        style: TextStyle(fontFamily: "poppins_thin"))),
              ],
              onChanged: (value) {
                setState(() {
                  selectedProduct = value;
                  // print('Country Code Dropdown changed to: $_selectedCountryCode');
                });
              },
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Apx Buying Time *",
              style: TextStyle(fontFamily: "poppins_thin"),
            ),
            SizedBox(
              height: 10,
            ),
            DropdownButton2(
              isExpanded: true,
              hint: Text('Select Apx Time',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: "poppins_thin")),
              value: selectedBuyingTime,
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
                    value: '10 15 days',
                    child: Text('10-15 days',
                        style: TextStyle(fontFamily: "poppins_thin"))),
                DropdownMenuItem(
                    value: 'week',
                    child: Text('Week',
                        style: TextStyle(fontFamily: "poppins_thin"))),
                DropdownMenuItem(
                    value: '2 3 days',
                    child: Text('2 3 days',
                        style: TextStyle(fontFamily: "poppins_thin"))),
              ],
              onChanged: (value) {
                setState(() {
                  selectedBuyingTime = value;
                  // print('Country Code Dropdown changed to: $_selectedCountryCode');
                });
              },
            ),
          ],
        ],
      ),
    );
  }

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
            height: 10,
          )
        ],
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
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hr_app/Inquiry_Management/Utils/Colors/app_Colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../Api_services/api_service.dart';
import '../Provider/UserProvider.dart';

// Helper class to store both ID and name for Int Site
class IntSiteOption {
  final String id;
  final String name;

  IntSiteOption({required this.id, required this.name});

  @override
  String toString() => name; // For display in dropdown
}

class AddVisitScreen extends StatefulWidget {
  @override
  _AddVisitScreenState createState() => _AddVisitScreenState();
}

class _AddVisitScreenState extends State<AddVisitScreen> {
  String approxBuying = "";
  PageController _pageController = PageController();
  int _currentPage = 0;
  DateTime? nextFollowUp;
  final TextEditingController _dateController = TextEditingController();
  bool isLoanSelected = true;

  final TextEditingController _mobileNoController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _intAreaController = TextEditingController();
  final TextEditingController _propertyTypeController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _dpAmountController = TextEditingController();
  final TextEditingController _loanAmountController = TextEditingController();
  final TextEditingController _afterVisitStatusController = TextEditingController();
  final TextEditingController _followUpDateController = TextEditingController();

  String? _purposeOfBuying;
  String? _approxBuyingTime;
  IntSiteOption? _selectedIntSite; // Updated to use IntSiteOption
  String? _cashPaymentCondition;
  String? _selectTime;
  String? _selectedPropertySubType;
  String? _selectedUnitNo;
  String? _selectedSize;

  List<String> _propertySubTypeOptions = [];
  List<String> _unitNoOptions = [];
  List<String> _sizeOptions = [];
  List<IntSiteOption> _intSiteOptions = []; // Store ID-name pairs

  final List<DropdownMenuItem<String>> _timeOptions = [
    DropdownMenuItem(value: "09:00:00", child: Text("9:00 AM")),
    DropdownMenuItem(value: "12:00:00", child: Text("12:00 PM")),
    DropdownMenuItem(value: "15:00:00", child: Text("3:00 PM")),
    DropdownMenuItem(value: "18:00:00", child: Text("6:00 PM")),
  ];

  final ApiService _apiService = ApiService();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = Provider.of<UserProvider>(context, listen: false);
      provider.fetchVisitData().then((_) {
        if (provider.visitData != null) {
          final inquiry = provider.visitData!.inquiries;
          final projects = provider.visitData!.projects;
          final unitNos = provider.visitData!.unitNo;
          setState(() {
            _mobileNoController.text = inquiry.mobileno ?? '';
            _nameController.text = inquiry.fullName ?? '';
            _addressController.text = inquiry.address ?? '';
            _intAreaController.text = inquiry.intrestedProduct ?? '';
            _propertyTypeController.text = inquiry.propertyType ?? '';
            _budgetController.text = inquiry.budget ?? '';

            _propertySubTypeOptions = projects
                .map((project) => project.projectSubType.trim())
                .where((subType) => subType.isNotEmpty)
                .toSet()
                .toList();
            _selectedPropertySubType = inquiry.propertySubType.isNotEmpty
                ? inquiry.propertySubType.trim()
                : _propertySubTypeOptions.isNotEmpty
                ? _propertySubTypeOptions.first
                : null;

            _unitNoOptions = unitNos.isNotEmpty
                ? unitNos
                .map((unit) => unit.unitNo.trim())
                .where((unit) => unit.isNotEmpty)
                .toSet()
                .toList()
                : ['No Units Available'];
            _selectedUnitNo = inquiry.unitNo.isNotEmpty
                ? inquiry.unitNo.trim()
                : _unitNoOptions.isNotEmpty
                ? _unitNoOptions.first
                : null;

            _sizeOptions = unitNos.isNotEmpty
                ? unitNos
                .map((unit) => unit.propertySize.trim())
                .where((size) => size.isNotEmpty)
                .toSet()
                .toList()
                : ['No Size Available'];
            _selectedSize = unitNos.isNotEmpty && _unitNoOptions.contains(inquiry.unitNo)
                ? unitNos
                .firstWhere((unit) => unit.unitNo == inquiry.unitNo)
                .propertySize
                .trim()
                : _sizeOptions.isNotEmpty
                ? _sizeOptions.first
                : null;
          });
        }
      });

      provider.fetchAddLeadData().then((_) {
        if (provider.dropdownData != null) {
          setState(() {
            final dropdownData = provider.dropdownData!;
            _purposeOfBuying = dropdownData.purposeOfBuying?.investment?.trim() ??
                dropdownData.purposeOfBuying?.personalUse?.trim();
            _approxBuyingTime = dropdownData.apxTime?.apxTimeData?.split(',')?.first.trim();
            _intSiteOptions = dropdownData.intSite.isNotEmpty
                ? dropdownData.intSite
                .map((site) => IntSiteOption(
              id: site.id ?? "6", // Assuming 'id' field exists; adjust if different
              name: site.productName.trim(),
            ))
                .toList()
                : [IntSiteOption(id: "6", name: "Default Site")];
            _selectedIntSite = _intSiteOptions.isNotEmpty ? _intSiteOptions.first : null;
            _selectTime = _timeOptions.first.value;
            print("IntSite Options: ${_intSiteOptions.map((e) => 'ID: ${e.id}, Name: ${e.name}').toList()}");
          });
        } else {
          setState(() {
            _purposeOfBuying = 'Investment';
            _approxBuyingTime = '2-3 days';
            _intSiteOptions = [IntSiteOption(id: "6", name: "Default Site")];
            _selectedIntSite = _intSiteOptions.first;
            _selectTime = _timeOptions.first.value;
            print("IntSite Options (Default): ${_intSiteOptions.map((e) => 'ID: ${e.id}, Name: ${e.name}').toList()}");
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _mobileNoController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _intAreaController.dispose();
    _propertyTypeController.dispose();
    _budgetController.dispose();
    _dpAmountController.dispose();
    _loanAmountController.dispose();
    _afterVisitStatusController.dispose();
    _dateController.dispose();
    _followUpDateController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 1) {
      setState(() => _currentPage++);
      _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() => _currentPage--);
      _pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  Future<void> _submitData() async {
    String? token = await _secureStorage.read(key: 'token');
    print("Submit Data - Token: $token");

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: No token found in secure storage")),
      );
      return;
    }

    final Map<String, dynamic> apiData = {
      "token": token,
      "remark": _afterVisitStatusController.text,
      "intrested_product": _selectedIntSite?.id ?? "6", // Send ID instead of name
      "budget": _budgetController.text.isNotEmpty ? "1" : "1",
      "approx_buy": _approxBuyingTime ?? "2-3 days",
      "inquiry_id": 95560,
      "isSiteVisit": "3",
      "intrested_area": "64",
      "unit_no": _selectedUnitNo ?? "5",
      "paymentref": isLoanSelected ? "loan" : "cash",
      "dp_amount": _dpAmountController.text.isNotEmpty ? _dpAmountController.text : "2000000",
      "nxt_follow_up": _followUpDateController.text.isNotEmpty ? _followUpDateController.text : "2025-02-28",
      "time": _selectTime ?? "12:00:00",
    };

    print("Submit Data - API Data: ${jsonEncode(apiData)}");

    final result = await _apiService.submitVisitData(apiData);
    print("Submit Data - API Result: $result");

    if (result["success"]) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result["message"])));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result["message"])));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visit Entry', style: TextStyle(fontFamily: "poppins_thin", color: Colors.white)),
        backgroundColor: AppColor.Buttoncolor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: Consumer<UserProvider>(
        builder: (context, provider, child) {
          if (provider.isLoadingDropdown) {
            return Center(child: CircularProgressIndicator());
          }
          if (provider.error != null) {
            return Center(child: Text('Error: ${provider.error}'));
          }

          final dropdownData = provider.dropdownData;

          List<DropdownMenuItem<String>> purposeOfBuyingItems = dropdownData != null
          ? [
          if (dropdownData.purposeOfBuying?.investment != null)
            DropdownMenuItem<String>(
              value: dropdownData.purposeOfBuying!.investment.trim(),
              child: Text(dropdownData.purposeOfBuying!.investment.trim(),
                  style: TextStyle(fontFamily: "poppins_thin"), overflow: TextOverflow.ellipsis),
            ),
          if (dropdownData.purposeOfBuying?.personalUse != null)
          DropdownMenuItem<String>(
          value: dropdownData.purposeOfBuying!.personalUse.trim(),
          child: Text(dropdownData.purposeOfBuying!.personalUse.trim(),
          style: TextStyle(fontFamily: "poppins_thin"), overflow: TextOverflow.ellipsis),
          ),
          ].where((item) => item.value!.isNotEmpty).toList()
              : [
          DropdownMenuItem<String>(
          value: 'Investment',
          child: Text('Investment', style: TextStyle(fontFamily: "poppins_thin"), overflow: TextOverflow.ellipsis),
          ),
          DropdownMenuItem<String>(
          value: 'Personal Use',
          child: Text('Personal Use', style: TextStyle(fontFamily: "poppins_thin"), overflow: TextOverflow.ellipsis),
          ),
          ];

          List<DropdownMenuItem<String>> approxBuyingTimeItems = dropdownData != null &&
          dropdownData.apxTime?.apxTimeData != null
          ? dropdownData.apxTime!.apxTimeData
              .split(',')
              .map((time) => time.trim())
              .where((time) => time.isNotEmpty)
              .toSet()
              .map((time) => DropdownMenuItem<String>(
          value: time,
          child: Text(time, style: TextStyle(fontFamily: "poppins_thin"), overflow: TextOverflow.ellipsis),
          ))
              .toList()
              : [
          DropdownMenuItem<String>(
          value: '2-3 days',
          child: Text('2-3 days', style: TextStyle(fontFamily: "poppins_thin"), overflow: TextOverflow.ellipsis),
          ),
          DropdownMenuItem<String>(
          value: '1 week',
          child: Text('1 week', style: TextStyle(fontFamily: "poppins_thin"), overflow: TextOverflow.ellipsis),
          ),
          DropdownMenuItem<String>(
          value: '1 month',
          child: Text('1 month', style: TextStyle(fontFamily: "poppins_thin"), overflow: TextOverflow.ellipsis),
          ),
          ];

          List<DropdownMenuItem<IntSiteOption>> intSiteItems = _intSiteOptions
              .map((option) => DropdownMenuItem<IntSiteOption>(
          value: option,
          child: Text(option.name, style: TextStyle(fontFamily: "poppins_thin"), overflow: TextOverflow.ellipsis),
          ))
              .toList();

          List<DropdownMenuItem<String>> propertySubTypeItems = _propertySubTypeOptions.isNotEmpty
          ? _propertySubTypeOptions
              .map((subType) => DropdownMenuItem<String>(
          value: subType,
          child: Text(subType, style: TextStyle(fontFamily: "poppins_thin"), overflow: TextOverflow.ellipsis),
          ))
              .toList()
              : [
          DropdownMenuItem<String>(
          value: 'Residential',
          child: Text('Residential', style: TextStyle(fontFamily: "poppins_thin"), overflow: TextOverflow.ellipsis),
          ),
          DropdownMenuItem<String>(
          value: 'Commercial',
          child: Text('Commercial', style: TextStyle(fontFamily: "poppins_thin"), overflow: TextOverflow.ellipsis),
          ),
          ];

          List<DropdownMenuItem<String>> unitNoItems = _unitNoOptions.isNotEmpty
          ? _unitNoOptions
              .map((unit) => DropdownMenuItem<String>(
          value: unit,
          child: Text(unit, style: TextStyle(fontFamily: "poppins_thin"), overflow: TextOverflow.ellipsis),
          ))
              .toList()
              : [
          DropdownMenuItem<String>(
          value: 'Default Unit',
          child: Text('Default Unit', style: TextStyle(fontFamily: "poppins_thin"), overflow: TextOverflow.ellipsis),
          ),
          ];

          List<DropdownMenuItem<String>> sizeItems = _sizeOptions.isNotEmpty
          ? _sizeOptions
              .map((size) => DropdownMenuItem<String>(
          value: size,
          child: Text(size, style: TextStyle(fontFamily: "poppins_thin"), overflow: TextOverflow.ellipsis),
          ))
              .toList()
              : [
          DropdownMenuItem<String>(
          value: 'Default Size',
          child: Text('Default Size', style: TextStyle(fontFamily: "poppins_thin"), overflow: TextOverflow.ellipsis),
          ),
          ];

          _purposeOfBuying = purposeOfBuyingItems.any((item) => item.value == _purposeOfBuying)
          ? _purposeOfBuying
              : purposeOfBuyingItems.isNotEmpty
          ? purposeOfBuyingItems.first.value
              : null;
          _approxBuyingTime = approxBuyingTimeItems.any((item) => item.value == _approxBuyingTime)
          ? _approxBuyingTime
              : approxBuyingTimeItems.isNotEmpty
          ? approxBuyingTimeItems.first.value
              : null;
          _selectedPropertySubType =
          propertySubTypeItems.any((item) => item.value == _selectedPropertySubType)
          ? _selectedPropertySubType
              : propertySubTypeItems.isNotEmpty
          ? propertySubTypeItems.first.value
              : null;
          _selectedUnitNo = unitNoItems.any((item) => item.value == _selectedUnitNo)
          ? _selectedUnitNo
              : unitNoItems.isNotEmpty
          ? unitNoItems.first.value
              : null;
          _selectedSize = sizeItems.any((item) => item.value == _selectedSize)
          ? _selectedSize
              : sizeItems.isNotEmpty
          ? sizeItems.first.value
              : null;

          return PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: [
          _buildCustomerInformationPage(purposeOfBuyingItems, approxBuyingTimeItems, propertySubTypeItems),
          _buildInterestSuggestionPage(intSiteItems, unitNoItems, sizeItems),
          ],
          );
        },
      ),
    );
  }

  Widget _buildCustomerInformationPage(
      List<DropdownMenuItem<String>> purposeOfBuyingItems,
      List<DropdownMenuItem<String>> approxBuyingTimeItems,
      List<DropdownMenuItem<String>> propertySubTypeItems) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 8),
            child: Row(
              children: [
                Icon(Icons.person),
                SizedBox(width: 10),
                Text('Customer Information', style: TextStyle(fontSize: 18, fontFamily: "poppins_thin")),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildTextField('Mobile No.', prefix: '+91', controller: _mobileNoController),
                  _buildTextField('Name', controller: _nameController),
                  _buildTextField('Address', controller: _addressController),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 8),
            child: Row(
              children: [
                Icon(Icons.add_circle_outline),
                SizedBox(width: 10),
                Text('Interest', style: TextStyle(fontSize: 18, fontFamily: "poppins_thin")),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  _buildTextField('Int Area*', controller: _intAreaController),
                  _buildDropdown<String>(
                    "Property Sub Type",
                    items: propertySubTypeItems,
                    value: _selectedPropertySubType,
                    onChanged: (value) => setState(() => _selectedPropertySubType = value),
                  ),
                  _buildTextField('Property Type*', controller: _propertyTypeController),
                  _buildTextField('Budget*', controller: _budgetController),
                  _buildDropdown<String>(
                    "Purpose of Buying*",
                    items: purposeOfBuyingItems,
                    value: _purposeOfBuying,
                    onChanged: (value) => setState(() => _purposeOfBuying = value),
                  ),
                  _buildDropdown<String>(
                    "Approx Buying Time*",
                    items: approxBuyingTimeItems,
                    value: _approxBuyingTime,
                    onChanged: (value) => setState(() => _approxBuyingTime = value),
                  ),
                ],
              ),
            ),
          ),
          _buildNextButton(),
        ],
      ),
    );
  }

  Widget _buildInterestSuggestionPage(
      List<DropdownMenuItem<IntSiteOption>> intSiteItems,
      List<DropdownMenuItem<String>> unitNoItems,
      List<DropdownMenuItem<String>> sizeItems) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Row(
            children: [
              Icon(Icons.add),
              SizedBox(width: 10),
              Text('Suggestion', style: TextStyle(fontSize: 18, fontFamily: "poppins_thin")),
            ],
          ),
          Container(
            decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  _buildDropdown<IntSiteOption>(
                    'Int Site*',
                    items: intSiteItems,
                    value: _selectedIntSite,
                    onChanged: (value) => setState(() => _selectedIntSite = value),
                  ),
                  _buildDropdown<String>(
                    'Unit No',
                    items: unitNoItems,
                    value: _selectedUnitNo,
                    onChanged: (value) => setState(() => _selectedUnitNo = value),
                  ),
                  _buildDropdown<String>(
                    'Size',
                    items: sizeItems,
                    value: _selectedSize,
                    onChanged: (value) => setState(() => _selectedSize = value),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Icon(Icons.add_circle_outline),
              SizedBox(width: 10),
              Text('Buying Information', style: TextStyle(fontSize: 18, fontFamily: "poppins_thin")),
            ],
          ),
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.grey.shade200),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  _buildToggleSwitch(),
                  if (isLoanSelected) ...[
                    _buildTextField('DP Amount*', controller: _dpAmountController),
                    _buildTextField('Loan Amount*', controller: _loanAmountController),
                    _buildTextField('After Visit Status*', controller: _afterVisitStatusController),
                    _buildDatePickerField('Next Followup Date*', controller: _followUpDateController),
                    _buildDropdown<String>(
                      'Select Time*',
                      items: _timeOptions,
                      value: _selectTime,
                      onChanged: (value) => setState(() => _selectTime = value),
                    ),
                  ] else ...[
                    _buildTextField('DP Amount*', controller: _dpAmountController),
                    _buildTextField('After Visit Status*', controller: _afterVisitStatusController),
                    _buildDatePickerField('Next Followup Date*', controller: _followUpDateController),
                    _buildDropdown<String>(
                      'Select Time*',
                      items: _timeOptions,
                      value: _selectTime,
                      onChanged: (value) => setState(() => _selectTime = value),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: _previousPage,
                child: Text('Back', style: TextStyle(fontFamily: "poppins_thin", color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple.shade300),
              ),
              ElevatedButton(
                onPressed: _submitData,
                child: Text('Submit', style: TextStyle(fontFamily: "poppins_thin", color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple.shade300),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, {String? prefix, required TextEditingController controller}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.0),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(offset: Offset(1, 3), color: Colors.grey.shade400)],
        ),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(fontFamily: "poppins_thin", fontSize: 15),
            prefixText: prefix != null ? '$prefix ' : null,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePickerField(String label, {required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 10),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(offset: Offset(1, 3), color: Colors.grey.shade400)],
        ),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: Colors.white,
            labelStyle: const TextStyle(fontFamily: "poppins_thin", fontSize: 15),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
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
                controller.text = DateFormat('yyyy-MM-dd').format(picked);
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildDropdown<T>(
      String label, {
        List<DropdownMenuItem<T>>? items,
        T? value,
        required ValueChanged<T?> onChanged,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
      child: Container(
        width: double.infinity,
        child: DropdownButtonFormField<T>(
          value: value,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            labelText: label,
            labelStyle: TextStyle(fontFamily: "poppins_thin", fontSize: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          ),
          items: items ?? [],
          onChanged: onChanged,
          icon: Icon(Icons.arrow_drop_down, color: Colors.deepPurple),
          elevation: 8,
          dropdownColor: Colors.white,
          style: TextStyle(fontFamily: "poppins_thin", fontSize: 16, color: Colors.black),
          isExpanded: true,
        ),
      ),
    );
  }

  Widget _buildToggleSwitch() {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 12),
      child: ToggleSwitch(
        initialLabelIndex: isLoanSelected ? 0 : 1,
        totalSwitches: 2,
        labels: ['Loan', 'Cash'],
        customTextStyles: [TextStyle(fontFamily: "poppins_thin")],
        activeBgColors: [[Colors.deepPurple.shade300], [Colors.deepPurple.shade300]],
        inactiveBgColor: Colors.grey[300],
        cornerRadius: 10.0,
        onToggle: (index) => setState(() => isLoanSelected = index == 0),
      ),
    );
  }

  Widget _buildNextButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: ElevatedButton(
        onPressed: _nextPage,
        child: Text('Next', style: TextStyle(fontFamily: "poppins_thin", color: Colors.white)),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: Colors.deepPurple.shade300,
        ),
      ),
    );
  }
}
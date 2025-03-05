import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../Api_services/api_service.dart';
import '../Provider/UserProvider.dart';

// import 'Model/add_Lead_Model.dart';
import 'Model/Api Model/add_Lead_Model.dart';
import 'Utils/Colors/app_Colors.dart';

class IntSiteOption {
  final String id;
  final String name;

  IntSiteOption({required this.id, required this.name});

  @override
  String toString() => name;
}

class AddVisitScreen extends StatefulWidget {
  final String? inquiryId;

  const AddVisitScreen({Key? key, this.inquiryId}) : super(key: key);

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
  IntSiteOption? _selectedIntSite;
  String? _cashPaymentCondition;
  String? _selectTime;
  String? _selectedPropertySubType;
  String? _selectedUnitNo;
  String? _selectedSize;

  String? _iscountvisit;

  List<String> _propertySubTypeOptions = [];
  List<String> _unitNoOptions = [];
  List<String> _sizeOptions = [];
  List<IntSiteOption> _intSiteOptions = [];

  final ApiService _apiService = ApiService();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = Provider.of<UserProvider>(context, listen: false);
      if (widget.inquiryId != null) {
        provider.fetchVisitData(widget.inquiryId!).then((_) {
          if (provider.visitData != null) {
            final inquiry = provider.visitData!.inquiries;
            final projects = provider.visitData!.projects;
            final unitNos = provider.visitData!.unitNo;
            setState(() {
              _iscountvisit = inquiry.iscountvisit;
              _mobileNoController.text = inquiry.mobileno ?? '';
              _nameController.text = inquiry.fullName ?? '';
              _addressController.text = inquiry.address ?? '';
              _intAreaController.text = 'Olpad';
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
        }).catchError((e) {
          print('Error fetching visit data: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load visit data: $e')),
          );
        });
      } else {
        print('No inquiryId provided');
      }

      provider.fetchAddLeadData().then((_) {
        if (provider.dropdownData != null) {
          setState(() {
            final dropdownData = provider.dropdownData!;
            final inquiry = provider.visitData?.inquiries;

            _purposeOfBuying = dropdownData.purposeOfBuying?.investment?.trim() ??
                dropdownData.purposeOfBuying?.personalUse?.trim();
            if (inquiry != null && inquiry.purposeBuy.isNotEmpty) {
              _purposeOfBuying = dropdownData.purposeOfBuying?.investment == inquiry.purposeBuy ||
                  dropdownData.purposeOfBuying?.personalUse == inquiry.purposeBuy
                  ? inquiry.purposeBuy
                  : _purposeOfBuying;
            }

            _approxBuyingTime = dropdownData.apxTime?.apxTimeData?.split(',')?.first.trim();
            if (inquiry != null && inquiry.budget.isNotEmpty) {
              final times = dropdownData.apxTime?.apxTimeData?.split(',')?.map((e) => e.trim()).toList();
              if (times != null && times.isNotEmpty) {
                int index = int.tryParse(inquiry.budget) ?? 1;
                _approxBuyingTime = (index > 0 && index <= times.length) ? times[index - 1] : _approxBuyingTime;
              }
            }

            _intSiteOptions = dropdownData.intSite.isNotEmpty
                ? dropdownData.intSite
                .map((site) => IntSiteOption(
              id: site.id ?? "6",
              name: site.productName.trim(),
            ))
                .toList()
                : [IntSiteOption(id: "6", name: "Default Site")];
            if (inquiry != null && inquiry.intrestedProduct.isNotEmpty) {
              _selectedIntSite = _intSiteOptions.firstWhere(
                    (option) => option.id == inquiry.intrestedProduct,
                orElse: () => _intSiteOptions.first,
              );
            } else {
              _selectedIntSite = _intSiteOptions.isNotEmpty ? _intSiteOptions.first : null;
            }

            _selectTime = null; // Initially null, updated by API
            print("IntSite Options: ${_intSiteOptions.map((e) => 'ID: ${e.id}, Name: ${e.name}').toList()}");
          });
        } else {
          setState(() {
            _purposeOfBuying = 'Investment';
            _approxBuyingTime = '2-3 days';
            _intSiteOptions = [IntSiteOption(id: "6", name: "Default Site")];
            _selectedIntSite = _intSiteOptions.first;
            _selectTime = null; // Initially null, updated by API
            print("IntSite Options (Default): ${_intSiteOptions.map((e) => 'ID: ${e.id}, Name: ${e.name}').toList()}");
          });
        }
      }).catchError((e) {
        print('Error fetching dropdown data: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load dropdown data: $e')),
        );
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

    if (widget.inquiryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: No inquiry ID provided")),
      );
      return;
    }

    final Map<String, dynamic> apiData = {
      "token": token,
      "remark": _afterVisitStatusController.text,
      "intrested_product": _selectedIntSite?.id ?? "6",
      "budget": _budgetController.text.isNotEmpty ? "1" : "1",
      "approx_buy": _approxBuyingTime ?? "2-3 days",
      "inquiry_id": widget.inquiryId,
      "isSiteVisit": "3",
      "intrested_area": _intAreaController.text.isNotEmpty ? _intAreaController.text : "64",
      "unit_no": _selectedUnitNo ?? "5",
      "paymentref": isLoanSelected ? "loan" : "cash",
      "dp_amount": _dpAmountController.text.isNotEmpty ? _dpAmountController.text : "2000000",
      "nxt_follow_up":
      _followUpDateController.text.isNotEmpty ? _followUpDateController.text : "2025-02-28",
      "time": _selectTime ?? "",
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
        title: Text(
          'Visit Entry${_iscountvisit != null ? " ($_iscountvisit)" : ""}',
          style: TextStyle(fontFamily: "poppins_thin", color: Colors.white),
        ),
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
                    style: TextStyle(fontFamily: "poppins_thin"),
                    overflow: TextOverflow.ellipsis),
              ),
            if (dropdownData.purposeOfBuying?.personalUse != null)
              DropdownMenuItem<String>(
                value: dropdownData.purposeOfBuying!.personalUse.trim(),
                child: Text(dropdownData.purposeOfBuying!.personalUse.trim(),
                    style: TextStyle(fontFamily: "poppins_thin"),
                    overflow: TextOverflow.ellipsis),
              ),
          ].where((item) => item.value!.isNotEmpty).toList()
              : [
            DropdownMenuItem<String>(
              value: 'Investment',
              child: Text('Investment',
                  style: TextStyle(fontFamily: "poppins_thin"), overflow: TextOverflow.ellipsis),
            ),
            DropdownMenuItem<String>(
              value: 'Personal Use',
              child: Text('Personal Use',
                  style: TextStyle(fontFamily: "poppins_thin"), overflow: TextOverflow.ellipsis),
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
            child: Text(time,
                style: TextStyle(fontFamily: "poppins_thin"), overflow: TextOverflow.ellipsis),
          ))
              .toList()
              : [
            DropdownMenuItem<String>(
              value: '2-3 days',
              child: Text('2-3 days',
                  style: TextStyle(fontFamily: "poppins_thin"), overflow: TextOverflow.ellipsis),
            ),
            DropdownMenuItem<String>(
              value: '1 week',
              child: Text('1 week',
                  style: TextStyle(fontFamily: "poppins_thin"), overflow: TextOverflow.ellipsis),
            ),
            DropdownMenuItem<String>(
              value: '1 month',
              child: Text('1 month',
                  style: TextStyle(fontFamily: "poppins_thin"), overflow: TextOverflow.ellipsis),
            ),
          ];

          List<DropdownMenuItem<IntSiteOption>> intSiteItems = _intSiteOptions
              .map((option) => DropdownMenuItem<IntSiteOption>(
            value: option,
            child: Text(option.name,
                style: TextStyle(fontFamily: "poppins_thin"), overflow: TextOverflow.ellipsis),
          ))
              .toList();

          List<DropdownMenuItem<String>> propertySubTypeItems = _propertySubTypeOptions.isNotEmpty
              ? _propertySubTypeOptions
              .map((subType) => DropdownMenuItem<String>(
            value: subType,
            child: Text(subType,
                style: TextStyle(fontFamily: "poppins_thin"), overflow: TextOverflow.ellipsis),
          ))
              .toList()
              : [
            DropdownMenuItem<String>(
              value: 'Residential',
              child: Text('Residential',
                  style: TextStyle(fontFamily: "poppins_thin"), overflow: TextOverflow.ellipsis),
            ),
            DropdownMenuItem<String>(
              value: 'Commercial',
              child: Text('Commercial',
                  style: TextStyle(fontFamily: "poppins_thin"), overflow: TextOverflow.ellipsis),
            ),
          ];

          List<DropdownMenuItem<String>> unitNoItems = _unitNoOptions.isNotEmpty
              ? _unitNoOptions
              .map((unit) => DropdownMenuItem<String>(
            value: unit,
            child: Text(unit,
                style: TextStyle(fontFamily: "poppins_thin"), overflow: TextOverflow.ellipsis),
          ))
              .toList()
              : [
            DropdownMenuItem<String>(
              value: 'Default Unit',
              child: Text('Default Unit',
                  style: TextStyle(fontFamily: "poppins_thin"), overflow: TextOverflow.ellipsis),
            ),
          ];

          List<DropdownMenuItem<String>> sizeItems = _sizeOptions.isNotEmpty
              ? _sizeOptions
              .map((size) => DropdownMenuItem<String>(
            value: size,
            child: Text(size,
                style: TextStyle(fontFamily: "poppins_thin"), overflow: TextOverflow.ellipsis),
          ))
              .toList()
              : [
            DropdownMenuItem<String>(
              value: 'Default Size',
              child: Text('Default Size',
                  style: TextStyle(fontFamily: "poppins_thin"), overflow: TextOverflow.ellipsis),
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
              _buildInterestSuggestionPage(intSiteItems, unitNoItems, sizeItems, provider),
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
      List<DropdownMenuItem<String>> sizeItems,
      UserProvider provider) {
    // Filter nextSlots to unique source values, preferring available slots
    final uniqueSlots = <String, NextSlot>{};
    for (var slot in provider.nextSlots) {
      if (!uniqueSlots.containsKey(slot.source)) {
        uniqueSlots[slot.source] = slot;
      } else if (!slot.disabled) {
        uniqueSlots[slot.source] = slot; // Prefer available slot
      }
    }
    final filteredSlots = uniqueSlots.values.toList();

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
                    TextFormField(
                      controller: _followUpDateController,
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
                            _followUpDateController.text = DateFormat('yyyy-MM-dd').format(nextFollowUp!);
                            provider.fetchNextSlots(_followUpDateController.text);
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
                    SizedBox(height: 10),
                    provider.isLoading
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
                      value: _selectTime,
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
                      items: filteredSlots.isEmpty
                          ? [
                        const DropdownMenuItem(
                          value: 'None',
                          enabled: false,
                          child: Text(
                            'No slots available',
                            style: TextStyle(fontFamily: "poppins_thin", color: Colors.grey),
                          ),
                        ),
                      ]
                          : filteredSlots.map((slot) {
                        return DropdownMenuItem<String>(
                          value: slot.source,
                          enabled: !slot.disabled,
                          child: Text(
                            slot.source ?? '',
                            style: TextStyle(
                              fontFamily: "poppins_thin",
                              color: !slot.disabled ? Colors.black : Colors.grey,
                              fontWeight: !slot.disabled ? FontWeight.normal : FontWeight.normal,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectTime = value;
                          });
                        }
                      },
                    ),
                  ] else ...[
                    _buildTextField('DP Amount*', controller: _dpAmountController),
                    _buildTextField('After Visit Status*', controller: _afterVisitStatusController),
                    _buildDatePickerField('Next Followup Date*', controller: _followUpDateController),
                    provider.isLoading
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
                      value: _selectTime,
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
                      items: filteredSlots.isEmpty
                          ? [
                        const DropdownMenuItem(
                          value: 'None',
                          enabled: false,
                          child: Text(
                            'No slots available',
                            style: TextStyle(fontFamily: "poppins_thin", color: Colors.grey),
                          ),
                        ),
                      ]
                          : filteredSlots.map((slot) {
                        return DropdownMenuItem<String>(
                          value: slot.source,
                          enabled: !slot.disabled,
                          child: Text(
                            slot.source ?? '',
                            style: TextStyle(
                              fontFamily: "poppins_thin",
                              color: !slot.disabled ? Colors.black : Colors.grey,
                              fontWeight: !slot.disabled ? FontWeight.normal : FontWeight.normal,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectTime = value;
                          });
                        }
                      },
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
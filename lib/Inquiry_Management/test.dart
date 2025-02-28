import 'package:flutter/material.dart';
import 'package:hr_app/Inquiry_Management/Utils/Colors/app_Colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../Provider/UserProvider.dart';
import 'Model/Api Model/fetch_visit_Model.dart';

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
  TextEditingController _followUpDateController = TextEditingController();
  String? _selectedPurpose;
  String? _selectedApxTime;
  String? _selectIntSite;

  // Controllers for each TextFormField to bind API data
  final TextEditingController _mobileNoController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _intAreaController = TextEditingController();
  final TextEditingController _propertyTypeController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _dpAmountController = TextEditingController();
  final TextEditingController _loanAmountController = TextEditingController();
  final TextEditingController _afterVisitStatusController = TextEditingController();

  // Dropdown values
  String? _purposeOfBuying;
  String? _approxBuyingTime;
  String? _intSite;
  String? _cashPaymentCondition;
  String? _apxTime;
  String? _selectTime;

  // Dropdown-specific variables
  List<String> _propertySubTypeOptions = [];
  String? _selectedPropertySubType;
  List<String> _unitNoOptions = [];
  String? _selectedUnitNo;
  List<String> _sizeOptions = [];
  String? _selectedSize;

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

            // Property Sub Type
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
            print('Property Sub Type Options: $_propertySubTypeOptions');
            print('Selected Property Sub Type: $_selectedPropertySubType');

            // Unit No
            _unitNoOptions = unitNos.isNotEmpty
                ? unitNos
                .map((unit) => unit.unitNo.trim())
                .where((unit) => unit.isNotEmpty)
                .toSet()
                .toList()
                : ['No Units Available']; // Fallback if empty
            _selectedUnitNo = inquiry.unitNo.isNotEmpty
                ? inquiry.unitNo.trim()
                : _unitNoOptions.isNotEmpty
                ? _unitNoOptions.first
                : null;
            print('Unit No Options: $_unitNoOptions');
            print('Selected Unit No: $_selectedUnitNo');

            // Size
            _sizeOptions = unitNos.isNotEmpty
                ? unitNos
                .map((unit) => unit.propertySize.trim())
                .where((size) => size.isNotEmpty)
                .toSet()
                .toList()
                : ['No Size Available']; // Fallback if empty
            _selectedSize = unitNos.isNotEmpty && _unitNoOptions.contains(inquiry.unitNo)
                ? unitNos
                .firstWhere((unit) => unit.unitNo == inquiry.unitNo)
                .propertySize
                .trim()
                : _sizeOptions.isNotEmpty
                ? _sizeOptions.first
                : null;
            print('Size Options: $_sizeOptions');
            print('Selected Size: $_selectedSize');
          });
        } else {
          print('Visit data is null: ${provider.error}');
        }
      }).catchError((e) {
        print('Error fetching visit data: $e');
      });

      provider.fetchAddLeadData().then((_) {
        if (provider.dropdownData != null) {
          setState(() {
            final dropdownData = provider.dropdownData!;
            _purposeOfBuying = dropdownData.purposeOfBuying?.investment?.trim() ??
                dropdownData.purposeOfBuying?.personalUse?.trim();
            _approxBuyingTime = dropdownData.apxTime?.apxTimeData?.split(',')?.first.trim();
            _intSite = dropdownData.intSite.isNotEmpty ? dropdownData.intSite.first.productName : null;
            print('Initialized Purpose of Buying: $_purposeOfBuying');
            print('Initialized Approx Buying Time: $_approxBuyingTime');
            print('Initialized Int Site: $_intSite');
          });
        } else {
          print('dropdownData is null after fetch: ${provider.error}');
          setState(() {
            _purposeOfBuying = 'Investment';
            _approxBuyingTime = '2-3 days';
            _intSite = 'Default Site';
          });
        }
      }).catchError((e) {
        print('Error fetching dropdown data: $e');
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
      _pageController.nextPage(
          duration: Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() => _currentPage--);
      _pageController.previousPage(
          duration: Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visit Entry',
            style: TextStyle(fontFamily: "poppins_thin", color: Colors.white)),
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

          // Purpose of Buying
          List<DropdownMenuItem<String>> purposeOfBuyingItems = dropdownData != null
          ? [
          if (dropdownData.purposeOfBuying?.investment != null)
            DropdownMenuItem<String>(
              value: dropdownData.purposeOfBuying!.investment.trim(),
              child: Text(
                dropdownData.purposeOfBuying!.investment.trim(),
                style: TextStyle(fontFamily: "poppins_thin"),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          if (dropdownData.purposeOfBuying?.personalUse != null)
          DropdownMenuItem<String>(
          value: dropdownData.purposeOfBuying!.personalUse.trim(),
          child: Text(
          dropdownData.purposeOfBuying!.personalUse.trim(),
          style: TextStyle(fontFamily: "poppins_thin"),
          overflow: TextOverflow.ellipsis,
          ),
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

          // Approx Buying Time
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

          // Int Site
          List<DropdownMenuItem<String>> intSiteItems = dropdownData != null &&
          dropdownData.intSite.isNotEmpty
          ? dropdownData.intSite
              .map((site) => site.productName.trim())
              .toSet()
              .map((productName) => DropdownMenuItem<String>(
          value: productName,
          child: Text(productName,
          style: TextStyle(fontFamily: "poppins_thin"), overflow: TextOverflow.ellipsis),
          ))
              .toList()
              : [
          DropdownMenuItem<String>(
          value: 'Default Site',
          child: Text('Default Site',
          style: TextStyle(fontFamily: "poppins_thin"), overflow: TextOverflow.ellipsis),
          ),
          ];

          // Property Sub Type
          List<DropdownMenuItem<String>> propertySubTypeItems = _propertySubTypeOptions.isNotEmpty
          ? _propertySubTypeOptions.map((subType) {
          return DropdownMenuItem<String>(
          value: subType,
          child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Text(
          subType,
          style: TextStyle(fontFamily: "poppins_thin"),
          overflow: TextOverflow.ellipsis,
          ),
          ),
          );
          }).toList()
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
          print('Property Sub Type Items: ${propertySubTypeItems.map((e) => e.value).toList()}');

          // Unit No
          List<DropdownMenuItem<String>> unitNoItems = _unitNoOptions.isNotEmpty
          ? _unitNoOptions.map((unit) {
          return DropdownMenuItem<String>(
          value: unit,
          child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Text(
          unit,
          style: TextStyle(fontFamily: "poppins_thin"),
          overflow: TextOverflow.ellipsis,
          ),
          ),
          );
          }).toList()
              : [
          DropdownMenuItem<String>(
          value: 'Default Unit',
          child: Text('Default Unit',
          style: TextStyle(fontFamily: "poppins_thin"), overflow: TextOverflow.ellipsis),
          ),
          ];

          // Size
          List<DropdownMenuItem<String>> sizeItems = _sizeOptions.isNotEmpty
          ? _sizeOptions.map((size) {
          return DropdownMenuItem<String>(
          value: size,
          child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Text(
          size,
          style: TextStyle(fontFamily: "poppins_thin"),
          overflow: TextOverflow.ellipsis,
          ),
          ),
          );
          }).toList()
              : [
          DropdownMenuItem<String>(
          value: 'Default Size',
          child: Text('Default Size',
          style: TextStyle(fontFamily: "poppins_thin"), overflow: TextOverflow.ellipsis),
          ),
          ];

          // Ensure initial values are valid and exist in items
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
          _intSite = intSiteItems.any((item) => item.value == _intSite)
          ? _intSite
              : intSiteItems.isNotEmpty
          ? intSiteItems.first.value
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
          _buildCustomerInformationPage(
          purposeOfBuyingItems,
          approxBuyingTimeItems,
          propertySubTypeItems,
          ),
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
                Text('Customer Information',
                    style: TextStyle(fontSize: 18, fontFamily: "poppins_thin")),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
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
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  _buildTextField('Int Area*', controller: _intAreaController),
                  _buildDropdown(
                    "Property Sub Type",
                    items: propertySubTypeItems,
                    value: _selectedPropertySubType,
                    onChanged: (String? value) {
                      if (value != null) {
                        setState(() {
                          _selectedPropertySubType = value;
                          print('Selected Property Sub Type: $value');
                        });
                      }
                    },
                  ),
                  _buildTextField('Property Type*', controller: _propertyTypeController),
                  _buildTextField('Budget*', controller: _budgetController),
                  _buildDropdown(
                    "Purpose of Buying*",
                    items: purposeOfBuyingItems,
                    value: _purposeOfBuying,
                    onChanged: (String? value) {
                      if (value != null) {
                        setState(() {
                          _purposeOfBuying = value;
                          _selectedPurpose = value;
                          print('Selected Purpose of Buying: $_selectedPurpose');
                        });
                      }
                    },
                  ),
                  _buildDropdown(
                    "Approx Buying Time*",
                    items: approxBuyingTimeItems,
                    value: _approxBuyingTime,
                    onChanged: (String? value) {
                      if (value != null) {
                        setState(() {
                          _approxBuyingTime = value;
                          _selectedApxTime = value;
                          print('Selected Approx Buying Time: $_selectedApxTime');
                        });
                      }
                    },
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
      List<DropdownMenuItem<String>> intSiteItems,
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
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  _buildDropdown(
                    'Int Site*',
                    items: intSiteItems,
                    value: _intSite,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _intSite = value;
                          _selectIntSite = value;
                          print('Selected Int Site: $_selectIntSite');
                        });
                      }
                    },
                  ),
                  _buildDropdown(
                    'Unit No',
                    items: unitNoItems,
                    value: _selectedUnitNo,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedUnitNo = value;
                          print('Selected Unit No: $_selectedUnitNo');
                        });
                      }
                    },
                  ),
                  _buildDropdown(
                    'Size',
                    items: sizeItems,
                    value: _selectedSize,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedSize = value;
                          print('Selected Size: $_selectedSize');
                        });
                      }
                    },
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
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.grey.shade200,
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  _buildToggleSwitch(),
                  if (isLoanSelected) ...[
                    _buildTextField('DP Amount*', controller: _dpAmountController),
                    _buildTextField('Loan Amount*', controller: _loanAmountController),
                    _buildTextField('After Visit Status*', controller: _afterVisitStatusController),
                    _buildDatePickerField('Next FollowupDate*', controller: _followUpDateController),
                    _buildDropdown(
                      'Select Time*',
                      value: _selectTime,
                      onChanged: (value) => setState(() => _selectTime = value),
                    ),
                  ] else ...[
                    _buildTextField('DP Amount*', controller: _dpAmountController),
                    _buildDropdown(
                      'Cash Payment Condition',
                      value: _cashPaymentCondition,
                      onChanged: (value) => setState(() => _cashPaymentCondition = value),
                    ),
                    _buildDropdown(
                      'Apx Time',
                      value: _apxTime,
                      onChanged: (value) => setState(() => _apxTime = value),
                    ),
                    _buildTextField('After Visit Status*', controller: _afterVisitStatusController),
                    _buildDatePickerField('Next FollowupDate*', controller: _followUpDateController),
                    _buildDropdown(
                      'Select Time*',
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
                child: Text('Back',
                    style: TextStyle(fontFamily: "poppins_thin", color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple.shade300),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Submit',
                    style: TextStyle(fontFamily: "poppins_thin", color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple.shade300),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label,
      {String? prefix, required TextEditingController controller}) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 12.0),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              offset: Offset(1, 3),
              color: Colors.grey.shade400,
            ),
          ],
        ),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(fontFamily: "poppins_thin", fontSize: 15),
            prefixText: prefix != null ? '$prefix ' : null,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePickerField(String label,
      {required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 10),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              offset: Offset(1, 3),
              color: Colors.grey.shade400,
            ),
          ],
        ),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: Colors.white,
            labelStyle: const TextStyle(fontFamily: "poppins_thin", fontSize: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
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
                controller.text = DateFormat('yyyy-MM-dd').format(nextFollowUp!);
                print('Next Follow Up changed to: $nextFollowUp');
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildDropdown(String label,
      {List<DropdownMenuItem<String>>? items, String? value, required ValueChanged<String?> onChanged}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
      child: IgnorePointer(
        ignoring: items == null || items.isEmpty,
        child: Container(
          width: double.infinity, // Ensure dropdown takes full width
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              labelText: label,
              labelStyle: TextStyle(fontFamily: "poppins_thin", fontSize: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20), // Increased padding
            ),
            items: items ??
                [
                  DropdownMenuItem<String>(
                    value: 'Default',
                    child: Text('Default',
                        style: TextStyle(fontFamily: "poppins_thin"), overflow: TextOverflow.ellipsis),
                  ),
                ],
            onChanged: onChanged,
            icon: Icon(Icons.arrow_drop_down, color: Colors.deepPurple),
            elevation: 8,
            dropdownColor: Colors.white,
            style: TextStyle(fontFamily: "poppins_thin", fontSize: 16, color: Colors.black),
            isExpanded: true, // Expand to fit content
          ),
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
        activeBgColors: [
          [Colors.deepPurple.shade300],
          [Colors.deepPurple.shade300]
        ],
        inactiveBgColor: Colors.grey[300],
        cornerRadius: 10.0,
        onToggle: (index) {
          setState(() {
            isLoanSelected = index == 0;
          });
        },
      ),
    );
  }

  Widget _buildNextButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: ElevatedButton(
        onPressed: _nextPage,
        child: Text('Next',
            style: TextStyle(fontFamily: "poppins_thin", color: Colors.white)),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: Colors.deepPurple.shade300,
        ),
      ),
    );
  }
}
import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../Api_services/api_service.dart';
import '../Provider/UserProvider.dart';
import 'Model/Api Model/add_Lead_Model.dart';
import 'Utils/Colors/app_Colors.dart';

class IntSiteOption {
  final String id;
  final String name;

  IntSiteOption({required this.id, required this.name});

  @override
  String toString() => 'ID: $id, Name: $name';
}

class AddVisitScreen extends StatefulWidget {
  final String? inquiryId;

  const AddVisitScreen({Key? key, this.inquiryId}) : super(key: key);

  @override
  _AddVisitScreenState createState() => _AddVisitScreenState();
}

class _AddVisitScreenState extends State<AddVisitScreen> {
  PageController _pageController = PageController();
  int _currentPage = 0;
  DateTime? nextFollowUp;
  bool isLoanSelected = true;

  final TextEditingController _mobileNoController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _propertyTypeController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _dpAmountController = TextEditingController();
  final TextEditingController _loanAmountController = TextEditingController();
  final TextEditingController _afterVisitStatusController = TextEditingController();
  final TextEditingController _followUpDateController = TextEditingController();

  String? _purposeOfBuying;
  String? _approxBuyingTime;
  IntSiteOption? _selectedIntSite;
  String? _selectTime;
  String? _selectedPropertySubType;
  String? _selectedUnitNo;
  String? _selectedSize;
  String? _iscountvisit;
  String? _selectedIntArea;


  List<String> _propertySubTypeOptions = [];
  List<String> _sizeOptions = [];
  List<IntSiteOption> _intSiteOptions = [];
  List<String> _unitNoOptions = [];
  List<IntSiteOption> _intAreaOptions = [];

  final ApiService _apiService = ApiService();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = Provider.of<UserProvider>(context, listen: false);
      if (widget.inquiryId != null) {
        provider.fetchVisitData(widget.inquiryId!).then((_) {
          if (provider.visitData != null) {
            final inquiry = provider.visitData!.inquiries;
            // final area=provider.bookingData!.data[2]; //fetch selected int are from this api
            setState(() {
              _iscountvisit = inquiry.isSiteVisit;
              _mobileNoController.text = inquiry.mobileno;
              _nameController.text = inquiry.fullName;
              _addressController.text = inquiry.address;
              _propertyTypeController.text = inquiry.propertyType;
              _budgetController.text = inquiry.budget;
              // _selectedIntArea=area.area;

              _propertySubTypeOptions = provider.visitData!.projects
                  .map((project) => project.projectSubType.trim())
                  .where((subType) => subType.isNotEmpty)
                  .toSet()
                  .toList();
              _selectedPropertySubType = inquiry.propertySubType.isNotEmpty
                  ? inquiry.propertySubType.trim()
                  : _propertySubTypeOptions.isNotEmpty
                  ? _propertySubTypeOptions.first
                  : null;

              _unitNoOptions = provider.visitData!.unitNo.isNotEmpty
                  ? provider.visitData!.unitNo
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

              _sizeOptions = provider.visitData!.unitNo.isNotEmpty
                  ? provider.visitData!.unitNo
                  .map((unit) => unit.propertySize.trim())
                  .where((size) => size.isNotEmpty)
                  .toSet()
                  .toList()
                  : ['No Size Available'];
              _selectedSize = provider.visitData!.unitNo.isNotEmpty && _unitNoOptions.contains(inquiry.unitNo)
                  ? provider.visitData!.unitNo
                  .firstWhere((unit) => unit.unitNo == inquiry.unitNo)
                  .propertySize
                  .trim()
                  : _sizeOptions.isNotEmpty
                  ? _sizeOptions.first
                  : null;

              if (provider.bookingData != null && provider.bookingData!.data.isNotEmpty) {
                final booking = provider.bookingData!.data[0];
                _selectedIntArea = _intAreaOptions.firstWhere(
                      (option) => option.id == booking.area,
                  orElse: () => _intAreaOptions.first,
                ) as String?;
              }

              String intrestedProduct = inquiry.intrestedProduct.isNotEmpty ? inquiry.intrestedProduct : "1";
              provider.fetchUnitNumbers(intrestedProduct).then((_) => _updateUnitNoAndSize(provider));
            });
          }
        }).catchError((e) {
          print('Error fetching visit data: $e');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load visit data: $e')));
        });
      }

      provider.fetchAddLeadData().then((_) {
        if (provider.dropdownData != null) {
          setState(() {
            final dropdownData = provider.dropdownData!;
            final inquiry = provider.visitData?.inquiries;

            print("Dropdown Data Loaded: ${dropdownData.toString()}");
            print("intArea : ${dropdownData.intArea.map((a) => 'ID: ${a.id}, Area: ${a.area}').toList()}");

            _purposeOfBuying = dropdownData.purposeOfBuying?.investment ?? dropdownData.purposeOfBuying?.personalUse;
            if (inquiry != null && inquiry.purposeBuy.isNotEmpty) _purposeOfBuying = inquiry.purposeBuy;

            _approxBuyingTime = dropdownData.apxTime?.apxTimeData?.split(',')?.first.trim();
            if (inquiry != null && inquiry.budget.isNotEmpty) {
              final times = dropdownData.apxTime?.apxTimeData?.split(',')?.map((e) => e.trim()).toList();
              if (times != null && times.isNotEmpty) {
                int index = int.tryParse(inquiry.budget) ?? 1;
                _approxBuyingTime = (index > 0 && index <= times.length) ? times[index - 1] : _approxBuyingTime;
              }
            }

            _intSiteOptions = dropdownData.intSite.isNotEmpty
                ? dropdownData.intSite.map((site) => IntSiteOption(id: site.id, name: site.productName.trim())).toList()
                : [IntSiteOption(id: "0", name: "Default Site")];
            _selectedIntSite = inquiry != null && inquiry.intrestedProduct.isNotEmpty
                ? _intSiteOptions.firstWhere((option) => option.id == inquiry.intrestedProduct, orElse: () => _intSiteOptions.first)
                : _intSiteOptions.isNotEmpty
                ? _intSiteOptions.first
                : null;

            _intAreaOptions = dropdownData.intArea.isNotEmpty
                ? dropdownData.intArea
                .map((area) => IntSiteOption(id: area.id, name: area.area.trim()))
                .toList()
                : [IntSiteOption(id: "0", name: "Default Area")];
            // Do not set _selectedIntArea here to allow hint to show initially
            // _selectedIntArea = _intAreaOptions.isNotEmpty ? _intAreaOptions.first.id : null;

            print("IntSite Options: $_intSiteOptions");
            print("IntArea Options: $_intAreaOptions");
            print("Selected Int Area: $_selectedIntArea");
          });
        } else {
          setState(() {
            _intSiteOptions = [IntSiteOption(id: "0", name: "Default Site")];
            _selectedIntSite = _intSiteOptions.first;
            _intAreaOptions = [IntSiteOption(id: "0", name: "Default Area")];
            // Do not set _selectedIntArea here to allow hint to show initially
            // _selectedIntArea = _intAreaOptions.first.id;
            print("Fallback IntArea Options: $_intAreaOptions");
          });
        }
      }).catchError((e) {
        print('Error fetching dropdown data: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load dropdown data: $e')));
        setState(() {
          _intAreaOptions = [IntSiteOption(id: "0", name: "Default Area")];
          // _selectedIntArea = _intAreaOptions.first.id;
        });
      });
    });
  }

  void _updateUnitNoAndSize(UserProvider provider) {
    setState(() {
      _unitNoOptions = provider.unitNoData?.unitNo.map((unit) => unit.unitNo.trim()).toSet().toList() ?? ['No Units Available'];
      _selectedUnitNo = _unitNoOptions.isNotEmpty ? _unitNoOptions.first : null;

      _sizeOptions = provider.unitNoData?.unitNo.map((unit) => unit.propertySize.trim()).where((size) => size.isNotEmpty).toSet().toList() ?? ['No Size Available'];
      _selectedSize = _sizeOptions.isNotEmpty ? _sizeOptions.first : null;

      print("Updated UnitNo Options: $_unitNoOptions");
      print("Updated Size Options: $_sizeOptions");
    });
  }

  @override
  void dispose() {
    _mobileNoController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _propertyTypeController.dispose();
    _budgetController.dispose();
    _dpAmountController.dispose();
    _loanAmountController.dispose();
    _afterVisitStatusController.dispose();
    _followUpDateController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_formKey.currentState!.validate() && _currentPage < 1) {
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
    if (!_formKey.currentState!.validate()) {
      print("Form validation failed");
      return;
    }

    String? token = await _secureStorage.read(key: 'token');
    print("Submit Data - Token: $token");

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: No token found in secure storage")));
      return;
    }

    if (widget.inquiryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: No inquiry ID provided")));
      return;
    }

    final provider = Provider.of<UserProvider>(context, listen: false);
    final inquiry = provider.visitData!.inquiries;

    final Map<String, dynamic> apiData = {
      "token": token,
      "remark": _afterVisitStatusController.text,
      "full_name": _nameController.text,
      "intrested_product": _selectedIntSite?.id ?? "6",
      "budget": _budgetController.text,
      "approx_buy": _approxBuyingTime ?? "2-3 days",
      "inquiry_id": widget.inquiryId,
      "isSiteVisit": inquiry.isSiteVisit,
      "iscountvisit": inquiry.iscountvisit,
      // "property_sub_type":_selectedPropertySubType,(send id of selected property sub type)
      "purpose_buy":_purposeOfBuying,
      "intrested_area": _selectedIntArea ?? "0",
      "unit_no": _selectedUnitNo ?? "5",
      "paymentref": isLoanSelected ? "loan" : "cash",
      "dp_amount": _dpAmountController.text,
      "nxt_follow_up": _followUpDateController.text,
      "time": _selectTime ?? "",
      if (isLoanSelected) "loan_amount": _loanAmountController.text,
    };

    print("Submit Data - API Data: ${jsonEncode(apiData)}");

    try {
      final result = await _apiService.submitVisitData(apiData);
      print("Submit Data - API Result: $result");

      if (result["success"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result["message"] ?? "Visit submitted successfully")));
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result["message"] ?? "Submission failed")));
      }
    } catch (e) {
      print("Submission Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error submitting data: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context, listen: false);
    final inquiry = provider.visitData?.inquiries;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Visit Entry(${inquiry?.iscountvisit ?? "N/A"})',
          style: TextStyle(fontFamily: "poppins_thin", color: Colors.white),
        ),
        backgroundColor: AppColor.Buttoncolor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context, true),
        ),
      ),
      backgroundColor: Colors.white,
      body: Consumer<UserProvider>(
        builder: (context, provider, child) {
          if (provider.isLoadingDropdown) {
            print("Dropdown Loading State: ${provider.isLoadingDropdown}");
            return Center(child: CircularProgressIndicator());
          }
          if (provider.error != null) {
            print("Dropdown Error: ${provider.error}");
            return Center(child: Text('Error: ${provider.error}'));
          }

          final dropdownData = provider.dropdownData;
          print("Dropdown Data in Build: ${dropdownData?.toString() ?? 'null'}");

          List<DropdownMenuItem<String>> purposeOfBuyingItems = dropdownData != null
              ? [
            if (dropdownData.purposeOfBuying?.investment != null)
              DropdownMenuItem<String>(
                value: dropdownData.purposeOfBuying!.investment.trim(),
                child: Text(dropdownData.purposeOfBuying!.investment.trim(), style: TextStyle(fontFamily: "poppins_thin"), overflow: TextOverflow.ellipsis),
              ),
            if (dropdownData.purposeOfBuying?.personalUse != null)
              DropdownMenuItem<String>(
                value: dropdownData.purposeOfBuying!.personalUse.trim(),
                child: Text(dropdownData.purposeOfBuying!.personalUse.trim(), style: TextStyle(fontFamily: "poppins_thin"), overflow: TextOverflow.ellipsis),
              ),
          ].where((item) => item.value!.isNotEmpty).toList()
              : [
            DropdownMenuItem<String>(value: 'Investment', child: Text('Investment', style: TextStyle(fontFamily: "poppins_thin"))),
            DropdownMenuItem<String>(value: 'Personal Use', child: Text('Personal Use', style: TextStyle(fontFamily: "poppins_thin"))),
          ];

          List<DropdownMenuItem<String>> approxBuyingTimeItems = dropdownData != null && dropdownData.apxTime?.apxTimeData != null
              ? dropdownData.apxTime!.apxTimeData
              .split(',')
              .map((time) => time.trim())
              .where((time) => time.isNotEmpty)
              .toSet()
              .map((time) => DropdownMenuItem<String>(value: time, child: Text(time, style: TextStyle(fontFamily: "poppins_thin"))))
              .toList()
              : [
            DropdownMenuItem<String>(value: '2-3 days', child: Text('2-3 days', style: TextStyle(fontFamily: "poppins_thin"))),
            DropdownMenuItem<String>(value: '1 week', child: Text('1 week', style: TextStyle(fontFamily: "poppins_thin"))),
            DropdownMenuItem<String>(value: '1 month', child: Text('1 month', style: TextStyle(fontFamily: "poppins_thin"))),
          ];

          List<DropdownMenuItem<IntSiteOption>> intSiteItems =
          _intSiteOptions.map((option) => DropdownMenuItem<IntSiteOption>(value: option, child: Text(option.name, style: TextStyle(fontFamily: "poppins_thin")))).toList();

          List<DropdownMenuItem<String>> propertySubTypeItems = _propertySubTypeOptions.isNotEmpty
              ? _propertySubTypeOptions.map((subType) => DropdownMenuItem<String>(value: subType, child: Text(subType, style: TextStyle(fontFamily: "poppins_thin")))).toList()
              : [
            DropdownMenuItem<String>(value: 'Residential', child: Text('Residential', style: TextStyle(fontFamily: "poppins_thin"))),
            DropdownMenuItem<String>(value: 'Commercial', child: Text('Commercial', style: TextStyle(fontFamily: "poppins_thin"))),
          ];

          List<DropdownMenuItem<String>> unitNoItems = _unitNoOptions.isNotEmpty
              ? _unitNoOptions.map((unit) => DropdownMenuItem<String>(value: unit, child: Text(unit, style: TextStyle(fontFamily: "poppins_thin")))).toList()
              : [DropdownMenuItem<String>(value: 'No Units Available', child: Text('No Units Available', style: TextStyle(fontFamily: "poppins_thin")))];

          List<DropdownMenuItem<String>> sizeItems = _sizeOptions.isNotEmpty
              ? _sizeOptions.map((size) => DropdownMenuItem<String>(value: size, child: Text(size, style: TextStyle(fontFamily: "poppins_thin")))).toList()
              : [DropdownMenuItem<String>(value: 'No Size Available', child: Text('No Size Available', style: TextStyle(fontFamily: "poppins_thin")))];

          List<DropdownMenuItem<String>> intAreaItems =
          _intAreaOptions.map((option) => DropdownMenuItem<String>(value: option.id, child: Text(option.name, style: TextStyle(fontFamily: "poppins_thin")))).toList();
          print("intAreaItems: ${intAreaItems.map((item) => 'Value: ${item.value}, Child: ${item.child}').toList()}");

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
          _selectedPropertySubType = propertySubTypeItems.any((item) => item.value == _selectedPropertySubType)
              ? _selectedPropertySubType
              : propertySubTypeItems.isNotEmpty
              ? propertySubTypeItems.first.value
              : null;
          _selectedUnitNo = unitNoItems.any((item) => item.value == _selectedUnitNo) ? _selectedUnitNo : unitNoItems.isNotEmpty ? unitNoItems.first.value : null;
          _selectedSize = sizeItems.any((item) => item.value == _selectedSize) ? _selectedSize : sizeItems.isNotEmpty ? sizeItems.first.value : null;

          return Form(
            key: _formKey,
            child: PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                _buildCustomerInformationPage(purposeOfBuyingItems, approxBuyingTimeItems, propertySubTypeItems, intAreaItems),
                _buildInterestSuggestionPage(intSiteItems, unitNoItems, sizeItems, provider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCustomerInformationPage(
      List<DropdownMenuItem<String>> purposeOfBuyingItems, List<DropdownMenuItem<String>> approxBuyingTimeItems, List<DropdownMenuItem<String>> propertySubTypeItems, List<DropdownMenuItem<String>> intAreaItems) {
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
                  _buildTextField('Mobile No.', prefix: '+91', controller: _mobileNoController, maxLength: 10),
                  _buildTextField('Name', controller: _nameController, required: true),
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
                  _buildDropdown<String>(
                    "Int Area*",
                    items: intAreaItems,
                    value: _selectedIntArea,
                    onChanged: (value) => setState(() => _selectedIntArea = value),
                    required: true,
                  ),
                  _buildDropdown<String>(
                    "Property Sub Type",
                    items: propertySubTypeItems,
                    value: _selectedPropertySubType,
                    onChanged: (value) => setState(() => _selectedPropertySubType = value),
                  ),
                  _buildTextField('Property Type*', controller: _propertyTypeController),
                  _buildTextField('Budget*', controller: _budgetController, required: true, isNumeric: true),
                  _buildDropdown<String>(
                    "Purpose of Buying*",
                    items: purposeOfBuyingItems,
                    value: _purposeOfBuying,
                    onChanged: (value) => setState(() => _purposeOfBuying = value),
                    required: true,
                  ),
                  _buildDropdown<String>(
                    "Approx Buying Time*",
                    items: approxBuyingTimeItems,
                    value: _approxBuyingTime,
                    onChanged: (value) => setState(() => _approxBuyingTime = value),
                    required: true,
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

  Widget _buildInterestSuggestionPage(List<DropdownMenuItem<IntSiteOption>> intSiteItems, List<DropdownMenuItem<String>> unitNoItems, List<DropdownMenuItem<String>> sizeItems, UserProvider provider) {
    final allSlots = provider.nextSlots;

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
                    onChanged: (value) {
                      setState(() {
                        _selectedIntSite = value;
                        if (value != null) provider.fetchUnitNumbers(value.id).then((_) => _updateUnitNoAndSize(provider));
                      });
                    },
                    required: true,
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
                  _buildTextField('DP Amount*', controller: _dpAmountController, required: true, isNumeric: true),
                  if (isLoanSelected) _buildTextField('Loan Amount*', controller: _loanAmountController, required: true, isNumeric: true),
                  _buildTextField('After Visit Status*', controller: _afterVisitStatusController, required: true),
                  _buildDatePickerField('Next Followup Date*', controller: _followUpDateController, required: true),
                  SizedBox(height: 10),
                  provider.isLoading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : DropdownButton2<String>(
                    isExpanded: true,
                    hint: const Text('Select Time', style: TextStyle(fontFamily: "poppins_thin")),
                    value: _selectTime,
                    buttonStyleData: ButtonStyleData(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.grey.shade200)),
                    underline: const SizedBox(),
                    dropdownStyleData: DropdownStyleData(maxHeight: 200),
                    items: allSlots.map((slot) {
                      return DropdownMenuItem<String>(
                        value: slot.source,
                        enabled: slot.disabled,
                        child: Text(
                          slot.source ?? '',
                          style: TextStyle(fontFamily: "poppins_thin", color: slot.disabled ? Colors.black : Colors.grey),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null && allSlots.any((slot) => slot.source == value && slot.disabled)) {
                        setState(() => _selectTime = value);
                      }
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a time';
                        }
                        return null;
                      };
                    },



                  ),
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

  Widget _buildTextField(String label,
      {String? prefix, required TextEditingController controller, bool required = false, bool isNumeric = false, int? maxLength}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.0),
      child: Container(
        height: 50,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(offset: Offset(1, 3), color: Colors.grey.shade400)]),
        child: TextFormField(
          controller: controller,
          keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
          inputFormatters: isNumeric ? [FilteringTextInputFormatter.digitsOnly] : null,
          maxLength: maxLength,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(fontFamily: "poppins_thin", fontSize: 15),
            prefixText: prefix != null ? '$prefix ' : null,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            counterText: maxLength != null ? '' : null,
          ),
          validator: (value) {
            if (required && (value == null || value.isEmpty)) return '$label is required';
            if (isNumeric && value != null && value.isNotEmpty && int.tryParse(value) == null) return 'Enter a valid number for $label';
            if (maxLength != null && value != null && value.length != maxLength) return '$label must be $maxLength digits';
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildDatePickerField(String label, {required TextEditingController controller, bool required = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 10),
      child: Container(
        height: 50,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(offset: Offset(1, 3), color: Colors.grey.shade400)]),
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
            DateTime? picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
            if (picked != null) {
              final provider = Provider.of<UserProvider>(context, listen: false);
              setState(() {
                nextFollowUp = picked;
                _followUpDateController.text = DateFormat('yyyy-MM-dd').format(picked);
                _selectTime = null;
                provider.fetchNextSlots(DateFormat('yyyy-MM-dd').format(picked));
              });
            }
          },
          validator: (value) => required && (value == null || value.isEmpty) ? '$label is required' : null,
        ),
      ),
    );
  }

  Widget _buildDropdown<T>(String label, {List<DropdownMenuItem<T>>? items, T? value, required ValueChanged<T?> onChanged, bool required = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontFamily: "poppins_thin", fontSize: 16, color: Colors.grey[700]),
          ),
          SizedBox(height: 8),
          DropdownButton2<T>(
            isExpanded: true,
            hint: Text("Select $label", style: TextStyle(fontFamily: "poppins_thin", fontSize: 16, color: Colors.grey)),
            value: value,
            items: items ?? [],
            onChanged: onChanged,
            buttonStyleData: ButtonStyleData(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade400),
                color: Colors.white,
              ),
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 200,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.white),
            ),
            iconStyleData: IconStyleData(icon: Icon(Icons.arrow_drop_down, color: Colors.deepPurple)),
            underline: SizedBox(),
          ),
          if (required && value == null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 12.0),
              child: Text('$label is required', style: TextStyle(color: Colors.red, fontSize: 12)),
            ),
        ],
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
        style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), backgroundColor: Colors.deepPurple.shade300),
      ),
    );
  }
}
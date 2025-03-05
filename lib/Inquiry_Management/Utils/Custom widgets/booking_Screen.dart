import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hr_app/Inquiry_Management/Utils/Colors/app_Colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../../Api_services/api_service.dart';
import '../../../Provider/UserProvider.dart';
import '../../Model/Api Model/add_Lead_Model.dart';

class BookingScreen extends StatefulWidget {
  final String? inquiryId;

  BookingScreen({Key? key, this.inquiryId}) : super(key: key);

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  final ApiService _apiService = ApiService();

  DateTime? nextFollowUp;
  bool isLoanSelected = true;
  bool isIncludeSelected = true;
  List<Map<String, TextEditingController>> cashFields = [];
  List<Map<String, TextEditingController>> loanFields = [];
  bool _isPaymentValid = false;
  String? _amountError;

  final TextEditingController _mobileNoController = TextEditingController();
  final TextEditingController _partyNameController = TextEditingController();
  final TextEditingController _houseNoController = TextEditingController();
  final TextEditingController _societyController = TextEditingController();
  final TextEditingController _landMarkController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _intAreaController = TextEditingController();
  final TextEditingController _propertyTypeController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _extraWorkController = TextEditingController();
  final TextEditingController _extraExpenseController = TextEditingController();
  final TextEditingController _totalPriceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _finalPriceController = TextEditingController();
  final TextEditingController _remainingTotalAmountController = TextEditingController();
  final TextEditingController _totalAmountOfPurchaseController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _loanAmountController = TextEditingController();
  final TextEditingController _tokenAmountController = TextEditingController();
  final TextEditingController _tokenAmountInWordsController = TextEditingController();
  final TextEditingController _tokenDateController = TextEditingController();
  final TextEditingController _bookingDateController = TextEditingController();
  final TextEditingController _hastakController = TextEditingController();

  String? _selectedAreaId;
  String? _selectedPropertySubType;
  String? _selectedPurposeOfBuying;
  String? _selectedApproxBuyingTime;
  String? _selectedTokenBy;
  String? _selectedHastakSource;
  String? _selectedManager;
  String? _selectedStaff;
  String? _selectedChannelPartner;
  String? _selectedCustomer;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = Provider.of<UserProvider>(context, listen: false);
      if (widget.inquiryId != null) {
        provider.fetchBookingData(widget.inquiryId!);
        provider.fetchVisitData(widget.inquiryId!).then((_) {
          _populateVisitData(provider); // Populate data after fetch
        });
      }
      // Pre-fill booking data
      if (provider.bookingData != null && provider.bookingData!.data.isNotEmpty && _mobileNoController.text.isEmpty) {
        final booking = provider.bookingData!.data[0];
        _houseNoController.text = booking.houseno;
        _societyController.text = booking.society;
        _selectedAreaId = "${booking.area}";
        _cityController.text = booking.city;
      }

      provider.fetchAddLeadData();
      _addCashField();
      _addLoanField();
      _selectedHastakSource = 'Walk In';
      _bookingDateController.text = DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.now());

      _priceController.addListener(_updatePrices);
      _extraWorkController.addListener(_updatePrices);
      _extraExpenseController.addListener(_updatePrices);
      _discountController.addListener(_updatePrices);
      _loanAmountController.addListener(_updateRemainingAmount);
      _amountController.addListener(_updateRemainingAmount);
      _tokenAmountController.addListener(_updateTokenAmountInWords);

      _updatePrices();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _mobileNoController.dispose();
    _partyNameController.dispose();
    _houseNoController.dispose();
    _societyController.dispose();
    _landMarkController.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    _intAreaController.dispose();
    _propertyTypeController.dispose();
    _budgetController.dispose();
    _priceController.dispose();
    _extraWorkController.dispose();
    _extraExpenseController.dispose();
    _totalPriceController.dispose();
    _discountController.dispose();
    _finalPriceController.dispose();
    _remainingTotalAmountController.dispose();
    _totalAmountOfPurchaseController.dispose();
    _amountController.dispose();
    _loanAmountController.dispose();
    _tokenAmountController.dispose();
    _tokenAmountInWordsController.dispose();
    _tokenDateController.dispose();
    _bookingDateController.dispose();
    _hastakController.dispose();

    for (var field in cashFields) {
      field['amount']?.dispose();
      field['date']?.dispose();
      field['duration']?.dispose();
    }
    for (var field in loanFields) {
      field['amount']?.dispose();
      field['date']?.dispose();
      field['duration']?.dispose();
    }
    super.dispose();
  }

  void _populateVisitData(UserProvider provider) {

    if (provider.visitData != null) {

      final address=provider.bookingData?.data;
      final inquiries = provider.visitData!.inquiries;
      final propertySubTypeItems = provider.visitData!.projects.map((config) => config.projectSubType).toList() ?? ['Type 1', 'Type 2', 'Type 3'];
      final purposeBuyingItems = provider.dropdownData!.purposeOfBuying != null
          ? [provider.dropdownData!.purposeOfBuying!.investment, provider.dropdownData!.purposeOfBuying!.personalUse]
          : ['Purpose 1', 'Purpose 2', 'Purpose 3'];
      final approxBuyingTimeItems = provider.dropdownData!.apxTime != null
          ? provider.dropdownData!.apxTime!.apxTimeData.split(',').map((time) => time.trim()).toList()
          : ['Time 1', 'Time 2', 'Time 3'];

      setState(() {
        // Customer Information Page
        _mobileNoController.text = inquiries.mobileno;
        _partyNameController.text = inquiries.fullName;

        // _societyController.text = inquiries.address.split(', ').length > 1 ? inquiries.address.split(', ')[1] : inquiries.address;
        // _landMarkController.text = inquiries.address.split(', ').length > 2 ? inquiries.address.split(', ')[2] : '';
        // _cityController.text = inquiries.address.split(', ').last;

        // Interest Suggestion Page
        // _intAreaController.text = provider.visitData!.unitNo.isNotEmpty ? provider.visitData!.unitNo[0].propertySize : '';
        _selectedPropertySubType = propertySubTypeItems.contains(inquiries.propertySubType) ? inquiries.propertySubType : null;
        _propertyTypeController.text = inquiries.propertyType;
        _budgetController.text = inquiries.budget;
        _selectedPurposeOfBuying = purposeBuyingItems.contains(inquiries.purposeBuy) ? inquiries.purposeBuy : null;
        _selectedApproxBuyingTime = approxBuyingTimeItems.contains(provider.dropdownData?.apxTime?.apxTimeData.split(',').first.trim())
            ? provider.dropdownData!.apxTime!.apxTimeData.split(',').first.trim()
            : approxBuyingTimeItems.isNotEmpty
            ? approxBuyingTimeItems.first
            : null;
      });
    }
  }

  Future<void> _submitForm() async {
    print('Starting form submission...');

    if (_mobileNoController.text.isEmpty ||
        _partyNameController.text.isEmpty ||
        _houseNoController.text.isEmpty ||
        _societyController.text.isEmpty ||
        _selectedAreaId == null ||
        _landMarkController.text.isEmpty ||
        _cityController.text.isEmpty ||
        _pincodeController.text.isEmpty ||
        _intAreaController.text.isEmpty ||
        _selectedPropertySubType == null ||
        _propertyTypeController.text.isEmpty ||
        _budgetController.text.isEmpty ||
        _selectedPurposeOfBuying == null ||
        _selectedApproxBuyingTime == null ||
        _priceController.text.isEmpty ||
        _extraWorkController.text.isEmpty ||
        _totalPriceController.text.isEmpty ||
        _discountController.text.isEmpty ||
        _finalPriceController.text.isEmpty ||
        _tokenAmountController.text.isEmpty ||
        _tokenDateController.text.isEmpty ||
        _selectedTokenBy == null ||
        _bookingDateController.text.isEmpty ||
        _selectedHastakSource == null) {
      print('Validation failed: One or more required fields are empty');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    print('Validation passed, preparing request body...');

    String areaId = _selectedAreaId != null ? _selectedAreaId!.split('(').last.replaceAll(')', '').trim() : '0';
    String? managerId = _selectedManager != null ? _selectedManager!.split('(').last.replaceAll(')', '').trim() : '';
    String? staffId = _selectedStaff != null ? _selectedStaff!.split('(').last.replaceAll(')', '').trim() : '';
    String? channelPartnerId = _selectedChannelPartner != null ? _selectedChannelPartner!.split('(').last.replaceAll(')', '').trim() : '';
    String? customerId = _selectedCustomer != null ? _selectedCustomer!.split('(').last.replaceAll(')', '').trim() : '';

    List<Map<String, dynamic>> paymentFields = isLoanSelected
        ? loanFields.map((field) => {
      'amount': double.tryParse(field['amount']!.text) ?? 0,
      'date': field['date']!.text.isNotEmpty ? field['date']!.text : null,
      'duration': int.tryParse(field['duration']!.text) ?? 0,
    }).toList()
        : cashFields.map((field) => {
      'amount': double.tryParse(field['amount']!.text) ?? 0,
      'date': field['date']!.text.isNotEmpty ? field['date']!.text : null,
      'duration': int.tryParse(field['duration']!.text) ?? 0,
    }).toList();

    final Map<String, dynamic> requestBody = {
      "inquiry_id": widget.inquiryId ?? "",
      "booking_date": _bookingDateController.text,
      "product_name": "1",
      "unitno": int.tryParse(_houseNoController.text) ?? 0,
      "amount": double.tryParse(_totalAmountOfPurchaseController.text) ?? 0,
      "payment_date": _tokenDateController.text,
      "duration_day": paymentFields.isNotEmpty ? (int.tryParse(paymentFields[0]['duration'].toString()) ?? 0) : 0,
      "remaining_amount": double.tryParse(_remainingTotalAmountController.text) ?? 0,
      "token_amount": double.tryParse(_tokenAmountController.text) ?? 0,
      "token_amount_date": _tokenDateController.text,
      "token_by": _selectedTokenBy ?? "",
      "booking_by_ssm": managerId,
      "booking_by_sse": staffId,
      "booking_by_broker": channelPartnerId,
      "booking_by_customer": customerId,
      "mobileno": _mobileNoController.text,
      "partyname": _partyNameController.text,
      "houseno": int.tryParse(_houseNoController.text) ?? 0,
      "societyname": _societyController.text,
      "area": int.tryParse(areaId) ?? 0,
      "landmark": _landMarkController.text,
      "city": _cityController.text,
      "pincode": int.tryParse(_pincodeController.text) ?? 0,
      "unitsize": _intAreaController.text,
      "construction": 2,
      "price": double.tryParse(_priceController.text) ?? 0,
      "extra_work": double.tryParse(_extraWorkController.text) ?? 0,
      "total_price": double.tryParse(_totalPriceController.text) ?? 0,
      "discount_price": double.tryParse(_discountController.text) ?? 0,
      "switcher_amount": isLoanSelected ? "loan" : "cash",
      "loan_amount": isLoanSelected ? (double.tryParse(_loanAmountController.text) ?? 0).toString() : "",
    };

    print('Request Body: ${json.encode(requestBody)}');

    try {
      print('Calling API to submit booking data...');
      final result = await _apiService.submitBookingData(requestBody);
      print('API Response: $result');

      if (result['status'] == 1) {
        print('Booking submitted successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking submitted successfully!')),
        );
        Navigator.pop(context);
      } else {
        print('API returned error: ${result['message']}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${result['message']}')),
        );
      }
    } catch (e) {
      print('Exception during API call: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting booking: $e')),
      );
    }
  }

  void _updatePrices() {
    double price = double.tryParse(_priceController.text) ?? 0;
    double extraWork = double.tryParse(_extraWorkController.text) ?? 0;
    double extraExpense = isIncludeSelected ? 0 : (double.tryParse(_extraExpenseController.text) ?? 0);
    double discount = double.tryParse(_discountController.text) ?? 0;

    double total = price + extraWork + extraExpense;
    double finalPrice = total - discount;

    _totalPriceController.text = total.toStringAsFixed(2);
    _finalPriceController.text = finalPrice.toStringAsFixed(2);
    _totalAmountOfPurchaseController.text = finalPrice.toStringAsFixed(2);

    _updateRemainingAmount();
  }

  void _updateRemainingAmount() {
    double finalPrice = double.tryParse(_finalPriceController.text) ?? 0;
    double totalPaid = 0;

    if (isLoanSelected) {
      totalPaid = loanFields.fold(0, (sum, field) => sum + (double.tryParse(field['amount']!.text) ?? 0));
      totalPaid += double.tryParse(_loanAmountController.text) ?? 0;
    } else {
      totalPaid = cashFields.fold(0, (sum, field) => sum + (double.tryParse(field['amount']!.text) ?? 0));
      totalPaid += double.tryParse(_amountController.text) ?? 0;
    }

    double remaining = finalPrice - totalPaid;

    _remainingTotalAmountController.text = remaining.toStringAsFixed(2);

    setState(() {
      if (remaining < 0) {
        _remainingTotalAmountController.text = '0.00';
        _amountError = 'Amount is not equal to 0, extra: ${remaining.abs().toStringAsFixed(2)}';
        _isPaymentValid = false;
      } else if (remaining == 0) {
        _amountError = null;
        _isPaymentValid = true;
      } else {
        _amountError = 'Amount is not equal to 0, remaining: ${remaining.toStringAsFixed(2)}';
        _isPaymentValid = false;
      }
    });
  }

  String _numberToWords(double number) {
    if (number == 0) return "Zero";
    final units = ['', 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine', 'Ten', 'Eleven', 'Twelve', 'Thirteen', 'Fourteen', 'Fifteen', 'Sixteen', 'Seventeen', 'Eighteen', 'Nineteen'];
    final tens = ['', '', 'Twenty', 'Thirty', 'Forty', 'Fifty', 'Sixty', 'Seventy', 'Eighty', 'Ninety'];

    double whole = number.floorToDouble();
    String words = '';

    if (whole >= 10000000) {
      words += _numberToWordsHelper(whole / 10000000) + ' Crore ';
      whole %= 10000000;
    }
    if (whole >= 100000) {
      words += _numberToWordsHelper(whole / 100000) + ' Lakh ';
      whole %= 100000;
    }
    if (whole >= 1000) {
      words += _numberToWordsHelper(whole / 1000) + ' Thousand ';
      whole %= 1000;
    }
    if (whole >= 100) {
      words += units[(whole / 100).floor()] + ' Hundred ';
      whole %= 100;
    }
    if (whole >= 20) {
      words += tens[(whole / 10).floor()] + ' ';
      whole %= 10;
    }
    if (whole > 0) {
      words += units[whole.toInt()];
    }

    double decimal = number - number.floor();
    if (decimal > 0) {
      int paise = (decimal * 100).round();
      if (words.isNotEmpty) words += ' and ';
      if (paise >= 20) {
        words += tens[paise ~/ 10] + ' ';
        paise %= 10;
      }
      if (paise > 0) {
        words += units[paise];
      }
      words += ' Paise';
    }

    words = words.trim();
    return words.isEmpty ? 'Zero' : '$words Only';
  }

  String _numberToWordsHelper(double number) {
    if (number == 0) return "";
    final units = ['', 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine', 'Ten', 'Eleven', 'Twelve', 'Thirteen', 'Fourteen', 'Fifteen', 'Sixteen', 'Seventeen', 'Eighteen', 'Nineteen'];
    final tens = ['', '', 'Twenty', 'Thirty', 'Forty', 'Fifty', 'Sixty', 'Seventy', 'Eighty', 'Ninety'];

    double whole = number.floorToDouble();
    String words = '';

    if (whole >= 100) {
      words += units[(whole / 100).floor()] + ' Hundred ';
      whole %= 100;
    }
    if (whole >= 20) {
      words += tens[(whole / 10).floor()] + ' ';
      whole %= 10;
    }
    if (whole > 0) {
      words += units[whole.toInt()];
    }

    return words.trim();
  }

  void _updateTokenAmountInWords() {
    double amount = double.tryParse(_tokenAmountController.text) ?? 0;
    _tokenAmountInWordsController.text = _numberToWords(amount);
  }

  void _nextPage() {
    if (_currentPage < 3) {
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

  void _addCashField() {
    TextEditingController amountController = TextEditingController()..addListener(_updateRemainingAmount);
    TextEditingController dateController = TextEditingController();
    TextEditingController durationController = TextEditingController();
    setState(() {
      cashFields.add({'amount': amountController, 'date': dateController, 'duration': durationController});
    });
  }

  void _addLoanField() {
    TextEditingController amountController = TextEditingController()..addListener(_updateRemainingAmount);
    TextEditingController dateController = TextEditingController();
    TextEditingController durationController = TextEditingController();
    setState(() {
      loanFields.add({'amount': amountController, 'date': dateController, 'duration': durationController});
    });
  }

  void _removeCashField(int index) {
    setState(() {
      cashFields[index]['amount']?.dispose();
      cashFields[index]['date']?.dispose();
      cashFields[index]['duration']?.dispose();
      cashFields.removeAt(index);
      _updateRemainingAmount();
    });
  }

  void _removeLoanField(int index) {
    setState(() {
      loanFields[index]['amount']?.dispose();
      loanFields[index]['date']?.dispose();
      loanFields[index]['duration']?.dispose();
      loanFields.removeAt(index);
      _updateRemainingAmount();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Booking', style: TextStyle(fontFamily: "poppins_thin", color: Colors.white)),
        backgroundColor: AppColor.Buttoncolor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: Consumer<UserProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (provider.error != null) {
            return Center(child: Text('Error: ${provider.error}'));
          }


          return SafeArea(
            child: PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                _buildCustomerInformationPage(provider),
                _buildInterestSuggestionPage(provider),
                _buildAdditionalPage(),
                _buildFollowUpPage(provider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCustomerInformationPage(UserProvider provider) {
    final areaItems = provider.bookingData?.data.map((datum) => "${datum.area} (${datum.area})").toSet().toList() ?? ['Area 1 (1)', 'Area 2 (2)', 'Area 3 (3)'];
    if (_selectedAreaId != null && !areaItems.contains(_selectedAreaId)) {
      _selectedAreaId = null;
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(width: 10),
                    Text('Customer Information', style: TextStyle(fontSize: 18, fontFamily: "poppins_thin")),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        _buildTextField('Mobile No.', controller: _mobileNoController, prefix: '+91'),
                        _buildTextField('Party Name', controller: _partyNameController),
                        _buildTextField('House No.', controller: _houseNoController),
                        _buildTextField('Society', controller: _societyController),
                        _buildDropdown2(
                          label: "Area",
                          items: areaItems,
                          selectedValue: _selectedAreaId,
                          onChanged: (value) => setState(() => _selectedAreaId = value),
                        ),
                        _buildTextField('Land Mark', controller: _landMarkController),
                        _buildTextField('City', controller: _cityController),
                        _buildTextField('Pincode', controller: _pincodeController),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: _nextPage,
                child: Text('Next', style: TextStyle(fontFamily: "poppins_thin", color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple.shade300),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInterestSuggestionPage(UserProvider provider) {
    final propertySubTypeItems = provider.dropdownData?.propertyConfiguration.map((config) => config.propertyType).toList() ?? ['Type 1', 'Type 2', 'Type 3'];
    final purposeBuyingItems = provider.dropdownData?.purposeOfBuying != null
        ? [provider.dropdownData!.purposeOfBuying!.investment, provider.dropdownData!.purposeOfBuying!.personalUse]
        : ['Purpose 1', 'Purpose 2', 'Purpose 3'];
    final approxBuyingTimeItems = provider.dropdownData?.apxTime != null
        ? provider.dropdownData!.apxTime!.apxTimeData.split(',').map((time) => time.trim()).toList()
        : ['Time 1', 'Time 2', 'Time 3'];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(width: 10),
                    Text('Project Detail', style: TextStyle(fontSize: 18, fontFamily: "poppins_thin")),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTextField('Int Area*', controller: _intAreaController),
                        _buildDropdown2(
                          label: 'Property Sub Type*',
                          items: propertySubTypeItems,
                          selectedValue: _selectedPropertySubType,
                          onChanged: (value) => setState(() => _selectedPropertySubType = value),
                        ),
                        _buildTextField('Property Type*', controller: _propertyTypeController),
                        _buildTextField('Budget*', controller: _budgetController),
                        _buildDropdown2(
                          label: 'Purpose of Buying*',
                          items: purposeBuyingItems,
                          selectedValue: _selectedPurposeOfBuying,
                          onChanged: (value) => setState(() => _selectedPurposeOfBuying = value),
                        ),
                        _buildDropdown2(
                          label: 'Approx Buying Time*',
                          items: approxBuyingTimeItems,
                          selectedValue: _selectedApproxBuyingTime,
                          onChanged: (value) => setState(() => _selectedApproxBuyingTime = value),
                        ),
                        Text(
                          "Expenses",
                          style: TextStyle(fontFamily: "poppins_thin", color: Colors.black, fontSize: 18),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _buildToggleSwitch(
                            labels: ['Include', 'Exclude'],
                            initialIndex: isIncludeSelected ? 0 : 1,
                            onToggle: (index) {
                              setState(() {
                                isIncludeSelected = index == 0;
                                _updatePrices();
                              });
                            },
                          ),
                        ),
                        if (isIncludeSelected) ...[
                          _buildTextField('Price*', controller: _priceController),
                          _buildTextField('Extra Work*', controller: _extraWorkController),
                          _buildTextField("Total Price", controller: _totalPriceController, readOnly: true),
                          _buildTextField("Discount", controller: _discountController),
                          _buildTextField("Final Price", controller: _finalPriceController, readOnly: true),
                        ] else ...[
                          _buildTextField('Price*', controller: _priceController),
                          _buildTextField('Extra Work*', controller: _extraWorkController),
                          _buildTextField('Extra Expense*', controller: _extraExpenseController),
                          _buildTextField("Total Price", controller: _totalPriceController, readOnly: true),
                          _buildTextField("Discount", controller: _discountController),
                          _buildTextField("Final Price", controller: _finalPriceController, readOnly: true),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
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
                onPressed: _nextPage,
                child: Text('Next', style: TextStyle(fontFamily: "poppins_thin", color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple.shade300),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(width: 10),
                    Text('Payment Condition', style: TextStyle(fontSize: 18, fontFamily: "poppins_thin")),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        _buildToggleSwitch(
                          labels: ['Loan', 'Cash'],
                          initialIndex: isLoanSelected ? 0 : 1,
                          onToggle: (index) {
                            setState(() {
                              isLoanSelected = index == 0;
                              _updateRemainingAmount();
                            });
                          },
                        ),
                        if (isLoanSelected) ...[
                          for (int i = 0; i < loanFields.length; i++)
                            Column(
                              children: [
                                _buildTextField('Amount', controller: loanFields[i]['amount']),
                                _buildDatePickerField('Date', controller: loanFields[i]['date']),
                                _buildTextField('Duration (in days)', controller: loanFields[i]['duration']),
                                SizedBox(height: 20),
                                if (i != 0)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.remove_circle, color: Colors.red),
                                        onPressed: () => _removeLoanField(i),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: Icon(Icons.add_circle, color: Colors.green),
                              onPressed: _addLoanField,
                            ),
                          ),
                          _buildTextField('Loan Amount', controller: _loanAmountController),
                          _buildTextField('Remaining Total Amount', controller: _remainingTotalAmountController, readOnly: true),
                          if (_amountError != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                _amountError!,
                                style: TextStyle(color: Colors.red, fontFamily: "poppins_thin"),
                              ),
                            ),
                          _buildTextField('Total Amount of Purchase', controller: _totalAmountOfPurchaseController, readOnly: true),
                        ] else ...[
                          for (int i = 0; i < cashFields.length; i++)
                            Column(
                              children: [
                                _buildTextField('Amount', controller: cashFields[i]['amount']),
                                _buildDatePickerField('Date', controller: cashFields[i]['date']),
                                _buildTextField('Duration (in days)', controller: cashFields[i]['duration']),
                                SizedBox(height: 20),
                                if (i != 0)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.remove_circle, color: Colors.red),
                                        onPressed: () => _removeCashField(i),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: Icon(Icons.add_circle, color: Colors.green),
                              onPressed: _addCashField,
                            ),
                          ),
                          _buildTextField('Amount', controller: _amountController),
                          _buildTextField('Remaining Total Amount', controller: _remainingTotalAmountController, readOnly: true),
                          if (_amountError != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                _amountError!,
                                style: TextStyle(color: Colors.red, fontFamily: "poppins_thin"),
                              ),
                            ),
                          _buildTextField('Total Amount of Purchase', controller: _totalAmountOfPurchaseController, readOnly: true),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
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
              if (_isPaymentValid)
                ElevatedButton(
                  onPressed: _nextPage,
                  child: Text('Next', style: TextStyle(fontFamily: "poppins_thin", color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple.shade300),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFollowUpPage(UserProvider provider) {
    final managerItems = provider.bookingData?.manager.map((m) => "${m.firstname} (${m.id})").toList() ?? ['Select Manager'];
    final staffItems = provider.bookingData?.staff.map((s) => "${s.firstname} (${s.id})").toList() ?? ['Select Staff'];
    final channelPartnerItems = provider.bookingData?.channelPartner.map((cp) => "${cp.brokername} (${cp.id})").toList() ?? ['Select Channel Partner'];
    final customerItems = provider.bookingData?.customer.map((c) => "${c.name} (${c.id})").toList() ?? ['Select Customer'];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(width: 10),
                    Text('Token Payment Status', style: TextStyle(fontSize: 18, fontFamily: "poppins_thin")),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        _buildTextField('Token Amount', controller: _tokenAmountController),
                        _buildTextField('Token Amount in Words', controller: _tokenAmountInWordsController, readOnly: true),
                        _buildDatePickerField('Token Amount Date', controller: _tokenDateController),
                        _buildDropdown2(
                          label: 'Token By',
                          items: ['Cash', 'Cheque', 'Transfer'],
                          selectedValue: _selectedTokenBy,
                          onChanged: (value) => setState(() => _selectedTokenBy = value),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text('Booking Date', style: TextStyle(fontSize: 18, fontFamily: "poppins_thin")),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        _buildDatePickerField('Booking Date', controller: _bookingDateController),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text('Hastak', style: TextStyle(fontSize: 18, fontFamily: "poppins_thin")),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        _buildDropdown2(
                          label: 'Manager',
                          items: managerItems,
                          selectedValue: _selectedManager,
                          onChanged: (value) => setState(() => _selectedManager = value),
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Radio<String>(
                                  value: 'Walk In',
                                  groupValue: _selectedHastakSource,
                                  onChanged: (value) => setState(() => _selectedHastakSource = value),
                                ),
                                Text('Walk In', style: TextStyle(fontFamily: "poppins_thin")),
                                Radio<String>(
                                  value: 'Staff',
                                  groupValue: _selectedHastakSource,
                                  onChanged: (value) => setState(() => _selectedHastakSource = value),
                                ),
                                Text('Staff', style: TextStyle(fontFamily: "poppins_thin")),
                              ],
                            ),
                            Row(
                              children: [
                                Radio<String>(
                                  value: 'Channel Partner',
                                  groupValue: _selectedHastakSource,
                                  onChanged: (value) => setState(() => _selectedHastakSource = value),
                                ),
                                Text('Channel Partner', style: TextStyle(fontFamily: "poppins_thin")),
                                Radio<String>(
                                  value: 'Customer',
                                  groupValue: _selectedHastakSource,
                                  onChanged: (value) => setState(() => _selectedHastakSource = value),
                                ),
                                Text('Customer', style: TextStyle(fontFamily: "poppins_thin")),
                              ],
                            ),
                          ],
                        ),
                        if (_selectedHastakSource == 'Staff')
                          _buildDropdown2(
                            label: 'Staff Select',
                            items: staffItems,
                            selectedValue: _selectedStaff,
                            onChanged: (value) => setState(() => _selectedStaff = value),
                          ),
                        if (_selectedHastakSource == 'Channel Partner')
                          _buildDropdown2(
                            label: 'Channel Partner Select',
                            items: channelPartnerItems,
                            selectedValue: _selectedChannelPartner,
                            onChanged: (value) => setState(() => _selectedChannelPartner = value),
                          ),
                        if (_selectedHastakSource == 'Customer')
                          _buildDropdown2(
                            label: 'Customer Select',
                            items: customerItems,
                            selectedValue: _selectedCustomer,
                            onChanged: (value) => setState(() => _selectedCustomer = value),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
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
                onPressed: _submitForm,
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
      {TextEditingController? controller, String? prefix, bool readOnly = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(offset: Offset(1, 3), color: Colors.grey.shade400)],
        ),
        child: TextFormField(
          controller: controller,
          readOnly: readOnly,
          maxLines: maxLines,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(fontFamily: "poppins_thin", fontSize: 15),
            prefixText: prefix != null ? '$prefix ' : null,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          ),
          keyboardType: (label.contains('Amount') && !label.contains('Words')) || label.contains('Price') || label.contains('Discount')
              ? TextInputType.numberWithOptions(decimal: true)
              : TextInputType.text,
        ),
      ),
    );
  }

  Widget _buildDatePickerField(String label, {TextEditingController? controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontFamily: "poppins_thin"),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey)),
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
            controller!.text = DateFormat('dd-MM-yyyy hh:mm a').format(picked);
          }
        },
      ),
    );
  }

  Widget _buildDropdown2({
    required String label,
    required List<String> items,
    required String? selectedValue,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Container(
        height: 55,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          boxShadow: [
            BoxShadow(color: Colors.grey.shade300, blurRadius: 4, spreadRadius: 2),
          ],
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            hint: Text(label, style: TextStyle(fontSize: 15, fontFamily: "poppins_thin")),
            items: items.map((String item) => DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: TextStyle(fontSize: 16, fontFamily: "poppins_thin")),
            )).toList(),
            value: selectedValue,
            onChanged: onChanged,
            buttonStyleData: ButtonStyleData(
              height: 40,
              padding: const EdgeInsets.only(left: 14, right: 14),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
            iconStyleData: const IconStyleData(icon: Icon(Icons.arrow_drop_down), iconSize: 24),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 200,
              padding: null,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white),
              elevation: 8,
              offset: const Offset(0, -4),
              scrollbarTheme: ScrollbarThemeData(
                radius: const Radius.circular(40),
                thickness: MaterialStateProperty.all<double>(6),
                thumbVisibility: MaterialStateProperty.all<bool>(true),
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(height: 40, padding: EdgeInsets.only(left: 14, right: 14)),
          ),
        ),
      ),
    );
  }

  Widget _buildToggleSwitch({
    required List<String> labels,
    required int initialIndex,
    required Function(int?) onToggle,
    double minWidth = 90.0,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: ToggleSwitch(
        minWidth: minWidth,
        initialLabelIndex: initialIndex,
        totalSwitches: labels.length,
        labels: labels,
        customTextStyles: [TextStyle(fontFamily: "poppins_thin")],
        activeBgColors: List.generate(labels.length, (index) => [Colors.deepPurple.shade300]),
        inactiveBgColor: Colors.grey[300],
        cornerRadius: 10,
        onToggle: onToggle,
      ),
    );
  }
}
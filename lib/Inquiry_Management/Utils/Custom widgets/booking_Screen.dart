import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hr_app/Inquiry_Management/Utils/Colors/app_Colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../../Api_services/api_service.dart';
import '../../../Provider/UserProvider.dart';
import '../../Model/Api Model/add_Lead_Model.dart';

class IntSiteOption {
  final String id;
  final String name;

  IntSiteOption({required this.id, required this.name});

  @override
  String toString() => 'ID: $id, Name: $name';
}

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
  String? selectedConstruction;

  List<IntSiteOption> _intAreaOptions = []; // Changed to List<IntSiteOption>
  bool _isLoadingUnitNo = false;

  final List<String> ConstructionOptions = ['none', 'G', 'G+1', 'G+1/2', 'G+2'];

  final TextEditingController _mobileNoController = TextEditingController();
  final TextEditingController _partyNameController = TextEditingController();
  final TextEditingController _houseNoController = TextEditingController();
  final TextEditingController _societyController = TextEditingController();
  final TextEditingController _landMarkController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
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
  String? _selectedIntsiteId;
  String? _selectedTokenBy;
  String? _selectedHastakSource;
  String? _selectedManager;
  String? _selectedStaff;
  String? _selectedChannelPartner;
  String? _selectedCustomer;

  bool isLoadingDropdown = false;
  IntSiteOption? _selectedIntSite;
  String? _selectedUnitNo;
  String? _selectedSize;
  IntSiteOption? _selectedIntArea; // Changed to IntSiteOption?
  List<IntSiteOption> _intSiteOptions = [];
  List<String> _unitNoOptions = [];
  List<String> _sizeOptions = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = Provider.of<UserProvider>(context, listen: false);

      if (widget.inquiryId != null) {
        provider.fetchBookingData(widget.inquiryId!);
        provider.fetchVisitData(widget.inquiryId!).then((_) {
          _populateVisitData(provider);
        });
      }

      setState(() {
        if (provider.bookingData != null && provider.bookingData!.data.isNotEmpty) {
          final booking = provider.bookingData!.data[0];
          _houseNoController.text = booking.houseno;
          _societyController.text = booking.society;
          // _selectedIntArea = booking.area as ?; // Assuming this is the ID or value from booking data

          _cityController.text = booking.city;
        }
      });

      provider.fetchAddLeadData().then((_) {
        if (provider.dropdownData != null) {
          setState(() {
            final dropdownData = provider.dropdownData!;
            final inquiry = provider.visitData?.inquiries;

            _intSiteOptions = dropdownData.intSite.isNotEmpty
                ? dropdownData.intSite
                .map((site) => IntSiteOption(id: site.id, name: site.productName.trim()))
                .toList()
                : [IntSiteOption(id: "0", name: "Default Site")];
            _selectedIntSite = inquiry != null && inquiry.intrestedProduct.isNotEmpty
                ? _intSiteOptions.firstWhere(
                    (option) => option.id == inquiry.intrestedProduct,
                orElse: () => _intSiteOptions.first)
                : _intSiteOptions.isNotEmpty
                ? _intSiteOptions.first
                : null;

            // Fetch Int Area options from area_city_country
            _intAreaOptions = dropdownData.areaCityCountry.isNotEmpty
                ? dropdownData.areaCityCountry
                .map((area) => IntSiteOption(id: area.id, name: area.area.trim()))
                .toList()
                : [IntSiteOption(id: "0", name: "Default Area")];

            // Set selected Int Area from booking data if available
            if (provider.bookingData != null && provider.bookingData!.data.isNotEmpty) {
              final booking = provider.bookingData!.data[0];
              _selectedIntArea = _intAreaOptions.firstWhere(
                    (option) => option.id == booking.area,
                orElse: () => _intAreaOptions.first,
              );
            }

            if (_selectedIntSite != null && widget.inquiryId != null) {
              String intrestedProduct = inquiry != null && inquiry.intrestedProduct.isNotEmpty
                  ? inquiry.intrestedProduct
                  : _selectedIntSite!.id;
              provider.fetchUnitNumbers(intrestedProduct).then((_) => _updateUnitNoAndSize(provider));
            }

            print("Int Area Options: $_intAreaOptions");
            print("Selected Int Area: $_selectedIntArea");
          });
        } else {
          setState(() {
            _intSiteOptions = [IntSiteOption(id: "0", name: "Default Site")];
            _selectedIntSite = _intSiteOptions.first;
            _intAreaOptions = [IntSiteOption(id: "0", name: "Default Area")];
            _selectedIntArea = _intAreaOptions.first;
          });
        }
      }).catchError((e) {
        print('Error fetching dropdown data: $e');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load dropdown data: $e')));
        setState(() {
          _intSiteOptions = [IntSiteOption(id: "0", name: "Default Site")];
          _selectedIntSite = _intSiteOptions.first;
          _intAreaOptions = [IntSiteOption(id: "0", name: "Default Area")];
          _selectedIntArea = _intAreaOptions.first;
        });
      });

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

  void _updateUnitNoAndSize(UserProvider provider) {
    setState(() {
      _unitNoOptions = provider.unitNoData?.unitNo
          .map((unit) => unit.unitNo.trim())
          .toSet()
          .toList() ??
          ['No Units Available'];
      _selectedUnitNo = _unitNoOptions.isNotEmpty ? _unitNoOptions.first : null;

      _sizeOptions = provider.unitNoData?.unitNo
          .map((unit) => unit.propertySize.trim())
          .where((size) => size.isNotEmpty)
          .toSet()
          .toList() ??
          ['No Size Available'];
      _selectedSize = _sizeOptions.isNotEmpty ? _sizeOptions.first : null;

      print("Updated UnitNo Options: $_unitNoOptions");
      print("Updated Size Options: $_sizeOptions");
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
      final inquiries = provider.visitData!.inquiries;
      setState(() {
        _mobileNoController.text = inquiries.mobileno;
        _partyNameController.text = inquiries.fullName;
      });
    }
  }

  Future<void> _submitForm() async {
    print('Starting form submission...');

    if (_mobileNoController.text.isEmpty ||
        _partyNameController.text.isEmpty ||
        _houseNoController.text.isEmpty ||
        _societyController.text.isEmpty ||
          // _selectedAreaId == null ||
        _landMarkController.text.isEmpty ||
        _cityController.text.isEmpty ||
        _pincodeController.text.isEmpty ||
            // _selectedIntsiteId == null ||
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

    String areaId = _selectedAreaId ?? '0';
    String? managerId =
    _selectedManager != null ? _selectedManager!.split('(').last.replaceAll(')', '').trim() : '';
    String? staffId =
    _selectedStaff != null ? _selectedStaff!.split('(').last.replaceAll(')', '').trim() : '';
    String? channelPartnerId = _selectedChannelPartner != null
        ? _selectedChannelPartner!.split('(').last.replaceAll(')', '').trim()
        : '';
    String? customerId =
    _selectedCustomer != null ? _selectedCustomer!.split('(').last.replaceAll(')', '').trim() : '';

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
      "product_name": _selectedIntSite?.id ?? "",
      "unitno": _selectedUnitNo ?? "0",
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
      "unitsize": _selectedSize ?? "",
      "construction": selectedConstruction ?? "",
      "price": double.tryParse(_priceController.text) ?? 0,
      "extra_work": double.tryParse(_extraWorkController.text) ?? 0,
      "total_price": double.tryParse(_totalPriceController.text) ?? 0,
      "discount_price": double.tryParse(_discountController.text) ?? 0,
      "switcher_amount": isLoanSelected ? "loan" : "cash",
      "loan_amount": isLoanSelected ? (double.tryParse(_loanAmountController.text) ?? 0).toString() : "",
      "int_area": _selectedIntArea?.id ?? "", // Add selected int area to request body
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
        Navigator.pop(context, true);
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
        _amountError = 'Amount exceeds total by ${remaining.abs().toStringAsFixed(2)}';
        _isPaymentValid = false;
      } else if (remaining == 0) {
        _amountError = null;
        _isPaymentValid = true;
      } else {
        _amountError = 'Remaining amount: ${remaining.toStringAsFixed(2)}';
        _isPaymentValid = false;
      }
    });
  }

  String _numberToWords(double number) {
    if (number == 0) return "Zero";
    final units = [
      '',
      'One',
      'Two',
      'Three',
      'Four',
      'Five',
      'Six',
      'Seven',
      'Eight',
      'Nine',
      'Ten',
      'Eleven',
      'Twelve',
      'Thirteen',
      'Fourteen',
      'Fifteen',
      'Sixteen',
      'Seventeen',
      'Eighteen',
      'Nineteen'
    ];
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
    final units = [
      '',
      'One',
      'Two',
      'Three',
      'Four',
      'Five',
      'Six',
      'Seven',
      'Eight',
      'Nine',
      'Ten',
      'Eleven',
      'Twelve',
      'Thirteen',
      'Fourteen',
      'Fifteen',
      'Sixteen',
      'Seventeen',
      'Eighteen',
      'Nineteen'
    ];
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
          onPressed: () => Navigator.pop(context, true),
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
    final areaItems = provider.bookingData?.data
        .map((datum) => "${datum.area} (${datum.area})")
        .toSet()
        .toList() ??
        ['Area 1 (1)', 'Area 2 (2)', 'Area 3 (3)'];
    if (_selectedAreaId != null && !areaItems.contains(_selectedAreaId)) {
      _selectedAreaId = null;
    }

    List<DropdownMenuItem<IntSiteOption>> intAreaItems = _intAreaOptions
        .map((option) => DropdownMenuItem<IntSiteOption>(
      value: option,
      child: Text(option.name, style: TextStyle(fontFamily: "poppins_thin")),
    ))
        .toList();

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

                        // _buildDropdown2(label: "Int Area*", items: intAreaItems, selectedValue: _selectedIntArea, onChanged: (value) => setState(() => _selectedIntArea = value)),

                        _buildDropdown<IntSiteOption>(

                          "Area*",
                          items: intAreaItems,
                          value: _selectedIntArea,
                          onChanged: (value) => setState(() => _selectedIntArea = value),
                          required: true,
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
    List<DropdownMenuItem<IntSiteOption>> intSiteItems = _intSiteOptions
        .map((option) => DropdownMenuItem<IntSiteOption>(
      value: option,
      child: Text(option.name, style: TextStyle(fontFamily: "poppins_thin")),
    ))
        .toList();

    List<DropdownMenuItem<String>> unitNoItems = _unitNoOptions
        .map((unit) => DropdownMenuItem<String>(
      value: unit,
      child: Text(unit, style: TextStyle(fontFamily: "poppins_thin")),
    ))
        .toList();

    List<DropdownMenuItem<String>> sizeItems = _sizeOptions
        .map((size) => DropdownMenuItem<String>(
      value: size,
      child: Text(size, style: TextStyle(fontFamily: "poppins_thin")),
    ))
        .toList();

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
                        _buildDropdown<IntSiteOption>(
                          "Int Site*",
                          items: intSiteItems,
                          value: _selectedIntSite,
                          onChanged: (value) async {
                            if (value != null) {
                              setState(() => isLoadingDropdown = true);
                              try {
                                _selectedIntSite = value;
                                await provider.fetchUnitNumbers(value.id);
                                _updateUnitNoAndSize(provider);
                              } finally {
                                setState(() => isLoadingDropdown = false);
                              }
                            }
                          },
                          required: true,
                        ),
                        if (isLoadingDropdown) ...[
                          const SizedBox(width: 10),
                          const SizedBox(
                            height: 20,
                            width: 20,
                            child: Center(child: CircularProgressIndicator(strokeWidth: 2, color: Colors.deepPurple)),
                          ),
                        ],
                        _buildDropdown<String>(
                          "Unit No",
                          items: unitNoItems,
                          value: _selectedUnitNo,
                          onChanged: (value) => setState(() => _selectedUnitNo = value),
                        ),
                        _buildDropdown<String>(
                          "Size",
                          items: sizeItems,
                          value: _selectedSize,
                          onChanged: (value) => setState(() => _selectedSize = value),
                        ),
                        _buildDropdown2(
                          label: "Select Construction",
                          items: ConstructionOptions,
                          selectedValue: selectedConstruction,
                          onChanged: (value) => setState(() => selectedConstruction = value),
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
                          _buildTextField('Remaining Total Amount',
                              controller: _remainingTotalAmountController, readOnly: true),
                          if (_amountError != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                _amountError!,
                                style: TextStyle(color: Colors.red, fontFamily: "poppins_thin"),
                              ),
                            ),
                          _buildTextField('Total Amount of Purchase',
                              controller: _totalAmountOfPurchaseController, readOnly: true),
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
                          _buildTextField('Remaining Total Amount',
                              controller: _remainingTotalAmountController, readOnly: true),
                          if (_amountError != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                _amountError!,
                                style: TextStyle(color: Colors.red, fontFamily: "poppins_thin"),
                              ),
                            ),
                          _buildTextField('Total Amount of Purchase',
                              controller: _totalAmountOfPurchaseController, readOnly: true),
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
    final managerItems = provider.bookingData?.manager.map((m) => "${m.firstname} (${m.id})").toList() ??
        ['Select Manager'];
    final staffItems =
        provider.bookingData?.staff.map((s) => "${s.firstname} (${s.id})").toList() ?? ['Select Staff'];
    final channelPartnerItems = provider.bookingData?.channelPartner
        .map((cp) => "${cp.brokername} (${cp.id})")
        .toList() ??
        ['Select Channel Partner'];
    final customerItems =
        provider.bookingData?.customer.map((c) => "${c.name} (${c.id})").toList() ?? ['Select Customer'];

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
                        _buildTextField('Token Amount in Words',
                            controller: _tokenAmountInWordsController, readOnly: true),
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
      {TextEditingController? controller,
        String? prefix,
        bool readOnly = false,
        int maxLines = 1}) {
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
          keyboardType: (label.contains('Amount') && !label.contains('Words')) ||
              label.contains('Price') ||
              label.contains('Discount') ||
              label.contains('House No.') ||
              label.contains('Pincode')
              ? TextInputType.numberWithOptions(decimal: true)
              : TextInputType.text,
          inputFormatters: (label.contains('Amount') && !label.contains('Words')) ||
              label.contains('Price') ||
              label.contains('Discount') ||
              label.contains('House No.') ||
              label.contains('Pincode')
              ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))]
              : null,
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
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey)),
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
            items: items
                .map((String item) => DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: TextStyle(fontSize: 16, fontFamily: "poppins_thin")),
            ))
                .toList(),
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

  Widget _buildDropdown<T>(
      String label, {
        required List<DropdownMenuItem<T>> items,
        required T? value,
        required ValueChanged<T?> onChanged,
        bool required = false,
      }) {
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
            hint: Text("Select $label",
                style: TextStyle(fontFamily: "poppins_thin", fontSize: 16, color: Colors.grey)),
            value: value,
            items: items,
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
}
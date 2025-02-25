import 'package:flutter/material.dart';
import 'package:hr_app/Inquiry_Management/Utils/Colors/app_Colors.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:dropdown_button2/dropdown_button2.dart'; // Import the new package

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Form data variables
  DateTime? nextFollowUp;
  bool isLoanSelected = true;
  bool isIncludeSelected = true;
  List<Map<String, TextEditingController>> cashFields = [];
  List<Map<String, TextEditingController>> loanFields = [];
  bool _isPaymentValid = false;
  String? _amountError;

  // Text Editing Controllers
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _followUpDateController = TextEditingController();
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
  final TextEditingController _afterVisitStatus = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _contactPersonController = TextEditingController();
  final TextEditingController _tokenAmountController = TextEditingController();
  final TextEditingController _tokenAmountInWordsController = TextEditingController();
  final TextEditingController _tokenDateController = TextEditingController();
  final TextEditingController _bookingDateController = TextEditingController(); // New controller for booking date
  final TextEditingController _hastakController = TextEditingController(); // New controller for hastak

  // Dropdown values
  String? _selectedArea;
  String? _selectedPropertySubType;
  String? _selectedPurposeOfBuying;
  String? _selectedApproxBuyingTime;
  String? _selectedTime;
  String? _selectedStatus;
  String? _selectedTokenBy;
  String? _selectedHastakSource;

  @override
  void initState() {
    super.initState();
    _addCashField();
    _addLoanField();
    _selectedHastakSource = 'Walk In';

    // Set today's date as default for booking date
    _bookingDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());

    _priceController.addListener(_updatePrices);
    _extraWorkController.addListener(_updatePrices);
    _extraExpenseController.addListener(_updatePrices);
    _discountController.addListener(_updatePrices);
    _loanAmountController.addListener(_updateRemainingAmount);
    _amountController.addListener(_updateRemainingAmount);
    _tokenAmountController.addListener(_updateTokenAmountInWords);

    _updatePrices();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _dateController.dispose();
    _followUpDateController.dispose();
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
    _afterVisitStatus.dispose();
    _notesController.dispose();
    _contactPersonController.dispose();
    _tokenAmountController.dispose();
    _tokenAmountInWordsController.dispose();
    _tokenDateController.dispose();
    _bookingDateController.dispose(); // Dispose new controller
    _hastakController.dispose(); // Dispose new controller

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
      totalPaid = loanFields.fold(0, (sum, field) =>
      sum + (double.tryParse(field['amount']!.text) ?? 0));
      totalPaid += double.tryParse(_loanAmountController.text) ?? 0;
    } else {
      totalPaid = cashFields.fold(0, (sum, field) =>
      sum + (double.tryParse(field['amount']!.text) ?? 0));
      totalPaid += double.tryParse(_amountController.text) ?? 0;
    }

    double remaining = finalPrice - totalPaid;

    _remainingTotalAmountController.text = remaining.toStringAsFixed(2);

    setState(() {
      if (remaining < 0) {
        _remainingTotalAmountController.text = '0.00';
        _amountError = 'Amount is not equal to 0 amount is :- ${remaining.abs().toStringAsFixed(2)} extra';
        _isPaymentValid = false;
      } else if (remaining == 0) {
        _amountError = null;
        _isPaymentValid = true;
      } else {
        _amountError = 'Amount is not equal to 0 amount is : ${remaining.toStringAsFixed(2)}';
        _isPaymentValid = false;
      }
    });
  }

  String _numberToWords(double number) {
    if (number == 0) return "Zero";

    final units = [
      '', 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine',
      'Ten', 'Eleven', 'Twelve', 'Thirteen', 'Fourteen', 'Fifteen', 'Sixteen',
      'Seventeen', 'Eighteen', 'Nineteen'
    ];
    final tens = [
      '', '', 'Twenty', 'Thirty', 'Forty', 'Fifty', 'Sixty', 'Seventy', 'Eighty', 'Ninety'
    ];

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
      '', 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine',
      'Ten', 'Eleven', 'Twelve', 'Thirteen', 'Fourteen', 'Fifteen', 'Sixteen',
      'Seventeen', 'Eighteen', 'Nineteen'
    ];
    final tens = [
      '', '', 'Twenty', 'Thirty', 'Forty', 'Fifty', 'Sixty', 'Seventy', 'Eighty', 'Ninety'
    ];

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

  void _submitForm() {
    final formData = {
      'mobileNo': _mobileNoController.text,
      'partyName': _partyNameController.text,
      'houseNo': _houseNoController.text,
      'society': _societyController.text,
      'area': _selectedArea,
      'landMark': _landMarkController.text,
      'city': _cityController.text,
      'pincode': _pincodeController.text,
      'intArea': _intAreaController.text,
      'propertySubType': _selectedPropertySubType,
      'propertyType': _propertyTypeController.text,
      'budget': _budgetController.text,
      'purposeOfBuying': _selectedPurposeOfBuying,
      'approxBuyingTime': _selectedApproxBuyingTime,
      'expensesIncluded': isIncludeSelected,
      'price': _priceController.text,
      'extraWork': _extraWorkController.text,
      'extraExpense': _extraExpenseController.text,
      'totalPrice': _totalPriceController.text,
      'discount': _discountController.text,
      'finalPrice': _finalPriceController.text,
      'followUpDate': _followUpDateController.text,
      'selectedTime': _selectedTime,
      'paymentCondition': isLoanSelected ? 'Loan' : 'Cash',
      'remainingTotalAmount': _remainingTotalAmountController.text,
      'totalAmountOfPurchase': _totalAmountOfPurchaseController.text,
      'afterVisitStatus': _afterVisitStatus.text,
      'amount': _amountController.text,
      'loanAmount': _loanAmountController.text,
      'notes': _notesController.text,
      'contactPerson': _contactPersonController.text,
      'status': _selectedStatus,
      'tokenAmount': _tokenAmountController.text,
      'tokenAmountInWords': _tokenAmountInWordsController.text,
      'tokenDate': _tokenDateController.text,
      'tokenBy': _selectedTokenBy,
      'bookingDate': _bookingDateController.text,
      'hastak': _hastakController.text,
      'hastakSource': _selectedHastakSource,
    };

    if (!isLoanSelected) {
      for (int i = 0; i < cashFields.length; i++) {
        formData['cashAmount_$i'] = cashFields[i]['amount']?.text;
        formData['cashDate_$i'] = cashFields[i]['date']?.text;
        formData['cashDuration_$i'] = cashFields[i]['duration']?.text;
      }
    }
    if (isLoanSelected) {
      for (int i = 0; i < loanFields.length; i++) {
        formData['loanAmount_$i'] = loanFields[i]['amount']?.text;
        formData['loanDate_$i'] = loanFields[i]['date']?.text;
        formData['loanDuration_$i'] = loanFields[i]['duration']?.text;
      }
    }

    print('Form Data: $formData');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Form submitted successfully!')),
    );
    Navigator.pop(context);
  }

  void _addCashField() {
    TextEditingController amountController = TextEditingController()..addListener(_updateRemainingAmount);
    TextEditingController dateController = TextEditingController();
    TextEditingController durationController = TextEditingController();

    setState(() {
      cashFields.add({
        'amount': amountController,
        'date': dateController,
        'duration': durationController,
      });
    });
  }

  void _addLoanField() {
    TextEditingController amountController = TextEditingController()..addListener(_updateRemainingAmount);
    TextEditingController dateController = TextEditingController();
    TextEditingController durationController = TextEditingController();

    setState(() {
      loanFields.add({
        'amount': amountController,
        'date': dateController,
        'duration': durationController,
      });
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
        title: Text('Add Lead', style: TextStyle(fontFamily: "poppins_thin", color: Colors.white)),
        backgroundColor: AppColor.Buttoncolor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            _buildCustomerInformationPage(),
            _buildInterestSuggestionPage(),
            _buildAdditionalPage(),
            _buildFollowUpPage(),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerInformationPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Text('Customer Information', style: TextStyle(fontSize: 20, fontFamily: "poppins_thin")),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        _buildTextField('Mobile No.', controller: _mobileNoController, prefix: '+91'),
                        _buildTextField('Party Name', controller: _partyNameController),
                        _buildTextField('House No.', controller: _houseNoController),
                        _buildTextField('Society', controller: _societyController),
                        _buildDropdown2("Area",
                            items: ['Area 1', 'Area 2', 'Area 3'],
                            onChanged: (value) => setState(() => _selectedArea = value)),
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

  Widget _buildInterestSuggestionPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Text('Project Details', style: TextStyle(fontSize: 20, fontFamily: "poppins_thin")),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTextField('Int Area*', controller: _intAreaController),
                        _buildDropdown2('Property Sub Type*',
                            items: ['Type 1', 'Type 2', 'Type 3'],
                            onChanged: (value) => setState(() => _selectedPropertySubType = value)),
                        _buildTextField('Property Type*', controller: _propertyTypeController),
                        _buildTextField('Budget*', controller: _budgetController),
                        _buildDropdown2('Purpose of Buying*',
                            items: ['Purpose 1', 'Purpose 2', 'Purpose 3'],
                            onChanged: (value) => setState(() => _selectedPurposeOfBuying = value)),
                        _buildDropdown2('Approx Buying Time*',
                            items: ['Time 1', 'Time 2', 'Time 3'],
                            onChanged: (value) => setState(() => _selectedApproxBuyingTime = value)),
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
                Text('Payment Condition', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Card(
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

  Widget _buildFollowUpPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Text('Token Payment Status', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        _buildTextField(
                          'Token Amount',
                          controller: _tokenAmountController,
                        ),
                        _buildTextField(
                          'Token Amount in Words',
                          controller: _tokenAmountInWordsController,
                          readOnly: true,
                        ),
                        _buildDatePickerField('Token Amount Date', controller: _tokenDateController),
                        _buildDropdown2(
                          'Token By',
                          items: ['Cash', 'Cheque', 'Transfer'],
                          onChanged: (value) => setState(() => _selectedTokenBy = value),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text('Booking Date', style: TextStyle(fontSize: 18, fontFamily: "poppins_thin")),// Spacing between cards
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
                          'Manager',
                          items: ['Select Manager', 'Manager 1', 'Manager 2', 'Manager 3'], // Add your manager list here
                          onChanged: (value) => setState(() {}), // You can add logic here if needed
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
                            'Staff Select',
                            items: ['Select Staff', 'Staff 1', 'Staff 2', 'Staff 3'], // Add your staff list here
                            onChanged: (value) => setState(() {}), // You can add logic here if needed
                          ),
                        if (_selectedHastakSource == 'Channel Partner')
                          _buildDropdown2(
                            'Channel Partner Select',
                            items: ['Select Channel Partner', 'Partner 1', 'Partner 2', 'Partner 3'], // Add your channel partner list here
                            onChanged: (value) => setState(() {}), // You can add logic here if needed
                          ),
                        if (_selectedHastakSource == 'Customer')
                          _buildDropdown2(
                            'Customer Select',
                            items: ['Select Customer', 'Customer 1', 'Customer 2', 'Customer 3'], // Add your customer list here
                            onChanged: (value) => setState(() {}), // You can add logic here if needed
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
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontFamily: "poppins_thin"),
          prefixText: prefix != null ? '$prefix ' : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        keyboardType: (label.contains('Amount') && !label.contains('Words')) || label.contains('Price') || label.contains('Discount')
            ? TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
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
            controller!.text = DateFormat('yyyy-MM-dd').format(picked);
          }
        },
      ),
    );
  }

  // New method for DropdownButton2
  Widget _buildDropdown2(String label,
      {required List<String> items, required Function(String?) onChanged}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width , // 40% of screen width (adjust as needed)
        ),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey.shade100,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 4,
              spreadRadius: 2,
            ),
          ],
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            hint: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontFamily: "poppins_thin",
              ),
            ),
            items: items.map((String item) => DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "poppins_thin",
                ),
              ),
            )).toList(),
            value: items.contains(_selectedArea) ? _selectedArea :
            items.contains(_selectedPropertySubType) ? _selectedPropertySubType :
            items.contains(_selectedPurposeOfBuying) ? _selectedPurposeOfBuying :
            items.contains(_selectedApproxBuyingTime) ? _selectedApproxBuyingTime :
            items.contains(_selectedTime) ? _selectedTime :
            items.contains(_selectedStatus) ? _selectedStatus :
            items.contains(_selectedTokenBy) ? _selectedTokenBy :
            null,
            onChanged: (value) => onChanged(value),
            buttonStyleData: ButtonStyleData(
              height: 40,
              padding: const EdgeInsets.only(left: 14, right: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            iconStyleData: const IconStyleData(
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 24,
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 200,
              padding: null,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              elevation: 8,
              offset: const Offset(0, -4),
              scrollbarTheme: ScrollbarThemeData(
                radius: const Radius.circular(40),
                thickness: MaterialStateProperty.all<double>(6),
                thumbVisibility: MaterialStateProperty.all<bool>(true),
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 40,
              padding: EdgeInsets.only(left: 14, right: 14),
            ),
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
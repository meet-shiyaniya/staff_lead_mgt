import 'package:flutter/material.dart';
import 'package:hr_app/Inquiry_Management/Utils/Colors/app_Colors.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';

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
  List<Map<String, dynamic>> cashFields = [];
  List<Map<String, dynamic>> loanFields = []; // New list for loan fields

  // Text Editing Controllers (Initialize all required controllers)
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
  // Dropdown values
  String? _selectedArea;
  String? _selectedPropertySubType;
  String? _selectedPurposeOfBuying;
  String? _selectedApproxBuyingTime;
  String? _selectedCashPaymentCondition;
  String? _selectedAfterVisit;
  String? _selectedTime;

  @override
  void initState() {
    super.initState();
    // Initialize with one Cash field by default
    cashFields.add({
      'amount': TextEditingController(),
      'date': TextEditingController(),
      'duration': TextEditingController(),
    });

    // Initialize with one Loan field by default
    loanFields.add({
      'amount': TextEditingController(),
      'date': TextEditingController(),
      'duration': TextEditingController(),
    });
  }

  @override
  void dispose() {
    // Dispose of all controllers to prevent memory leaks
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

    for (var field in cashFields) {
      field['amount'].dispose();
      field['date'].dispose();
      field['duration'].dispose();
    }

    // Dispose loan field controllers
    for (var field in loanFields) {
      field['amount'].dispose();
      field['date'].dispose();
      field['duration'].dispose();
    }

    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
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
    // Gather all form data
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
    };

    if (!isLoanSelected) {
      // Add cash fields data
      for (int i = 0; i < cashFields.length; i++) {
        formData['cashAmount_$i'] = cashFields[i]['amount'].text;
        formData['cashDate_$i'] = cashFields[i]['date'].text;
        formData['cashDuration_$i'] = cashFields[i]['duration'].text;
      }
    }
    if (isLoanSelected) {
      // Add loan fields data
      for (int i = 0; i < loanFields.length; i++) {
        formData['loanAmount_$i'] = loanFields[i]['amount'].text;
        formData['loanDate_$i'] = loanFields[i]['date'].text;
        formData['loanDuration_$i'] = loanFields[i]['duration'].text;
      }
    }

    // Print or send the form data
    print('Form Data: $formData');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Form submitted successfully!')),
    );
  }

  void _addCashField() {
    setState(() {
      cashFields.add({
        'amount': TextEditingController(),
        'date': TextEditingController(),
        'duration': TextEditingController(),
      });
    });
  }

  void _addLoanField() {
    setState(() {
      loanFields.add({
        'amount': TextEditingController(),
        'date': TextEditingController(),
        'duration': TextEditingController(),
      });
    });
  }

  void _removeCashField(int index) {
    setState(() {
      // Dispose the controllers when removing
      cashFields[index]['amount'].dispose();
      cashFields[index]['date'].dispose();
      cashFields[index]['duration'].dispose();
      cashFields.removeAt(index);
    });
  }

  void _removeLoanField(int index) {
    setState(() {
      // Dispose the controllers when removing
      loanFields[index]['amount'].dispose();
      loanFields[index]['date'].dispose();
      loanFields[index]['duration'].dispose();
      loanFields.removeAt(index);
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
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          _buildCustomerInformationPage(),
          _buildInterestSuggestionPage(),
          _buildAdditionalPage(),
        ],
      ),
    );
  }

  Widget _buildCustomerInformationPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
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
                    _buildDropdown("Area",
                        items: ['Area 1', 'Area 2', 'Area 3'], onChanged: (value) => _selectedArea = value),
                    _buildTextField('Land Mark', controller: _landMarkController),
                    _buildTextField('City', controller: _cityController),
                    _buildTextField('Pincode', controller: _pincodeController),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildNextButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildInterestSuggestionPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
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
                  _buildDropdown('Property Sub Type*', items: ['Type 1', 'Type 2', 'Type 3'],
                      onChanged: (value) => _selectedPropertySubType = value),
                  _buildTextField('Property Type*', controller: _propertyTypeController),
                  _buildTextField('Budget*', controller: _budgetController),
                  _buildDropdown('Purpose of Buying*', items: ['Purpose 1', 'Purpose 2', 'Purpose 3'],
                      onChanged: (value) => _selectedPurposeOfBuying = value),
                  _buildDropdown('Approx Buying Time*', items: ['Time 1', 'Time 2', 'Time 3'],
                      onChanged: (value) => _selectedApproxBuyingTime = value),
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
                        });
                      },
                    ),
                  ),
                  if (isIncludeSelected) ...[
                    _buildTextField('Price*', controller: _priceController),
                    _buildTextField('Extra Work*', controller: _extraWorkController),
                    _buildTextField('Extra Expense*', controller: _extraExpenseController),
                    _buildTextField("Total Price", controller: _totalPriceController),
                    _buildTextField("Discount", controller: _discountController),
                    _buildTextField("Final Price", controller: _finalPriceController),
                  ] else ...[
                    _buildTextField('Price*', controller: _priceController),
                    _buildDropdown('Cash Payment Condition', items: ['Condition 1', 'Condition 2', 'Condition 3'],
                        onChanged: (value) => _selectedCashPaymentCondition = value),
                    _buildDropdown('Apx Time', items: ['Time 1', 'Time 2', 'Time 3'], onChanged: (value) => null),
                    _buildTextField('After Visit Status*', controller: _afterVisitStatus),
                    _buildDatePickerField('Next FollowupDate*', controller: _followUpDateController),
                    _buildDropdown('Select Time*', items: ['Time 1', 'Time 2', 'Time 3'],
                        onChanged: (value) => _selectedTime = value),
                  ],
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove_circle, color: Colors.red),
                                onPressed: () => _removeLoanField(i),
                              ),
                            ],
                          ),
                          _buildTextField('Loan Amount', controller: _remainingTotalAmountController),
                          _buildTextField('Remaining Total Amount', controller: _remainingTotalAmountController),
                          _buildTextField('Total Amount of Purchase', controller: _totalAmountOfPurchaseController),

                        ],
                      ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: Icon(Icons.add_circle, color: Colors.green),
                        onPressed: _addLoanField,
                      ),
                    ),
                  ] else ...[
                    for (int i = 0; i < cashFields.length; i++)
                      Column(
                        children: [
                          _buildTextField('Amount', controller: cashFields[i]['amount']),
                          _buildDatePickerField('Date', controller: cashFields[i]['date']),
                          _buildTextField('Duration (in days)', controller: cashFields[i]['duration']),
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
                    _buildTextField('Remaining Total Amount', controller: _remainingTotalAmountController),
                    _buildTextField('Total Amount of Purchase', controller: _totalAmountOfPurchaseController),
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

  Widget _buildTextField(String label, {TextEditingController? controller, String? prefix}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontFamily: "poppins_thin"),
          prefixText: prefix != null ? '$prefix ' : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _buildDatePickerField(String label, {TextEditingController? controller}) {
    controller ??= TextEditingController();
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

  Widget _buildDropdown(String label, {required List<String> items, required Function(String?) onChanged}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontFamily: "poppins_thin", color: Colors.black),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        items: items.map((option) => DropdownMenuItem(value: option, child: Text(option))).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildToggleSwitch({
    required List<String> labels,
    required int initialIndex,
    required Function(int?) onToggle,
    double minWidth = 90.0, // Set default width
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
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

  Widget _buildNextButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: ElevatedButton(
        onPressed: _nextPage,
        child: Text('Next', style: TextStyle(fontFamily: "poppins_thin", color: Colors.white)),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.deepPurple.shade300,
        ),
      ),
    );
  }
}
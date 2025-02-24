import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: AddBookingScreen(),
  ));
}

class AddBookingScreen extends StatefulWidget {
  @override
  _AddBookingScreenState createState() => _AddBookingScreenState();
}

class _AddBookingScreenState extends State<AddBookingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  // Data to be collected
  Map<String, dynamic> _formData = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add New Booking')),
      body: Column(
        children: [
          // Progress Indicator (customize this)
          LinearProgressIndicator(
            value: (_currentPage + 1) / 5, // 5 steps total
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(), // Disable swipe
              children: [
                BookingInfoStep(onDataChanged: _updateFormData),
                ProjectDetailsStep(onDataChanged: _updateFormData),
                PricingExpensesStep(onDataChanged: _updateFormData),
                PaymentDetailsStep(onDataChanged: _updateFormData),
                ConfirmationStep(formData: _formData),
              ],
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: _currentPage > 0 ? () {
                  _pageController.previousPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                } : null, // Disable if on the first page
                child: Text('Back'),
              ),
              ElevatedButton(
                onPressed: _currentPage < 4
                    ? () {
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
                    : _submitForm, // Submit on the last page
                child: Text(_currentPage < 4 ? 'Next' : 'Submit'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _updateFormData(Map<String, dynamic> newData) {
    setState(() {
      _formData.addAll(newData);
    });
  }

  void _submitForm() {
    // Validate form data
    // Send to API/Database
    print('Form Data: $_formData');
    // Optionally navigate to a success screen
  }
}

// --- Step Widgets ---

class BookingInfoStep extends StatefulWidget {
  final Function(Map<String, dynamic>) onDataChanged;
  const BookingInfoStep({Key? key, required this.onDataChanged}) : super(key: key);

  @override
  State<BookingInfoStep> createState() => _BookingInfoStepState();
}

class _BookingInfoStepState extends State<BookingInfoStep> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _partyMobileController = TextEditingController();
  final TextEditingController _partyNameController = TextEditingController();
  final TextEditingController _houseNoController = TextEditingController();
  final TextEditingController _societyController = TextEditingController();
  final TextEditingController _landMarkController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  String _selectedArea = "Purani Haveli";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _partyMobileController,
              decoration: InputDecoration(labelText: 'Party Mobile No*'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter party mobile number';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _partyNameController,
              decoration: InputDecoration(labelText: 'Party Name*'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter party name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _houseNoController,
              decoration: InputDecoration(labelText: 'House No*'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter house number';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _societyController,
              decoration: InputDecoration(labelText: 'Society*'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter society';
                }
                return null;
              },
            ),
            DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Area*'),
                value: _selectedArea,
                items: const [
                  DropdownMenuItem(
                    value: "Purani Haveli",
                    child: Text("Purani Haveli"),
                  ),
                  DropdownMenuItem(
                    value: "Some Area",
                    child: Text("Some Area"),
                  )
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedArea = value!;
                  });
                }),
            TextFormField(
              controller: _landMarkController,
              decoration: InputDecoration(labelText: 'Land Mark'),
            ),
            TextFormField(
              controller: _cityController,
              decoration: InputDecoration(labelText: 'City*'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter city';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _pincodeController,
              decoration: InputDecoration(labelText: 'Pincode*'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter pincode';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Save the data to the form
                  Map<String, dynamic> data = {
                    'partyMobile': _partyMobileController.text,
                    'partyName': _partyNameController.text,
                    'houseNo': _houseNoController.text,
                    'society': _societyController.text,
                    'area': _selectedArea,
                    'landMark': _landMarkController.text,
                    'city': _cityController.text,
                    'pincode': _pincodeController.text,
                  };
                  widget.onDataChanged(data);
                }
              },
              child: Text("Submit Booking Information"),
            )
          ],
        ),
      ),
    );
  }
}

class ProjectDetailsStep extends StatefulWidget {
  final Function(Map<String, dynamic>) onDataChanged;

  const ProjectDetailsStep({Key? key, required this.onDataChanged})
      : super(key: key);

  @override
  State<ProjectDetailsStep> createState() => _ProjectDetailsStepState();
}

class _ProjectDetailsStepState extends State<ProjectDetailsStep> {
  String? _selectedProjectName;
  String? _selectedUnitNumber;
  String? _selectedUnitSize;
  String? _selectedConstruction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: 'Project Name*'),
            value: _selectedProjectName,
            items: [
              // Replace with your actual Project Name options
              DropdownMenuItem(value: 'Project A', child: Text('Project A')),
              DropdownMenuItem(value: 'Project B', child: Text('Project B')),
            ],
            onChanged: (value) {
              setState(() {
                _selectedProjectName = value;
              });
              _updateFormData();
            },
            validator: (value) => value == null ? 'Please select project' : null,
          ),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: 'Unit Number*'),
            value: _selectedUnitNumber,
            items: [
              // Replace with your actual Unit Number options
              DropdownMenuItem(value: 'Unit 101', child: Text('Unit 101')),
              DropdownMenuItem(value: 'Unit 102', child: Text('Unit 102')),
            ],
            onChanged: (value) {
              setState(() {
                _selectedUnitNumber = value;
              });
              _updateFormData();
            },
            validator: (value) => value == null ? 'Please select unit number' : null,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Unit Size*'),
            onChanged: (value) {
              setState(() {
                _selectedUnitSize = value;
              });
              _updateFormData();
            },
            validator: (value) =>
            value == null || value.isEmpty ? 'Please enter unit size' : null,
          ),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: 'Construction*'),
            value: _selectedConstruction,
            items: [
              // Replace with your actual Construction options
              DropdownMenuItem(value: 'Under Construction', child: Text('Under Construction')),
              DropdownMenuItem(value: 'Ready to Move', child: Text('Ready to Move')),
            ],
            onChanged: (value) {
              setState(() {
                _selectedConstruction = value;
              });
              _updateFormData();
            },
            validator: (value) => value == null ? 'Please select construction' : null,
          ),
        ],
      ),
    );
  }

  void _updateFormData() {
    final data = <String, dynamic>{
      'projectName': _selectedProjectName,
      'unitNumber': _selectedUnitNumber,
      'unitSize': _selectedUnitSize,
      'construction': _selectedConstruction,
    };
    widget.onDataChanged(data);
  }
}

class PricingExpensesStep extends StatefulWidget {
  final Function(Map<String, dynamic>) onDataChanged;

  const PricingExpensesStep({Key? key, required this.onDataChanged})
      : super(key: key);

  @override
  State<PricingExpensesStep> createState() => _PricingExpensesStepState();
}

class _PricingExpensesStepState extends State<PricingExpensesStep> {
  bool _includeExpenses = true;  // Initial state
  TextEditingController _priceController = TextEditingController();
  TextEditingController _extraWorkController = TextEditingController();
  TextEditingController _totalPriceController = TextEditingController();
  TextEditingController _discountController = TextEditingController();
  double _finalPrice = 0.0;  // Initial value, will be calculated

  @override
  void initState() {
    super.initState();
    _priceController.addListener(_calculateFinalPrice);
    _extraWorkController.addListener(_calculateFinalPrice);
    _discountController.addListener(_calculateFinalPrice);
  }

  @override
  void dispose() {
    _priceController.dispose();
    _extraWorkController.dispose();
    _totalPriceController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  void _calculateFinalPrice() {
    double price = double.tryParse(_priceController.text) ?? 0.0;
    double extraWork = double.tryParse(_extraWorkController.text) ?? 0.0;
    double discount = double.tryParse(_discountController.text) ?? 0.0;

    double totalPrice = price + extraWork; // Total price without discount
    double discountedPrice = totalPrice * (1 - discount / 100); // Apply discount

    setState(() {
      _finalPrice = discountedPrice;
      _totalPriceController.text = totalPrice.toStringAsFixed(2); // Update Total Price
    });
    _updateFormData();
  }

  void _updateFormData() {
    final data = <String, dynamic>{
      'includeExpenses': _includeExpenses,
      'price': _priceController.text,
      'extraWork': _extraWorkController.text,
      'totalPrice': _totalPriceController.text,
      'discount': _discountController.text,
      'finalPrice': _finalPrice,
    };
    widget.onDataChanged(data);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Text('Expenses:'),
              SizedBox(width: 10),
              ChoiceChip(
                label: Text('Include'),
                selected: _includeExpenses,
                onSelected: (selected) {
                  setState(() {
                    _includeExpenses = selected;
                  });
                  _updateFormData();
                },
              ),
              SizedBox(width: 10),
              ChoiceChip(
                label: Text('Exclude'),
                selected: !_includeExpenses,
                onSelected: (selected) {
                  setState(() {
                    _includeExpenses = !selected;
                  });
                  _updateFormData();
                },
              ),
            ],
          ),
          TextFormField(
            controller: _priceController,
            decoration: InputDecoration(labelText: 'Price*'),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) {
              _calculateFinalPrice();
            },
          ),
          TextFormField(
            controller: _extraWorkController,
            decoration: InputDecoration(labelText: 'Extra Work*'),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) {
              _calculateFinalPrice();
            },
          ),
          TextFormField(
            controller: _totalPriceController,
            decoration: InputDecoration(labelText: 'Total Price*', enabled: false),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ),
          TextFormField(
            controller: _discountController,
            decoration: InputDecoration(labelText: 'Discount*'),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) {
              _calculateFinalPrice();
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Final Price*', enabled: false),
            controller: TextEditingController(text: _finalPrice.toStringAsFixed(2)), // Display only
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ),
        ],
      ),
    );
  }
}
class PaymentDetailsStep extends StatefulWidget {
  final Function(Map<String, dynamic>) onDataChanged;

  const PaymentDetailsStep({Key? key, required this.onDataChanged})
      : super(key: key);

  @override
  State<PaymentDetailsStep> createState() => _PaymentDetailsStepState();
}

class _PaymentDetailsStepState extends State<PaymentDetailsStep> {
  String _paymentCondition = 'Loan'; // Default selection
  TextEditingController _amountController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _durationController = TextEditingController();
  TextEditingController _loanAmountController = TextEditingController();
  TextEditingController _remainingTotalAmountController = TextEditingController();
  TextEditingController _totalAmountOfPurchaseController = TextEditingController();
  TextEditingController _tokenAmountController = TextEditingController();
  TextEditingController _tokenAmountInWordsController = TextEditingController();
  TextEditingController _tokenAmountDateController = TextEditingController();
  String? _selectedTokenBy;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              ChoiceChip(
                label: Text('Loan'),
                selected: _paymentCondition == 'Loan',
                onSelected: (selected) {
                  setState(() {
                    _paymentCondition = 'Loan';
                  });
                  _updateFormData();
                },
              ),
              SizedBox(width: 10),
              ChoiceChip(
                label: Text('Cash'),
                selected: _paymentCondition == 'Cash',
                onSelected: (selected) {
                  setState(() {
                    _paymentCondition = 'Cash';
                  });
                  _updateFormData();
                },
              ),
            ],
          ),
          if (_paymentCondition == 'Loan') ...[
            // Loan-specific fields
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Amount*'),
            ),
            TextFormField(
              controller: _dateController,
              decoration: InputDecoration(labelText: 'Date*'),
            ),
            TextFormField(
              controller: _durationController,
              decoration: InputDecoration(labelText: 'Duration in days*'),
            ),
            TextFormField(
              controller: _loanAmountController,
              decoration: InputDecoration(labelText: 'Loan Amount*'),
            ),
            TextFormField(
              controller: _remainingTotalAmountController,
              decoration: InputDecoration(labelText: 'Remaining Total Amount*'),
            ),
            TextFormField(
              controller: _totalAmountOfPurchaseController,
              decoration: InputDecoration(labelText: 'Total Amount Of Purchase*'),
            ),
          ] else ...[
            // Cash-specific fields
            TextFormField(
              controller: _tokenAmountController,
              decoration: InputDecoration(labelText: 'Token Amount*'),
            ),
            TextFormField(
              controller: _tokenAmountInWordsController,
              decoration: InputDecoration(labelText: 'Token Amount in Words*'),
            ),
            TextFormField(
              controller: _tokenAmountDateController,
              decoration: InputDecoration(labelText: 'Token Amount Date*'),
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'By*'),
              value: _selectedTokenBy,
              items: [
                DropdownMenuItem(value: 'Manager', child: Text('Manager')),
                DropdownMenuItem(value: 'Staff', child: Text('Staff')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedTokenBy = value;
                });
              },
            ),
          ],
        ],
      ),
    );
  }

  void _updateFormData() {
    final data = <String, dynamic>{
      'paymentCondition': _paymentCondition,
      'amount': _amountController.text,
      'date': _dateController.text,
      'duration': _durationController.text,
      'loanAmount': _loanAmountController.text,
      'remainingTotalAmount': _remainingTotalAmountController.text,
      'totalAmountOfPurchase': _totalAmountOfPurchaseController.text,
    };
    widget.onDataChanged(data);
  }
}
class ConfirmationStep extends StatelessWidget {
  final Map<String, dynamic> formData;

  const ConfirmationStep({Key? key, required this.formData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Confirmation',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text('Booking Information:', style: TextStyle(fontWeight: FontWeight.bold)),
          Text('Party Name: ${formData['partyName'] ?? 'N/A'}'),
          Text('Mobile Number: ${formData['partyMobile'] ?? 'N/A'}'),
          Text('Area: ${formData['area'] ?? 'N/A'}'),
          Text('Project Information:', style: TextStyle(fontWeight: FontWeight.bold)),
          Text('Project Name: ${formData['projectName'] ?? 'N/A'}'),
          Text('Unit Number: ${formData['unitNumber'] ?? 'N/A'}'),
          // Add more fields here
        ],
      ),
    );
  }
}

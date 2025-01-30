import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
// import 'package:inquiry_management_ui/Utils/Colors/app_Colors.dart';
// import 'package:inquiry_management_ui/Model/quotation_Model.dart';
// import 'package:inquiry_management_ui/Utils/Custom%20widgets/custom_buttons.dart';
import 'package:intl/intl.dart';

import '../../Model/quotation_Model.dart';
import '../Colors/app_Colors.dart';
import 'custom_buttons.dart';


class QuotationScreen extends StatefulWidget {
  @override
  _QuotationScreenState createState() => _QuotationScreenState();
}

class _QuotationScreenState extends State<QuotationScreen> {
  bool isEditing = false;
  bool isGstEnabled = true;
  bool isProductSelected = true;
  String selectedCountry = 'India';
  String selectedState = 'Meghalaya';
  String selectedCity = 'Cherrapunji';
  TextEditingController dateController = TextEditingController();
  List<String> countries = ['India', 'USA', 'Canada', 'Australia'];
  List<String> states = ['Meghalaya', 'Assam', 'West Bengal', 'Sikkim'];
  List<String> cities = ['Cherrapunji', 'Shillong', 'Tura', 'Jowai'];

  final List<Product> products = [
    Product(name: 'Wooden Table', rate: 900, hsnCode: '4403', gst: 18, duration: '1 week'),
    Product(name: "Bowl", rate: 150, hsnCode: '4419', gst: 12, duration: '2 week')
  ];
  final List<Service> services = [
    Service(name: "Web Development", rate: 2000, hsnCode: '99831', gst: 18, duration: '3 months'),
    Service(name: "Consulting", rate: 1500, hsnCode: '99834', gst: 5, duration: '6 months')
  ];

  String? selectedProductOrService;
  int rate = 0;
  String hsnCode = '';
  int quantity = 1;
  double gstPercentage = 0.0;
  double gstAmount = 0.0;
  double totalValue = 0.0;

  double subtotal = 0.0;
  double discount = 0.0;
  double tax = 0.0;
  double total = 0.0;
  Map<String, dynamic>? selectedItem;

  TextEditingController gstController = TextEditingController();

  String? productDropdownValue;
  String? serviceDropdownValue;
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController whatsappController = TextEditingController();

  List<Map<String, dynamic>> itemRows = [
  ];

  @override
  void initState() {
    super.initState();
    gstController.text = '0.0';
    _addNewItemRow();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.MainColor,
        title: Text('Quotation', style: TextStyle(fontFamily: "poppins_thin",color: Colors.white,fontSize: 20)),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios,color: Colors.white,)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Column(
              children: [
                SizedBox(height: 20,),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: userNameController,
                        decoration: InputDecoration(
                          labelText: 'User Name',
                          labelStyle: TextStyle(fontFamily: "poppins_thin"),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: 'Enter User Name',
                          hintStyle: TextStyle(fontFamily: "poppins_thin"),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(fontFamily: "poppins_thin"),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                          hintText: 'Enter Email',
                          hintStyle: TextStyle(fontFamily: "poppins_thin"),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: subjectController,
                    decoration: InputDecoration(
                      labelText: 'Subject',
                      labelStyle: TextStyle(fontFamily: "poppins_thin"),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      hintText: 'Enter Subject',
                      hintStyle: TextStyle(fontFamily: "poppins_thin"),
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: TextField(
                    controller: whatsappController,
                    decoration: InputDecoration(
                      labelText: 'WhatsApp',
                      labelStyle: TextStyle(fontFamily: "poppins_thin"),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      hintText: 'Enter WhatsApp Number',
                      hintStyle: TextStyle(fontFamily: "poppins_thin"),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            GestureDetector(
              onTap: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (selectedDate != null) {
                  setState(() {
                    dateController.text =
                        DateFormat('dd/MM/yyyy').format(selectedDate);
                  });
                }
              },
              child: AbsorbPointer(
                child: TextField(
                  controller: dateController,
                  decoration: InputDecoration(
                    labelText: 'Date',
                    suffixIcon: Icon(Icons.calendar_month),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    hintText: 'Enter Date',
                    hintStyle: TextStyle(fontFamily: "poppins_thin"),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: isEditing
                    ? Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildDropdown('Country', countries, selectedCountry,
                                (value) {
                              setState(() {
                                selectedCountry = value!;
                              });
                            }),
                        Spacer(),
                        CircleAvatar(
                          backgroundColor: AppColor.Buttoncolor,
                          radius: 18,
                          child: IconButton(
                            icon: Icon(Icons.save,
                              color: Colors.white,
                              size: 20,),
                            onPressed: () {
                              setState(() {
                                isEditing = false;
                              });
                            },
                          ),
                        ),

                      ],
                    ),
                    Row(
                      children: [
                        _buildDropdown('City', cities, selectedCity, (value) {
                          setState(() {
                            selectedCity = value!;
                          });
                        }),
                        Spacer(),
                        _buildDropdown('State', states, selectedState, (value) {
                          setState(() {
                            selectedState = value!;
                          });
                        }),
                      ],
                    ),
                  ],
                )
                    : Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Country: $selectedCountry',
                            style: TextStyle(fontFamily: "poppins_thin")),
                        CircleAvatar(
                          backgroundColor: AppColor.Buttoncolor,
                          radius: 15,
                          child: IconButton(
                            icon: Icon(Icons.edit,
                              color: Colors.white,
                              size: 15,),
                            onPressed: () {
                              setState(() {
                                isEditing = true;
                              });
                            },
                          ),
                        ),

                      ],
                    ),
                    Row(
                      children: [
                        Text('City: $selectedCity',
                            style: TextStyle(fontFamily: "poppins_thin")),
                        Spacer(),
                        Text('State: $selectedState',
                            style: TextStyle(fontFamily: "poppins_thin")),

                      ],
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text('GST', style: TextStyle(fontFamily: "poppins_thin")),
                    Switch(
                      value: isGstEnabled,
                      onChanged: (value) {
                        setState(() {
                          isGstEnabled = value;
                          if (!isGstEnabled) {
                            gstController.clear();
                            gstController.text = '0.0';
                          }
                          _calculateTotalValue();
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('Service',
                        style: TextStyle(fontFamily: "poppins_thin")),
                    Switch(
                      inactiveThumbColor: Colors.white,
                      activeTrackColor: Colors.green,
                      thumbColor: MaterialStateProperty.all(Colors.white),
                      activeColor: Colors.green,
                      inactiveTrackColor: Colors.deepPurple,
                      value: isProductSelected,
                      onChanged: (value) {
                        setState(() {
                          isProductSelected = value;
                          selectedProductOrService = null;
                          rate = 0;
                          hsnCode = '';
                          quantity = 1;
                          gstAmount = 0;
                          gstPercentage = 0;
                          totalValue = 0;
                          gstController.text = '0.0';
                          productDropdownValue = null;
                          serviceDropdownValue = null;
                          selectedItem = null;
                          _calculateTotalValue();
                        });
                      },
                    ),
                    Text('Product',
                        style: TextStyle(fontFamily: "poppins_thin")),
                  ],
                ),
              ],
            ),
            Divider(height: 40,),
            // SizedBox(height: 16.0),
            Row(
              children: [
                Text(
                  'Item Details',
                  style: TextStyle(fontSize:20,fontWeight: FontWeight.bold),
                ),
                Spacer(),
                CircleAvatar(
                  backgroundColor: AppColor.Buttoncolor,
                  radius: 17,
                  child: IconButton(
                      onPressed: () {
                        _addNewItemRow();
                      },
                      icon: Icon(Icons.add,color: Colors.white,size: 18,)),
                )
              ],
            ),
            SizedBox(height: 8.0),
            Column(
              children: [
                for (int i = 0; i < itemRows.length; i++)
                  _buildItemRow(i),
              ],
            ),
            if (selectedItem != null)
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if(isProductSelected)
                            Column(
                              children: [
                                Text('Rate',
                                    style: TextStyle(
                                        fontFamily: "poppins_thin",
                                        fontSize: 14,
                                        color: Colors.grey.shade700)),
                                Text('${selectedItem!['rate']}',
                                    style: const TextStyle(
                                        fontFamily: "poppins_thin", fontSize: 14)),
                              ],
                            ),
                          if(!isProductSelected)
                            Column(
                              children: [
                                Text('Duration',
                                    style: TextStyle(
                                        fontFamily: "poppins_thin",
                                        fontSize: 14,
                                        color: Colors.grey.shade700)),
                                Text('${selectedItem!['duration']}',
                                    style: const TextStyle(
                                        fontFamily: "poppins_thin", fontSize: 14)),
                              ],
                            ),

                          const Spacer(),
                          if(isProductSelected)
                            Column(
                              children: [
                                Text('Value',
                                    style: TextStyle(
                                        fontFamily: "poppins_thin",
                                        fontSize: 14,
                                        color: Colors.grey.shade700)),
                                Text('${selectedItem!['totalValue'].toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        fontFamily: "poppins_thin", fontSize: 14)),
                              ],
                            ),
                          const Spacer(),
                          Column(
                            children: [
                              Text('HSN Code',
                                  style: TextStyle(
                                      fontFamily: "poppins_thin",
                                      fontSize: 14,
                                      color: Colors.grey.shade700)),
                              Text('${selectedItem!['hsnCode']}',
                                  style: const TextStyle(
                                      fontFamily: "poppins_thin", fontSize: 14)),
                            ],
                          ),
                          if (isGstEnabled)
                            const Spacer(),
                          if (isGstEnabled)
                            Column(
                              children: [
                                Text('GST Amt',
                                    style: TextStyle(
                                        fontFamily: "poppins_thin",
                                        fontSize: 14,
                                        color: Colors.grey.shade700)),
                                Text('${selectedItem!['gstAmount'].toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        fontFamily: "poppins_thin", fontSize: 14)),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            SizedBox(height: 8.0),
            // Add this section above the DottedBorder
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: [
                  _buildCalculationRow(
                      'Sub Total', subtotal.toStringAsFixed(2)),
                  _buildCalculationRow(
                      'Total Discount', discount.toStringAsFixed(2)),
                  if(isGstEnabled)_buildCalculationRow('IGST', tax.toStringAsFixed(2)),

                ],
              ),
            ),
            SizedBox(height: 8),
            DottedBorder(
              color: Colors.grey,
              strokeWidth: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: "poppins_thin",
                          ),
                        ),
                        Text(
                          '₹${total.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: "poppins_thin",
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),
            GradientButton(
                buttonText: "Generate Quotation",
                onPressed: () {

                },),

          ],
        ),
      ),
    );
  }

  Widget _buildCalculationRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontFamily: "poppins_thin", fontSize: 16)),
        Row(
          children: [
            Text('₹',
                style: TextStyle(fontFamily: "poppins_thin", fontSize: 16)),
            SizedBox(width: 4),
            Text(value,
                style: TextStyle(fontFamily: "poppins_thin", fontSize: 16)),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, List<String> items, String currentValue,
      ValueChanged<String?> onChanged) {
    return Expanded(
      child: DropdownButton<String>(
        value: currentValue,
        onChanged: onChanged,
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(value),
            ),
          );
        }).toList(),
        isExpanded: true,
        hint: Text(label),
      ),
    );
  }
  Widget _buildGSTFieldForIndex(int index) {
    return Container(
      width: 80,
      child: TextField(
        controller: gstController,
        keyboardType: TextInputType.number,
        onChanged: (value) {
          double? parsedGst = double.tryParse(value);
          setState(() {
            itemRows[index]['gstPercentage'] = parsedGst ?? 0.0;
            _calculateTotalValue();
          });
          _updateItemData(index,itemRows[index]['selectedProductOrService'] );
          if (itemRows[index]['selectedProductOrService'] != null) {
            selectedProductOrService = itemRows[index]['selectedProductOrService'];
            _updateSelectedItem();
          }
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          hintText: 'GST %',
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
  void _calculateTotalValue() {
    subtotal = 0;
    tax = 0;
    total = 0;
    for (var item in itemRows) {
      if (isProductSelected) {
        if(item['rate'] != null && item['quantity']!=null){
          totalValue = (item['rate'] * item['quantity']).toDouble();
          gstAmount = 0;
          if (isGstEnabled && (item['gstPercentage'] ?? 0) > 0) {
            gstAmount = totalValue * (item['gstPercentage'] / 100);
          }
          item['totalValue'] = totalValue;
          item['gstAmount'] = gstAmount;
          subtotal += totalValue ;
        }

      }
      else {
        if(item['rate'] != null){
          totalValue = (item['rate']).toDouble();
          gstAmount = 0;
          if (isGstEnabled && (item['gstPercentage'] ?? 0) > 0) {
            gstAmount = totalValue * (item['gstPercentage'] / 100);
          }

          item['totalValue'] = totalValue;
          item['gstAmount'] = gstAmount;
          subtotal += totalValue;
        }
      }

      if (isGstEnabled) {
        tax += gstAmount;
      }
      total= subtotal + tax;
    }
    setState(() {});
  }
  void _updateSelectedItem() {
    if (selectedProductOrService != null) {
      final selectedService = services.firstWhere(
            (service) => service.name == selectedProductOrService,
        orElse: () => Service(name: '', rate: 0, hsnCode: '', gst: 0, duration: ''),
      );
      final selectedProduct = products.firstWhere(
            (product) => product.name == selectedProductOrService,
        orElse: () =>  Product(name: '', rate: 0, hsnCode: '', gst: 0, duration: ''),
      );
      final selectedItemFromRow = itemRows.firstWhere((item) => item['selectedProductOrService'] == selectedProductOrService , orElse: ()=> {'rate': 0, 'hsnCode': '', 'quantity': 1,  'gstPercentage': 0.0,'gstAmount': 0, 'totalValue': 0,'duration' : ''});

      setState(() {
        selectedItem = isProductSelected
            ? {
          'name': selectedProduct.name,
          'rate':  selectedItemFromRow['rate'] ,
          'hsnCode': selectedProduct.hsnCode ?? '',
          'quantity': selectedItemFromRow['quantity'],
          'gstPercentage': selectedProduct.gst.toDouble() ?? 0.0,
          'gstAmount': (selectedItemFromRow['rate'] ) * ((selectedProduct.gst.toDouble() ?? 0.0) / 100),
          'totalValue': (selectedItemFromRow['rate'] * selectedItemFromRow['quantity']).toDouble(),
          'duration': selectedProduct.duration,
        } : {
          'name': selectedService.name,
          'rate':  selectedItemFromRow['rate'],
          'hsnCode': selectedService.hsnCode ?? '',
          'duration': selectedService.duration,
          'gstPercentage': selectedService.gst.toDouble() ?? 0.0,
          'gstAmount': (selectedItemFromRow['rate']) * ((selectedService.gst.toDouble() ?? 0.0) / 100),
          'totalValue': selectedItemFromRow['rate'] * 1.0,
        };
      });
    }
  }
  Widget _buildItemRow(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: DropdownButton2<String>(
              isExpanded: true,
              hint: itemRows[index]['selectedProductOrService'] == null
                  ? const Text('Select Product',
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: "poppins_thin",
                      overflow: TextOverflow.ellipsis))
                  : Text(itemRows[index]['selectedProductOrService']!,
                  style: const TextStyle(
                      fontSize: 14,
                      fontFamily: "poppins_thin",
                      overflow: TextOverflow.ellipsis)),
              items: isProductSelected
                  ? products
                  .map((product) => DropdownMenuItem<String>(
                value: product.name,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(product.name),
                ),
              ))
                  .toList()
                  : services
                  .map((service) => DropdownMenuItem<String>(
                value: service.name,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(service.name),
                ),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  itemRows[index]['selectedProductOrService'] = value;
                  selectedProductOrService = value;
                  _updateItemData(index, value);
                  _calculateTotalValue();
                  _updateSelectedItem();
                });
              },
              buttonStyleData: ButtonStyleData(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade100,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 4,
                          spreadRadius: 2,
                        ),
                      ]
                  )
              ),
              dropdownStyleData: DropdownStyleData(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2)
                  )
              ),
              underline: const Center(),
            ),
          ),
          const SizedBox(width: 10,),
          if(isProductSelected)
            _buildQuantityFieldForIndex(index),
          if (!isProductSelected)
            _buildRateFieldForIndex(index),
          SizedBox(width: 10,),
          if (isGstEnabled)
            _buildGSTFieldForIndex(index),
          if (index>0)
          IconButton(
              onPressed: (){
                _removeItemRow(index);
              },
              icon: Icon(Icons.remove_circle_outline)
          ),
        ],
      ),
    );
  }
  Widget _buildRateFieldForIndex(int index) {
    return Container(
      width: 80,
      child: TextField(
        keyboardType: TextInputType.number,
        onChanged: (value) {
          int parsedRate = int.tryParse(value) ?? 0;
          setState(() {
            itemRows[index]['rate'] = parsedRate;
            _calculateTotalValue();
            _updateItemData(index,itemRows[index]['selectedProductOrService'] );
            if (itemRows[index]['selectedProductOrService'] != null){
              selectedProductOrService  = itemRows[index]['selectedProductOrService'];
              _updateSelectedItem();
            }
          });
        },
        decoration: const InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))
            ),
            hintText: 'Rate',
            prefixText: '₹'

        ),
        textAlign: TextAlign.center,
      ),
    );
  }
  Widget _buildQuantityFieldForIndex(int index) {
    return Container(
        width: 80,
        child: TextField(
        keyboardType: TextInputType.number,
        onChanged: (value) {
      int parsedQuantity = int.tryParse(value) ?? 1;
      setState(() {
        itemRows[index]['quantity'] = parsedQuantity;
        _calculateTotalValue();
        _updateItemData(index,itemRows[index]['selectedProductOrService'] );
        if (itemRows[index]['selectedProductOrService'] != null){
          selectedProductOrService = itemRows[index]['selectedProductOrService'];
          _updateSelectedItem();
        }
      });
    },
    decoration: const InputDecoration(
    border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(20))
    ),
    hintText: 'Qty',
    ),
    textAlign: TextAlign.center,
        ),
    );
  }

  void _addNewItemRow() {
    setState(() {
      itemRows.add({
        'selectedProductOrService': null,
        'rate': 0,
        'hsnCode': '',
        'quantity': 1,
        'gstPercentage': 0.0,
        'gstAmount': 0.0,
        'totalValue': 0.0,
        'duration': ''

      });
    });
  }
  void _removeItemRow(int index) {
    setState(() {
      itemRows.removeAt(index);
      _calculateTotalValue();
    });
  }
  void _updateItemData(int index, String? selectedValue) {
    if (selectedValue == null) {
      itemRows[index]['rate'] = 0;
      itemRows[index]['hsnCode'] = '';
      itemRows[index]['gstPercentage'] = 0.0;
      itemRows[index]['duration'] = '';
      itemRows[index]['gst'] = 0.0;
      return;
    }
    if(isProductSelected){
      final product = products.firstWhere(
            (element) => element.name == selectedValue,
        orElse: () =>  Product(name: '', rate: 0, hsnCode: '', gst: 0, duration: ''),
      );

      itemRows[index]['rate'] = product.rate;
      itemRows[index]['hsnCode'] = product.hsnCode;
      itemRows[index]['gstPercentage'] =
      product.gst != null ? product.gst.toDouble() : 0.0;
      itemRows[index]['duration'] = product.duration;
      itemRows[index]['gst'] = product.gst != null ? product.gst.toDouble() : 0.0;
      gstController.text =  itemRows[index]['gstPercentage'].toString();
      itemRows[index]['gstAmount'] = 0;
    }
    else{
      final service = services.firstWhere(
            (element) => element.name == selectedValue,
        orElse: () => Service(name: '', rate: 0, hsnCode: '', gst: 0, duration: ''),
      );

      itemRows[index]['rate'] = service.rate;
      itemRows[index]['hsnCode'] = service.hsnCode;
      itemRows[index]['gstPercentage'] =
      service.gst != null ? service.gst.toDouble() : 0.0;
      itemRows[index]['duration'] = service.duration;
      itemRows[index]['gst'] = service.gst != null ? service.gst.toDouble() : 0.0;
      gstController.text =  itemRows[index]['gstPercentage'].toString();
      itemRows[index]['gstAmount'] = 0;

    }
  }

}
  // void _calculateTotalValue() {
  //   subtotal = 0;
  //   tax = 0;
  //   total = 0;
  //   for (var item in itemRows) {
  //     if (isProductSelected) {
  //       if(item['rate'] != null && item['quantity']!=null){
  //         totalValue = (item['rate'] * item['quantity']).toDouble();
  //         gstAmount = 0;
  //         if (isGstEnabled && (item['gstPercentage'] ?? 0) > 0) {
  //           gstAmount = totalValue * (item['gstPercentage'] / 100);
  //         }
  //         item['totalValue'] = totalValue;
  //         item['gstAmount'] = gstAmount;
  //
  //         subtotal += totalValue ;
  //       }
  //
  //     }
  //     else {
  //       if(item['rate'] != null){
  //         totalValue = (item['rate']).toDouble();
  //         gstAmount = 0;
  //         if (isGstEnabled && (item['gstPercentage'] ?? 0) > 0) {
  //           gstAmount = totalValue * (item['gstPercentage'] / 100);
  //         }
  //         item['totalValue'] = totalValue;
  //         item['gstAmount'] = gstAmount;
  //         subtotal += totalValue;
  //
  //       }
  //     }
  //
  //     if (isGstEnabled) {
  //       tax += gstAmount;
  //     }
  //     total= subtotal + tax;
  //   }
  //   setState(() {});
  // }
  // void _updateSelectedItem() {
  //   if (selectedProductOrService != null) {
  //     final selectedService = services.firstWhere(
  //           (service) => service['name'] == selectedProductOrService,
  //       orElse: () => {
  //         'name': '',
  //         'rate': 0,
  //         'hsnCode': '',
  //         'gst': 0.0,
  //         'duration': ''
  //       },
  //     );
  //     final selectedProduct = products.firstWhere(
  //           (product) => product['name'] == selectedProductOrService,
  //       orElse: () => {
  //         'name': '',
  //         'rate': 0,
  //         'hsnCode': '',
  //         'gst': 0.0,
  //         'duration': ''
  //
  //       },
  //     );
  //
  //     setState(() {
  //       selectedItem = isProductSelected
  //           ? {
  //         'name': selectedProduct['name'],
  //         'rate': rate ,
  //         'hsnCode': selectedProduct['hsnCode'] ?? '',
  //         'quantity': quantity,
  //         'gstPercentage': selectedProduct['gst'] ?? 0.0,
  //         'gstAmount': (rate ) * ((selectedProduct['gst'] ?? 0.0) / 100),
  //         'totalValue': (rate * quantity).toDouble(),
  //         'duration': selectedProduct['duration'],
  //       } : {
  //         'name': selectedService['name'],
  //         'rate': rate,
  //         'hsnCode': selectedService['hsnCode'] ?? '',
  //         'duration': selectedService['duration'],
  //         'gstPercentage': selectedService['gst'] ?? 0.0,
  //         'gstAmount': (rate) * ((selectedService['gst'] ?? 0.0) / 100),
  //         'totalValue': rate * 1.0 ,
  //       };
  //     });
  //   }
  // }
// _buildTaxDetailsTable(),

// SizedBox(height: 16.0),

// Row(
//   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   children: [
//     Text(
//       'Subtotal:',
//       style: TextStyle(
//         fontSize: 16,
//         fontWeight: FontWeight.w600,
//         fontFamily: "poppins_thin",
//       ),
//     ),
//     Text(
//       '₹${subtotal.toStringAsFixed(2)}',  // Format as currency
//       style: TextStyle(
//         fontSize: 16,
//         fontWeight: FontWeight.w600,
//         fontFamily: "poppins_thin",
//         color: Colors.black,
//       ),
//     ),
//   ],
// ),

// Tax Details Table
// Widget _buildTaxDetailsTable() {
//   return Table(
//     border: TableBorder.all(color: Colors.grey),
//     columnWidths: {
//       0: FlexColumnWidth(1),
//       1: FlexColumnWidth(2),
//       2: FlexColumnWidth(2),
//       3: FlexColumnWidth(2),
//       if (isGstEnabled) 4: FlexColumnWidth(2),
//       if (isGstEnabled) 5: FlexColumnWidth(2),
//     },
//     children: [
//       // Header Row
//       TableRow(
//         decoration: BoxDecoration(color: Colors.grey[200]),
//         children: [
//           tableHeader('No.'),
//           tableHeader('Value'),
//           tableHeader('Discount'),
//           tableHeader('HSN Code'),
//           if (isGstEnabled) tableHeader('GST'),
//           if (isGstEnabled) tableHeader('GST Amt'),
//         ],
//       ),
//       // Tax Details Row
//       TableRow(
//         children: [
//           tableCell('1'),
//           tableCell(totalValue.toStringAsFixed(2)),
//           tableCell('0'),
//           tableCell(hsnCode),
//           if (isGstEnabled)
//             Padding(
//               padding: EdgeInsets.symmetric(vertical: 8.0,horizontal: 10),
//               child: TextField(
//                 controller: gstController,
//                 keyboardType: TextInputType.number,
//                 decoration: InputDecoration(
//                   labelText: '(%)',
//                   border: OutlineInputBorder(),
//                   // hintText: 'Enter GST percentage',
//                 ),
//                 onChanged: (value) {
//                   setState(() {
//                     _calculateTotalValue(); // Recalculate total value on GST change
//                   });
//                 },
//               ),
//             ),
//           if (isGstEnabled) tableCell('0'),
//         ],
//       ),
//     ],
//   );
// }

// Table Header Cell
// Widget tableHeader(String text) {
//   return Padding(
//     padding: EdgeInsets.all(8.0),
//     child: Text(
//       text,
//       style: TextStyle(fontWeight: FontWeight.bold),
//       textAlign: TextAlign.center,
//     ),
//   );
// }
//
// // Table Data Cell
// Widget tableCell(String text) {
//   return Padding(
//     padding: EdgeInsets.all(8.0),
//     child: Text(
//       text,
//       textAlign: TextAlign.center,
//     ),
//   );
// }
// DropdownMenuItem(
//   value: item,
//   child: Row(
//     children: [
//       Container(
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(5),
//           color: Colors.grey.shade800,
//         ),
//         child: Text(
//           products.substring(0, 1).toUpperCase(),
//           style: const TextStyle(color: Colors.white,
//               fontFamily: "poppins_thin"),
//         ),
//       ),
//       const SizedBox(width: 5),
//       Text(item, style: const TextStyle(
//           fontFamily: "poppins_thin")),
//     ],
//   ),
// )).toList(),
// onChanged: (value) {
//   setState(() {
//     selectedValue = value;
//   });
// },

// DropdownMenuItem(
//   value: item,
//   child: Row(
//     children: [
//       Container(
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(5),
//           color: Colors.grey.shade800,
//         ),
//         child: Text(
//           products.substring(0, 1).toUpperCase(),
//           style: const TextStyle(color: Colors.white,
//               fontFamily: "poppins_thin"),
//         ),
//       ),
//       const SizedBox(width: 5),
//       Text(item, style: const TextStyle(
//           fontFamily: "poppins_thin")),
//     ],
//   ),
// )).toList(),
// onChanged: (value) {
//   setState(() {
//     selectedValue = value;
//   });
// },
// Row(
//   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   children: [
//
//     Text(
//       'Discount:',
//       style: TextStyle(
//         fontSize: 18,
//         fontWeight: FontWeight.bold,
//         fontFamily: "poppins_thin",
//       ),
//     ),
//     Text(
//       '₹${discount.toStringAsFixed(2)}',  // Format as currency
//       style: TextStyle(
//         fontSize: 18,
//         fontWeight: FontWeight.bold,
//         fontFamily: "poppins_thin",
//         color: Colors.black,
//       ),
//     ),
//   ],
// ),
// Divider(),
// Row(
//   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   children: [
//
//     Text(
//       'SubTotal:',
//       style: TextStyle(
//         fontSize: 18,
//         fontWeight: FontWeight.bold,
//         fontFamily: "poppins_thin",
//       ),
//     ),
//     Text(
//       '₹${subtotal.toStringAsFixed(2)}',  // Format as currency
//       style: TextStyle(
//         fontSize: 18,
//         fontWeight: FontWeight.bold,
//         fontFamily: "poppins_thin",
//         color: Colors.black,
//       ),
//     ),
//   ],
// ),
//
// Divider(thickness: 1, color: Colors.grey.shade300),
// SizedBox(height: 8),
// Widget _buildProductTable() {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 8),
//     child: Row(
//       children: [
//         Expanded(
//           flex: 3,
//           child: DropdownButton2<String>(
//             isExpanded: true,
//             hint: selectedProductOrService == null
//                 ? const Text('Select Product',
//                 style: TextStyle(
//                     fontSize: 14,
//                     fontFamily: "poppins_thin",
//                     overflow: TextOverflow.ellipsis))
//                 : Text(selectedProductOrService!,
//                 style: const TextStyle(
//                     fontSize: 14,
//                     fontFamily: "poppins_thin",
//                     overflow: TextOverflow.ellipsis)),
//             items: products
//                 .map((product) => DropdownMenuItem<String>(
//               value: product.name,
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(product.name),
//               ),
//             ))
//                 .toList(),
//             onChanged: (value) {
//               setState(() {
//                 selectedProductOrService = value;
//                 _updateProductData(value);
//                 _calculateTotalValue();
//                 _updateSelectedItem();
//               });
//             },
//             buttonStyleData: ButtonStyleData(
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: Colors.grey.shade100,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.shade300,
//                         blurRadius: 4,
//                         spreadRadius: 2,
//                       ),
//                     ]
//                 )
//             ),
//             dropdownStyleData: DropdownStyleData(
//                 decoration: BoxDecoration(
//                     border: Border.all(color: Colors.black, width: 2)
//                 )
//             ),
//             underline: const Center(),
//           ),
//         ),
//         const SizedBox(width: 10,),
//         _buildQuantityField(),
//         SizedBox(width: 10,),
//         if (isGstEnabled)
//           Container(
//             width: 80,
//             child: TextField(
//               controller: gstController,
//               keyboardType: TextInputType.number,
//               onChanged: (value) {
//                 double? parsedGst = double.tryParse(value);
//                 setState(() {
//                   gstPercentage = parsedGst ?? 0.0;
//                   _calculateTotalValue();
//                   if (selectedItem != null) {
//                     _updateSelectedItem();
//                   }
//                 });
//
//               },
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(20))
//                 ),
//                 hintText: 'GST %',
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//       ],
//     ),
//   );
// }
//
// Widget _buildServiceTable() {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 8),
//     child: Row(
//       children: [
//         Expanded(
//           flex: 3,
//           child: DropdownButton2<String>(
//             isExpanded: true,
//             hint: selectedProductOrService == null
//                 ? const Text('Select Service',
//                 style: TextStyle(
//                     fontSize: 14,
//                     fontFamily: "poppins_thin",
//                     overflow: TextOverflow.ellipsis))
//                 : Text(selectedProductOrService!,
//                 style: const TextStyle(
//                     fontSize: 14,
//                     fontFamily: "poppins_thin",
//                     overflow: TextOverflow.ellipsis)),
//             items: services
//                 .map((service) => DropdownMenuItem<String>(
//               value: service.name,
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(service.name),
//               ),
//             ))
//                 .toList(),
//             onChanged: (value) {
//               setState(() {
//                 selectedProductOrService = value;
//                 _updateServiceData(value);
//                 _calculateTotalValue();
//                 _updateSelectedItem();
//               });
//             },
//             buttonStyleData: ButtonStyleData(
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: Colors.grey.shade100,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.shade300,
//                         blurRadius: 4,
//                         spreadRadius: 2,
//                       ),
//                     ]
//                 )
//             ),
//             dropdownStyleData: DropdownStyleData(
//                 decoration: BoxDecoration(
//                     border: Border.all(color: Colors.black, width: 2)
//                 )
//             ),
//             underline: const Center(),
//           ),
//         ),
//         const SizedBox(width: 10,),
//         _buildRateField(),
//         SizedBox(width: 10,),
//         if (isGstEnabled)
//           Container(
//             width: 80,
//             child: TextField(
//               controller: gstController,
//               keyboardType: TextInputType.number,
//               onChanged: (value) {
//                 double? parsedGst = double.tryParse(value);
//                 setState(() {
//                   gstPercentage = parsedGst ?? 0.0;
//                   _calculateTotalValue();
//                   if (selectedItem != null) {
//                     _updateSelectedItem();
//                   }
//                 });
//
//               },
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(20))
//                 ),
//                 hintText: 'GST %',
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//       ],
//     ),
//   );
// }

// void _updateServiceData(String? serviceName) {
//   if (serviceName == null) {
//     rate = 0;
//     hsnCode = '';
//     gstPercentage = 0.0;
//     return;
//   }
//   final service = services.firstWhere(
//         (element) => element.name == serviceName,
//     orElse: () => Service(name: '', rate: 0, hsnCode: '', gst: 0, duration: ''),
//   );
//
//   setState(() {
//     rate = service.rate;
//     hsnCode = service.hsnCode;
//     gstPercentage =
//     service.gst != null ? service.gst.toDouble() : 0.0;
//     gstController.text = gstPercentage.toString();
//     gstAmount = 0;
//   });
// }
// void _updateProductData(String? productName) {
//   if (productName == null) {
//     rate = 0;
//     hsnCode = '';
//     gstPercentage = 0.0;
//     return;
//   }
//
//   final product = products.firstWhere(
//         (element) => element.name == productName,
//     orElse: () =>  Product(name: '', rate: 0, hsnCode: '', gst: 0, duration: ''),
//   );
//   setState(() {
//     rate = product.rate;
//     hsnCode = product.hsnCode;
//     gstPercentage =
//     product.gst != null ? product.gst.toDouble() : 0.0;
//     gstController.text = gstPercentage.toString();
//     gstAmount = 0;
//   });
// }
// Widget _buildRateField() {
//   return Container(
//     width: 80,
//     child: TextField(
//       keyboardType: TextInputType.number,
//       onChanged: (value) {
//         int? parsedRate = int.tryParse(value);
//         setState(() {
//           rate = parsedRate ?? 0;
//           _calculateTotalValue();
//           if (selectedItem != null) {
//             _updateSelectedItem();
//           }
//         });
//       },
//       decoration: const InputDecoration(
//           border: OutlineInputBorder(
//               borderRadius: BorderRadius.all(Radius.circular(20))
//           ),
//           hintText: 'Rate',
//           prefixText: '₹'
//
//       ),
//       textAlign: TextAlign.center,
//     ),
//   );
// }
// Widget _buildQuantityField() {
//   return Container(
//     width: 80,
//     child: TextField(
//       keyboardType: TextInputType.number,
//       onChanged: (value) {
//         int? parsedQuantity = int.tryParse(value);
//         setState(() {
//           quantity = parsedQuantity ?? 1;
//           _calculateTotalValue();
//         });
//         if (selectedItem != null) {
//           _updateSelectedItem();
//         }
//       },
//       decoration: const InputDecoration(
//         border: OutlineInputBorder(
//             borderRadius: BorderRadius.all(Radius.circular(20))
//         ),
//         hintText: 'Qty',
//       ),
//       textAlign: TextAlign.center,
//     ),
//   );
// }
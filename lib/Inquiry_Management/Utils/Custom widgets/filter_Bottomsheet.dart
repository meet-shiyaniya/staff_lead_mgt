// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:inquiry_management_ui/Utils/Custom%20widgets/custom_buttons.dart';
//
// class FilterModal extends StatefulWidget {
//   final List<String> Items = [
//     'Fresh',
//     'Qualified',
//     'Appointment',
//     'Meeting',
//     'Negotiations',
//     'Dismissed',
//     'Dismissed Request',
//     'Feedback',
//     'Reappointment',
//   ];
//
//   FilterModal({super.key});
//
//   @override
//   _FilterModalState createState() => _FilterModalState();
// }
//
// class _FilterModalState extends State<FilterModal> {
//   final TextEditingController _idController = TextEditingController();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _mobileController = TextEditingController();
//   // final TextEditingController _nextFollowUpController = TextEditingController();
//   // final TextEditingController _fromDateController = TextEditingController();
//   // final TextEditingController _toDateController = TextEditingController();
//   // String? intProduct;
//   // String? inquirystatus;
//   // String? assignother;
//   // String? inqtype;
//   // String? intarea;
//   // String? owner;
//   List<String> selectedItems = [];
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isSmallScreen = screenWidth < 600; // Adjust this value as per your need
//
//     final paddingValue = isSmallScreen ? 8.0 : 16.0;
//     final textFontSize = isSmallScreen ? 14.0 : 16.0;
//     return Column(
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20)),
//             color: Colors.deepPurple.shade400,
//           ),
//           child: Row(
//               children: [
//                 IconButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   icon: Icon(Icons.arrow_back_ios, color: Colors.white),
//                 ),
//                 Text("Filter",style: TextStyle(fontFamily: "poppins_thin",color: Colors.white,fontSize: 20),)
//               ]
//           ),
//         ),
//         SizedBox(height: paddingValue),
//         Expanded(  //Make the inner scrollable container
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//
//
//
//                 //ID and Name fields row
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: paddingValue, vertical: paddingValue / 2),
//                   child: TextField(
//                     controller: _idController,
//                     decoration: InputDecoration(
//                       labelText: "Id",
//                       labelStyle: TextStyle(fontFamily: "poppins_thin"),
//                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: paddingValue, vertical: paddingValue / 2),
//                   child: TextField(
//                     controller: _nameController,
//                     decoration: InputDecoration(
//                       labelText: "Enter Name",
//                       labelStyle: TextStyle(fontFamily: "poppins_thin"),
//                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: paddingValue, vertical: paddingValue/2),
//                   child: TextField(
//                     controller: _mobileController,
//                     decoration: InputDecoration(
//                       labelText: "Mobile No",
//                       labelStyle: TextStyle(fontFamily: "poppins_thin"),
//                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                     ),
//                   ),
//                 ),
//                 // Padding(
//                 //   padding: EdgeInsets.symmetric(horizontal: paddingValue, vertical: paddingValue/2),
//                 //   child: TextField(
//                 //     controller: _nextFollowUpController,
//                 //     readOnly: true,
//                 //     decoration: InputDecoration(
//                 //       labelText: "Next Followup",
//                 //       labelStyle: TextStyle(fontFamily: "poppins_thin"),
//                 //       border: OutlineInputBorder(),
//                 //       suffixIcon: IconButton(
//                 //         icon: Icon(Icons.calendar_today),
//                 //         onPressed: () async {
//                 //           DateTime? pickedDate = await showDatePicker(
//                 //             context: context,
//                 //             initialDate: DateTime.now(),
//                 //             firstDate: DateTime(2000),
//                 //             lastDate: DateTime(2101),
//                 //           );
//                 //           if (pickedDate != null) {
//                 //             setState(() {
//                 //               _nextFollowUpController.text = "${pickedDate.toLocal()}".split(' ')[0];
//                 //             });
//                 //           }
//                 //         },
//                 //       ),
//                 //     ),
//                 //   ),
//                 // ),
//                 //Inquiry Status
//                 Container(
//                   width: double.infinity, // Ensures the field takes full width
//                   padding: EdgeInsets.symmetric(horizontal: paddingValue),
//                   child: DropdownButtonHideUnderline(
//                     child: DropdownButton2(
//                       isExpanded: true,
//                       customButton: Container(
//                         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8),
//                           color: Colors.grey.shade100,
//                           border: Border.all(color: Colors.black, width: 1),
//                         ),
//                         child: Text(
//                           selectedItems.isEmpty
//                               ? 'Inquiry Status'
//                               : selectedItems.join(', '),
//                           style: TextStyle(
//                             fontSize: textFontSize,
//                             fontFamily: "poppins_thin",
//                             color: Colors.black,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                       dropdownStyleData: DropdownStyleData(
//                         maxHeight: 300,
//                         width: MediaQuery.of(context).size.width * 0.9,
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.black, width: 2),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         elevation: 10,
//                       ),
//                       items: widget.Items.map((item) {
//                         return DropdownMenuItem<String>(
//                           value: item,
//                           enabled: false,
//                           child: StatefulBuilder(
//                             builder: (context, menuSetState) {
//                               final isSelected = selectedItems.contains(item);
//                               return InkWell(
//                                 onTap: () {
//                                   setState(() {
//                                     if (isSelected) {
//                                       selectedItems.remove(item);
//                                     } else {
//                                       selectedItems.add(item);
//                                     }
//                                   });
//                                   menuSetState(() {}); // Rebuild menu state
//                                 },
//                                 child: Row(
//                                   children: [
//                                     Checkbox(
//                                       value: isSelected,
//                                       onChanged: (checked) {
//                                         setState(() {
//                                           if (checked!) {
//                                             selectedItems.add(item);
//                                           } else {
//                                             selectedItems.remove(item);
//                                           }
//                                         });
//                                         menuSetState(() {}); // Update menu UI
//                                       },
//                                     ),
//                                     SizedBox(width: 8),
//                                     Text(
//                                       item,
//                                       style: TextStyle(fontFamily: "poppins_thin"),
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             },
//                           ),
//                         );
//                       }).toList(),
//                       onChanged: (_) {}, // Required but unused
//                       iconStyleData: IconStyleData(
//                         icon: Icon(Icons.arrow_drop_down, color: Colors.black),
//                       ),
//                     ),
//                   ),
//                 ),
//                 // // Int Product Dropdown
//                 // Padding(
//                 //   padding: EdgeInsets.all(paddingValue),
//                 //   child: DropdownButton2(
//                 //
//                 //     isExpanded: true,
//                 //     hint: Text(
//                 //       'Int Product',
//                 //       style: TextStyle(
//                 //         color: Colors.black,
//                 //         fontSize: textFontSize,
//                 //         fontFamily: "poppins_thin",
//                 //       ),
//                 //     ),
//                 //
//                 //     value: intProduct,
//                 //     buttonStyleData: ButtonStyleData(
//                 //       decoration: BoxDecoration(
//                 //         borderRadius: BorderRadius.circular(8),
//                 //         color: Colors.grey.shade100,
//                 //         boxShadow: [
//                 //           BoxShadow(
//                 //             color: Colors.grey.shade300,
//                 //             blurRadius: 4,
//                 //             spreadRadius: 2,
//                 //           ),
//                 //         ],
//                 //       ),
//                 //     ),
//                 //     underline: SizedBox.shrink(),
//                 //     dropdownStyleData: DropdownStyleData(
//                 //       decoration: BoxDecoration(
//                 //         border: Border.all(color: Colors.black, width: 2),
//                 //       ),
//                 //       elevation: 10,
//                 //     ),
//                 //     items: [
//                 //       DropdownMenuItem(
//                 //         value: 'sofa',
//                 //         child: Row(
//                 //           children: [
//                 //             Text('Sofa(Still)', style: TextStyle(fontFamily: "poppins_thin")),
//                 //           ],
//                 //         ),
//                 //       ),
//                 //       DropdownMenuItem(
//                 //         value: 'bowl(steel)',
//                 //         child: Row(
//                 //           children: [
//                 //             Text('Bowl(steel)', style: TextStyle(fontFamily: "poppins_thin")),
//                 //           ],
//                 //         ),
//                 //       ),
//                 //       DropdownMenuItem(
//                 //         value: 'table',
//                 //         child: Row(
//                 //           children: [
//                 //             Text('Table(Wooden)', style: TextStyle(fontFamily: "poppins_thin")),
//                 //           ],
//                 //         ),
//                 //       ),
//                 //     ],
//                 //     onChanged: (value) {
//                 //       setState(() {
//                 //         intProduct = value as String?;
//                 //       });
//                 //     },
//                 //   ),
//                 // ),
//                 // //Assign to and Owner to Dropdowns
//                 // Row(
//                 //   children: [
//                 //     Expanded(
//                 //       child: Padding(
//                 //         padding: EdgeInsets.all(paddingValue),
//                 //         child: DropdownButton2(
//                 //           isExpanded: true,
//                 //           hint: Text(
//                 //             'Assign To',
//                 //             style: TextStyle(
//                 //               color: Colors.black,
//                 //               fontSize: textFontSize,
//                 //               fontFamily: "poppins_thin",
//                 //             ),
//                 //           ),
//                 //           value: assignother,
//                 //           buttonStyleData: ButtonStyleData(
//                 //             decoration: BoxDecoration(
//                 //               borderRadius: BorderRadius.circular(8),
//                 //               color: Colors.grey.shade100,
//                 //               boxShadow: [
//                 //                 BoxShadow(
//                 //                   color: Colors.grey.shade300,
//                 //                   blurRadius: 4,
//                 //                   spreadRadius: 2,
//                 //                 ),
//                 //               ],
//                 //             ),
//                 //           ),
//                 //           underline: SizedBox.shrink(),
//                 //           dropdownStyleData: DropdownStyleData(
//                 //             decoration: BoxDecoration(
//                 //               border: Border.all(color: Colors.black, width: 2),
//                 //             ),
//                 //             elevation: 10,
//                 //           ),
//                 //           items: [
//                 //             DropdownMenuItem(
//                 //               value: 'RealToSmart',
//                 //               child: Text('RealToSmart', style: TextStyle(fontFamily: "poppins_thin")),
//                 //             ),
//                 //             DropdownMenuItem(
//                 //               value: 'Gymsmart',
//                 //               child: Text('Gymsmart', style: TextStyle(fontFamily: "poppins_thin")),
//                 //             ),
//                 //             DropdownMenuItem(
//                 //               value: 'leadmgt',
//                 //               child: Text('leadmgt', style: TextStyle(fontFamily: "poppins_thin")),
//                 //             ),
//                 //           ],
//                 //           onChanged: (value) {
//                 //             setState(() {
//                 //               assignother = value as String?;
//                 //             });
//                 //           },
//                 //         ),
//                 //       ),
//                 //     ),
//                 //     Expanded(
//                 //       child: Padding(
//                 //         padding: EdgeInsets.all(paddingValue),
//                 //         child: DropdownButton2(
//                 //           isExpanded: true,
//                 //           hint: Text(
//                 //             'Owner To',
//                 //             style: TextStyle(
//                 //               color: Colors.black,
//                 //               fontSize: textFontSize,
//                 //               fontFamily: "poppins_thin",
//                 //             ),
//                 //           ),
//                 //           value: owner,
//                 //           buttonStyleData: ButtonStyleData(
//                 //             decoration: BoxDecoration(
//                 //               borderRadius: BorderRadius.circular(8),
//                 //               color: Colors.grey.shade100,
//                 //               boxShadow: [
//                 //                 BoxShadow(
//                 //                   color: Colors.grey.shade300,
//                 //                   blurRadius: 4,
//                 //                   spreadRadius: 2,
//                 //                 ),
//                 //               ],
//                 //             ),
//                 //           ),
//                 //           underline: SizedBox.shrink(),
//                 //           dropdownStyleData: DropdownStyleData(
//                 //             decoration: BoxDecoration(
//                 //               border: Border.all(color: Colors.black, width: 2),
//                 //             ),
//                 //             elevation: 10,
//                 //           ),
//                 //           items: [
//                 //             DropdownMenuItem(
//                 //               value: 'RealToSmart',
//                 //               child: Text('RealToSmart', style: TextStyle(fontFamily: "poppins_thin")),
//                 //             ),
//                 //             DropdownMenuItem(
//                 //               value: 'Gymsmart',
//                 //               child: Text('Gymsmart', style: TextStyle(fontFamily: "poppins_thin")),
//                 //             ),
//                 //             DropdownMenuItem(
//                 //               value: 'leadmgt',
//                 //               child: Text('leadmgt', style: TextStyle(fontFamily: "poppins_thin")),
//                 //             ),
//                 //           ],
//                 //           onChanged: (value) {
//                 //             setState(() {
//                 //               owner = value as String?;
//                 //             });
//                 //           },
//                 //         ),
//                 //       ),
//                 //     ),
//                 //   ],
//                 // ),
//                 // //Inquiry type and interested area Dropdowns
//                 // Row(
//                 //   children: [
//                 //     Expanded(
//                 //       child: Padding(
//                 //         padding: EdgeInsets.all(paddingValue),
//                 //         child: DropdownButton2(
//                 //           isExpanded: true,
//                 //           hint: Text(
//                 //             'Inq Type',
//                 //             style: TextStyle(
//                 //               color: Colors.black,
//                 //               fontSize: textFontSize,
//                 //               fontFamily: "poppins_thin",
//                 //             ),
//                 //           ),
//                 //           value: inqtype,
//                 //           buttonStyleData: ButtonStyleData(
//                 //             decoration: BoxDecoration(
//                 //               borderRadius: BorderRadius.circular(8),
//                 //               color: Colors.grey.shade100,
//                 //               boxShadow: [
//                 //                 BoxShadow(
//                 //                   color: Colors.grey.shade300,
//                 //                   blurRadius: 4,
//                 //                   spreadRadius: 2,
//                 //                 ),
//                 //               ],
//                 //             ),
//                 //           ),
//                 //           underline: SizedBox.shrink(),
//                 //           dropdownStyleData: DropdownStyleData(
//                 //             decoration: BoxDecoration(
//                 //               border: Border.all(color: Colors.black, width: 2),
//                 //             ),
//                 //             elevation: 10,
//                 //           ),
//                 //           items: [
//                 //             DropdownMenuItem(
//                 //               value: 'Walk in',
//                 //               child: Row(
//                 //                 children: [
//                 //                   Text('Walk in', style: TextStyle(fontFamily: "poppins_thin")),
//                 //                 ],
//                 //               ),
//                 //             ),
//                 //             DropdownMenuItem(
//                 //               value: 'autoleads',
//                 //               child: Row(
//                 //                 children: [
//                 //                   Text('Autoleads', style: TextStyle(fontFamily: "poppins_thin")),
//                 //                 ],
//                 //               ),
//                 //             ),
//                 //             DropdownMenuItem(
//                 //               value: 'call',
//                 //               child: Row(
//                 //                 children: [
//                 //                   Text('Call', style: TextStyle(fontFamily: "poppins_thin")),
//                 //                 ],
//                 //               ),
//                 //             ),
//                 //           ],
//                 //           onChanged: (value) {
//                 //             setState(() {
//                 //               inqtype = value as String?;
//                 //             });
//                 //           },
//                 //         ),
//                 //       ),
//                 //     ),
//                 //     Expanded(
//                 //       child: Padding(
//                 //         padding: EdgeInsets.all(paddingValue),
//                 //         child: DropdownButton2(
//                 //           isExpanded: true,
//                 //           hint: Text(
//                 //             'Assign To',
//                 //             style: TextStyle(
//                 //               color: Colors.black,
//                 //               fontSize: textFontSize,
//                 //               fontFamily: "poppins_thin",
//                 //             ),
//                 //           ),
//                 //           value: intarea,
//                 //           buttonStyleData: ButtonStyleData(
//                 //             decoration: BoxDecoration(
//                 //               borderRadius: BorderRadius.circular(8),
//                 //               color: Colors.grey.shade100,
//                 //               boxShadow: [
//                 //                 BoxShadow(
//                 //                   color: Colors.grey.shade300,
//                 //                   blurRadius: 4,
//                 //                   spreadRadius: 2,
//                 //                 ),
//                 //               ],
//                 //             ),
//                 //           ),
//                 //           underline: SizedBox.shrink(),
//                 //           dropdownStyleData: DropdownStyleData(
//                 //             decoration: BoxDecoration(
//                 //               border: Border.all(color: Colors.black, width: 2),
//                 //             ),
//                 //             elevation: 10,
//                 //           ),
//                 //           items: [
//                 //             DropdownMenuItem(
//                 //               value: 'amroli',
//                 //               child: Row(
//                 //                 children: [
//                 //                   Text('Amroli', style: TextStyle(fontFamily: "poppins_thin")),
//                 //                 ],
//                 //               ),
//                 //             ),
//                 //             DropdownMenuItem(
//                 //               value: 'katargam',
//                 //               child: Row(
//                 //                 children: [
//                 //                   Text('Katargam', style: TextStyle(fontFamily: "poppins_thin")),
//                 //                 ],
//                 //               ),
//                 //             ),
//                 //             DropdownMenuItem(
//                 //               value: 'varachha',
//                 //               child: Row(
//                 //                 children: [
//                 //                   Text('Varachha', style: TextStyle(fontFamily: "poppins_thin")),
//                 //                 ],
//                 //               ),
//                 //             ),
//                 //           ],
//                 //           onChanged: (value) {
//                 //             setState(() {
//                 //               intarea = value as String?;
//                 //             });
//                 //           },
//                 //         ),
//                 //       ),
//                 //     ),
//                 //   ],
//                 // ),
//                 // //Duration Text
//                 // Padding(
//                 //   padding: EdgeInsets.symmetric(horizontal: paddingValue),
//                 //   child: Text(
//                 //     "Duration:",
//                 //     style: TextStyle(fontFamily: "poppins_thin", fontSize: textFontSize),
//                 //   ),
//                 // ),
//                 // SizedBox(height: 10),
//                 // //From and To Date fields row
//                 // Padding(
//                 //   padding: EdgeInsets.symmetric(horizontal: paddingValue, vertical: paddingValue / 2),
//                 //   child: Row(
//                 //     children: [
//                 //       Expanded(
//                 //         child: TextField(
//                 //           controller: _fromDateController,
//                 //           readOnly: true,
//                 //           decoration: InputDecoration(
//                 //             labelText: "From date",
//                 //             labelStyle: TextStyle(fontFamily: "poppins_thin"),
//                 //             border: OutlineInputBorder(),
//                 //             suffixIcon: IconButton(
//                 //               icon: Icon(Icons.calendar_today),
//                 //               onPressed: () async {
//                 //                 DateTime? pickedDate = await showDatePicker(
//                 //                   context: context,
//                 //                   initialDate: DateTime.now(),
//                 //                   firstDate: DateTime(2000),
//                 //                   lastDate: DateTime(2101),
//                 //                 );
//                 //                 if (pickedDate != null) {
//                 //                   setState(() {
//                 //                     _fromDateController.text = "${pickedDate.toLocal()}".split(' ')[0];
//                 //                   });
//                 //                 }
//                 //               },
//                 //             ),
//                 //           ),
//                 //         ),
//                 //       ),
//                 //       SizedBox(width: 10),
//                 //       Expanded(
//                 //         child: TextField(
//                 //           controller: _toDateController,
//                 //           readOnly: true,
//                 //           decoration: InputDecoration(
//                 //             labelText: "To date",
//                 //             labelStyle: TextStyle(fontFamily: "poppins_thin"),
//                 //             border: OutlineInputBorder(),
//                 //             suffixIcon: IconButton(
//                 //               icon: Icon(Icons.calendar_today),
//                 //               onPressed: () async {
//                 //                 DateTime? pickedDate = await showDatePicker(
//                 //                   context: context,
//                 //                   initialDate: DateTime.now(),
//                 //                   firstDate: DateTime(2000),
//                 //                   lastDate: DateTime(2101),
//                 //                 );
//                 //                 if (pickedDate != null) {
//                 //                   setState(() {
//                 //                     _toDateController.text = "${pickedDate.toLocal()}".split(' ')[0];
//                 //                   });
//                 //                 }
//                 //               },
//                 //             ),
//                 //           ),
//                 //         ),
//                 //       ),
//                 //     ],
//                 //   ),
//                 // ),
//                 // SizedBox(height: paddingValue),
//               ],
//             ),
//           ),
//         ),
//         // Apply Filters Button
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: GradientButton(
//             buttonText: "Apply Filters",
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import '../../Inquiry Management Screens/dismiss_request_Screen.dart';
import '../../Model/followup_Model.dart';
import 'custom_buttons.dart';


class FilterModal extends StatefulWidget {
  final Function(List<LeadModel>, Map<String, dynamic>) onFilterApplied;
  final Map<String, dynamic> appliedFilters;
  final List<String> Items = [
    'Fresh',
    'Qualified',
    'Appointment',
    'Meeting',
    'Negotiations',
    'Dismissed',
    'Dismissed Request',
    'Feedback',
    'Reappointment',
  ];

  FilterModal({super.key, required this.onFilterApplied, required this.appliedFilters});

  @override
  _FilterModalState createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  List<String> selectedItems = [];

  @override
  void initState() {
    super.initState();
    _idController.text = widget.appliedFilters['Id'] ?? '';
    _nameController.text = widget.appliedFilters['Name'] ?? '';
    _mobileController.text = widget.appliedFilters['Mobile'] ?? '';
    selectedItems = List.from(widget.appliedFilters['Status'] ?? []);
  }

  void applyFilters() {
    List<LeadModel> filteredList = LeadList;

    if (_idController.text.isNotEmpty) {
      filteredList = filteredList.where((lead) =>
          lead.id.toLowerCase().contains(_idController.text.toLowerCase())).toList();
    }

    if (_nameController.text.isNotEmpty) {
      filteredList = filteredList.where((lead) =>
          lead.name.toLowerCase().contains(_nameController.text.toLowerCase())).toList();
    }

    if (_mobileController.text.isNotEmpty) {
      filteredList = filteredList.where((lead) =>
          lead.phone.toLowerCase().contains(_mobileController.text.toLowerCase())).toList();
    }

    if (selectedItems.isNotEmpty) {
      filteredList = filteredList.where((lead) => selectedItems.contains(lead.label)).toList();
    }

    widget.onFilterApplied(filteredList, {
      'Id': _idController.text,
      'Name': _nameController.text,
      'Mobile': _mobileController.text,
      'Status': selectedItems,
    });
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final paddingValue = isSmallScreen ? 8.0 : 16.0;
    final textFontSize = isSmallScreen ? 16.0 : 18.0;

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
            color: Colors.deepPurple.shade400,
          ),
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              ),
              const Text(
                "Filter",
                style: TextStyle(fontFamily: "poppins_thin", color: Colors.white, fontSize: 20),
              ),
            ],
          ),
        ),
        SizedBox(height: paddingValue),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ID and Name fields row
                SizedBox(height: 10,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: paddingValue, vertical: paddingValue / 2),
                  child: TextField(
                    controller: _idController,
                    decoration: InputDecoration(
                      labelText: "Id",
                      labelStyle: const TextStyle(fontFamily: "poppins_thin"),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onChanged: (_) => applyFilters(), // Apply filter on change
                  ),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: paddingValue, vertical: paddingValue / 2),
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "Enter Name",
                      labelStyle: const TextStyle(fontFamily: "poppins_thin"),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onChanged: (_) => applyFilters(), // Apply filter on change
                  ),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: paddingValue, vertical: paddingValue / 2),
                  child: TextField(
                    controller: _mobileController,
                    decoration: InputDecoration(
                      labelText: "Mobile No",
                      labelStyle: const TextStyle(fontFamily: "poppins_thin"),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onChanged: (_) => applyFilters(), // Apply filter on change
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  width: double.infinity,
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: paddingValue),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      isExpanded: true,
                      customButton: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey.shade100,
                          border: Border.all(color: Colors.black, width: 1),
                        ),
                        child: Text(
                          selectedItems.isEmpty
                              ? 'Inquiry Status'
                              : selectedItems.join(', '),
                          style: TextStyle(
                            fontSize: textFontSize,
                            fontFamily: "poppins_thin",
                            color: Colors.black,

                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      dropdownStyleData: DropdownStyleData(
                        maxHeight: 300,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 10,
                      ),
                      items: widget.Items.map((item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          enabled: false,
                          child: StatefulBuilder(
                            builder: (context, menuSetState) {
                              final isSelected = selectedItems.contains(item);
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      selectedItems.remove(item);
                                    } else {
                                      selectedItems.add(item);
                                    }
                                    applyFilters();
                                  });
                                  menuSetState(() {}); // Rebuild menu state
                                },
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: isSelected,
                                      onChanged: (checked) {
                                        setState(() {
                                          if (checked!) {
                                            selectedItems.add(item);
                                          } else {
                                            selectedItems.remove(item);
                                          }
                                        });
                                        applyFilters(); // Update filter immediately
                                        menuSetState(() {}); // Update menu UI
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                    Text(item, style: const TextStyle(fontFamily: "poppins_thin")),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      }).toList(),
                      onChanged: (_) {},
                      iconStyleData: const IconStyleData(
                        icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // No Apply Filters Button
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GradientButton(
            buttonText: "Apply Filters",
            onPressed: () {
              applyFilters();
              Navigator.pop(context);
            }, // Apply filters when clicked
          ),
        ),
      ],
    );
  }
}
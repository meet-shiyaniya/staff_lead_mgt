// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
//
// import '../../../Provider/UserProvider.dart'; // Adjust path
// import '../../Inquiry Management Screens/all_inquiries_Screen.dart';
// import '../Colors/app_Colors.dart';
// import 'custom_buttons.dart';
//
// class AddLeadScreen extends StatefulWidget {
//   final bool? isEdit;
//   const AddLeadScreen({super.key, this.isEdit});
//
//   @override
//   _AddLeadScreenState createState() => _AddLeadScreenState();
// }
//
// class _AddLeadScreenState extends State<AddLeadScreen> {
//   int _currentStep = 0;
//   String? _selectedCountryCode;
//   String? _selectedArea;
//   String? _selectedCity;
//   String? _selectedInquiryType;
//   String? _selectedInqSource;
//   String? _selectedIntSite;
//   String? _selectedBudget;
//   String? _selectedPurpose;
//   String? _selectedApxTime;
//   String? _selectedPropertyConfiguration;
//
//   bool _isCSTInterestVisible = false;
//   String? _selectedCSTType = 'Service';
//   DateTime? dateOfBirth;
//   DateTime? anniversaryDate;
//   DateTime? nextFollowUp;
//   final TextEditingController _dobController = TextEditingController();
//   final TextEditingController _anniversaryController = TextEditingController();
//   final TextEditingController _dateController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//
//   final List<String> _steps = ["Personal Info", "CST & Inquiry", "Follow Up"];
//
//   @override
//   void initState() {
//     super.initState();
//     // Fetch dropdown options when the screen loads
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final userProvider = Provider.of<UserProvider>(context, listen: false);
//       userProvider.fetchAddLeadData().then((_) {
//         setState(() {});
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           widget.isEdit == true ? "Edit Lead" : "Add Lead",
//           style: const TextStyle(
//               fontFamily: "poppins_thin", color: Colors.white, fontSize: 20),
//         ),
//         backgroundColor: AppColor.MainColor,
//         leading: IconButton(
//           onPressed: () => Navigator.pop(context),
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//         ),
//       ),
//       body: Consumer<UserProvider>(
//         builder: (context, userProvider, child) {
//           if (userProvider.isLoadingDropdown) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           final dropdownData = userProvider.dropdownData;
//           if (dropdownData == null) {
//             print("Dropdown data is null");
//             return const Center(child: Text("Failed to load dropdown options"));
//           }
//
//           // Explicitly type all lists as List<String>
//           final List<String> countryCodes = ['+1', '+44', '+91'];
//           final List<String> areas = (dropdownData.areaCityCountry ?? [])
//               .map<String>((area) => area.area)
//               .where((area) => area.trim().isNotEmpty)
//               .toSet()
//               .toList();
//           final List<String> cities = (dropdownData.areaCityCountry ?? [])
//               .map<String>((city) => city.city)
//               .where((city) => city.trim().isNotEmpty)
//               .toSet()
//               .toList();
//           final List<String> intAreas = (dropdownData.intArea ?? [])
//               .map<String>((area) => area.area)
//               .where((area) => area.trim().isNotEmpty)
//               .toSet()
//               .toList();
//           final List<String> inquiryTypes = (dropdownData.inqType ?? [])
//               .map<String>((inq) => inq.inquiryDetails)
//               .where((type) => type.trim().isNotEmpty)
//               .toSet()
//               .toList();
//           final List<String> inquirySources = (dropdownData.inqSource ?? [])
//               .map<String>((source) => source.source)
//               .where((source) => source.trim().isNotEmpty)
//               .toSet()
//               .toList();
//           final List<String> intSites = (dropdownData.intSite ?? [])
//               .map<String>((site) => site.productName)
//               .where((site) => site.trim().isNotEmpty)
//               .toSet()
//               .toList();
//           final List<String> budgets = dropdownData.budget?.values
//               .split(',')
//               .map<String>((value) => value.trim())
//               .where((value) => value.isNotEmpty)
//               .toSet()
//               .toList() ??
//               [];
//           final List<String> purposes = dropdownData.purposeOfBuying != null
//               ? [
//             dropdownData.purposeOfBuying!.investment,
//             dropdownData.purposeOfBuying!.personalUse
//           ].where((purpose) => purpose.trim().isNotEmpty).toList()
//               : [];
//           final List<String> apxTimes = dropdownData.apxTime?.apxTimeData
//               .split(',')
//               .map<String>((time) => time.trim())
//               .where((time) => time.isNotEmpty)
//               .toSet()
//               .toList() ??
//               [];
//           final List<String> propertyConfigurations =
//           (dropdownData.propertyConfiguration ?? [])
//               .map<String>((prop) => prop.propertyType)
//               .where((config) => config.trim().isNotEmpty)
//               .toSet()
//               .toList();
//
//           // Debug prints
//           print("Areas: $areas");
//           print("Cities: $cities");
//           print("Int Areas: $intAreas");
//           print("Inquiry Types: $inquiryTypes");
//           print("Inquiry Sources: $inquirySources");
//           print("Int Sites: $intSites");
//           print("Budgets: $budgets");
//           print("Purposes: $purposes");
//           print("Apx Times: $apxTimes");
//           print("Property Configurations: $propertyConfigurations");
//
//           return Column(
//             children: [
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: _buildFormContent(
//                     countryCodes,
//                     areas,
//                     cities,
//                     inquiryTypes,
//                     inquirySources,
//                     intSites,
//                     budgets,
//                     purposes,
//                     apxTimes,
//                     propertyConfigurations,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Row(
//                   mainAxisAlignment: _currentStep == 0
//                       ? MainAxisAlignment.end
//                       : MainAxisAlignment.spaceBetween,
//                   children: [
//                     if (_currentStep > 0)
//                       GradientButton(
//                         buttonText: "",
//                         icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//                         width: 40.0,
//                         onPressed: _goToPreviousStep,
//                       ),
//                     GradientButton(
//                       buttonText: _currentStep == _steps.length - 1 ? "Submit" : "Next",
//                       width: 120.0,
//                       onPressed: _currentStep == _steps.length - 1
//                           ? () {
//                         Navigator.pop(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const AllInquiriesScreen(),
//                           ),
//                         );
//                       }
//                           : _goToNextStep,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildFormContent(
//       List<String> countryCodes,
//       List<String> areas,
//       List<String> cities,
//       List<String> inquiryTypes,
//       List<String> inquirySources,
//       List<String> intSites,
//       List<String> budgets,
//       List<String> purposes,
//       List<String> apxTimes,
//       List<String> propertyConfigurations,
//       ) {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(0.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (_currentStep == 0) ...[
//               const Text(
//                 "Personal Inquiry",
//                 style: TextStyle(fontSize: 24, fontFamily: "poppins_thin"),
//               ),
//               Card(child: _buildPersonalInquirySection(countryCodes, areas, cities)),
//             ],
//             if (_currentStep == 1) ...[
//               const Text(
//                 "CST Interest",
//                 style: TextStyle(fontSize: 24, fontFamily: "poppins_thin"),
//               ),
//               Card(
//                 child: _buildCSTInterestSection(
//                   context,
//                   areas,
//                   intSites,
//                   budgets,
//                   purposes,
//                   apxTimes,
//                   propertyConfigurations,
//                   inquirySources,
//                 ),
//               ),
//             ],
//             if (_currentStep == 2) ...[
//               const SizedBox(height: 16),
//               const Text(
//                 "Inquiry Information",
//                 style: TextStyle(fontSize: 24, fontFamily: "poppins_thin"),
//               ),
//               Card(child: _buildInquiryInformationSection(inquiryTypes, inquirySources)),
//               const SizedBox(height: 15),
//               const Text(
//                 "Follow Up",
//                 style: TextStyle(fontSize: 24, fontFamily: "poppins_thin"),
//               ),
//               Card(child: _buildFollowUpSection()),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _goToNextStep() {
//     if (_currentStep < _steps.length - 1) {
//       setState(() {
//         _currentStep++;
//         print("Navigating to next step: $_currentStep");
//       });
//     }
//   }
//
//   void _goToPreviousStep() {
//     if (_currentStep > 0) {
//       setState(() {
//         _currentStep--;
//         print("Navigating to previous step: $_currentStep");
//       });
//     }
//   }
//
//   Widget _buildPersonalInquirySection(List<String> countryCodes, List<String> areas, List<String> cities) {
//     return Padding(
//       padding: const EdgeInsets.all(18.0),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               SizedBox(
//                 width: 80,
//                 child: DropdownButton2(
//                   isExpanded: true,
//                   hint: const Text('+91', style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: "poppins_thin")),
//                   value: _selectedCountryCode,
//                   buttonStyleData: ButtonStyleData(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(18),
//                       color: Colors.grey.shade200,
//                       boxShadow: [
//                         BoxShadow(color: Colors.grey.shade300, blurRadius: 4, spreadRadius: 2),
//                       ],
//                     ),
//                   ),
//                   underline: const SizedBox(),
//                   dropdownStyleData: DropdownStyleData(
//                     decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 2)),
//                     elevation: 10,
//                   ),
//                   items: countryCodes.map((code) => DropdownMenuItem(
//                     value: code,
//                     child: Text(code, style: const TextStyle(fontFamily: "poppins_thin")),
//                   )).toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       _selectedCountryCode = value;
//                       print('Country Code Dropdown changed to: $_selectedCountryCode');
//                     });
//                   },
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: TextFormField(
//                   decoration: InputDecoration(
//                     labelText: "Mobile No.",
//                     labelStyle: const TextStyle(fontFamily: "poppins_thin"),
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
//                   ),
//                   keyboardType: TextInputType.phone,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           TextFormField(
//             decoration: InputDecoration(
//               labelText: "Full Name",
//               labelStyle: const TextStyle(fontFamily: "poppins_thin"),
//               border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
//             ),
//           ),
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               Expanded(
//                 child: DropdownButton2(
//                   isExpanded: true,
//                   hint: const Text('Area', style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: "poppins_thin")),
//                   value: _selectedArea,
//                   buttonStyleData: ButtonStyleData(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(18),
//                       color: Colors.grey.shade200,
//                       boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4, spreadRadius: 2)],
//                     ),
//                   ),
//                   underline: const SizedBox(),
//                   dropdownStyleData: DropdownStyleData(
//                     decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 2)),
//                     elevation: 10,
//                   ),
//                   items: areas.map((area) => DropdownMenuItem(
//                     value: area,
//                     child: Text(area, style: const TextStyle(fontFamily: "poppins_thin")),
//                   )).toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       _selectedArea = value;
//                       print('Area Dropdown changed to: $_selectedArea');
//                     });
//                   },
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: DropdownButton2(
//                   isExpanded: true,
//                   hint: const Text('City', style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: "poppins_thin")),
//                   value: _selectedCity,
//                   buttonStyleData: ButtonStyleData(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(18),
//                       color: Colors.grey.shade200,
//                       boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4, spreadRadius: 2)],
//                     ),
//                   ),
//                   underline: const SizedBox(),
//                   dropdownStyleData: DropdownStyleData(
//                     decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 2)),
//                     elevation: 10,
//                   ),
//                   items: cities.map((city) => DropdownMenuItem(
//                     value: city,
//                     child: Text(city, style: const TextStyle(fontFamily: "poppins_thin")),
//                   )).toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       _selectedCity = value;
//                       print('City Dropdown changed to: $_selectedCity');
//                     });
//                   },
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           TextFormField(
//             decoration: InputDecoration(
//               labelText: "House",
//               labelStyle: const TextStyle(fontFamily: "poppins_thin"),
//               border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
//             ),
//           ),
//           const SizedBox(height: 10),
//           TextFormField(
//             decoration: InputDecoration(
//               labelText: "Society",
//               labelStyle: const TextStyle(fontFamily: "poppins_thin"),
//               border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
//             ),
//           ),
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               SizedBox(
//                 width: 80,
//                 child: DropdownButton2(
//                   isExpanded: true,
//                   hint: const Text('+91', style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: "poppins_thin")),
//                   value: _selectedCountryCode,
//                   buttonStyleData: ButtonStyleData(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(18),
//                       color: Colors.grey.shade200,
//                       boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4, spreadRadius: 2)],
//                     ),
//                   ),
//                   underline: const SizedBox(),
//                   dropdownStyleData: DropdownStyleData(
//                     decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 2)),
//                     elevation: 10,
//                   ),
//                   items: countryCodes.map((code) => DropdownMenuItem(
//                     value: code,
//                     child: Text(code, style: const TextStyle(fontFamily: "poppins_thin")),
//                   )).toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       _selectedCountryCode = value;
//                       print('Alt Country Code Dropdown changed to: $_selectedCountryCode');
//                     });
//                   },
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: TextFormField(
//                   decoration: InputDecoration(
//                     labelText: "Alt. Mobile No.",
//                     labelStyle: const TextStyle(fontFamily: "poppins_thin"),
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
//                   ),
//                   keyboardType: TextInputType.phone,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           TextFormField(
//             decoration: InputDecoration(
//               labelText: "Email Address",
//               labelStyle: const TextStyle(fontFamily: "poppins_thin"),
//               border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
//             ),
//             keyboardType: TextInputType.emailAddress, // Corrected from phone
//           ),
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               Expanded(
//                 child: TextFormField(
//                   controller: _dobController,
//                   decoration: InputDecoration(
//                     labelText: "Date of Birth",
//                     labelStyle: const TextStyle(fontFamily: "poppins_thin"),
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                     suffixIcon: const Icon(Icons.calendar_today),
//                   ),
//                   readOnly: true,
//                   onTap: () async {
//                     DateTime? picked = await showDatePicker(
//                       context: context,
//                       initialDate: DateTime.now(),
//                       firstDate: DateTime(1900),
//                       lastDate: DateTime.now(),
//                     );
//                     if (picked != null) {
//                       setState(() {
//                         dateOfBirth = picked;
//                         _dobController.text = DateFormat('dd/MM/yyyy').format(dateOfBirth!);
//                         print('Date of Birth changed to: $dateOfBirth');
//                       });
//                     }
//                   },
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: TextFormField(
//                   controller: _anniversaryController,
//                   decoration: InputDecoration(
//                     labelText: "Anniversary Date",
//                     labelStyle: const TextStyle(fontFamily: "poppins_thin"),
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                     suffixIcon: const Icon(Icons.calendar_today),
//                   ),
//                   readOnly: true,
//                   onTap: () async {
//                     DateTime? picked = await showDatePicker(
//                       context: context,
//                       initialDate: DateTime.now(),
//                       firstDate: DateTime(1900),
//                       lastDate: DateTime(2100),
//                     );
//                     if (picked != null) {
//                       setState(() {
//                         anniversaryDate = picked;
//                         _anniversaryController.text = DateFormat('dd/MM/yyyy').format(anniversaryDate!);
//                         print('Anniversary Date changed to: $anniversaryDate');
//                       });
//                     }
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCSTInterestSection(
//       BuildContext context,
//       List<String> areas,
//       List<String> intSites,
//       List<String> budgets,
//       List<String> purposes,
//       List<String> apxTimes,
//       List<String> propertyConfigurations,
//       List<String> inquirySources,
//       ) {
//     return Padding(
//       padding: const EdgeInsets.all(14.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(height: 16),
//           DropdownButton2(
//             isExpanded: true,
//             hint: const Text('Int Area*', style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: "poppins_thin")),
//             value: _selectedArea,
//             buttonStyleData: ButtonStyleData(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(18),
//                 color: Colors.grey.shade200,
//                 boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4, spreadRadius: 2)],
//               ),
//             ),
//             underline: const SizedBox(),
//             dropdownStyleData: DropdownStyleData(
//               decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 2)),
//               elevation: 10,
//             ),
//             items: areas.map((area) => DropdownMenuItem(
//               value: area,
//               child: Text(area, style: const TextStyle(fontFamily: "poppins_thin")),
//             )).toList(),
//             onChanged: (value) {
//               setState(() {
//                 _selectedArea = value;
//                 print('Int Area Dropdown changed to: $_selectedArea');
//               });
//             },
//           ),
//           const SizedBox(height: 16),
//           DropdownButton2(
//             isExpanded: true,
//             hint: const Text('Int Site*', style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: "poppins_thin")),
//             value: _selectedIntSite,
//             buttonStyleData: ButtonStyleData(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(18),
//                 color: Colors.grey.shade200,
//                 boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4, spreadRadius: 2)],
//               ),
//             ),
//             underline: const SizedBox(),
//             dropdownStyleData: DropdownStyleData(
//               decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 2)),
//               elevation: 10,
//             ),
//             items: intSites.map((site) => DropdownMenuItem(
//               value: site,
//               child: Text(site, style: const TextStyle(fontFamily: "poppins_thin")),
//             )).toList(),
//             onChanged: (value) {
//               setState(() {
//                 _selectedIntSite = value;
//                 print('Int Site Dropdown changed to: $_selectedIntSite');
//               });
//             },
//           ),
//           const SizedBox(height: 16),
//           DropdownButton2(
//             isExpanded: true,
//             hint: const Text('Budget(In Lac)*', style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: "poppins_thin")),
//             value: _selectedBudget,
//             buttonStyleData: ButtonStyleData(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(18),
//                 color: Colors.grey.shade200,
//                 boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4, spreadRadius: 2)],
//               ),
//             ),
//             underline: const SizedBox(),
//             dropdownStyleData: DropdownStyleData(
//               decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 2)),
//               elevation: 10,
//             ),
//             items: budgets.map((budget) => DropdownMenuItem(
//               value: budget,
//               child: Text(budget, style: const TextStyle(fontFamily: "poppins_thin")),
//             )).toList(),
//             onChanged: (value) {
//               setState(() {
//                 _selectedBudget = value;
//                 print('Budget Dropdown changed to: $_selectedBudget');
//               });
//             },
//           ),
//           const SizedBox(height: 16),
//           DropdownButton2(
//             isExpanded: true,
//             hint: const Text('Purpose of Buying*', style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: "poppins_thin")),
//             value: _selectedPurpose,
//             buttonStyleData: ButtonStyleData(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(18),
//                 color: Colors.grey.shade200,
//                 boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4, spreadRadius: 2)],
//               ),
//             ),
//             underline: const SizedBox(),
//             dropdownStyleData: DropdownStyleData(
//               decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 2)),
//               elevation: 10,
//             ),
//             items: purposes.map((purpose) => DropdownMenuItem(
//               value: purpose,
//               child: Text(purpose, style: const TextStyle(fontFamily: "poppins_thin")),
//             )).toList(),
//             onChanged: (value) {
//               setState(() {
//                 _selectedPurpose = value;
//                 print('Purpose Dropdown changed to: $_selectedPurpose');
//               });
//             },
//           ),
//           const SizedBox(height: 16),
//           DropdownButton2(
//             isExpanded: true,
//             hint: const Text('Apx Buying Time*', style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: "poppins_thin")),
//             value: _selectedApxTime,
//             buttonStyleData: ButtonStyleData(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(18),
//                 color: Colors.grey.shade200,
//                 boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4, spreadRadius: 2)],
//               ),
//             ),
//             underline: const SizedBox(),
//             dropdownStyleData: DropdownStyleData(
//               decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 2)),
//               elevation: 10,
//             ),
//             items: apxTimes.map((time) => DropdownMenuItem(
//               value: time,
//               child: Text(time, style: const TextStyle(fontFamily: "poppins_thin")),
//             )).toList(),
//             onChanged: (value) {
//               setState(() {
//                 _selectedApxTime = value;
//                 print('Apx Buying Time Dropdown changed to: $_selectedApxTime');
//               });
//             },
//           ),
//           const SizedBox(height: 16),
//           DropdownButton2(
//             isExpanded: true,
//             hint: const Text('Property Configuration*', style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: "poppins_thin")),
//             value: _selectedPropertyConfiguration,
//             buttonStyleData: ButtonStyleData(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(18),
//                 color: Colors.grey.shade200,
//                 boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4, spreadRadius: 2)],
//               ),
//             ),
//             underline: const SizedBox(),
//             dropdownStyleData: DropdownStyleData(
//               decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 2)),
//               elevation: 10,
//             ),
//             items: propertyConfigurations.map((config) => DropdownMenuItem(
//               value: config,
//               child: Text(config, style: const TextStyle(fontFamily: "poppins_thin")),
//             )).toList(),
//             onChanged: (value) {
//               setState(() {
//                 _selectedPropertyConfiguration = value;
//                 print('Property Configuration Dropdown changed to: $_selectedPropertyConfiguration');
//               });
//             },
//           ),
//           const SizedBox(height: 15),
//           DropdownButton2(
//             isExpanded: true,
//             hint: const Text('Inq Source*', style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: "poppins_thin")),
//             value: _selectedInqSource,
//             buttonStyleData: ButtonStyleData(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(18),
//                 color: Colors.grey.shade200,
//                 boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4, spreadRadius: 2)],
//               ),
//             ),
//             underline: const SizedBox(),
//             dropdownStyleData: DropdownStyleData(
//               decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 2)),
//               elevation: 10,
//             ),
//             items: inquirySources.map((source) => DropdownMenuItem(
//               value: source,
//               child: Text(source, style: const TextStyle(fontFamily: "poppins_thin")),
//             )).toList(),
//             onChanged: (value) {
//               setState(() {
//                 _selectedInqSource = value;
//                 print('Inq Source Dropdown changed to: $_selectedInqSource');
//               });
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInquiryInformationSection(List<String> inquiryTypes, List<String> inquirySources) {
//     return Padding(
//       padding: const EdgeInsets.all(18.0),
//       child: Column(
//         children: [
//           DropdownButton2(
//             isExpanded: true,
//             hint: const Text('Inquiry Type', style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: "poppins_thin")),
//             value: _selectedInquiryType,
//             buttonStyleData: ButtonStyleData(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(18),
//                 color: Colors.grey.shade200,
//                 boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4, spreadRadius: 2)],
//               ),
//             ),
//             underline: const SizedBox(),
//             dropdownStyleData: DropdownStyleData(
//               decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 2)),
//               elevation: 10,
//             ),
//             items: inquiryTypes.map((type) => DropdownMenuItem(
//               value: type,
//               child: Text(type, style: const TextStyle(fontFamily: "poppins_thin")),
//             )).toList(),
//             onChanged: (value) {
//               setState(() {
//                 _selectedInquiryType = value;
//                 print('Inquiry Type Dropdown changed to: $_selectedInquiryType');
//               });
//             },
//           ),
//           const SizedBox(height: 16),
//           DropdownButton2(
//             isExpanded: true,
//             hint: const Text('Inq Source', style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: "poppins_thin")),
//             value: _selectedInqSource,
//             buttonStyleData: ButtonStyleData(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(18),
//                 color: Colors.grey.shade200,
//                 boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4, spreadRadius: 2)],
//               ),
//             ),
//             underline: const SizedBox(),
//             dropdownStyleData: DropdownStyleData(
//               decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 2)),
//               elevation: 10,
//             ),
//             items: inquirySources.map((source) => DropdownMenuItem(
//               value: source,
//               child: Text(source, style: const TextStyle(fontFamily: "poppins_thin")),
//             )).toList(),
//             onChanged: (value) {
//               setState(() {
//                 _selectedInqSource = value;
//                 print('Inq Source Dropdown changed to: $_selectedInqSource');
//               });
//             },
//           ),
//           const SizedBox(height: 16),
//           if (widget.isEdit == false)
//             TextFormField(
//               controller: _dateController,
//               decoration: InputDecoration(
//                 labelText: "Next Follow Up",
//                 labelStyle: const TextStyle(fontFamily: "poppins_thin"),
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                 suffixIcon: const Icon(Icons.calendar_today),
//               ),
//               readOnly: true,
//               onTap: () async {
//                 DateTime? picked = await showDatePicker(
//                   context: context,
//                   initialDate: DateTime.now(),
//                   firstDate: DateTime(2000),
//                   lastDate: DateTime(2100),
//                 );
//                 if (picked != null) {
//                   setState(() {
//                     nextFollowUp = picked;
//                     _dateController.text = DateFormat('yyyy-MM-dd').format(nextFollowUp!);
//                     print('Next Follow Up changed to: $nextFollowUp');
//                   });
//                 }
//               },
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildFollowUpSection() {
//     return Padding(
//       padding: const EdgeInsets.all(18.0),
//       child: TextFormField(
//         decoration: InputDecoration(
//           labelText: "Description",
//           labelStyle: const TextStyle(fontFamily: "poppins_thin"),
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//         ),
//         maxLines: 3,
//       ),
//     );
//   }
// }
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../Provider/UserProvider.dart';
import '../../Inquiry Management Screens/all_inquiries_Screen.dart';
import '../../test.dart';
import '../Colors/app_Colors.dart';
import 'custom_buttons.dart';

class AddLeadScreen extends StatefulWidget {
  final bool? isEdit;
  AddLeadScreen({super.key, this.isEdit});

  @override
  _AddLeadScreenState createState() => _AddLeadScreenState();
}

class _AddLeadScreenState extends State<AddLeadScreen> {
  int _currentStep = 0;
  String? _selectedCountryCode;
  String? _selectedArea;
  String? _selectedCity;
  String? _selectedInquiryType;
  String? _selectedInqSource;
  String? _selectedIntSite;
  String? _selectedBudget;
  String? _selectedPurpose;
  String? _selectedApxTime;
  String? _selectedPropertyConfiguration;

  bool _isCSTInterestVisible = false;
  String? _selectedCSTType = 'Service';
  String? selectedBuyingTime;
  String? selectedDuration;
  DateTime? dateOfBirth;
  DateTime? anniversaryDate;
  DateTime? nextFollowUp;
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _anniversaryController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String selectedType = "Service";
  String? selectedProduct;
  String? selectedService;
  String approxBuying = "";
  String serviceDuration = "";

  final List<String> _steps = ["Personal Info", "CST & Inquiry", "Follow Up"];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.fetchAddLeadData().then((_) {
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEdit == true ? "Edit Lead" : "Add Lead",
          style: const TextStyle(
              fontFamily: "poppins_thin", color: Colors.white, fontSize: 20),
        ),
        backgroundColor: AppColor.MainColor,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (userProvider.isLoadingDropdown) {
            return const Center(child: CircularProgressIndicator());
          }

          final dropdownData = userProvider.dropdownData;
          if (dropdownData == null) {
            print("Dropdown data is null");
            return const Center(child: Text("Failed to load dropdown options"));
          }

          // Fetch API data for all dropdowns
          final List<String> countryCodeOptions = ['+1', '+44', '+91']; // Hardcoded since not in API
          final List<String> areaOptions = (dropdownData.areaCityCountry ?? [])
              .map<String>((area) => area.area)
              .where((area) => area.trim().isNotEmpty)
              .toSet()
              .toList();
          final List<String> cityOptions = (dropdownData.areaCityCountry ?? [])
              .map<String>((city) => city.city)
              .where((city) => city.trim().isNotEmpty)
              .toSet()
              .toList();
          final List<String> inquiryTypeOptions = (dropdownData.inqType ?? [])
              .map<String>((inq) => inq.inquiryDetails)
              .where((type) => type.trim().isNotEmpty)
              .toSet()
              .toList();
          final List<String> inquirySourceOptions = (dropdownData.inqSource ?? [])
              .map<String>((source) => source.source)
              .where((source) => source.trim().isNotEmpty)
              .toSet()
              .toList();
          final List<String> intSiteOptions = (dropdownData.intSite ?? [])
              .map<String>((site) => site.productName)
              .where((site) => site.trim().isNotEmpty)
              .toSet()
              .toList();
          final List<String> budgetOptions = dropdownData.budget?.values
              .split(',')
              .map<String>((value) => value.trim())
              .where((value) => value.isNotEmpty)
              .toSet()
              .toList() ??
              [];
          final List<String> purposeOptions = dropdownData.purposeOfBuying != null
          ? [
          dropdownData.purposeOfBuying!.investment,
              dropdownData.purposeOfBuying!.personalUse
          ].where((purpose) => purpose.trim().isNotEmpty).toList()
              : [];
          final List<String> apxTimeOptions = dropdownData.apxTime?.apxTimeData
              .split(',')
              .map<String>((time) => time.trim())
              .where((time) => time.isNotEmpty)
              .toSet()
              .toList() ??
          [];
          final List<String> propertyConfigurationOptions =
          (dropdownData.propertyConfiguration ?? [])
              .map<String>((prop) => prop.propertyType)
              .where((config) => config.trim().isNotEmpty)
              .toSet()
              .toList();

          // Debug prints
          print("Country Codes: $countryCodeOptions");
          print("Areas: $areaOptions");
          print("Cities: $cityOptions");
          print("Inquiry Types: $inquiryTypeOptions");
          print("Inquiry Sources: $inquirySourceOptions");
          print("Int Sites: $intSiteOptions");
          print("Budgets: $budgetOptions");
          print("Purposes: $purposeOptions");
          print("Apx Times: $apxTimeOptions");
          print("Property Configurations: $propertyConfigurationOptions");

          return Column(
          children: [
          Expanded(
          child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildFormContent(
          countryCodeOptions,
          areaOptions,
          cityOptions,
          inquiryTypeOptions,
          inquirySourceOptions,
          intSiteOptions,
          budgetOptions,
          purposeOptions,
          apxTimeOptions,
          propertyConfigurationOptions,
          ),
          ),
          ),
          Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
          mainAxisAlignment: _currentStep == 0
          ? MainAxisAlignment.end
              : MainAxisAlignment.spaceBetween,
          children: [
          if (_currentStep > 0)
          GradientButton(
          buttonText: "",
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          width: 40.0,
          onPressed: _goToPreviousStep,
          ),
          GradientButton(
          buttonText: _currentStep == _steps.length - 1 ? "Submit" : "Next",
          width: 120.0,
          onPressed: _currentStep == _steps.length - 1
          ? () {
          Navigator.pop(
          context,
          MaterialPageRoute(
          builder: (context) => const AllInquiriesScreen(),
          ),
          );
          }
              : _goToNextStep,
          ),
          ],
          ),
          ),
          ],
          );
        },
      ),
    );
  }

  Widget _buildFormContent(
      List<String> countryCodeOptions,
      List<String> areaOptions,
      List<String> cityOptions,
      List<String> inquiryTypeOptions,
      List<String> inquirySourceOptions,
      List<String> intSiteOptions,
      List<String> budgetOptions,
      List<String> purposeOptions,
      List<String> apxTimeOptions,
      List<String> propertyConfigurationOptions,
      ) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_currentStep == 0) ...[
              const Text(
                "Personal Inquiry",
                style: TextStyle(fontSize: 24, fontFamily: "poppins_thin"),
              ),
              Card(
                child: _buildPersonalInquirySection(
                  countryCodeOptions,
                  areaOptions,
                  cityOptions,
                ),
              ),
            ],
            if (_currentStep == 1) ...[
              const Text(
                "CST Interest",
                style: TextStyle(fontSize: 24, fontFamily: "poppins_thin"),
              ),
              Card(
                child: _buildCSTInterestSection(
                  context,
                  areaOptions,
                  intSiteOptions,
                  budgetOptions,
                  purposeOptions,
                  apxTimeOptions,
                  propertyConfigurationOptions,
                  inquirySourceOptions,
                ),
              ),
            ],
            if (_currentStep == 2) ...[
              const SizedBox(height: 16),
              const Text(
                "Inquiry Information",
                style: TextStyle(fontSize: 24, fontFamily: "poppins_thin"),
              ),
              Card(
                child: _buildInquiryInformationSection(
                  inquiryTypeOptions,
                  inquirySourceOptions,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                "Follow up",
                style: TextStyle(fontSize: 24, fontFamily: "poppins_thin"),
              ),
              Card(child: _buildFollowUpSection()),
            ],
          ],
        ),
      ),
    );
  }

  void _goToNextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
        print("Navigating to next step: $_currentStep");
      });
    }
  }

  void _goToPreviousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
        print("Navigating to previous step: $_currentStep");
      });
    }
  }

  Widget _buildPersonalInquirySection(
      List<String> countryCodeOptions,
      List<String> areaOptions,
      List<String> cityOptions,
      ) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 90,
                child: CombinedDropdownTextField(
                  options: countryCodeOptions,
                  onSelected: (String value) {
                    setState(() {
                      _selectedCountryCode = value;
                      print('Country Code selected: $_selectedCountryCode');
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Mobile No.",
                    labelStyle: const TextStyle(fontFamily: "poppins_thin"),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Full Name",
                    labelStyle: const TextStyle(fontFamily: "poppins_thin"),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CombinedDropdownTextField(
                  options: areaOptions,
                  onSelected: (String value) {
                    setState(() {
                      _selectedArea = value;
                      print('Area selected: $_selectedArea');
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CombinedDropdownTextField(
                  options: cityOptions,
                  onSelected: (String value) {
                    setState(() {
                      _selectedCity = value;
                      print('City selected: $_selectedCity');
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: "House",
                  labelStyle: const TextStyle(fontFamily: "poppins_thin"),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Society",
                  labelStyle: const TextStyle(fontFamily: "poppins_thin"),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                width: 80,
                child: CombinedDropdownTextField(
                  options: countryCodeOptions,
                  onSelected: (String value) {
                    setState(() {
                      _selectedCountryCode = value;
                      print('Alt Country Code selected: $_selectedCountryCode');
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Alt. Mobile No.",
                    labelStyle: const TextStyle(fontFamily: "poppins_thin"),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Email Address",
                  labelStyle: const TextStyle(fontFamily: "poppins_thin"),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
                keyboardType: TextInputType.emailAddress, // Fixed from phone
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Society",
                  labelStyle: const TextStyle(fontFamily: "poppins_thin"),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _dobController,
                  decoration: InputDecoration(
                    labelText: "Date of Birth",
                    labelStyle: const TextStyle(fontFamily: "poppins_thin"),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        dateOfBirth = picked;
                        _dobController.text = DateFormat('dd/MM/yyyy').format(dateOfBirth!);
                        print('Date of Birth changed to: $dateOfBirth');
                      });
                    }
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: _anniversaryController,
                  decoration: InputDecoration(
                    labelText: "Anniversary Date",
                    labelStyle: const TextStyle(fontFamily: "poppins_thin"),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() {
                        anniversaryDate = picked;
                        _anniversaryController.text =
                            DateFormat('dd/MM/yyyy').format(anniversaryDate!);
                        print('Anniversary Date changed to: $anniversaryDate');
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCSTInterestSection(
      BuildContext context,
      List<String> areaOptions,
      List<String> intSiteOptions,
      List<String> budgetOptions,
      List<String> purposeOptions,
      List<String> apxTimeOptions,
      List<String> propertyConfigurationOptions,
      List<String> inquirySourceOptions,
      ) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Int Area*",
                            style:
                            TextStyle(fontSize: 16, fontFamily: "poppins_thin")),
                        CombinedDropdownTextField(
                          options: areaOptions,
                          onSelected: (String selectedArea) {
                            setState(() {
                              _selectedArea = selectedArea;
                              print('Int Area selected: $_selectedArea');
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Int Site*",
                      style: TextStyle(fontSize: 16, fontFamily: "poppins_thin")),
                  CombinedDropdownTextField(
                    options: intSiteOptions,
                    onSelected: (String selectedIntSite) {
                      setState(() {
                        _selectedIntSite = selectedIntSite;
                        print('Int Site selected: $_selectedIntSite');
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Budget(In Lac)*",
                        style: TextStyle(fontSize: 16, fontFamily: "poppins_thin")),
                    CombinedDropdownTextField(
                      options: budgetOptions,
                      onSelected: (String selectedBudget) {
                        setState(() {
                          _selectedBudget = selectedBudget;
                          print('Budget selected: $_selectedBudget');
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Purpose of Buying*",
                  style: TextStyle(fontSize: 16, fontFamily: "poppins_thin")),
              CombinedDropdownTextField(
                options: purposeOptions,
                onSelected: (String selectedPurpose) {
                  setState(() {
                    _selectedPurpose = selectedPurpose;
                    print('Purpose selected: $_selectedPurpose');
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Apx Buying Time : *",
                        style: TextStyle(fontSize: 16, fontFamily: "poppins_thin")),
                    CombinedDropdownTextField(
                      options: apxTimeOptions,
                      onSelected: (String selectedApxTime) {
                        setState(() {
                          _selectedApxTime = selectedApxTime;
                          print('Apx Buying Time selected: $_selectedApxTime');
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Property Configuration*",
                  style: TextStyle(fontSize: 16, fontFamily: "poppins_thin")),
              CombinedDropdownTextField(
                options: propertyConfigurationOptions,
                onSelected: (String selectedPropertyConfiguration) {
                  setState(() {
                    _selectedPropertyConfiguration = selectedPropertyConfiguration;
                    print('Property Configuration selected: $_selectedPropertyConfiguration');
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Inq Source*",
                  style: TextStyle(fontSize: 16, fontFamily: "poppins_thin")),
              CombinedDropdownTextField(
                options: inquirySourceOptions,
                onSelected: (String selectedInqSource) {
                  setState(() {
                    _selectedInqSource = selectedInqSource;
                    print('Inq Source selected: $_selectedInqSource');
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInquiryInformationSection(
      List<String> inquiryTypeOptions,
      List<String> inquirySourceOptions,
      ) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Center(
        child: Column(
          children: [
            CombinedDropdownTextField(
              options: inquiryTypeOptions,
              onSelected: (String value) {
                setState(() {
                  _selectedInquiryType = value;
                  print('Inquiry Type selected: $_selectedInquiryType');
                });
              },
            ),
            const SizedBox(height: 16),
            CombinedDropdownTextField(
              options: inquirySourceOptions,
              onSelected: (String value) {
                setState(() {
                  _selectedInqSource = value;
                  print('Inq Source selected: $_selectedInqSource');
                });
              },
            ),
            const SizedBox(height: 16),
            widget.isEdit == false
                ? TextFormField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: "Next Follow Up",
                labelStyle: const TextStyle(fontFamily: "poppins_thin"),
                border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
                    _dateController.text =
                        DateFormat('yyyy-MM-dd').format(nextFollowUp!);
                    print('Next Follow Up changed to: $nextFollowUp');
                  });
                }
              },
            )
                : const SizedBox(height: 0),
          ],
        ),
      ),
    );
  }

  Widget _buildFollowUpSection() {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: "Description",
          labelStyle: const TextStyle(fontFamily: "poppins_thin"),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        maxLines: 3,
      ),
    );
  }
}

class CombinedDropdownTextField extends StatefulWidget {
  final List<String> options;
  final Function(String) onSelected;

  const CombinedDropdownTextField({
    super.key,
    required this.options,
    required this.onSelected,
  });

  @override
  State<CombinedDropdownTextField> createState() =>
      _CombinedDropdownTextFieldState();
}

class _CombinedDropdownTextFieldState extends State<CombinedDropdownTextField> {
  final TextEditingController _controller = TextEditingController();
  bool _isDropdownVisible = false;
  List<String> _filteredOptions = [];
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _hideOverlay();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isDropdownVisible = _focusNode.hasFocus;
      if (_isDropdownVisible) {
        _showOverlay(context);
      } else {
        _hideOverlay();
      }
    });
  }

  void _filterOptions(String query) {
    setState(() {
      _filteredOptions = widget.options
          .where((option) => option.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _selectOption(String option) {
    setState(() {
      _controller.text = option;
      _filteredOptions = [];
      _isDropdownVisible = false;
    });
    widget.onSelected(option);
    _focusNode.unfocus();
    _hideOverlay();
  }

  void _showOverlay(BuildContext context) {
    if (_overlayEntry != null) return;

    final overlayState = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 5.0),
          child: Card(
            elevation: 4,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _filteredOptions.length,
                itemBuilder: (context, index) {
                  final option = _filteredOptions[index];
                  return InkWell(
                    onTap: () => _selectOption(option),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(option),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    overlayState.insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _controller,
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: 'Select or Type',
              hintStyle: const TextStyle(fontFamily: "poppins_light"),
              border: const OutlineInputBorder(),
              suffixIcon: _isDropdownVisible
                  ? IconButton(
                icon: const Icon(Icons.arrow_drop_up),
                onPressed: () {
                  setState(() {
                    _isDropdownVisible = false;
                    _focusNode.unfocus();
                    _hideOverlay();
                  });
                },
              )
                  : IconButton(
                icon: const Icon(Icons.arrow_drop_down),
                onPressed: () {
                  setState(() {
                    _isDropdownVisible = true;
                    _focusNode.requestFocus();
                    _filterOptions(_controller.text);
                    _showOverlay(context);
                  });
                },
              ),
            ),
            onChanged: _filterOptions,
            onTap: () {
              setState(() {
                _isDropdownVisible = true;
                _focusNode.requestFocus();
                _filterOptions(_controller.text);
                _showOverlay(context);
              });
            },
          ),
        ],
      ),
    );
  }
}
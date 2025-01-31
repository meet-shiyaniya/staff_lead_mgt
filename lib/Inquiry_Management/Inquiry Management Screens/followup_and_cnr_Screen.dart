// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:flutter/material.dart';
// import 'package:inquiry_management_ui/Utils/Colors/app_Colors.dart';
// import 'package:inquiry_management_ui/Utils/Custom%20widgets/add_lead_Screen.dart';
// import 'package:inquiry_management_ui/Utils/Custom%20widgets/custom_screen.dart';
// import 'package:inquiry_management_ui/Utils/Custom%20widgets/custom_search.dart';
// import 'package:inquiry_management_ui/Utils/Custom%20widgets/quotation_Screen.dart';
// import 'package:intl/intl.dart';
// import 'package:lottie/lottie.dart';
//
// import '../Model/followup_Model.dart';
// import '../Utils/Custom widgets/custom_buttons.dart';
// import '../Utils/Custom widgets/custom_dialog.dart';
// import 'Followups Timing Screen/timing_Screen.dart';
//
// class FollowupAndCnrScreen extends StatefulWidget {
//   const FollowupAndCnrScreen({super.key});
//
//   @override
//   State<FollowupAndCnrScreen> createState() => _FollowupAndCnrScreenState();
// }
//
// class _FollowupAndCnrScreenState extends State<FollowupAndCnrScreen> {
//   String selectedMainFilter = "Today's Followup";
//   int selectedIndex = 0;
//   int CnrselectedIndex = 0;
//   bool isSelectionMode = false;
//   bool isCnrSelectionMode = false;
//
//   String selectedcallFilter = "Follow Up";
//   List<String> callList=['Followup','Dismissed','Appointment','Negotiation','Feedback','Cnr'];
//
//   Map<int, Set<int>> selectedItemsPerFilter = {};
//   Map<int, Set<int>> CnrselectedItemsPerFilter = {};
//
//   String? selectedAction;
//   String? selectedEmployee;
//
//   String? selectedMembership;
//   String? selectedApx;
//   String? selectedPurpose;
//   String? selectedTime;
//
//
//   final List<Task> tasks = [
//     Task(
//       time: "10 am - 11 am",
//       leads: 60,
//       color: Colors.deepPurple.shade200,
//     ),
//     Task(
//       time: "11 am - 12 pm",
//       leads: 75,
//       color: Colors.deepPurple.shade200,
//     ),
//     Task(
//       time: "12 pm - 01 pm",
//       leads: 30,
//       color: Colors.deepPurple.shade200,
//     ),
//     Task(
//       time: "01 pm - 02 pm",
//       leads: 60,
//       color: Colors.deepPurple.shade200,
//     ),
//     Task(
//       time: "03 pm - 04 pm",
//       leads: 75,
//       color: Colors.deepPurple.shade200,
//     ),
//     Task(
//       time: "04 pm - 05 pm",
//       leads: 30,
//       color: Colors.deepPurple.shade200,
//     ),
//   ];
//
//   final List<Map<String, dynamic>> items = [
//     {'label': 'Feedbacks', 'count': 2},
//     {'label': 'Negotiations', 'count': 4},
//     {'label': 'Appointment', 'count': 2},
//     {'label': 'Qualified', 'count': 4},
//     {'label': 'Fresh', 'count': 1},
//     {'label': 'All', 'count': 4},
//   ];
//
//   final List<Map<String, dynamic>> cnrList = [
//     {'label': 'Dismissed', 'count': 2},
//     {'label': 'Trail', 'count': 4},
//     {'label': 'Converted', 'count': 1},
//     {'label': 'Fresh', 'count': 2},
//     {'label': 'All', 'count': 4},
//     {'label': 'CNR', 'count': 1},
//   ];
//
//   List<FollowupData> followupDataList = [
//     FollowupData(
//       id: 1,
//       name: 'Aakash',
//       member: 'Ajasys Developer Use (Testing)',
//       inquiryType: 'Telephone',
//       dateTime: '04-01-2025 06:33 PM',
//       nextfollowup: '10-02-2025 08:30 PM',
//       services: 'IELTS(UK)',
//       product: 'bowl(steel)',
//       apxbuying: '10-15_days',
//       duration: '6-month',
//       label: 'Feedbacks',
//     ),
//     FollowupData(
//       id: 2,
//       name: 'Aakash',
//       member: 'Ajasys Developer Use (Testing)',
//       inquiryType: 'Telephone',
//       dateTime: '04-01-2025 06:33 PM',
//       nextfollowup: '10-02-2025 08:30 PM',
//       services: 'IELTS(UK)',
//       product: 'bowl(steel)',
//       apxbuying: '10-15_days',
//       duration: '6-month',
//       label: 'Negotiations',
//     ),
//     FollowupData(
//       id: 3,
//       name: 'Aakash',
//       member: 'Ajasys Developer Use (Testing)',
//       inquiryType: 'Telephone',
//       dateTime: '04-01-2025 06:33 PM',
//       nextfollowup: '10-02-2025 08:30 PM',
//       services: 'IELTS(UK)',
//       product: 'bowl(steel)',
//       apxbuying: '10-15_days',
//       duration: '6-month',
//       label: 'Trail',
//     ),
//     FollowupData(
//       id: 4,
//       name: 'Aakash',
//       member: 'Ajasys Developer Use (Testing)',
//       inquiryType: 'Telephone',
//       dateTime: '04-01-2025 06:33 PM',
//       nextfollowup: '10-02-2025 08:30 PM',
//       services: 'IELTS(UK)',
//       product: 'bowl(steel)',
//       apxbuying: '10-15_days',
//       duration: '6-month',
//       label: 'Appointment',
//     ),
//     FollowupData(
//       id: 5,
//       name: 'Aakash',
//       member: 'Ajasys Developer Use (Testing)',
//       inquiryType: 'Telephone',
//       dateTime: '04-01-2025 06:33 PM',
//       nextfollowup: '10-02-2025 08:30 PM',
//       services: 'IELTS(UK)',
//       product: 'bowl(steel)',
//       apxbuying: '10-15_days',
//       duration: '6-month',
//       label: 'Qualified',
//     ),
//     FollowupData(
//       id: 6,
//       name: 'Aakash',
//       member: 'Ajasys Developer Use (Testing)',
//       inquiryType: 'Telephone',
//       dateTime: '04-01-2025 06:33 PM',
//       nextfollowup: '10-02-2025 08:30 PM',
//       services: 'IELTS(UK)',
//       product: 'bowl(steel)',
//       apxbuying: '10-15_days',
//       duration: '6-month',
//       label: 'Fresh',
//     ),
//   ];
//
//   List<FollowupData> CNRdata = [
//     FollowupData(
//       id: 1,
//       name: 'Aakash',
//       member: 'Ajasys Developer Use (Testing)',
//       inquiryType: 'Telephone',
//       dateTime: '04-01-2025 06:33 PM',
//       nextfollowup: '10-02-2025 08:30 PM',
//       services: 'IELTS(UK)',
//       product: 'bowl(steel)',
//       apxbuying: '10-15_days',
//       duration: '6-month',
//       label: 'Dismissed',
//     ),
//     FollowupData(
//       id: 2,
//       name: 'Aakash',
//       member: 'Ajasys Developer Use (Testing)',
//       inquiryType: 'Telephone',
//       dateTime: '04-01-2025 06:33 PM',
//       nextfollowup: '10-02-2025 08:30 PM',
//       services: 'IELTS(UK)',
//       product: 'bowl(steel)',
//       apxbuying: '10-15_days',
//       duration: '6-month',
//       label: 'Trail',
//     ),
//     FollowupData(
//       id: 3,
//       name: 'Aakash',
//       member: 'Ajasys Developer Use (Testing)',
//       inquiryType: 'Telephone',
//       dateTime: '04-01-2025 06:33 PM',
//       nextfollowup: '10-02-2025 08:30 PM',
//       services: 'IELTS(UK)',
//       product: 'bowl(steel)',
//       apxbuying: '10-15_days',
//       duration: '6-month',
//       label: 'Converted',
//     ),
//     FollowupData(
//       id: 4,
//       name: 'Aakash',
//       member: 'Ajasys Developer Use (Testing)',
//       inquiryType: 'Telephone',
//       dateTime: '04-01-2025 06:33 PM',
//       nextfollowup: '10-02-2025 08:30 PM',
//       services: 'IELTS(UK)',
//       product: 'bowl(steel)',
//       apxbuying: '10-15_days',
//       duration: '6-month',
//       label: 'Fresh',
//     ),
//     FollowupData(
//       id: 5,
//       name: 'Aakash',
//       member: 'Ajasys Developer Use (Testing)',
//       inquiryType: 'Telephone',
//       dateTime: '04-01-2025 06:33 PM',
//       nextfollowup: '10-02-2025 08:30 PM',
//       services: 'IELTS(UK)',
//       product: 'bowl(steel)',
//       apxbuying: '10-15_days',
//       duration: '6-month',
//       label: 'All',
//     ),
//     FollowupData(
//       id: 6,
//       name: 'Aakash',
//       member: 'Ajasys Developer Use (Testing)',
//       inquiryType: 'Telephone',
//       dateTime: '04-01-2025 06:33 PM',
//       nextfollowup: '10-02-2025 08:30 PM',
//       services: 'IELTS(UK)',
//       product: 'bowl(steel)',
//       apxbuying: '10-15_days',
//       duration: '6-month',
//       label: 'CNR',
//     ),
//   ];
//
//
//   // final List<Map<String, String>> followupData = [
//   //   {
//   //     'name': 'Aakash',
//   //     'membership': 'Ajasys Developer Use (Testing)',
//   //     'inquiryType': 'Telephone',
//   //     'leadPurpose': 'Not Available',
//   //     'dateTime': '04-01-2025 06:33 PM',
//   //     'nextfollowup':'10-02-2025 08:30 PM',
//   //     'timeSpent': '0 mins',
//   //     'label': 'Feedbacks'
//   //   },
//   //   {
//   //     'name': 'Rahul',
//   //     'membership': 'Testing Membership',
//   //     'inquiryType': 'Email',
//   //     'leadPurpose': 'Demo Purpose',
//   //     'dateTime': '04-01-2025 09:06 AM',
//   //     'timeSpent': '15 mins',
//   //     'label': 'Feedbacks'
//   //   },
//   //   {
//   //     'name': 'Aakash',
//   //     'membership': 'Ajasys Developer Use (Testing)',
//   //     'inquiryType': 'Telephone',
//   //     'leadPurpose': 'Not Available',
//   //     'dateTime': '04-01-2025 06:33 PM',
//   //     'timeSpent': '0 mins',
//   //     'label': 'Negotiations'
//   //   },
//   //   {
//   //     'name': 'Rahul',
//   //     'membership': 'Testing Membership',
//   //     'inquiryType': 'Email',
//   //     'leadPurpose': 'Demo Purpose',
//   //     'dateTime': '04-01-2025 09:06 AM',
//   //     'timeSpent': '15 mins',
//   //     'label': 'Trail'
//   //   },
//   //   {
//   //     'name': 'Aakash',
//   //     'membership': 'Ajasys Developer Use (Testing)',
//   //     'inquiryType': 'Telephone',
//   //     'leadPurpose': 'Not Available',
//   //     'dateTime': '04-01-2025 06:33 PM',
//   //     'timeSpent': '0 mins',
//   //     'label': 'Appointment'
//   //   },
//   //   {
//   //     'name': 'Rahul',
//   //     'membership': 'Testing Membership',
//   //     'inquiryType': 'Email',
//   //     'leadPurpose': 'Demo Purpose',
//   //     'dateTime': '04-01-2025 09:06 AM',
//   //     'timeSpent': '15 mins',
//   //     'label': 'Appointment'
//   //   },
//   //   {
//   //     'name': 'Aakash',
//   //     'membership': 'Ajasys Developer Use (Testing)',
//   //     'inquiryType': 'Telephone',
//   //     'leadPurpose': 'Not Available',
//   //     'dateTime': '04-01-2025 06:33 PM',
//   //     'timeSpent': '0 mins',
//   //     'label': 'Qualified'
//   //   },
//   //   {
//   //     'name': 'Rahul',
//   //     'membership': 'Testing Membership',
//   //     'inquiryType': 'Email',
//   //     'leadPurpose': 'Demo Purpose',
//   //     'dateTime': '04-01-2025 09:06 AM',
//   //     'timeSpent': '15 mins',
//   //     'label': 'Fresh'
//   //   },
//   // ];
//
//   List<FollowupData> _filteredFollowupData() {
//     if (selectedIndex == items.length - 1) {
//       // If "All" is selected, return all data
//       return followupDataList;
//     }
//     final selectedLabel = items[selectedIndex]['label'];
//     return followupDataList
//         .where((data) => data.label == selectedLabel)
//         .toList();
//   }
//
//
//   List<FollowupData> _filteredCnrData() {
//     if (CnrselectedIndex == cnrList.length - 2) {
//       // If "All" is selected, return all data
//       return CNRdata;
//     }
//     final selectedLabel = cnrList[selectedIndex]['label'];
//     return CNRdata
//         .where((data) => data.label == selectedLabel)
//         .toList();
//   }
//   // List<Map<String, String>> _filteredCnrData() {
//   //   if (CnrselectedIndex == cnrList.length - 1) {
//   //     // If "All" is selected, return all data
//   //     return CNRdata;
//   //   }
//   //   final selectedLabel = cnrList[CnrselectedIndex]['label'];
//   //   return CNRData
//   //       .where((data) => data['label'] == selectedLabel)
//   //       .toList();
//   // }
//
//   Map<String, int> getLabelCount() {
//     Map<String, int> labelCount = {};
//
//     for (var data in CNRdata) {
//       String label = data.label!;
//       labelCount[label] = (labelCount[label] ?? 0) + 1;
//     }
//
//     // Add the total count for "All"
//     labelCount['All'] = CNRdata.length;
//
//     return labelCount;
//   }
//   Map<String, int> getPendingLabelCount() {
//     Map<String, int> PendinglabelCount = {};
//
//     // Iterate through the followupDataList to count labels
//     for (var data in followupDataList) {
//       String label = data.label;  // Access the label property from FollowupData
//       PendinglabelCount[label] = (PendinglabelCount[label] ?? 0) + 1;
//     }
//
//     // Add the total count for "All"
//     PendinglabelCount['All'] = followupDataList.length;
//
//     return PendinglabelCount;
//   }
//
//   void _onFilterChange(int index) {
//     setState(() {
//       _saveSelectedItems(selectedIndex, isSelectionMode);
//       selectedIndex = index;
//       isSelectionMode = _isSelectionModeActive(selectedIndex);
//     });
//   }
//
//   void _onCnrFilterChange(int index) {
//     setState(() {
//       _saveSelectedItems(CnrselectedIndex, isCnrSelectionMode, isCnr: true);
//       CnrselectedIndex = index;
//       isCnrSelectionMode = _isSelectionModeActive(CnrselectedIndex, isCnr: true);
//     });
//   }
//
//   void _saveSelectedItems(int filterIndex, bool isSelectionActive,
//       {bool isCnr = false}) {
//     if(isCnr){
//       if (CnrselectedItemsPerFilter.containsKey(filterIndex) && isSelectionActive) {
//         CnrselectedItemsPerFilter[filterIndex] =
//         CnrselectedItemsPerFilter[filterIndex]!;
//       } else if(isSelectionActive){
//         CnrselectedItemsPerFilter[filterIndex] = {};
//       }
//     }else{
//       if (selectedItemsPerFilter.containsKey(filterIndex) && isSelectionActive) {
//         selectedItemsPerFilter[filterIndex] =
//         selectedItemsPerFilter[filterIndex]!;
//       } else if(isSelectionActive){
//         selectedItemsPerFilter[filterIndex] = {};
//       }
//     }
//   }
//
//   bool _isSelectionModeActive(int filterIndex, {bool isCnr = false}) {
//     if(isCnr){
//       return CnrselectedItemsPerFilter.containsKey(filterIndex) && CnrselectedItemsPerFilter[filterIndex]!.isNotEmpty;
//     }else{
//       return selectedItemsPerFilter.containsKey(filterIndex) && selectedItemsPerFilter[filterIndex]!.isNotEmpty;
//     }
//
//   }
//
//
//
//
//   void handleAction(String action, String employee) {
//     print("Action: $action on items: $selectedItemsPerFilter");
//     setState(() {
//       selectedItemsPerFilter[selectedIndex]?.clear();
//       isSelectionMode = false;
//       selectedAction = null;
//       selectedEmployee=null;
//     });
//   }
//
//   void handleCnrAction(String action, String employee) {
//     print("Action: $action on items: $CnrselectedItemsPerFilter");
//     setState(() {
//       CnrselectedItemsPerFilter[CnrselectedIndex]?.clear();
//       isCnrSelectionMode = false;
//       selectedAction = null;
//       selectedEmployee=null;
//     });
//   }
//
//
//   final TextEditingController _idController = TextEditingController();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _mobileController = TextEditingController();
//   final TextEditingController _nextFollowUpController = TextEditingController();
//   final TextEditingController _fromDateController = TextEditingController();
//   final TextEditingController _toDateController = TextEditingController();
//   String? intProduct;
//   String? inquirystatus;
//   String? assignother;
//   String? inqtype;
//   String? intarea;
//   String? owner;
//   List<String> Items = [
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
//   List<String> selectedItems = [];
//
//   void showBottomModalSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (context) => Padding(
//         padding: EdgeInsets.only(
//           top: 16.0,
//           bottom: MediaQuery.of(context).viewInsets.bottom,
//         ),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min, // Ensure the column doesn't expand
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               AppBar(
//                 title: const Text("Filter",style: TextStyle(fontFamily: "poppins_thin",color: Colors.white,fontSize: 20),),
//                 backgroundColor: AppColor.MainColor,
//                 automaticallyImplyLeading: false,
//                 leading: IconButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   icon: Icon(Icons.arrow_back_ios, color: Colors.white),
//                 ),
//               ),
//               const SizedBox(height: 16),
//
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
//                 child: TextField(
//                   controller: _idController,
//                   decoration: InputDecoration(
//                     labelText: "Id",
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                   ),
//                 ),
//               ),
//
//               // Name Text Field
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
//                 child: TextField(
//                   controller: _nameController,
//                   decoration: InputDecoration(
//                     labelText: "Enter Name",
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                   ),
//                 ),
//               ),
//
//               // Mobile Number Text Field
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
//                 child: TextField(
//                   controller: _mobileController,
//                   decoration: InputDecoration(
//                     labelText: "Mobile No",
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                   ),
//                 ),
//               ),
//
//               // Next Follow Up Text Field
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
//                 child: TextField(
//                   controller: _nextFollowUpController,
//                   readOnly: true,
//                   decoration: InputDecoration(
//                     labelText: "Next Followup",
//                     border: OutlineInputBorder(),
//                     suffixIcon: IconButton(
//                       icon: Icon(Icons.calendar_today),
//                       onPressed: () async {
//                         DateTime? pickedDate = await showDatePicker(
//                           context: context,
//                           initialDate: DateTime.now(),
//                           firstDate: DateTime(2000),
//                           lastDate: DateTime(2101),
//                         );
//                         if (pickedDate != null) {
//                           setState(() {
//                             _nextFollowUpController.text = "${pickedDate.toLocal()}".split(' ')[0];
//                           });
//                         }
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//           Container(
//             width: double.infinity, // Ensures the field takes full width
//             padding: EdgeInsets.symmetric(horizontal: 8),
//             child: DropdownButtonHideUnderline(
//               child: DropdownButton2(
//                 isExpanded: true, // Makes dropdown take full width
//                 customButton: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8),
//                     color: Colors.grey.shade100,
//                     border: Border.all(color: Colors.black, width: 1),
//                   ),
//                   child: Text(
//                     selectedItems.isEmpty
//                         ? 'Inquiry Status'
//                         : selectedItems.join(', '), // Display selected items
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontFamily: "poppins_thin",
//                       color: Colors.black,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 dropdownStyleData: DropdownStyleData(
//                   maxHeight: 300,
//                   width: MediaQuery.of(context).size.width * 0.9, // Full-width dropdown
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.black, width: 2),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   elevation: 10,
//                 ),
//                 items: Items.map((item) {
//                   return DropdownMenuItem<String>(
//                     value: item,
//                     enabled: false, // Prevent direct selection
//                     child: StatefulBuilder(
//                       builder: (context, menuSetState) {
//                         final isSelected = selectedItems.contains(item);
//                         return InkWell(
//                           onTap: () {
//                             setState(() {
//                               if (isSelected) {
//                                 selectedItems.remove(item);
//                               } else {
//                                 selectedItems.add(item);
//                               }
//                             });
//                             menuSetState(() {}); // Rebuild menu state
//                           },
//                           child: Row(
//                             children: [
//                               Checkbox(
//                                 value: isSelected,
//                                 onChanged: (checked) {
//                                   setState(() {
//                                     if (checked!) {
//                                       selectedItems.add(item);
//                                     } else {
//                                       selectedItems.remove(item);
//                                     }
//                                   });
//                                   menuSetState(() {}); // Update menu UI
//                                 },
//                               ),
//                               SizedBox(width: 8),
//                               Text(
//                                 item,
//                                 style: TextStyle(fontFamily: "poppins_thin"),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                   );
//                 }).toList(),
//                 onChanged: (_) {}, // Required but unused
//                 iconStyleData: IconStyleData(
//                   icon: Icon(Icons.arrow_drop_down, color: Colors.black),
//                 ),
//               ),
//             ),
//           ),
//
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: DropdownButton2(
//               isExpanded: true, // Make the dropdown button take full width
//               hint: Text(
//                 'Int Product',
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 16,
//                   fontFamily: "poppins_thin",
//                 ),
//               ),
//               value: intProduct, // Selected value is displayed here
//               buttonStyleData: ButtonStyleData(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   color: Colors.grey.shade100,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.shade300,
//                       blurRadius: 4,
//                       spreadRadius: 2,
//                     ),
//                   ],
//                 ),
//               ),
//               underline: SizedBox.shrink(), // No underline
//               dropdownStyleData: DropdownStyleData(
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.black, width: 2),
//                 ),
//                 elevation: 10,
//               ),
//               items: [
//                 DropdownMenuItem(
//                   value: 'sofa',
//                   child: Row(
//                     children: [
//                       Text('Sofa(Still)', style: TextStyle(fontFamily: "poppins_thin")),
//                     ],
//                   ),
//                 ),
//                 DropdownMenuItem(
//                   value: 'bowl(steel)',
//                   child: Row(
//                     children: [
//                       Text('Bowl(steel)', style: TextStyle(fontFamily: "poppins_thin")),
//                     ],
//                   ),
//                 ),
//                 DropdownMenuItem(
//                   value: 'table',
//                   child: Row(
//                     children: [
//                       Text('Table(Wooden)', style: TextStyle(fontFamily: "poppins_thin")),
//                     ],
//                   ),
//                 ),
//               ],
//               onChanged: (value) {
//                 setState(() {
//                   intProduct = value as String?; // Update the selected value
//                 });
//               },
//             ),
//           ),
//
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: DropdownButton2(
//               isExpanded: true, // Make the dropdown button take full width
//               hint: Text(
//                 'Assign To',
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 16,
//                   fontFamily: "poppins_thin",
//                 ),
//               ),
//               value: assignother, // Selected value is displayed here
//               buttonStyleData: ButtonStyleData(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   color: Colors.grey.shade100,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.shade300,
//                       blurRadius: 4,
//                       spreadRadius: 2,
//                     ),
//                   ],
//                 ),
//               ),
//               underline: SizedBox.shrink(), // No underline
//               dropdownStyleData: DropdownStyleData(
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.black, width: 2),
//                 ),
//                 elevation: 10,
//               ),
//               items: [
//                 DropdownMenuItem(
//                   value: 'RealToSmart',
//                   child: Row(
//                     children: [
//                       Text('RealToSmart', style: TextStyle(fontFamily: "poppins_thin")),
//                     ],
//                   ),
//                 ),
//                 DropdownMenuItem(
//                   value: 'Gymsmart',
//                   child: Row(
//                     children: [
//                       Text('Gymsmart', style: TextStyle(fontFamily: "poppins_thin")),
//                     ],
//                   ),
//                 ),
//                 DropdownMenuItem(
//                   value: 'leadmgt',
//                   child: Row(
//                     children: [
//                      Text('leadmgt', style: TextStyle(fontFamily: "poppins_thin")),
//                     ],
//                   ),
//                 ),
//               ],
//               onChanged: (value) {
//                 setState(() {
//                   assignother = value as String?; // Update the selected value
//                 });
//               },
//             ),
//           ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: DropdownButton2(
//                   isExpanded: true, // Make the dropdown button take full width
//                   hint: Text(
//                     'Owner To',
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 16,
//                       fontFamily: "poppins_thin",
//                     ),
//                   ),
//                   value: owner, // Selected value is displayed here
//                   buttonStyleData: ButtonStyleData(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(8),
//                       color: Colors.grey.shade100,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.shade300,
//                           blurRadius: 4,
//                           spreadRadius: 2,
//                         ),
//                       ],
//                     ),
//                   ),
//                   underline: SizedBox.shrink(), // No underline
//                   dropdownStyleData: DropdownStyleData(
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.black, width: 2),
//                     ),
//                     elevation: 10,
//                   ),
//                   items: [
//                     DropdownMenuItem(
//                       value: 'RealToSmart',
//                       child: Row(
//                         children: [
//                           Text('RealToSmart', style: TextStyle(fontFamily: "poppins_thin")),
//                         ],
//                       ),
//                     ),
//                     DropdownMenuItem(
//                       value: 'Gymsmart',
//                       child: Row(
//                         children: [
//                           Text('Gymsmart', style: TextStyle(fontFamily: "poppins_thin")),
//                         ],
//                       ),
//                     ),
//                     DropdownMenuItem(
//                       value: 'leadmgt',
//                       child: Row(
//                         children: [
//                           Text('leadmgt', style: TextStyle(fontFamily: "poppins_thin")),
//                         ],
//                       ),
//                     ),
//                   ],
//                   onChanged: (value) {
//                     setState(() {
//                       owner = value as String?; // Update the selected value
//                     });
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: DropdownButton2(
//                   isExpanded: true, // Make the dropdown button take full width
//                   hint: Text(
//                     'Inq Type',
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 16,
//                       fontFamily: "poppins_thin",
//                     ),
//                   ),
//                   value: inqtype, // Selected value is displayed here
//                   buttonStyleData: ButtonStyleData(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(8),
//                       color: Colors.grey.shade100,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.shade300,
//                           blurRadius: 4,
//                           spreadRadius: 2,
//                         ),
//                       ],
//                     ),
//                   ),
//                   underline: SizedBox.shrink(), // No underline
//                   dropdownStyleData: DropdownStyleData(
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.black, width: 2),
//                     ),
//                     elevation: 10,
//                   ),
//                   items: [
//                     DropdownMenuItem(
//                       value: 'Walk in',
//                       child: Row(
//                         children: [
//                           Text('Walk in', style: TextStyle(fontFamily: "poppins_thin")),
//                         ],
//                       ),
//                     ),
//                     DropdownMenuItem(
//                       value: 'autoleads',
//                       child: Row(
//                         children: [
//                           Text('Autoleads', style: TextStyle(fontFamily: "poppins_thin")),
//                         ],
//                       ),
//                     ),
//                     DropdownMenuItem(
//                       value: 'call',
//                       child: Row(
//                         children: [
//                           Text('Call', style: TextStyle(fontFamily: "poppins_thin")),
//                         ],
//                       ),
//                     ),
//                   ],
//                   onChanged: (value) {
//                     setState(() {
//                       inqtype = value as String?; // Update the selected value
//                     });
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: DropdownButton2(
//                   isExpanded: true, // Make the dropdown button take full width
//                   hint: Text(
//                     'Assign To',
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 16,
//                       fontFamily: "poppins_thin",
//                     ),
//                   ),
//                   value: intarea, // Selected value is displayed here
//                   buttonStyleData: ButtonStyleData(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(8),
//                       color: Colors.grey.shade100,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.shade300,
//                           blurRadius: 4,
//                           spreadRadius: 2,
//                         ),
//                       ],
//                     ),
//                   ),
//                   underline: SizedBox.shrink(), // No underline
//                   dropdownStyleData: DropdownStyleData(
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.black, width: 2),
//                     ),
//                     elevation: 10,
//                   ),
//                   items: [
//                     DropdownMenuItem(
//                       value: 'amroli',
//                       child: Row(
//                         children: [
//                           Text('Amroli', style: TextStyle(fontFamily: "poppins_thin")),
//                         ],
//                       ),
//                     ),
//                     DropdownMenuItem(
//                       value: 'katargam',
//                       child: Row(
//                         children: [
//                           Text('Katargam', style: TextStyle(fontFamily: "poppins_thin")),
//                         ],
//                       ),
//                     ),
//                     DropdownMenuItem(
//                       value: 'varachha',
//                       child: Row(
//                         children: [
//                           Text('Varachha', style: TextStyle(fontFamily: "poppins_thin")),
//                         ],
//                       ),
//                     ),
//                   ],
//                   onChanged: (value) {
//                     setState(() {
//                       intarea = value as String?; // Update the selected value
//                     });
//                   },
//                 ),
//               ),
//
//
//               // Duration Section (From Date and To Date)
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10),
//                 child: const Text(
//                   "Duration:",
//                   style: TextStyle(fontFamily: "poppins_thin", fontSize: 16),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         controller: _fromDateController,
//                         readOnly: true,
//                         decoration: InputDecoration(
//                           labelText: "From date",
//                           border: OutlineInputBorder(),
//                           suffixIcon: IconButton(
//                             icon: Icon(Icons.calendar_today),
//                             onPressed: () async {
//                               DateTime? pickedDate = await showDatePicker(
//                                 context: context,
//                                 initialDate: DateTime.now(),
//                                 firstDate: DateTime(2000),
//                                 lastDate: DateTime(2101),
//                               );
//                               if (pickedDate != null) {
//                                 setState(() {
//                                   _fromDateController.text = "${pickedDate.toLocal()}".split(' ')[0];
//                                 });
//                               }
//                             },
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     Expanded(
//                       child: TextField(
//                         controller: _toDateController,
//                         readOnly: true,
//                         decoration: InputDecoration(
//                           labelText: "To date",
//                           border: OutlineInputBorder(),
//                           suffixIcon: IconButton(
//                             icon: Icon(Icons.calendar_today),
//                             onPressed: () async {
//                               DateTime? pickedDate = await showDatePicker(
//                                 context: context,
//                                 initialDate: DateTime.now(),
//                                 firstDate: DateTime(2000),
//                                 lastDate: DateTime(2101),
//                               );
//                               if (pickedDate != null) {
//                                 setState(() {
//                                   _toDateController.text = "${pickedDate.toLocal()}".split(' ')[0];
//                                 });
//                               }
//                             },
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//
//               // Apply Filter Button
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColor.Buttoncolor,
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                     ),
//                     onPressed: () {
//                       Navigator.pop(context); // Logic to apply filters can be added here
//                     },
//                     child: const Text(
//                       "Apply Filters",
//                       style: TextStyle(color: Colors.white, fontSize: 16,fontFamily: "poppins_thin"),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//
//     // showModalBottomSheet(
//     //   context: context,
//     //   isScrollControlled: true,
//     //   shape: RoundedRectangleBorder(
//     //     borderRadius: BorderRadius.vertical(top: Radius.circular(86)),
//     //   ),
//     //   builder: (context) => Scaffold(
//     //     appBar: AppBar(
//     //       title: const Text("Filter"),
//     //       backgroundColor: Colors.purple,
//     //       automaticallyImplyLeading: false,
//     //       leading: IconButton(
//     //         onPressed: () {
//     //           Navigator.pop(context);
//     //         },icon: Icon(Icons.arrow_back_ios,color: Colors.white,),
//     //       ),
//     //     ),
//     //     body: SafeArea(
//     //       child: Padding(
//     //         padding: const EdgeInsets.all(16.0),
//     //         child: SingleChildScrollView(
//     //           child: Column(
//     //             crossAxisAlignment: CrossAxisAlignment.start,
//     //             children: [
//     //               // Id Text Field
//     //               Padding(
//     //                 padding: const EdgeInsets.only(bottom: 16.0),
//     //                 child: TextField(
//     //                   controller: _idController,
//     //                   decoration: InputDecoration(
//     //                     labelText: "Id",
//     //                     border: OutlineInputBorder(),
//     //                   ),
//     //                 ),
//     //               ),
//     //
//     //               // Name Text Field
//     //               Padding(
//     //                 padding: const EdgeInsets.only(bottom: 16.0),
//     //                 child: TextField(
//     //                   controller: _nameController,
//     //                   decoration: InputDecoration(
//     //                     labelText: "Enter Name",
//     //                     border: OutlineInputBorder(),
//     //                   ),
//     //                 ),
//     //               ),
//     //
//     //               // Mobile Number Text Field
//     //               Padding(
//     //                 padding: const EdgeInsets.only(bottom: 16.0),
//     //                 child: TextField(
//     //                   controller: _mobileController,
//     //                   decoration: InputDecoration(
//     //                     labelText: "Mobile No",
//     //                     border: OutlineInputBorder(),
//     //                   ),
//     //                 ),
//     //               ),
//     //
//     //               // Next Follow Up Text Field
//     //               Padding(
//     //                 padding: const EdgeInsets.only(bottom: 16.0),
//     //                 child: TextField(
//     //                   controller: _nextFollowUpController,
//     //                   decoration: InputDecoration(
//     //                     labelText: "Next Follow Up",
//     //                     border: OutlineInputBorder(),
//     //                   ),
//     //                 ),
//     //               ),
//     //
//     //               // Duration Section (From Date and To Date)
//     //               const Text(
//     //                 "Duration:",
//     //                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//     //               ),
//     //               const SizedBox(height: 10),
//     //               Row(
//     //                 children: [
//     //                   Expanded(
//     //                     child: TextField(
//     //                       controller: _fromDateController,
//     //                       readOnly: true,
//     //                       decoration: InputDecoration(
//     //                         labelText: "From date",
//     //                         border: OutlineInputBorder(),
//     //                         suffixIcon: IconButton(
//     //                           icon: Icon(Icons.calendar_today),
//     //                           onPressed: () async {
//     //                             DateTime? pickedDate = await showDatePicker(
//     //                               context: context,
//     //                               initialDate: DateTime.now(),
//     //                               firstDate: DateTime(2000),
//     //                               lastDate: DateTime(2101),
//     //                             );
//     //                             if (pickedDate != null) {
//     //                               setState(() {
//     //                                 _fromDateController.text = "${pickedDate.toLocal()}".split(' ')[0];
//     //                               });
//     //                             }
//     //                           },
//     //                         ),
//     //                       ),
//     //                     ),
//     //                   ),
//     //                   const SizedBox(width: 10),
//     //                   Expanded(
//     //                     child: TextField(
//     //                       controller: _toDateController,
//     //                       readOnly: true,
//     //                       decoration: InputDecoration(
//     //                         labelText: "To date",
//     //                         border: OutlineInputBorder(),
//     //                         suffixIcon: IconButton(
//     //                           icon: Icon(Icons.calendar_today),
//     //                           onPressed: () async {
//     //                             DateTime? pickedDate = await showDatePicker(
//     //                               context: context,
//     //                               initialDate: DateTime.now(),
//     //                               firstDate: DateTime(2000),
//     //                               lastDate: DateTime(2101),
//     //                             );
//     //                             if (pickedDate != null) {
//     //                               setState(() {
//     //                                 _toDateController.text = "${pickedDate.toLocal()}".split(' ')[0];
//     //                               });
//     //                             }
//     //                           },
//     //                         ),
//     //                       ),
//     //                     ),
//     //                   ),
//     //                 ],
//     //               ),
//     //               const SizedBox(height: 20),
//     //
//     //               // Apply Filter Button
//     //               SizedBox(
//     //                 width: double.infinity,
//     //                 child: ElevatedButton(
//     //                   style: ElevatedButton.styleFrom(
//     //                     backgroundColor: Colors.purple,
//     //                     padding: const EdgeInsets.symmetric(vertical: 12),
//     //                   ),
//     //                   onPressed: () {
//     //                     Navigator.pop(context); // Logic to apply filters can be added here
//     //                   },
//     //                   child: const Text(
//     //                     "Apply Filters",
//     //                     style: TextStyle(color: Colors.white, fontSize: 16),
//     //                   ),
//     //                 ),
//     //               ),
//     //             ],
//     //           ),
//     //         ),
//     //       ),
//     //     ),
//     //   ),
//     // );
//   }
//
//
//
//   final TextEditingController nextFollowupcontroller=TextEditingController();
//
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Followup And CNR",
//           style: TextStyle(fontFamily: "poppins_thin", color: Colors.white,fontSize: 20),
//         ),
//         backgroundColor: AppColor.MainColor,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Icon(Icons.arrow_back_ios, color: Colors.white),
//         ),
//         actions: [
//           SearchBar1(),
//           SizedBox(width: 5,),
//           CircleAvatar(
//             child: IconButton(
//                 onPressed: () {
//                   showBottomModalSheet(context);
//                 },
//                 icon: Icon(Icons.filter_alt_rounded)),
//           ),
//           SizedBox(width: 15,)
//         ],
//       ),
//       body: Column(
//         children: [
//           MainButtonGroup(
//             buttonTexts: ["Today's Followup", "Pending Followup", "CNR"],
//             selectedButton: selectedMainFilter,
//             onButtonPressed: (selected) {
//               setState(() {
//                 selectedMainFilter = selected;
//               });
//             },
//           ),
//           selectedMainFilter == "Today's Followup"
//               ? Expanded(
//             child: GestureDetector(
//               onTap: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => TimingScreen(),));
//               },
//               child: ListView.builder(
//                 itemCount: tasks.length,
//                 itemBuilder: (context, index) {
//                   final task = tasks[index];
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 16.0, vertical: 8.0),
//                     child: Container(
//                       padding: const EdgeInsets.all(16.0),
//                       decoration: BoxDecoration(
//                         color: task.color,
//                         borderRadius: BorderRadius.circular(16.0),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.4),
//                             blurRadius: 8.0,
//                             offset: Offset(0, 4),
//                           ),
//                         ],
//                       ),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: Text(
//                               task.time,
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.black,
//                                 fontFamily: "poppins_thin",
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 50,
//                             width: 50,
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(25),
//                                 color: Colors.white,
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   "${task.leads}",
//                                   style: TextStyle(
//                                       fontFamily: "poppins_thin",
//                                       color: AppColor.MainColor),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           IconButton(
//                               onPressed: () {
//                                 Navigator.push(context, MaterialPageRoute(builder: (context) =>
//                                     TimingScreen(),));
//                               },
//                               icon: Icon(Icons.arrow_forward_ios,color: Colors.white,size: 20,))
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ):selectedMainFilter == "Pending Followup"
//               ?Expanded(
//             child: Column(
//               children: [
//                 if (isSelectionMode) // Show form only in selection mode
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         DropdownButton2(
//                           isExpanded: true, // This will make the dropdown button take full width
//                           hint: Text(
//                             'Select Action',
//                             style: TextStyle(color: Colors.black, fontSize: 16,fontFamily: "poppins_thin"),
//                           ),
//                           value: selectedAction,
//
//                           buttonStyleData: ButtonStyleData(
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(8),
//                                   color: Colors.grey.shade100,
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.grey.shade300,
//                                       blurRadius: 4,
//                                       spreadRadius: 2,
//                                     ),]
//                               )
//                           ),
//                           underline: Center(),
//                           dropdownStyleData: DropdownStyleData(
//                               decoration: BoxDecoration(
//                                   border: Border.all(color: Colors.black,width: 2)
//                               ),
//                               elevation: 10
//                           ),
//                           items: [
//                             DropdownMenuItem(
//                               value: 'markAsComplete',
//                               child: Row(
//                                 children: [
//                                   Icon(Icons.check_circle,size: 20,color: Colors.green,),
//                                   SizedBox(width: 5,),
//                                   Text('Mark as Complete',style: TextStyle(fontFamily: "poppins_thin"),),
//                                 ],
//                               ),
//                             ),
//                             DropdownMenuItem(
//                               value: 'assignToUser',
//                               child: Row(
//                                 children: [
//                                   Icon(Icons.person_add,color: Colors.blue,size: 20,),
//                                   SizedBox(width: 5,),
//                                   Text('Assign to User',style: TextStyle(fontFamily: "poppins_thin"),),
//                                 ],
//                               ),
//                             ),
//                             DropdownMenuItem(
//                               value: 'delete',
//                               child: Row(
//                                 children: [
//                                   Icon(Icons.delete,color: Colors.red,size: 20),
//                                   SizedBox(width: 5,),
//                                   Text('Delete',style: TextStyle(fontFamily: "poppins_thin"),),
//                                 ],
//                               ),
//                             ),
//                           ],
//                           onChanged: (value) {
//                             setState(() {
//                               selectedAction = value;
//                             });
//                           },
//                         ),
//
//                         SizedBox(height: 8.0),
//                         DropdownButton2(
//                           isExpanded: true, // This will make the dropdown button take full width
//                           hint: Text(
//                             'Select Employee',
//                             style: TextStyle(color: Colors.black, fontSize: 16,fontFamily: "poppins_thin"),
//                           ),
//                           value: selectedEmployee,
//
//                           buttonStyleData: ButtonStyleData(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(8),
//                               color: Colors.grey.shade100,
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.grey.shade300,
//                                   blurRadius: 4,
//                                   spreadRadius: 2,
//                                 ),],
//                             ),
//                           ),
//                           underline: Center(),
//                           dropdownStyleData:DropdownStyleData(
//                               decoration: BoxDecoration(
//                                   border: Border.all(color: Colors.black,width: 2)
//                               )
//                           ),
//                           items: [
//                             DropdownMenuItem(
//                               value: 'employee 1',
//                               child: Text('Employee 1',style: TextStyle(fontFamily: "poppins_thin"),),
//                             ),
//                             DropdownMenuItem(
//                               value: 'employee 2',
//                               child: Text('Employee 2',style: TextStyle(fontFamily: "poppins_thin"),),
//                             ),
//                             DropdownMenuItem(
//                               value: 'employee 3',
//                               child: Text('Employee 3',style: TextStyle(fontFamily: "poppins_thin"),),
//                             ),
//                           ],
//                           onChanged: (value) {
//                             setState(() {
//                               selectedEmployee= value;
//                             });
//                           },
//                         ),
//                         SizedBox(height: 8.0),
//                         Center(
//                           child: GradientButton(
//                             buttonText: "Submit",
//                             onPressed: () {
//                               if (selectedAction == null || selectedEmployee == null) {
//                                 // Show dialog to prompt the user to select data
//                                 showsubmitdialog(context);
//                               } else {
//                                 // Show confirmation dialog
//                                 showConfirmationDialog(context);
//                                 handleAction(selectedAction!, selectedEmployee!);
//                               }
//                             },
//                           ),
//                         ),
//
//                       ],
//                     ),
//                   ),
//                 SizedBox(
//                   height: 40,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: items.length,
//                     itemBuilder: (context, index) {
//                       bool isSelected = index == selectedIndex;
//                       return GestureDetector(
//                         onTap: () {
//                           _onFilterChange(index);
//                         },
//                         child: Container(
//                           margin: EdgeInsets.symmetric(horizontal: 8.0),
//                           padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
//                           decoration: BoxDecoration(
//                             color: isSelected ? Colors.grey[800] : Colors.grey[200],
//                             borderRadius: BorderRadius.circular(20.0),
//                           ),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Text(
//                                 items[index]['label']!,
//                                 style: TextStyle(
//                                   color: isSelected ? Colors.white : Colors.black,
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               SizedBox(width: 8.0),
//                               Container(
//                                 width: 20.0,
//                                 height: 20.0,
//                                 alignment: Alignment.center,
//                                 decoration: BoxDecoration(
//                                   color: isSelected ? Colors.green : Colors.grey[400],
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: Text(
//                                   '${getPendingLabelCount()[items[index]['label']] ?? 0}',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 10,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: _filteredFollowupData().length,
//                     itemBuilder: (context, index) {
//                       final data = _filteredFollowupData()[index];
//                       final isSelected =  selectedItemsPerFilter.containsKey(selectedIndex) && selectedItemsPerFilter[selectedIndex]!.contains(index);
//
//                       return GestureDetector(
//                         onLongPress: () {
//                           setState(() {
//                             isSelectionMode = true;
//                             if (selectedItemsPerFilter[selectedIndex] == null) {
//                               selectedItemsPerFilter[selectedIndex] = {index};
//                             }else {
//                               selectedItemsPerFilter[selectedIndex]!.add(index);
//                             }
//                           });
//                         },
//                         onTap: () {
//                           if (isSelectionMode) {
//                             setState(() {
//                               if (isSelected) {
//                                 selectedItemsPerFilter[selectedIndex]!.remove(index);
//                                 if (selectedItemsPerFilter[selectedIndex]!.isEmpty) {
//                                   isSelectionMode = false;
//                                 }
//                               } else {
//                                 if (selectedItemsPerFilter[selectedIndex] == null) {
//                                   selectedItemsPerFilter[selectedIndex] = {index};
//                                 }else{
//                                   selectedItemsPerFilter[selectedIndex]!.add(index);
//                                 }
//                               }
//                             });
//                           }
//                         },
//                         child: Card(
//                           color: isSelected ? Colors.grey[300] : AppColor.deepPurp400,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12.0),
//                           ),
//                           elevation: 5,
//                           margin: EdgeInsets.symmetric(
//                             horizontal: MediaQuery.of(context).size.width * 0.04, // Responsive margin for horizontal spacing
//                             vertical: MediaQuery.of(context).size.height * 0.02, // Responsive margin for vertical spacing
//                           ),
//                           child: Stack(
//                             children: [
//                               Padding(
//                                 padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04), // Responsive padding
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     // Label Row
//                                     Row(
//                                       children: [
//                                         Container(
//                                           padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
//                                           decoration: BoxDecoration(
//                                             color: Colors.blueAccent,
//                                             borderRadius: BorderRadius.circular(8.0),
//                                           ),
//                                           child: Text(
//                                             data.label ?? '',
//                                             style: TextStyle(
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 14, // Fixed font size
//                                             ),
//                                           ),
//                                         ),
//                                         Spacer(),
//                                         CircleAvatar(
//                                           backgroundColor: AppColor.Buttoncolor,
//                                           radius: 18, // Fixed size for CircleAvatar
//                                           child: IconButton(
//                                             onPressed: () {
//                                               Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                   builder: (context) => LeadDetailScreen(
//                                                     selectedApx: selectedApx,
//                                                     selectedPurpose: selectedPurpose,
//                                                     selectedTime: selectedTime,
//                                                     data: data,
//                                                     callList: callList,
//                                                     product: data.product,
//                                                     apxbuy: data.apxbuying,
//                                                     services: data.services,
//                                                     duration: data.duration,
//                                                     selectedaction: selectedMembership,
//                                                     selectedButton: selectedcallFilter,
//                                                     controller: nextFollowupcontroller,
//                                                     isTiming: false,
//                                                   ),
//                                                 ),
//                                               );
//                                             },
//                                             icon: Icon(Icons.call, color: Colors.white, size: 20), // Fixed icon size
//                                           ),
//                                         ),
//                                         SizedBox(width: 15),
//                                         GestureDetector(
//                                           onTap: () {
//                                             Navigator.push(context, MaterialPageRoute(builder: (context) => QuotationScreen()));
//                                           },
//                                           child: CircleAvatar(
//                                             radius: 18, // Fixed size for CircleAvatar
//                                             backgroundColor: AppColor.Buttoncolor,
//                                             child: Image(image: AssetImage("assets/stationery.png"), height: 25, width: 25), // Fixed image size
//                                           ),
//                                         ),
//                                         PopupMenuButton<String>(
//                                           icon: Icon(Icons.more_vert),
//                                           onSelected: (value) {
//                                             if (value == 'edit') {
//                                               // Handle Edit action
//                                               Navigator.push(context, MaterialPageRoute(builder: (context) => AddLeadScreen(isEdit: true,),));
//                                             } else if (value == 'delete') {
//                                               // Handle Delete action
//                                             }
//                                           },
//                                           offset: Offset(0, 20),
//                                           itemBuilder: (BuildContext context) {
//                                             return [
//                                               PopupMenuItem<String>(
//                                                 value: 'edit',
//                                                 child: Text(
//                                                   'Edit',
//                                                   style: TextStyle(fontFamily: "poppins_thin"),
//                                                 ),
//                                               ),
//                                               PopupMenuItem<String>(
//                                                 value: 'delete',
//                                                 child: Text(
//                                                   'Delete',
//                                                   style: TextStyle(fontFamily: "poppins_thin"),
//                                                 ),
//                                               ),
//                                             ];
//                                           },
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(height: MediaQuery.of(context).size.height * 0.01), // Responsive space
//
//                                     SizedBox(height: 8),
//                                     Row(
//                                       children: [
//                                         Icon(Icons.person, color: Colors.purple, size: 20),
//                                         SizedBox(width: 8),
//                                         Text(
//                                           data.name ?? '',
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: MediaQuery.of(context).size.width < 400 ? 14 : 16, // Adjust font size based on screen width
//                                           ),
//                                         ),
//                                         Spacer(),
//                                         Text(
//                                           data.member ?? '',
//                                           style: TextStyle(
//                                             fontFamily: "poppins_thin",
//                                             fontSize: 12, // Fixed font size
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(height: 8),
//                                     Row(
//                                       children: [
//                                         Icon(Icons.phone, color: Colors.blue, size: 18), // Fixed icon size
//                                         SizedBox(width: 8),
//                                         Expanded(
//                                           child: Text(
//                                             "Inquiry Type: ${data.inquiryType ?? ''}",
//                                             style: TextStyle(fontSize: 14, fontFamily: "poppins_thin"),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(height: MediaQuery.of(context).size.height * 0.01), // Responsive space
//
//                                     // Product and Services Row
//                                     Row(
//                                       children: [
//                                         Icon(Icons.label, color: Colors.orange, size: 18), // Fixed icon size
//                                         SizedBox(width: 8),
//                                         Expanded(
//                                           child: Text(
//                                             "Int Product: ${data.product ?? ''}",
//                                             style: TextStyle(
//                                               fontSize: 14,
//                                               fontFamily: "poppins_thin",
//                                               color: Colors.grey[700],
//                                             ),
//                                           ),
//                                         ),
//                                         Spacer(),
//                                         Icon(Icons.miscellaneous_services, color: Colors.red, size: 18), // Fixed icon size
//                                         SizedBox(width: 3),
//                                         Expanded(
//                                           child: Text(
//                                             "Services: ${data.services ?? ''}",
//                                             style: TextStyle(
//                                               fontSize: 14,
//                                               fontFamily: "poppins_thin",
//                                               color: Colors.grey[700],
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(height: MediaQuery.of(context).size.height * 0.01), // Responsive space
//
//                                     // Date and Time Row
//                                     Row(
//                                       children: [
//                                         Icon(Icons.calendar_today, color: Colors.green, size: 18), // Fixed icon size
//                                         SizedBox(width: 3),
//                                         Expanded(
//                                           child: Text(
//                                             data.dateTime ?? '',
//                                             style: TextStyle(fontSize: 14, fontFamily: "poppins_thin"),
//                                           ),
//                                         ),
//                                         SizedBox(width: 15),
//                                         Icon(Icons.edit_calendar_rounded, color: Colors.deepPurple.shade900, size: 18), // Fixed icon size
//                                         SizedBox(width: 3),
//                                         Expanded(
//                                           child: Text(
//                                             data.nextfollowup ?? '',
//                                             style: TextStyle(fontSize: 14, fontFamily: "poppins_thin"),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               if (isSelectionMode)
//                                 Positioned(
//                                   top: 0,
//                                   left: 0,
//                                   child: Checkbox(
//                                     value: isSelected,
//                                     onChanged: (value) {
//                                       setState(() {
//                                         if (value == true) {
//                                           if (selectedItemsPerFilter[selectedIndex] == null) {
//                                             selectedItemsPerFilter[selectedIndex] = {index};
//                                           } else {
//                                             selectedItemsPerFilter[selectedIndex]!.add(index);
//                                           }
//                                         } else {
//                                           selectedItemsPerFilter[selectedIndex]!.remove(index);
//                                           if (selectedItemsPerFilter[selectedIndex]!.isEmpty) {
//                                             isSelectionMode = false;
//                                           }
//                                         }
//                                       });
//                                     },
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         )
//
//
//
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           )
//               :Expanded(
//             child: Column(
//               children: [
//                 // Show form only in selection mode
//                 if (isCnrSelectionMode)
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         DropdownButton2(
//                           isExpanded: true,
//                           hint: Text('Select Action', style: TextStyle(color: Colors.black, fontSize: 16,fontFamily: "poppins_thin")),
//                           value: selectedAction,
//                           buttonStyleData: ButtonStyleData(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(8),
//                               color: Colors.grey.shade100,
//                               boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4, spreadRadius: 2)],
//                             ),
//                           ),
//                           underline: Center(),
//                           dropdownStyleData: DropdownStyleData(
//                             decoration: BoxDecoration(
//                               border: Border.all(color: Colors.black, width: 2),
//                             ),
//                             elevation: 10,
//                           ),
//                           items: [
//                             DropdownMenuItem(value: 'markAsComplete', child: Row(children: [Icon(Icons.check_circle, size: 20, color: Colors.green), SizedBox(width: 5), Text('Mark as Complete',style: TextStyle(fontFamily: "poppins_thin"),)])),
//                             DropdownMenuItem(value: 'assignToUser', child: Row(children: [Icon(Icons.person_add, color: Colors.blue, size: 20), SizedBox(width: 5), Text('Assign to User',style: TextStyle(fontFamily: "poppins_thin"),)])),
//                             DropdownMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete, color: Colors.red, size: 20), SizedBox(width: 5), Text('Delete',style: TextStyle(fontFamily: "poppins_thin"),)])),
//                           ],
//                           onChanged: (value) {
//                             setState(() {
//                               selectedAction = value;
//                             });
//                           },
//                         ),
//                         SizedBox(height: 8.0),
//                         DropdownButton2(
//                           isExpanded: true,
//                           hint: Text('Select Employee', style: TextStyle(color: Colors.black, fontSize: 16,fontFamily: "poppins_thin")),
//                           value: selectedEmployee,
//                           buttonStyleData: ButtonStyleData(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(8),
//                               color: Colors.grey.shade100,
//                               boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4, spreadRadius: 2)],
//                             ),
//                           ),
//                           underline: Center(),
//                           dropdownStyleData: DropdownStyleData(
//                             decoration: BoxDecoration(
//                               border: Border.all(color: Colors.black, width: 2),
//                             ),
//                           ),
//                           items: [
//                             DropdownMenuItem(value: 'employee 1', child: Text('Employee 1',style: TextStyle(fontFamily: "poppins_thin"),)),
//                             DropdownMenuItem(value: 'employee 2', child: Text('Employee 2',style: TextStyle(fontFamily: "poppins_thin"),)),
//                             DropdownMenuItem(value: 'employee 3', child: Text('Employee 3',style: TextStyle(fontFamily: "poppins_thin"),)),
//                           ],
//                           onChanged: (value) {
//                             setState(() {
//                               selectedEmployee = value;
//                             });
//                           },
//                         ),
//                         SizedBox(height: 8.0),
//                         Center(
//                           child: GradientButton(
//                             buttonText: "Submit",
//                             onPressed: () {
//
//                               if (selectedAction == null || selectedEmployee == null) {
//                                 // Show dialog to prompt the user to select data
//                                 showsubmitdialog(context);
//                               } else {
//                                 // Show confirmation dialog
//                                 showConfirmationDialog(context);
//                                 handleCnrAction(selectedAction!, selectedEmployee!);
//                               }
//                               // Handle Submit Action
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 // Horizontal ListView for Labels
//                 SizedBox(
//                   height: 40,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: cnrList.length,
//                     itemBuilder: (context, index) {
//                       bool CnrisSelected = index == CnrselectedIndex;
//                       return GestureDetector(
//                         onTap: () {
//                           _onCnrFilterChange(index);
//                         },
//                         child: Container(
//                           margin: EdgeInsets.symmetric(horizontal: 8.0),
//                           padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
//                           decoration: BoxDecoration(
//                             color: CnrisSelected ? Colors.grey[800] : Colors.grey[200],
//                             borderRadius: BorderRadius.circular(20.0),
//                           ),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Text(
//                                 cnrList[index]['label'],
//                                 style: TextStyle(
//                                   color: CnrisSelected ? Colors.white : Colors.black,
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               SizedBox(width: 8.0),
//                               Container(
//                                 width: 20.0,
//                                 height: 20.0,
//                                 alignment: Alignment.center,
//                                 decoration: BoxDecoration(
//                                   color: CnrisSelected ? Colors.green : Colors.grey[400],
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: Text(
//                                   '${getLabelCount()[cnrList[index]['label']] ?? 0}',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 10,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 // Main ListView (Follow-up Data)
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: _filteredCnrData().length,
//                     itemBuilder: (context, index) {
//                       final data = _filteredCnrData()[index];
//                       final isCnrSelected = CnrselectedItemsPerFilter.containsKey(CnrselectedIndex) &&
//                           CnrselectedItemsPerFilter[CnrselectedIndex]!.contains(index);
//
//                       return GestureDetector(
//                         onLongPress: () {
//                           setState(() {
//                             isCnrSelectionMode = true;
//                             if (CnrselectedItemsPerFilter[CnrselectedIndex] == null) {
//                               CnrselectedItemsPerFilter[CnrselectedIndex] = {index};
//                             } else {
//                               CnrselectedItemsPerFilter[CnrselectedIndex]!.add(index);
//                             }
//                           });
//                         },
//                         onTap: () {
//                           if (isCnrSelectionMode) {
//                             setState(() {
//                               if (isCnrSelected) {
//                                 CnrselectedItemsPerFilter[CnrselectedIndex]!.remove(index);
//                                 if (CnrselectedItemsPerFilter[CnrselectedIndex]!.isEmpty) {
//                                   isCnrSelectionMode = false;
//                                 }
//                               } else {
//                                 if (CnrselectedItemsPerFilter[CnrselectedIndex] == null) {
//                                   CnrselectedItemsPerFilter[CnrselectedIndex] = {index};
//                                 } else {
//                                   CnrselectedItemsPerFilter[CnrselectedIndex]!.add(index);
//                                 }
//                               }
//                             });
//                           }
//                         },
//                         child: Card(
//                           color: isCnrSelected ? Colors.grey[300] : AppColor.deepPurp400,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12.0),
//                           ),
//                           elevation: 5,
//                           margin: EdgeInsets.symmetric(
//                             horizontal: MediaQuery.of(context).size.width * 0.04, // Dynamic horizontal margin
//                             vertical: MediaQuery.of(context).size.height * 0.02, // Dynamic vertical margin
//                           ),
//                           child: Stack(
//                             children: [
//                               Padding(
//                                 padding: EdgeInsets.all(16.0), // Padding remains fixed
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Row(
//                                       children: [
//                                         Container(
//                                           padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
//                                           decoration: BoxDecoration(
//                                             color: Colors.blueAccent,
//                                             borderRadius: BorderRadius.circular(8.0),
//                                           ),
//                                           child: Text(
//                                             data.label ?? '',
//                                             style: TextStyle(
//                                               color: Colors.white,
//                                               fontFamily: "poppins_thin",
//                                               fontSize: 14,
//                                             ),
//                                           ),
//                                         ),
//                                         Spacer(),
//                                         CircleAvatar(
//                                           backgroundColor: AppColor.Buttoncolor,
//                                           radius: 18,
//                                           child: IconButton(
//                                             onPressed: () {
//                                               Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                   builder: (context) => LeadDetailScreen(
//                                                     selectedApx: selectedApx,
//                                                     selectedPurpose: selectedPurpose,
//                                                     selectedTime: selectedTime,
//                                                     data: data,
//                                                     callList: callList,
//                                                     product: data.product,
//                                                     apxbuy: data.apxbuying,
//                                                     services: data.services,
//                                                     duration: data.duration,
//                                                     selectedaction: selectedMembership,
//                                                     selectedButton: selectedcallFilter,
//                                                     controller: nextFollowupcontroller,
//                                                   ),
//                                                 ),
//                                               );
//                                             },
//                                             icon: Icon(Icons.call, color: Colors.white, size: 20),
//                                           ),
//                                         ),
//                                         SizedBox(width: 10,),
//                                         GestureDetector(
//                                           onTap: () {
//                                             Navigator.push(context, MaterialPageRoute(builder: (context) => QuotationScreen()));
//                                           },
//                                           child: CircleAvatar(
//                                             radius: 18, // Fixed size for CircleAvatar
//                                             backgroundColor: AppColor.Buttoncolor,
//                                             child: Image(image: AssetImage("assets/stationery.png"), height: 25, width: 25), // Fixed image size
//                                           ),
//                                         ),
//                                         PopupMenuButton<String>(
//                                           icon: Icon(Icons.more_vert),
//                                           onSelected: (value) {
//                                             if (value == 'edit') {
//                                               Navigator.push(context, MaterialPageRoute(builder: (context) => AddLeadScreen(isEdit: true),));
//                                               // Handle Edit action
//                                             } else if (value == 'delete') {
//                                               // Handle Delete action
//                                             }
//                                           },
//                                           offset: Offset(0, 20),
//                                           itemBuilder: (BuildContext context) {
//                                             return [
//                                               PopupMenuItem<String>(
//                                                 value: 'edit',
//                                                 child: Text(
//                                                   'Edit',
//                                                   style: TextStyle(fontFamily: "poppins_thin"),
//                                                 ),
//                                               ),
//                                               PopupMenuItem<String>(
//                                                 value: 'delete',
//                                                 child: Text(
//                                                   'Delete',
//                                                   style: TextStyle(fontFamily: "poppins_thin"),
//                                                 ),
//                                               ),
//                                             ];
//                                           },
//                                         )
//                                       ],
//                                     ),
//                                     SizedBox(height: 8),
//                                     Row(
//                                       children: [
//                                         Icon(Icons.person, color: Colors.purple, size: 20),
//                                         SizedBox(width: 8),
//                                         Text(
//                                           data.name ?? '',
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: MediaQuery.of(context).size.width < 400 ? 14 : 16, // Adjust font size based on screen width
//                                           ),
//                                         ),
//                                         Spacer(),
//                                         Text(
//                                           data.member ?? '',
//                                           style: TextStyle(
//                                             fontFamily: "poppins_thin",
//                                             fontSize: 12, // Fixed font size
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(height: 8),
//                                     Row(
//                                       children: [
//                                         Icon(Icons.phone, color: Colors.blue, size: 18), // Fixed icon size
//                                         SizedBox(width: 8),
//                                         Expanded(
//                                           child: Text(
//                                             "Inquiry Type: ${data.inquiryType ?? ''}",
//                                             style: TextStyle(fontSize: 14, fontFamily: "poppins_thin"),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(height: MediaQuery.of(context).size.height * 0.01), // Responsive space
//
//                                     // Product and Services Row
//                                     Row(
//                                       children: [
//                                         Icon(Icons.label, color: Colors.orange, size: 18), // Fixed icon size
//                                         SizedBox(width: 8),
//                                         Expanded(
//                                           child: Text(
//                                             "Int Product: ${data.product ?? ''}",
//                                             style: TextStyle(
//                                               fontSize: 14,
//                                               fontFamily: "poppins_thin",
//                                               color: Colors.grey[700],
//                                             ),
//                                           ),
//                                         ),
//                                         Spacer(),
//                                         Icon(Icons.miscellaneous_services, color: Colors.red, size: 18), // Fixed icon size
//                                         SizedBox(width: 3),
//                                         Expanded(
//                                           child: Text(
//                                             "Services: ${data.services ?? ''}",
//                                             style: TextStyle(
//                                               fontSize: 14,
//                                               fontFamily: "poppins_thin",
//                                               color: Colors.grey[700],
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(height: MediaQuery.of(context).size.height * 0.01), // Responsive space
//
//                                     // Date and Time Row
//                                     Row(
//                                       children: [
//                                         Icon(Icons.calendar_today, color: Colors.green, size: 18), // Fixed icon size
//                                         SizedBox(width: 3),
//                                         Expanded(
//                                           child: Text(
//                                             data.dateTime ?? '',
//                                             style: TextStyle(fontSize: 14, fontFamily: "poppins_thin"),
//                                           ),
//                                         ),
//                                         SizedBox(width: 15),
//                                         Icon(Icons.edit_calendar_rounded, color: Colors.deepPurple.shade900, size: 18), // Fixed icon size
//                                         SizedBox(width: 3),
//                                         Expanded(
//                                           child: Text(
//                                             data.nextfollowup ?? '',
//                                             style: TextStyle(fontSize: 14, fontFamily: "poppins_thin"),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               if (isCnrSelectionMode)
//                                 Positioned(
//                                   top: 0,
//                                   left: 0,
//                                   child: Checkbox(
//                                     value: isCnrSelected,
//                                     onChanged: (value) {
//                                       setState(() {
//                                         if (value == true) {
//                                           if (CnrselectedItemsPerFilter[CnrselectedIndex] == null) {
//                                             CnrselectedItemsPerFilter[CnrselectedIndex] = {index};
//                                           } else {
//                                             CnrselectedItemsPerFilter[CnrselectedIndex]!.add(index);
//                                           }
//                                         } else {
//                                           CnrselectedItemsPerFilter[CnrselectedIndex]!.remove(index);
//                                           if (CnrselectedItemsPerFilter[CnrselectedIndex]!.isEmpty) {
//                                             isCnrSelectionMode = false;
//                                           }
//                                         }
//                                       });
//                                     },
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         )
//
//                       );
//                     },
//                   ),
//                 ),
//
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
// import 'package:inquiry_management_ui/Inquiry%20Management%20Screens/Followup%20Screen/cnr_Screen.dart';

import '../Model/followup_Model.dart';
import '../Utils/Colors/app_Colors.dart';
import '../Utils/Custom widgets/custom_search.dart';
import '../Utils/Custom widgets/filter_Bottomsheet.dart';
// import '../test_Screen.dart';
import 'Followup Screen/cnr_Screen.dart';
import 'Followup Screen/pending_Screen.dart';
import 'Followup Screen/todays_Lead_Screen.dart';

class FollowupAndCnrScreen extends StatefulWidget {
  const FollowupAndCnrScreen({super.key});

  @override
  State<FollowupAndCnrScreen> createState() => _FollowupAndCnrScreenState();
}

class _FollowupAndCnrScreenState extends State<FollowupAndCnrScreen> {



  // void showBottomModalSheet(BuildContext context) {
  //   showModalBottomSheet(
  //       context: context,
  //       // isScrollControlled: true,
  //       isScrollControlled: true,
  //       constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
  //       ),
  //       builder: (context) => FractionallySizedBox(
  //           heightFactor: 0.8, child:  FilterModal()
  //       ));
  // }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController (
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple.shade300,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            "Leads",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          actions: [
            // SearchBar1(),
            SizedBox(width: 5,),
            CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: Icon(Icons.filter_list, color: Colors.black),
                onPressed: () {
                  // showBottomModalSheet(context);
                },
              ),
            ),
            SizedBox(width: 10,)
          ],
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.list), text: "Today's Followup"),
              Tab(icon: Icon(Icons.group), text: "Pending Followup"),
              Tab(icon: Icon(Icons.person), text: "CNR"),
            ],
          ),
        ),
        backgroundColor: Colors.grey.shade200,
        body: TabBarView(
          children: [
            ShiftsList(),
            LeadsList(),
            CnrScreen()

            // Center(child: Text("My Leads", style: TextStyle(fontSize: 18.0))),
            // Center(child: Text("CNR", style: TextStyle(fontSize: 18.0))),
          ],
        ),
      ),
    );
  }
}

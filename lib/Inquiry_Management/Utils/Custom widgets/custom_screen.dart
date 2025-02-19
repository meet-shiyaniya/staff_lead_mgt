// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:flutter_animate/flutter_animate.dart';
//
// import '../Colors/app_Colors.dart';
//
// class FollowupData {
//   String? name;
//   FollowupData({this.name});
// }
//
// class LeadDetailScreen extends StatefulWidget {
//   final FollowupData data;
//   String? selectedaction;
//   String? selectedApx;
//   String? selectedPurpose;
//   String? selectedTime;
//   List<String> callList;
//   String? selectedButton;
//   String? product;
//   String? apxbuy;
//   String? services;
//   String? duration;
//   final TextEditingController controller;
//
//   LeadDetailScreen({
//     required this.selectedApx,
//     required this.selectedPurpose,
//     required this.selectedTime,
//     required this.data,
//     Key? key,
//     required this.callList,
//     required this.product,
//     required this.apxbuy,
//     required this.services,
//     required this.duration,
//     required this.selectedaction,
//     required this.selectedButton,
//     required this.controller,
//   }) : super(key: key);
//
//   @override
//   _LeadDetailScreenState createState() => _LeadDetailScreenState();
// }
//
// class _LeadDetailScreenState extends State<LeadDetailScreen> {
//   final TextEditingController nextFollowUpController = TextEditingController();
//   bool isDismissed = false;
//   DateTime? selectedDate;
//   String? selectedTime;
//
//   @override
//   void initState() {
//     super.initState();
//     widget.selectedButton = widget.callList.isNotEmpty
//         ? widget.callList[0]
//         : ""; // Set the first item
//   }
//
//   void showDismissedConfirmationDialog() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title:
//           const Text("Are you sure?", style: TextStyle(fontFamily: "poppins_thin")),
//           content: const Text("Are you sure you want to dismiss?",
//               style: TextStyle(fontFamily: "poppins_thin")),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context); // Close the dialog
//                 setState(() {
//                   isDismissed = true; // Mark as dismissed
//                 });
//               },
//               child: const Text("Yes", style: TextStyle(fontFamily: "poppins_thin")),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context); // Close the dialog without action
//               },
//               child: const Text("No", style: TextStyle(fontFamily: "poppins_thin")),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Future<void> _pickDateAndTime() async {
//     // Pick Date
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//
//     if (pickedDate != null) {
//       // Pick Time
//       TimeOfDay? pickedTime = await showTimePicker(
//         context: context,
//         initialTime: TimeOfDay.now(),
//       );
//
//       if (pickedTime != null) {
//         setState(() {
//           selectedDate = pickedDate;
//           selectedTime = pickedTime.format(context);
//           widget.controller.text = _formatDateTime(selectedDate, selectedTime);
//         });
//       }
//     }
//   }
//
//   // Format the Date and Time together
//   String _formatDateTime(DateTime? date, String? time) {
//     if (date != null && time != null) {
//       DateFormat dateFormat = DateFormat('dd/MM/yyyy');
//       return '${dateFormat.format(date)} $time';
//     }
//     return "Select Date & Time";
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColor.MainColor,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         title: const Text(
//           'Lead Details',
//           style: TextStyle(fontFamily: "poppins_thin", color: Colors.white),
//         ),
//         centerTitle: true,
//         elevation: 0,
//         actions: [
//           CircleAvatar(
//             backgroundColor: AppColor.Buttoncolor,
//             child: const Icon(Icons.call, color: Colors.white),
//           ),
//           const SizedBox(width: 10.0),
//           CircleAvatar(
//             backgroundColor: AppColor.Buttoncolor,
//             child: const Image(image: AssetImage("assets/whatsapp.png"),color:Colors.white,height: 25,width: 25,),
//           ),
//           const SizedBox(width: 10.0),
//         ],
//       ),
//       body: Container(
//         color: Colors.grey.shade100,
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "${widget.data.name ?? 'Unknown'}",
//                   style: const TextStyle(
//                     fontFamily: "poppins_thin",
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   '+91 7359399094',
//                   style: TextStyle(
//                       fontFamily: "poppins_thin",
//                       fontSize: 14,
//                       color: Colors.grey.shade700),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 8.0),
//                   child: Card(
//                     elevation: 3,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           _buildDetailItem(
//                               'Product', widget.product, Icons.shopping_bag),
//                           _buildDetailItem('Apx Buying', widget.apxbuy,
//                               Icons.attach_money),
//                           _buildDetailItem(
//                               'Service Name', widget.services, Icons.work),
//                           _buildDetailItem('Service Duration', widget.duration,
//                               Icons.timer),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Center(
//                     child: GradientButton(
//                       buttonText: "Quotation",
//                       onPressed: () {},
//                     )),
//                 const SizedBox(height: 20),
//                 Row(
//                   children: [
//                     Flexible(
//                       child: SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: MainButtonGroup(
//                           buttonTexts: widget.callList,
//                           selectedButton: widget.selectedButton.toString(),
//                           onButtonPressed: (value) {
//                             setState(() {
//                               widget.selectedButton = value;
//                               if (value == "Dismissed") {
//                                 showDismissedConfirmationDialog();
//                               } else {
//                                 isDismissed = false;
//                               }
//                             });
//                           },
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 _buildActionContent(),
//                 const SizedBox(height: 20),
//                 Center(
//                     child: GradientButton(
//                       buttonText: "Submit",
//                       onPressed: () {},
//                     )),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//   Widget _buildDetailItem(String key, String? value, IconData icon) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Icon(icon, color: AppColor.Buttoncolor,size: 18,),
//               const SizedBox(width: 8.0,),
//               Text("$key:",
//                 style: const TextStyle(
//                   fontFamily: "poppins_thin",
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(width: 8.0),
//               Expanded(
//                 child: Text(
//                   value ?? 'N/A',
//                   style: const TextStyle(fontFamily: "poppins_thin",fontSize: 14),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8.0,),
//           Container(height: 1, color: Colors.grey.shade300)
//         ],
//       ),
//     ).animate().fadeIn(duration: const Duration(milliseconds: 300)).slideX(duration: const Duration(milliseconds: 300), begin: -0.1).move(duration: const Duration(milliseconds: 300),);
//   }
//
//
//   Widget _buildActionContent() {
//     if (widget.selectedButton == "Follow up") {
//       return _buildFollowUpForm();
//     } else if (widget.selectedButton == "Dismissed") {
//       return _buildDismissedForm();
//     } else if (widget.selectedButton == "Appointment") {
//       return _buildAppointmentForm();
//     } else if(widget.selectedButton=="Negotiation"){
//       return _buildOtherActionForm();
//     }else if(widget.selectedButton=="Feedback"){
//       return _buildOtherActionForm();
//     }else {
//       return _buildOtherActionForm();
//     }
//   }
//
//   Widget _buildFollowUpForm() {
//     return Column(
//       children: [
//         TextField(
//           decoration: InputDecoration(
//             labelText: "Remark *",
//             labelStyle: const TextStyle(fontFamily: "poppins_thin"),
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
//             hintText: "Your Message here...",
//           ),
//           maxLines: 3,
//         ),
//         const SizedBox(height: 16.0),
//         Row(
//           children: [
//             Expanded(
//               child: GestureDetector(
//                 onTap: () async {
//                   DateTime? selectedDate = await showDatePicker(
//                     context: context,
//                     initialDate: DateTime.now(),
//                     firstDate: DateTime(2000),
//                     lastDate: DateTime(2100),
//                   );
//                   if (selectedDate != null) {
//                     nextFollowUpController.text =
//                     "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
//                   }
//                 },
//                 child: AbsorbPointer(
//                   child: TextField(
//                     controller: nextFollowUpController,
//                     decoration: InputDecoration(
//                         labelText: "Next Follow Up *",
//                         labelStyle: const TextStyle(fontFamily: "poppins_thin"),
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(20)),
//                         hintText: "DD/MM/YYYY",
//                         suffixIcon: const Icon(Icons.calendar_month)),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 16.0),
//             Expanded(
//                 child: DropdownButton2(
//                   isExpanded: true,
//                   hint: const Text(
//                     'Time',
//                     style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 16,
//                         fontFamily: "poppins_thin",
//                         overflow: TextOverflow.ellipsis),
//                   ),
//                   value: widget.selectedApx,
//                   buttonStyleData: ButtonStyleData(
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(20),
//                           color: Colors.white,
//                           boxShadow: [
//                             const BoxShadow(
//                               color: Colors.grey,
//                               blurRadius: 4,
//                               spreadRadius: 2,
//                             ),
//                           ])),
//                   underline: const Center(),
//                   dropdownStyleData: DropdownStyleData(
//                       decoration: BoxDecoration(
//                           border: Border.all(color: Colors.black, width: 2)),
//                       elevation: 10),
//                   items: [
//                     DropdownMenuItem(
//                       value: '8:00',
//                       child: Row(
//                         children: [
//                           const Icon(
//                             Icons.check_circle,
//                             size: 20,
//                             color: Colors.green,
//                           ),
//                           const SizedBox(
//                             width: 5,
//                           ),
//                           const Text('8:00',
//                               style: TextStyle(fontFamily: "poppins_thin")),
//                         ],
//                       ),
//                     ),
//                     DropdownMenuItem(
//                       value: '9:00',
//                       child: Row(
//                         children: [
//                           const Icon(Icons.person_add, color: Colors.blue, size: 20),
//                           const SizedBox(
//                             width: 5,
//                           ),
//                           const Text('9:00',
//                               style: TextStyle(fontFamily: "poppins_thin")),
//                         ],
//                       ),
//                     ),
//                     DropdownMenuItem(
//                       value: '10:00',
//                       child: Row(
//                         children: [
//                           const Icon(Icons.delete, color: Colors.red, size: 20),
//                           const SizedBox(
//                             width: 5,
//                           ),
//                           const Text('10:00',
//                               style: TextStyle(fontFamily: "poppins_thin")),
//                         ],
//                       ),
//                     ),
//                   ],
//                   onChanged: (value) {
//                     setState(() {
//                       widget.selectedTime = value;
//                     });
//                   },
//                 )),
//           ],
//         )
//       ],
//     );
//   }
//
//   Widget _buildDismissedForm() {
//     return Column(
//       children: [
//         TextField(
//           decoration: InputDecoration(
//             labelText: "Remark *",
//             labelStyle: const TextStyle(fontFamily: "poppins_thin"),
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
//             hintText: "Your Message here...",
//           ),
//           maxLines: 3,
//         ),
//         SizedBox(height: 16,),
//         DropdownButton2(
//           isExpanded: true,
//           hint: const Text(
//             'Close Reason',
//             style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 14,
//                 fontFamily: "poppins_thin",
//                 overflow: TextOverflow.ellipsis),
//           ),
//           value: widget.selectedPurpose,
//           buttonStyleData: ButtonStyleData(
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   color: Colors.white,
//                   boxShadow: [
//                     const BoxShadow(
//                       color: Colors.grey,
//                       blurRadius: 4,
//                       spreadRadius: 2,
//                     ),
//                   ])),
//           underline: const Center(),
//           dropdownStyleData: DropdownStyleData(
//               decoration: BoxDecoration(
//                   border: Border.all(color: Colors.black, width: 2)),
//               elevation: 10),
//           items: [
//             DropdownMenuItem(
//               value: 'Budget Problem',
//               child: Row(
//                 children: [
//                   const Icon(
//                     Icons.check_circle,
//                     size: 20,
//                     color: Colors.green,
//                   ),
//                   const SizedBox(width: 5),
//                   const Text("Budget Problem",
//                       style: TextStyle(fontFamily: "poppins_thin")),
//                 ],
//               ),
//             ),
//             DropdownMenuItem(
//               value: 'Not Required',
//               child: Row(
//                 children: [
//                   const Icon(Icons.person_add, color: Colors.blue, size: 20),
//                   const SizedBox(width: 5),
//                   const Text('Not Required',
//                       style: TextStyle(fontFamily: "poppins_thin")),
//                 ],
//               ),
//             ),
//             DropdownMenuItem(
//               value: 'Muscles',
//               child: Row(
//                 children: [
//                   const Icon(Icons.delete, color: Colors.red, size: 20),
//                   const SizedBox(width: 5),
//                   const Text('Muscles',
//                       style: TextStyle(fontFamily: "poppins_thin")),
//                 ],
//               ),
//             ),
//           ],
//           onChanged: (value) {
//             setState(() {
//               widget.selectedPurpose = value;
//             });
//           },
//         ),
//       ],
//     );
//   }
//
//   Widget _buildAppointmentForm() {
//     return Column(
//       children: [
//         TextField(
//           decoration: InputDecoration(
//             labelText: "Remark *",
//             labelStyle: const TextStyle(fontFamily: "poppins_thin"),
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
//             hintText: "Your Message here...",
//           ),
//           maxLines: 3,
//         ),
//         const SizedBox(height: 16.0),
//         Row(
//           children: [
//             Expanded(
//               child: DropdownButton2(
//                 isExpanded: true,
//                 hint: const Text(
//                   'Int Membership',
//                   style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 14,
//                       fontFamily: "poppins_thin",
//                       overflow: TextOverflow.ellipsis),
//                 ),
//                 value: widget.selectedaction,
//                 buttonStyleData: ButtonStyleData(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     color: Colors.white,
//                     boxShadow: [
//                       const BoxShadow(
//                         color: Colors.grey,
//                         blurRadius: 4,
//                         spreadRadius: 2,
//                       ),
//                     ],
//                   ),
//                 ),
//                 underline: const Center(),
//                 dropdownStyleData: DropdownStyleData(
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.black, width: 2),
//                   ),
//                   elevation: 10,
//                 ),
//                 items: [
//                   DropdownMenuItem(
//                     value: 'Package 1',
//                     child: Row(
//                       children: [
//                         const Icon(Icons.check_circle,
//                             size: 20, color: Colors.green),
//                         const SizedBox(width: 5),
//                         const Text('Package 1',
//                             style: TextStyle(fontFamily: "poppins_thin")),
//                       ],
//                     ),
//                   ),
//                   DropdownMenuItem(
//                     value: 'Package 2',
//                     child: Row(
//                       children: [
//                         const Icon(Icons.person_add,
//                             color: Colors.blue, size: 20),
//                         const SizedBox(width: 5),
//                         const Text('Package 2',
//                             style: TextStyle(fontFamily: "poppins_thin")),
//                       ],
//                     ),
//                   ),
//                   DropdownMenuItem(
//                     value: 'Package 3',
//                     child: Row(
//                       children: [
//                         const  Icon(Icons.delete, color: Colors.red, size: 20),
//                         const SizedBox(width: 5),
//                         const Text('Package 3',
//                             style: TextStyle(fontFamily: "poppins_thin")),
//                       ],
//                     ),
//                   ),
//                 ],
//                 onChanged: (value) {
//                   setState(() {
//                     widget.selectedaction = value;
//                   });
//                 },
//               ),
//             ),
//             const SizedBox(width: 16.0),
//             Expanded(
//               child: GestureDetector(
//                 onTap: () async {
//                   DateTime? selectedDate = await showDatePicker(
//                     context: context,
//                     initialDate: DateTime.now(),
//                     firstDate: DateTime(2000),
//                     lastDate: DateTime(2100),
//                   );
//                   if (selectedDate != null) {
//                     nextFollowUpController.text =
//                     "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
//                   }
//                 },
//                 child: AbsorbPointer(
//                   child: TextField(
//                     controller: nextFollowUpController,
//                     decoration: InputDecoration(
//                       labelText: "Next Follow Up *",
//                       labelStyle:
//                       const TextStyle(fontFamily: "poppins_thin", fontSize: 14),
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20)),
//                       hintText: "DD/MM/YYYY",
//                       suffixIcon: const Icon(Icons.calendar_month),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 16.0),
//         Row(
//           children: [
//             Expanded(
//               child: DropdownButton2(
//                 isExpanded: true,
//                 hint: const Text(
//                   'Time',
//                   style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 14,
//                       fontFamily: "poppins_thin"),
//                 ),
//                 value: widget.selectedApx,
//                 buttonStyleData: ButtonStyleData(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     color: Colors.white,
//                     boxShadow: [
//                       const BoxShadow(
//                         color: Colors.grey,
//                         blurRadius: 4,
//                         spreadRadius: 2,
//                       ),
//                     ],
//                   ),
//                 ),
//                 underline: const Center(),
//                 dropdownStyleData: DropdownStyleData(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     border: Border.all(color: Colors.black, width: 2),
//                   ),
//                   elevation: 10,
//                 ),
//                 items: [
//                   DropdownMenuItem(
//                     value: '8:00',
//                     child: Row(
//                       children: [
//                         const Icon(Icons.check_circle,
//                             size: 20, color: Colors.green),
//                         const SizedBox(width: 5),
//                         const Text('8:00',
//                             style: TextStyle(fontFamily: "poppins_thin")),
//                       ],
//                     ),
//                   ),
//                   DropdownMenuItem(
//                     value: '9:00',
//                     child: Row(
//                       children: [
//                         const Icon(Icons.person_add,
//                             color: Colors.blue, size: 20),
//                         const SizedBox(width: 5),
//                         const Text('9:00',
//                             style: TextStyle(fontFamily: "poppins_thin")),
//                       ],
//                     ),
//                   ),
//                   DropdownMenuItem(
//                     value: '10:00',
//                     child: Row(
//                       children: [
//                         const Icon(Icons.delete, color: Colors.red, size: 20),
//                         const SizedBox(width: 5),
//                         const Text('10:00',
//                             style: TextStyle(fontFamily: "poppins_thin")),
//                       ],
//                     ),
//                   ),
//                 ],
//                 onChanged: (value) {
//                   setState(() {
//                     widget.selectedTime = value;
//                   });
//                 },
//               ),
//             ),
//             const SizedBox(width: 16.0),
//             Expanded(
//               child: GestureDetector(
//                 onTap: () async {
//                   DateTime? selectedDate = await showDatePicker(
//                     context: context,
//                     initialDate: DateTime.now(),
//                     firstDate: DateTime(2000),
//                     lastDate: DateTime(2100),
//                   );
//                   if (selectedDate != null) {
//                     nextFollowUpController.text =
//                     "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
//                   }
//                 },
//                 child: AbsorbPointer(
//                   child: TextField(
//                     controller: nextFollowUpController,
//                     decoration: InputDecoration(
//                       labelText: "Appointment Date *",
//                       labelStyle:
//                       const TextStyle(fontFamily: "poppins_thin", fontSize: 14),
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20)),
//                       hintText: "DD/MM/YYYY",
//                       suffixIcon: const Icon(Icons.calendar_month),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildOtherActionForm() {
//     return Column(
//       children: [
//         TextField(
//           decoration: InputDecoration(
//             labelText: "Remark *",
//             labelStyle: const TextStyle(fontFamily: "poppins_thin"),
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
//             hintText: "Your Message here...",
//           ),
//           maxLines: 3,
//         ),
//         const SizedBox(height: 16.0),
//         Row(
//           children: [
//             Expanded(
//               child: GestureDetector(
//                 onTap: () {
//                   _pickDateAndTime();
//                 },
//                 child: AbsorbPointer(
//                   child: TextField(
//                     controller: widget.controller,
//                     decoration: InputDecoration(
//                       labelText: "Select Date & Time",
//                       labelStyle: const TextStyle(fontFamily: "poppins_thin"),
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20)),
//                       hintText: "DD/MM/YYYY HH:MM",
//                       hintStyle: const TextStyle(fontFamily: "poppins_thin"),
//                       suffixIcon: const Icon(Icons.calendar_month),
//                     ),
//                     readOnly: true,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
//
// // Gradient Button
// class GradientButton extends StatelessWidget {
//   final String buttonText;
//   final VoidCallback onPressed;
//
//   const GradientButton({
//     required this.buttonText,
//     required this.onPressed,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20.0),
//         gradient: LinearGradient(
//           colors: [Colors.deepPurple,Colors.purple],
//           begin: Alignment.centerLeft,
//           end: Alignment.centerRight,
//         ),
//       ),
//       child: ElevatedButton(
//         onPressed: onPressed,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.transparent,
//           shadowColor: Colors.transparent,
//           padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20.0),
//           ),
//         ),
//         child: Text(
//           buttonText,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 18,
//             fontFamily: "poppins_thin",
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // Main Button Group
// class MainButtonGroup extends StatefulWidget {
//   final List<String> buttonTexts;
//   final String selectedButton;
//   final Function(String) onButtonPressed;
//
//   const MainButtonGroup({
//     Key? key,
//     required this.buttonTexts,
//     required this.selectedButton,
//     required this.onButtonPressed,
//   }) : super(key: key);
//
//   @override
//   _MainButtonGroupState createState() => _MainButtonGroupState();
// }
//
// class _MainButtonGroupState extends State<MainButtonGroup> {
//   late String _selectedButton;
//   @override
//   void initState() {
//     super.initState();
//     _selectedButton = widget.selectedButton;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: widget.buttonTexts.map((text) {
//         return Padding(
//           padding: const EdgeInsets.only(right: 8.0),
//           child: ElevatedButton(
//             onPressed: () {
//               setState(() {
//                 _selectedButton = text;
//               });
//               widget.onButtonPressed(text);
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor:
//               _selectedButton == text ? AppColor.Buttoncolor : Colors.white,
//               foregroundColor:
//               _selectedButton == text ? Colors.white : Colors.black,
//               padding:
//               const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20.0),
//                 side: BorderSide(color: Colors.grey.shade300),
//               ),
//             ),
//             child: Text(
//               text,
//               style: const TextStyle(fontFamily: "poppins_thin"),
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }
// }

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hr_app/Inquiry_Management/Utils/Custom%20widgets/quotation_Screen.dart';
import 'package:intl/intl.dart';

import '../../Model/Api Model/allInquiryModel.dart';
import '../Colors/app_Colors.dart';
import 'custom_buttons.dart';

class LeaddetailScreen extends StatefulWidget {
  final Inquiry data;
  String? selectedaction;
  String? selectedApx;
  String? selectedPurpose;
  String? selectedTime;
  List<String> callList;
  String? selectedButton;
  // String? product;
  // String? apxbuy;
  // String? services;
  // String? duration;
  final TextEditingController controller;
  bool? isTiming;

  LeaddetailScreen({
    required this.selectedApx,
    required this.selectedPurpose,
    required this.selectedTime,
    required this.data,
    Key? key,
    required this.callList,
    this.isTiming,
    required this.selectedaction,
    required this.selectedButton,
    required this.controller,
  }) : super(key: key);




  @override
  State<LeaddetailScreen> createState() => _LeaddetailScreenState();
}



class _LeaddetailScreenState extends State<LeaddetailScreen> {
  final TextEditingController nextFollowUpController = TextEditingController();
  bool isDismissed = false;
  DateTime? selectedDate;
  String? selectedTime;
  String? selectedProduct;
  String? selectedBuyingTime;
  String? selectedService;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    widget.selectedButton = widget.callList.isNotEmpty
        ? widget.callList[0]
        : "";

    widget.selectedPurpose = 'Budget Problem';

    // Initialize the controller
    // nextFollowUpController = TextEditingController();

    // Initialize dropdown values to avoid null errors
    // widget.selectedPurpose = null;
    // widget.selectedaction = null;
    // widget.selectedApx = null;// Set the first item
  }

  void showDismissedConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:
          const Text("Are you sure?", style: TextStyle(fontFamily: "poppins_thin")),
          content: const Text("Are you sure you want to dismiss?",
              style: TextStyle(fontFamily: "poppins_thin")),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                setState(() {
                  isDismissed = true; // Mark as dismissed
                });
              },
              child: const Text("Yes", style: TextStyle(fontFamily: "poppins_thin")),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog without action
              },
              child: const Text("No", style: TextStyle(fontFamily: "poppins_thin")),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickDateAndTime() async {
    // Pick Date
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      // Pick Time
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDate = pickedDate;
          selectedTime = pickedTime.format(context);
          widget.controller.text = _formatDateTime(selectedDate, selectedTime);
        });
      }
    }
  }

  // Format the Date and Time together
  String _formatDateTime(DateTime? date, String? time) {
    if (date != null && time != null) {
      DateFormat dateFormat = DateFormat('dd/MM/yyyy');
      return '${dateFormat.format(date)} $time';
    }
    return "Select Date & Time";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.MainColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Lead Details',
          style: TextStyle(fontFamily: "poppins_thin", color: Colors.white,fontSize: 20),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          CircleAvatar(
            backgroundColor: AppColor.Buttoncolor,
            child: const Icon(Icons.call, color: Colors.white),
          ),
          const SizedBox(width: 10.0),
          CircleAvatar(
            backgroundColor: AppColor.Buttoncolor,
            child: const Image(image: AssetImage("assets/whatsapp.png"),color:Colors.white,height: 25,width: 25,),
          ),
          const SizedBox(width: 10.0),
        ],
      ),
      body: Container(
        color: Colors.grey.shade100,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.data.fullName,
                  style: const TextStyle(
                    fontFamily: "poppins_thin",
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '+91 7359399094',
                  style: TextStyle(
                      fontFamily: "poppins_thin",
                      fontSize: 14,
                      color: Colors.grey.shade700),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child:
                        widget.isTiming==true?
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Product*",
                              style: TextStyle(fontFamily: "poppins_thin"),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            DropdownButton2(
                              isExpanded: true,
                              hint: Text('Select Product',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: "poppins_thin")),
                              value: selectedProduct,
                              buttonStyleData: ButtonStyleData(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  color: Colors.grey.shade200,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.shade300,
                                        blurRadius: 4,
                                        spreadRadius: 2)
                                  ],
                                ),
                              ),
                              underline: const Center(),
                              dropdownStyleData: DropdownStyleData(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black, width: 2),
                                ),
                                elevation: 10,
                              ),
                              items: const [
                                DropdownMenuItem(
                                    value: 'table(wooden)',
                                    child: Text('Table (Wooden)',
                                        style: TextStyle(fontFamily: "poppins_thin"))),
                                DropdownMenuItem(
                                    value: 'bowl(steel)',
                                    child: Text('Bowl(Steel)',
                                        style: TextStyle(fontFamily: "poppins_thin"))),
                                DropdownMenuItem(
                                    value: 'sofa(still)',
                                    child: Text('Sofa(Still)',
                                        style: TextStyle(fontFamily: "poppins_thin"))),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  selectedProduct = value;
                                  // print('Country Code Dropdown changed to: $_selectedCountryCode');
                                });
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Apx Buying Time *",
                              style: TextStyle(fontFamily: "poppins_thin"),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            DropdownButton2(
                              isExpanded: true,
                              hint: Text('Select Apx Time',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: "poppins_thin")),
                              value: selectedBuyingTime,
                              buttonStyleData: ButtonStyleData(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  color: Colors.grey.shade200,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.shade300,
                                        blurRadius: 4,
                                        spreadRadius: 2)
                                  ],
                                ),
                              ),
                              underline: const Center(),
                              dropdownStyleData: DropdownStyleData(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black, width: 2),
                                ),
                                elevation: 10,
                              ),
                              items: const [
                                DropdownMenuItem(
                                    value: '10 15 days',
                                    child: Text('10-15 days',
                                        style: TextStyle(fontFamily: "poppins_thin"))),
                                DropdownMenuItem(
                                    value: 'week',
                                    child: Text('Week',
                                        style: TextStyle(fontFamily: "poppins_thin"))),
                                DropdownMenuItem(
                                    value: '2 3 days',
                                    child: Text('2 3 days',
                                        style: TextStyle(fontFamily: "poppins_thin"))),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  selectedBuyingTime = value;
                                  // print('Country Code Dropdown changed to: $_selectedCountryCode');
                                });
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Services *',
                              style: TextStyle(fontFamily: "poppins_thin"),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            DropdownButton2(
                              isExpanded: true,
                              hint: Text('Select Services',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: "poppins_thin")),
                              value: selectedService,
                              buttonStyleData: ButtonStyleData(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  color: Colors.grey.shade200,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.shade300,
                                        blurRadius: 4,
                                        spreadRadius: 2)
                                  ],
                                ),
                              ),
                              underline: const Center(),
                              dropdownStyleData: DropdownStyleData(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black, width: 2),
                                ),
                                elevation: 10,
                              ),
                              items: const [
                                DropdownMenuItem(
                                    value: 'battry panel',
                                    child: Text('Battery Panel',
                                        style: TextStyle(fontFamily: "poppins_thin"))),
                                DropdownMenuItem(
                                    value: 'electricity',
                                    child: Text('Electricity',
                                        style: TextStyle(fontFamily: "poppins_thin"))),
                                DropdownMenuItem(
                                    value: 'IELTS (UK)',
                                    child: Text('IELTS (UK)',
                                        style: TextStyle(fontFamily: "poppins_thin"))),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  selectedService = value;
                                  // print('Country Code Dropdown changed to: $_selectedCountryCode');
                                });
                              },
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Service Duration *',
                              style: TextStyle(fontFamily: "poppins_thin"),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Form(
                              key: _formKey,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: "Duration",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  hintStyle: TextStyle(fontFamily: "poppins_thin"),
                                ),
                              ),
                            ),
                          ],
                        ):
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            _buildDetailItem(
                                'Product', widget.data.InqType, Icons.shopping_bag),
                            _buildDetailItem('Apx Buying', widget.data.InqType,
                                Icons.attach_money),
                            _buildDetailItem(
                                'Service Name', widget.data.InqType, Icons.work),
                            _buildDetailItem('Service Duration', widget.data.InqType,
                                Icons.timer),
                          ],
                        )

                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                    child: gradientButton(
                      buttonText: "Quotation",
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => QuotationScreen(),));
                      },
                    )),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Colors.grey.shade100,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black38,
                              blurRadius: 5,

                            )
                          ]
                      ),


                      padding: EdgeInsets.all(4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 2),
                            child: Text("Status",style: TextStyle(fontFamily: "poppins_thin",fontSize: 20),),
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: MainButtonGroup(
                                  buttonTexts: widget.callList,
                                  selectedButton: widget.selectedButton.toString(),


                                  onButtonPressed: (value) {
                                    setState(() {
                                      widget.selectedButton = value;
                                      if (value == "Dismissed") {
                                        showDismissedConfirmationDialog();
                                      } else {
                                        isDismissed = false;
                                      }
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),

                        ],
                      )),
                ),

                const SizedBox(height: 20),
                _buildActionContent(),
                const SizedBox(height: 20),
                Center(
                    child: gradientButton(
                      buttonText: "Submit",
                      onPressed: () {},
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildDetailItem(String key, String? value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: AppColor.Buttoncolor,size: 18,),
              const SizedBox(width: 8.0,),
              Text("$key:",
                style: const TextStyle(
                  fontFamily: "poppins_thin",
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  value ?? 'N/A',
                  style: const TextStyle(fontFamily: "poppins_thin",fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0,),
          Container(height: 1, color: Colors.grey.shade300)
        ],
      ),
    ).animate().fadeIn(duration: const Duration(milliseconds: 300)).slideX(duration: const Duration(milliseconds: 300), begin: -0.1).move(duration: const Duration(milliseconds: 300),);
  }


  Widget _buildActionContent() {
    if (widget.selectedButton == "Follow up") {
      return _buildFollowUpForm();
    } else if (widget.selectedButton == "Dismissed") {
      return _buildDismissedForm();
    } else if (widget.selectedButton == "Appointment") {
      return _buildAppointmentForm();
    } else if(widget.selectedButton=="Negotiation"){
      return _buildOtherActionForm();
    }else if(widget.selectedButton=="Feedback"){
      return _buildOtherActionForm();
    }else {
      return _buildOtherActionForm();
    }
  }

  Widget _buildFollowUpForm() {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: "Remark *",
            labelStyle: const TextStyle(fontFamily: "poppins_thin"),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            hintText: "Your Message here...",
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 16.0),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    nextFollowUpController.text =
                    "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
                  }
                },
                child: AbsorbPointer(
                  child: TextField(
                    controller: nextFollowUpController,
                    decoration: InputDecoration(
                        labelText: "Next Follow Up *",
                        labelStyle: const TextStyle(fontFamily: "poppins_thin"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        hintText: "DD/MM/YYYY",
                        suffixIcon: const Icon(Icons.calendar_month)),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16.0),
            // Expanded(
            //     child: DropdownButton2(
            //       isExpanded: true,
            //       hint: const Text(
            //         'Time',
            //         style: TextStyle(
            //             color: Colors.black,
            //             fontSize: 16,
            //             fontFamily: "poppins_thin",
            //             overflow: TextOverflow.ellipsis),
            //       ),
            //       value: widget.selectedApx,
            //       buttonStyleData: ButtonStyleData(
            //           decoration: BoxDecoration(
            //               borderRadius: BorderRadius.circular(20),
            //               color: Colors.white,
            //               boxShadow: [
            //                 const BoxShadow(
            //                   color: Colors.grey,
            //                   blurRadius: 4,
            //                   spreadRadius: 2,
            //                 ),
            //               ])),
            //       underline: const Center(),
            //       dropdownStyleData: DropdownStyleData(
            //           decoration: BoxDecoration(
            //               border: Border.all(color: Colors.black, width: 2)),
            //           elevation: 10),
            //       items: [
            //         DropdownMenuItem(
            //           value: '8:00',
            //           child: Row(
            //             children: [
            //               const Icon(
            //                 Icons.check_circle,
            //                 size: 20,
            //                 color: Colors.green,
            //               ),
            //               const SizedBox(
            //                 width: 5,
            //               ),
            //               const Text('8:00',
            //                   style: TextStyle(fontFamily: "poppins_thin")),
            //             ],
            //           ),
            //         ),
            //         DropdownMenuItem(
            //           value: '9:00',
            //           child: Row(
            //             children: [
            //               const Icon(Icons.person_add, color: Colors.blue, size: 20),
            //               const SizedBox(
            //                 width: 5,
            //               ),
            //               const Text('9:00',
            //                   style: TextStyle(fontFamily: "poppins_thin")),
            //             ],
            //           ),
            //         ),
            //         DropdownMenuItem(
            //           value: '10:00',
            //           child: Row(
            //             children: [
            //               const Icon(Icons.delete, color: Colors.red, size: 20),
            //               const SizedBox(
            //                 width: 5,
            //               ),
            //               const Text('10:00',
            //                   style: TextStyle(fontFamily: "poppins_thin")),
            //             ],
            //           ),
            //         ),
            //       ],
            //       onChanged: (value) {
            //         setState(() {
            //           widget.selectedTime = value;
            //         });
            //       },
            //     )),
          ],
        )
      ],
    );
  }

  Widget _buildDismissedForm() {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: "Remark *",
            labelStyle: const TextStyle(fontFamily: "poppins_thin"),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            hintText: "Your Message here...",
          ),
          maxLines: 3,
        ),
        SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton2(
            isExpanded: true,
            hint: const Text(
              'Close Reason',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: "poppins_thin",
                  overflow: TextOverflow.ellipsis),
            ),
            value: widget.selectedPurpose,
            buttonStyleData: ButtonStyleData(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  const BoxShadow(
                    color: Colors.grey,
                    blurRadius: 4,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
            underline: const SizedBox(),
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
              ),
              elevation: 10,
            ),
            items: const [
              DropdownMenuItem(
                value: 'Budget Problem',
                child: Text("Budget Problem",
                    style: TextStyle(fontFamily: "poppins_thin")),
              ),
              DropdownMenuItem(
                value: 'Not Required',
                child: Text('Not Required',
                    style: TextStyle(fontFamily: "poppins_thin")),
              ),
              DropdownMenuItem(
                value: 'Muscles',
                child: Text('Muscles',
                    style: TextStyle(fontFamily: "poppins_thin")),
              ),
            ],
            onChanged: (value) {
              setState(() {
                widget.selectedPurpose = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAppointmentForm() {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: "Remark *",
            labelStyle: const TextStyle(fontFamily: "poppins_thin"),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            hintText: "Your Message here...",
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 16.0),
        Row(
          children: [
            Expanded(
              child: DropdownButton2(
                isExpanded: true,
                hint: const Text(
                  'Int Membership',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: "poppins_thin",
                      overflow: TextOverflow.ellipsis),
                ),
                value: widget.selectedaction,
                buttonStyleData: ButtonStyleData(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      const BoxShadow(
                        color: Colors.grey,
                        blurRadius: 4,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
                underline: const SizedBox(),
                dropdownStyleData: DropdownStyleData(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  elevation: 10,
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Package 1',
                    child: Text('Package 1',
                        style: TextStyle(fontFamily: "poppins_thin")),
                  ),
                  DropdownMenuItem(
                    value: 'Package 2',
                    child: Text('Package 2',
                        style: TextStyle(fontFamily: "poppins_thin")),
                  ),
                  DropdownMenuItem(
                    value: 'Package 3',
                    child: Text('Package 3',
                        style: TextStyle(fontFamily: "poppins_thin")),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    widget.selectedaction = value;
                  });
                },
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    nextFollowUpController.text =
                    "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
                  }
                },
                child: AbsorbPointer(
                  child: TextField(
                    controller: nextFollowUpController,
                    decoration: InputDecoration(
                      labelText: "Next Follow Up *",
                      labelStyle:
                      const TextStyle(fontFamily: "poppins_thin", fontSize: 14),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      hintText: "DD/MM/YYYY",
                      suffixIcon: const Icon(Icons.calendar_month),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
  Widget _buildOtherActionForm() {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: "Remark *",
            labelStyle: const TextStyle(fontFamily: "poppins_thin"),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            hintText: "Your Message here...",
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 16.0),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  _pickDateAndTime();
                },
                child: AbsorbPointer(
                  child: TextField(
                    controller: widget.controller,
                    decoration: InputDecoration(
                      labelText: "Select Date & Time",
                      labelStyle: const TextStyle(fontFamily: "poppins_thin"),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      hintText: "DD/MM/YYYY HH:MM",
                      hintStyle: const TextStyle(fontFamily: "poppins_thin"),
                      suffixIcon: const Icon(Icons.calendar_month),
                    ),
                    readOnly: true,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Gradient Button
class gradientButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const gradientButton({
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        gradient: LinearGradient(
          colors: [Colors.deepPurple,Colors.purple],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        child: Text(
          buttonText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: "poppins_thin",
          ),
        ),
      ),
    );
  }
}


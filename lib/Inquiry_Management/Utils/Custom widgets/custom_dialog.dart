import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'custom_buttons.dart';
class dialogs extends StatefulWidget {
  const dialogs({super.key});

  @override
  State<dialogs> createState() => _dialogsState();
}

class _dialogsState extends State<dialogs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

void showConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        contentPadding: EdgeInsets.all(20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Lottie.asset('assets/errors.json', fit: BoxFit.contain, width: 200, height: 200),
            ),
            SizedBox(height: 20),
            Text(
              'Are you sure?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'You want to Assign 1 Followup to vb (Admin)?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                fontFamily: "poppins_thin",
              ),
            ),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // User confirmed
                    print('Yes, Assign 1 Followup!');
                    Navigator.of(context).pop(true); // Return true
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Yes, Assign 1 Followup!',
                    style: TextStyle(color: Colors.white, fontFamily: "poppins_thin"),
                  ),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    // User declined
                    print('No, cancel!');
                    Navigator.of(context).pop(false); // Return false
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'No, cancel!',
                    style: TextStyle(color: Colors.white, fontFamily: "poppins_thin"),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  ).then((value) {
    if (value != null) {
      if (value) {
        print("User confirmed the action");
        // Handle post-confirmation logic here
      } else {
        print("User canceled the action");
      }
    }
  });
}
void showsubmitdialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        contentPadding: EdgeInsets.all(20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Lottie.asset('assets/errors.json', fit: BoxFit.contain, width: 200, height: 200),
            ),
            SizedBox(height: 20),
            Text(
              'Missing Data',
              style: TextStyle(
                fontSize: 24,
                fontFamily: "poppins_thin",
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Please select both an action and an employee before submitting.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontFamily: "poppins_thin",
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 25),
            GradientButton(
              buttonText: "Okay",
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
            ),
          ],
        ),
      );
    },
  );
}


// void showCallDialog(BuildContext context){
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15)),
//         contentPadding: EdgeInsets.all(20),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Center(
//                 child: Lottie.asset('assets/errors.json',fit: BoxFit.contain,width: 200,height: 200)
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Missing Data',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontFamily: "poppins_thin",
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//             SizedBox(height: 10),
//             Text(
//               'Please select both an action and an employee before submitting.',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 16,
//                 fontFamily: "poppins_thin",
//                 color: Colors.black54,
//               ),
//             ),
//             SizedBox(height: 25),
//             GradientButton(
//               buttonText: "Okay",
//               onPressed: () {
//                 Navigator.pop(context);
//               },)
//           ],
//         ),
//       );
//     },
//   );
// }
// import 'package:flutter/material.dart';


// class customdialog extends StatefulWidget {
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
//   customdialog({
//     required this.selectedApx,
//     required this.selectedPurpose,
//     required this.selectedTime,
//     required this.data,
//     super.key,
//     required this.callList,
//     required this.product,
//     required this.apxbuy,
//     required this.services,
//     required this.duration,
//     required this.selectedaction,
//   required this.selectedButton,required this.controller});
//


//   @override
//   State<customdialog> createState() => _customdialogState();
// }



// class _customdialogState extends State<customdialog> {
//   final TextEditingController nextFollowUpController = TextEditingController();
//   late String selectedCall;
//   bool isDismissed = false;
//
//   @override
//   void initState() {
//     super.initState();
//     selectedCall = widget.selectedaction ?? widget.callList.first;
//     widget.selectedButton = widget.callList.isNotEmpty
//         ? widget.callList[0]
//         : "";
//   }
//
//   void showDismissedConfirmationDialog() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Are you sure?",style: TextStyle(fontFamily: "poppins_thin"),),
//           content: const Text("Are you sure you want to dismiss?",style: TextStyle(fontFamily: "poppins_thin")),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context); // Close the dialog
//                 setState(() {
//                   isDismissed = true; // Mark as dismissed
//                 });
//               },
//               child: const Text("Yes",style: TextStyle(fontFamily: "poppins_thin")),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context); // Close the dialog without action
//               },
//               child: const Text("No",style: TextStyle(fontFamily: "poppins_thin")),
//             ),
//           ],
//         );
//       },
//     );
//   }
//   DateTime? selectedDate;
//   String? selectedTime;
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
// // Format the Date and Time together
//   String _formatDateTime(DateTime? date, String? time) {
//     if (date != null && time != null) {
//       DateFormat dateFormat = DateFormat('dd/MM/yyyy');
//       return '${dateFormat.format(date)} $time';
//     }
//     return "Select Date & Time";
//   }
//
//   //
//   // @override
//   // Widget build(BuildContext context) {
//   //   return Dialog(
//   //     shape: RoundedRectangleBorder(
//   //       borderRadius: BorderRadius.circular(16.0),
//   //     ),
//   //     child: SingleChildScrollView(
//   //       child: Padding(
//   //         padding: const EdgeInsets.all(16.0),
//   //         child: Column(
//   //           crossAxisAlignment: CrossAxisAlignment.start,
//   //           children: [
//   //             // Header Section
//   //             Row(
//   //               children: [
//   //                 Text(
//   //                   "${widget.data.name ?? 'Unknown'}",
//   //                   style: TextStyle(
//   //                     fontFamily: "poppins_thin",
//   //                     fontSize: 18
//   //                   ),
//   //                 ),
//   //                 Spacer(),
//   //                 CircleAvatar(
//   //                   backgroundColor: AppColor.Buttoncolor,
//   //                   child: Icon(Icons.call, color: Colors.white),
//   //                 ),
//   //                 SizedBox(width: 10.0),
//   //                 CircleAvatar(
//   //                   backgroundColor: AppColor.Buttoncolor,
//   //                   child: Icon(Icons.message, color: Colors.white),
//   //                 ),
//   //                 SizedBox(width: 10.0),
//   //                 CircleAvatar(
//   //                   backgroundColor: AppColor.Buttoncolor,
//   //                   child: Icon(Icons.call, color: Colors.white),
//   //                 ),
//   //                 SizedBox(width: 10.0),
//   //                 GestureDetector(
//   //                   onTap: () {
//   //                     Navigator.pop(context);
//   //                   },
//   //                   child: CircleAvatar(
//   //                     backgroundColor: AppColor.Buttoncolor,
//   //                     child: Icon(Icons.close, color: Colors.white),
//   //                   ),
//   //                 ),
//   //               ],
//   //             ),
//   //             Text('+91 7359399094',style: TextStyle(fontFamily: "poppins_thin",fontSize: 14,color: Colors.grey.shade700),),
//   //             Padding(
//   //               padding: const EdgeInsets.symmetric(vertical: 8.0),
//   //               child: Container(
//   //                 height: 120,
//   //                 width: double.infinity,
//   //                 decoration: BoxDecoration(
//   //                   color: Colors.grey.shade300,
//   //                   boxShadow: [
//   //                     BoxShadow(color: Colors.black38, blurRadius: 10),
//   //                   ],
//   //                   borderRadius: BorderRadius.circular(20),
//   //                 ),
//   //                 child: Padding(
//   //                   padding: const EdgeInsets.all(12.0), // Added padding inside the container
//   //                   child: Column(
//   //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Adjusted space distribution
//   //                     children: [
//   //                       Row(
//   //                         children: [
//   //                           Text("Product : ",
//   //                               style: TextStyle(
//   //                                   fontFamily: "poppins_thin",
//   //                                   color: Colors.black,
//   //                                   fontSize: 14)),
//   //                           Expanded(
//   //                               child: Text("${widget.product}",
//   //                                   style: TextStyle(
//   //                                       fontFamily: "poppins_thin",
//   //                                       color: Colors.black,
//   //                                       fontSize: 14,
//   //                                       overflow: TextOverflow.ellipsis))),
//   //                         ],
//   //                       ),
//   //                       Row(
//   //                         children: [
//   //                           Text("Apx Buying : ",
//   //                               style: TextStyle(
//   //                                   fontFamily: "poppins_thin",
//   //                                   color: Colors.black,
//   //                                   fontSize: 14)),
//   //                           Expanded(
//   //                               child: Text("${widget.apxbuy}",
//   //                                   style: TextStyle(
//   //                                       fontFamily: "poppins_thin",
//   //                                       color: Colors.black,
//   //                                       fontSize: 14,
//   //                                       overflow: TextOverflow.ellipsis))),
//   //                         ],
//   //                       ),
//   //                       Row(
//   //                         children: [
//   //                           Text("Service Name : ",
//   //                               style: TextStyle(
//   //                                   fontFamily: "poppins_thin",
//   //                                   color: Colors.black,
//   //                                   fontSize: 14)),
//   //                           Expanded(
//   //                               child: Text("${widget.services}",
//   //                                   style: TextStyle(
//   //                                       fontFamily: "poppins_thin",
//   //                                       color: Colors.black,
//   //                                       fontSize: 14,
//   //                                       overflow: TextOverflow.ellipsis))),
//   //                         ],
//   //                       ),
//   //                       Row(
//   //                         children: [
//   //                           Text("Service Duration: ",
//   //                               style: TextStyle(
//   //                                   fontFamily: "poppins_thin",
//   //                                   color: Colors.black,
//   //                                   fontSize: 14)),
//   //                           Expanded(
//   //                               child: Text("${widget.duration}",
//   //                                   style: TextStyle(
//   //                                       fontFamily: "poppins_thin",
//   //                                       color: Colors.black,
//   //                                       fontSize: 14,
//   //                                       overflow: TextOverflow.ellipsis))),
//   //                         ],
//   //                       )
//   //                     ],
//   //                   ),
//   //                 ),
//   //               ),
//   //             ),
//   //             SizedBox(height: 16.0),
//   //             Center(
//   //                 child: GradientButton(
//   //                   buttonText: "Quotation",
//   //                   onPressed: () {
//   //
//   //                   },)
//   //             ),
//   //             SizedBox(height: 16.0),
//   //             Row(
//   //               children: [
//   //                 Flexible( // Using Flexible instead of Expanded
//   //                   child: SingleChildScrollView(
//   //                     scrollDirection: Axis.horizontal,
//   //                     child: MainButtonGroup(
//   //                       buttonTexts: widget.callList,
//   //                       selectedButton: widget.selectedButton.toString(),
//   //                       onButtonPressed: (value) {
//   //                         setState(() {
//   //                           widget.selectedButton =
//   //                               value; // Update selected button
//   //                           if (value == "Dismissed") {
//   //                             showDismissedConfirmationDialog();
//   //                           } else {
//   //                             isDismissed = false; // Reset dismissal flag
//   //                           }
//   //                         });
//   //                       },
//   //                     ),
//   //                   ),
//   //                 ),
//   //               ],
//   //             ),
//   //
//   //             SizedBox(height: 16.0),
//   //             widget.selectedButton=="Follow up"?
//   //             // Remark Section
//   //             Column(
//   //               children: [
//   //                 TextField(
//   //                   decoration: InputDecoration(
//   //                     labelText: "Remark *",
//   //                     labelStyle: TextStyle(fontFamily: "poppins_thin"),
//   //                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
//   //                     hintText: "Your Message here...",
//   //                   ),
//   //                   maxLines: 3,
//   //                 ),
//   //                 SizedBox(height: 16.0),
//   //                 Row(
//   //                   children: [
//   //                     Expanded(
//   //                       child: GestureDetector(
//   //                         onTap: () async {
//   //                           DateTime? selectedDate = await showDatePicker(
//   //                             context: context,
//   //                             initialDate: DateTime.now(),
//   //                             firstDate: DateTime(2000),
//   //                             lastDate: DateTime(2100),
//   //                           );
//   //                           if (selectedDate != null) {
//   //                             // Handle the selected date
//   //                             nextFollowUpController.text = "${selectedDate
//   //                                 .day}/${selectedDate.month}/${selectedDate.year}";
//   //                           }
//   //                         },
//   //                         child: AbsorbPointer(
//   //                           child: TextField(
//   //                             controller: nextFollowUpController,
//   //                             decoration: InputDecoration(
//   //                                 labelText: "Next Follow Up *",
//   //                                 labelStyle: TextStyle(fontFamily: "poppins_thin"),
//   //                                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
//   //                                 hintText: "DD/MM/YYYY",
//   //                                 suffixIcon: Icon(Icons.calendar_month)
//   //                             ),
//   //                           ),
//   //                         ),
//   //                       ),
//   //                     ),
//   //
//   //                     SizedBox(width: 16.0),
//   //                     Expanded(
//   //                         child: DropdownButton2(
//   //                           isExpanded: true,
//   //                           // This will make the dropdown button take full width
//   //                           hint: Text(
//   //                             'Time',
//   //                             style: TextStyle(color: Colors.black,
//   //                                 fontSize: 16,
//   //                                 fontFamily: "poppins_thin",
//   //                                 overflow: TextOverflow.ellipsis),
//   //                           ),
//   //                           value: widget.selectedApx,
//   //
//   //                           buttonStyleData: ButtonStyleData(
//   //                               decoration: BoxDecoration(
//   //                                   borderRadius: BorderRadius.circular(20),
//   //                                   color: Colors.grey.shade100,
//   //                                   boxShadow: [
//   //                                     BoxShadow(
//   //                                       color: Colors.grey.shade300,
//   //                                       blurRadius: 4,
//   //                                       spreadRadius: 2,
//   //                                     ),
//   //                                   ]
//   //                               )
//   //                           ),
//   //                           underline: Center(),
//   //                           dropdownStyleData: DropdownStyleData(
//   //                               decoration: BoxDecoration(
//   //                                   border: Border.all(color: Colors.black,
//   //                                       width: 2)
//   //                               ),
//   //                               elevation: 10
//   //                           ),
//   //                           items: [
//   //                             DropdownMenuItem(
//   //                               value: '8:00',
//   //                               child: Row(
//   //                                 children: [
//   //                                   Icon(Icons.check_circle, size: 20,
//   //                                     color: Colors.green,),
//   //                                   SizedBox(width: 5,),
//   //                                   Text('8:00', style: TextStyle(
//   //                                       fontFamily: "poppins_thin"),),
//   //                                 ],
//   //                               ),
//   //                             ),
//   //                             DropdownMenuItem(
//   //                               value: '9:00',
//   //                               child: Row(
//   //                                 children: [
//   //                                   Icon(Icons.person_add, color: Colors.blue,
//   //                                     size: 20,),
//   //                                   SizedBox(width: 5,),
//   //                                   Text('9:00', style: TextStyle(
//   //                                       fontFamily: "poppins_thin"),),
//   //                                 ],
//   //                               ),
//   //                             ),
//   //                             DropdownMenuItem(
//   //                               value: '10:00',
//   //                               child: Row(
//   //                                 children: [
//   //                                   Icon(Icons.delete, color: Colors.red, size: 20),
//   //                                   SizedBox(width: 5,),
//   //                                   Text('10:00', style: TextStyle(
//   //                                       fontFamily: "poppins_thin"),),
//   //                                 ],
//   //                               ),
//   //                             ),
//   //                           ],
//   //                           onChanged: (value) {
//   //                             setState(() {
//   //                               widget.selectedTime = value;
//   //                             });
//   //                           },
//   //                         )
//   //                     ),
//   //                   ],
//   //                 )
//   //
//   //               ],
//   //             ):widget.selectedButton=="Dismissed"?
//   //                 Column(
//   //                   children: [
//   //                     DropdownButton2(
//   //                       isExpanded: true,
//   //                       // This will make the dropdown button take full width
//   //                       hint: Text(
//   //                         'Close Reason',
//   //                         style: TextStyle(color: Colors.black,
//   //                             fontSize: 14,
//   //                             fontFamily: "poppins_thin",
//   //                             overflow: TextOverflow.ellipsis),
//   //                       ),
//   //                       value: widget.selectedPurpose,
//   //
//   //                       buttonStyleData: ButtonStyleData(
//   //                           decoration: BoxDecoration(
//   //                               borderRadius: BorderRadius.circular(20),
//   //                               color: Colors.grey.shade100,
//   //                               boxShadow: [
//   //                                 BoxShadow(
//   //                                   color: Colors.grey.shade300,
//   //                                   blurRadius: 4,
//   //                                   spreadRadius: 2,
//   //                                 ),
//   //                               ]
//   //                           )
//   //                       ),
//   //                       underline: Center(),
//   //                       dropdownStyleData: DropdownStyleData(
//   //                           decoration: BoxDecoration(
//   //                               border: Border.all(color: Colors.black, width: 2)
//   //                           ),
//   //                           elevation: 10
//   //                       ),
//   //                       items: [
//   //                         DropdownMenuItem(
//   //                           value: 'Budget Problem',
//   //                           child: Row(
//   //                             children: [
//   //                               Icon(
//   //                                 Icons.check_circle, size: 20, color: Colors.green,),
//   //                               SizedBox(width: 5,),
//   //                               Text("Budget Problem",
//   //                                 style: TextStyle(fontFamily: "poppins_thin"),),
//   //                             ],
//   //                           ),
//   //                         ),
//   //                         DropdownMenuItem(
//   //                           value: 'Not Required',
//   //                           child: Row(
//   //                             children: [
//   //                               Icon(Icons.person_add, color: Colors.blue, size: 20,),
//   //                               SizedBox(width: 5,),
//   //                               Text('Not Required',
//   //                                 style: TextStyle(fontFamily: "poppins_thin"),),
//   //                             ],
//   //                           ),
//   //                         ),
//   //                         DropdownMenuItem(
//   //                           value: 'Muscles',
//   //                           child: Row(
//   //                             children: [
//   //                               Icon(Icons.delete, color: Colors.red, size: 20),
//   //                               SizedBox(width: 5,),
//   //                               Text('Muscles',
//   //                                 style: TextStyle(fontFamily: "poppins_thin"),),
//   //                             ],
//   //                           ),
//   //                         ),
//   //                       ],
//   //                       onChanged: (value) {
//   //                         setState(() {
//   //                           widget.selectedPurpose = value;
//   //                         });
//   //                       },
//   //                     ),
//   //                   ],
//   //                 ):widget.selectedButton=="Appointment"?
//   //             Column(
//   //               children: [
//   //                 // Remark TextField
//   //                 TextField(
//   //                   decoration: InputDecoration(
//   //                     labelText: "Remark *",
//   //                     labelStyle: TextStyle(fontFamily: "poppins_thin"),
//   //                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
//   //                     hintText: "Your Message here...",
//   //                   ),
//   //                   maxLines: 3,
//   //                 ),
//   //                 SizedBox(height: 16.0),
//   //
//   //                 // Row 1: Membership Dropdown and Next Follow Up Date Picker
//   //                 Row(
//   //                   children: [
//   //                     Expanded(
//   //                       child: DropdownButton2(
//   //                         isExpanded: true,
//   //                         hint: Text(
//   //                           'Int Membership',
//   //                           style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: "poppins_thin",overflow: TextOverflow.ellipsis),
//   //                         ),
//   //                         value: widget.selectedaction,
//   //                         buttonStyleData: ButtonStyleData(
//   //                           decoration: BoxDecoration(
//   //                             borderRadius: BorderRadius.circular(20),
//   //                             color: Colors.grey.shade100,
//   //                             boxShadow: [
//   //                               BoxShadow(
//   //                                 color: Colors.grey.shade300,
//   //                                 blurRadius: 4,
//   //                                 spreadRadius: 2,
//   //                               ),
//   //                             ],
//   //                           ),
//   //                         ),
//   //                         underline: Center(),
//   //                         dropdownStyleData: DropdownStyleData(
//   //                           decoration: BoxDecoration(
//   //                             border: Border.all(color: Colors.black, width: 2),
//   //                           ),
//   //                           elevation: 10,
//   //                         ),
//   //                         items: [
//   //                           DropdownMenuItem(
//   //                             value: 'Package 1',
//   //                             child: Row(
//   //                               children: [
//   //                                 Icon(Icons.check_circle, size: 20, color: Colors.green),
//   //                                 SizedBox(width: 5),
//   //                                 Text('Package 1', style: TextStyle(fontFamily: "poppins_thin")),
//   //                               ],
//   //                             ),
//   //                           ),
//   //                           DropdownMenuItem(
//   //                             value: 'Package 2',
//   //                             child: Row(
//   //                               children: [
//   //                                 Icon(Icons.person_add, color: Colors.blue, size: 20),
//   //                                 SizedBox(width: 5),
//   //                                 Text('Package 2', style: TextStyle(fontFamily: "poppins_thin")),
//   //                               ],
//   //                             ),
//   //                           ),
//   //                           DropdownMenuItem(
//   //                             value: 'Package 3',
//   //                             child: Row(
//   //                               children: [
//   //                                 Icon(Icons.delete, color: Colors.red, size: 20),
//   //                                 SizedBox(width: 5),
//   //                                 Text('Package 3', style: TextStyle(fontFamily: "poppins_thin")),
//   //                               ],
//   //                             ),
//   //                           ),
//   //                         ],
//   //                         onChanged: (value) {
//   //                           setState(() {
//   //                             widget.selectedaction = value;
//   //                           });
//   //                         },
//   //                       ),
//   //                     ),
//   //                     SizedBox(width: 16.0),
//   //                     Expanded(
//   //                       child: GestureDetector(
//   //                         onTap: () async {
//   //                           DateTime? selectedDate = await showDatePicker(
//   //                             context: context,
//   //                             initialDate: DateTime.now(),
//   //                             firstDate: DateTime(2000),
//   //                             lastDate: DateTime(2100),
//   //                           );
//   //                           if (selectedDate != null) {
//   //                             // Handle the selected date
//   //                             nextFollowUpController.text = "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
//   //                           }
//   //                         },
//   //                         child: AbsorbPointer(
//   //                           child: TextField(
//   //                             controller: nextFollowUpController,
//   //                             decoration: InputDecoration(
//   //                               labelText: "Next Follow Up *",
//   //                               labelStyle: TextStyle(fontFamily: "poppins_thin",fontSize: 14),
//   //                               border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
//   //                               hintText: "DD/MM/YYYY",
//   //                               suffixIcon: Icon(Icons.calendar_month),
//   //                             ),
//   //                           ),
//   //                         ),
//   //                       ),
//   //                     ),
//   //                   ],
//   //                 ),
//   //                 SizedBox(height: 16.0),
//   //
//   //                 // Row 2: Time Dropdown and Appointment Date Picker
//   //                 Row(
//   //                   children: [
//   //                     Expanded(
//   //                       child: DropdownButton2(
//   //                         isExpanded: true,
//   //                         hint: Text(
//   //                           'Time',
//   //                           style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: "poppins_thin"),
//   //                         ),
//   //                         value: widget.selectedApx,
//   //                         buttonStyleData: ButtonStyleData(
//   //                           decoration: BoxDecoration(
//   //                             borderRadius: BorderRadius.circular(20),
//   //                             color: Colors.grey.shade100,
//   //                             boxShadow: [
//   //                               BoxShadow(
//   //                                 color: Colors.grey.shade300,
//   //                                 blurRadius: 4,
//   //                                 spreadRadius: 2,
//   //                               ),
//   //                             ],
//   //                           ),
//   //                         ),
//   //                         underline: Center(),
//   //                         dropdownStyleData: DropdownStyleData(
//   //                           decoration: BoxDecoration(
//   //                             borderRadius: BorderRadius.circular(20),
//   //                             border: Border.all(color: Colors.black, width: 2),
//   //                           ),
//   //                           elevation: 10,
//   //                         ),
//   //                         items: [
//   //                           DropdownMenuItem(
//   //                             value: '8:00',
//   //                             child: Row(
//   //                               children: [
//   //                                 Icon(Icons.check_circle, size: 20, color: Colors.green),
//   //                                 SizedBox(width: 5),
//   //                                 Text('8:00', style: TextStyle(fontFamily: "poppins_thin")),
//   //                               ],
//   //                             ),
//   //                           ),
//   //                           DropdownMenuItem(
//   //                             value: '9:00',
//   //                             child: Row(
//   //                               children: [
//   //                                 Icon(Icons.person_add, color: Colors.blue, size: 20),
//   //                                 SizedBox(width: 5),
//   //                                 Text('9:00', style: TextStyle(fontFamily: "poppins_thin")),
//   //                               ],
//   //                             ),
//   //                           ),
//   //                           DropdownMenuItem(
//   //                             value: '10:00',
//   //                             child: Row(
//   //                               children: [
//   //                                 Icon(Icons.delete, color: Colors.red, size: 20),
//   //                                 SizedBox(width: 5),
//   //                                 Text('10:00', style: TextStyle(fontFamily: "poppins_thin")),
//   //                               ],
//   //                             ),
//   //                           ),
//   //                         ],
//   //                         onChanged: (value) {
//   //                           setState(() {
//   //                             widget.selectedTime = value;
//   //                           });
//   //                         },
//   //                       ),
//   //                     ),
//   //                     SizedBox(width: 16.0),
//   //                     Expanded(
//   //                       child: GestureDetector(
//   //                         onTap: () async {
//   //                           DateTime? selectedDate = await showDatePicker(
//   //                             context: context,
//   //                             initialDate: DateTime.now(),
//   //                             firstDate: DateTime(2000),
//   //                             lastDate: DateTime(2100),
//   //                           );
//   //                           if (selectedDate != null) {
//   //                             // Handle the selected date
//   //                             nextFollowUpController.text = "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
//   //                           }
//   //                         },
//   //                         child: AbsorbPointer(
//   //                           child: TextField(
//   //                             controller: nextFollowUpController,
//   //                             decoration: InputDecoration(
//   //                               labelText: "Appointment Date *",
//   //                               labelStyle: TextStyle(fontFamily: "poppins_thin",fontSize: 14),
//   //                               border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
//   //                               hintText: "DD/MM/YYYY",
//   //                               suffixIcon: Icon(Icons.calendar_month),
//   //                             ),
//   //                           ),
//   //                         ),
//   //                       ),
//   //                     ),
//   //                   ],
//   //                 ),
//   //               ],
//   //             )
//   //                 :Column(
//   //               children: [
//   //                 TextField(
//   //                   decoration: InputDecoration(
//   //                     labelText: "Remark *",
//   //                     labelStyle: TextStyle(fontFamily: "poppins_thin"),
//   //                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
//   //                     hintText: "Your Message here...",
//   //                   ),
//   //                   maxLines: 3,
//   //                 ),
//   //                 SizedBox(height: 16.0),
//   //                 Row(
//   //                   children: [
//   //                     Expanded(
//   //                       child: GestureDetector(
//   //                         onTap: () {
//   //                           _pickDateAndTime();
//   //                         },
//   //                         child: AbsorbPointer(
//   //                           child: TextField(
//   //                             controller:widget.controller,
//   //                             decoration: InputDecoration(
//   //                               labelText: "Select Date & Time",
//   //                               labelStyle: TextStyle(fontFamily: "poppins_thin"),
//   //                               border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
//   //                               hintText: "DD/MM/YYYY HH:MM",
//   //                               hintStyle: TextStyle(fontFamily: "poppins_thin"),
//   //                               suffixIcon: Icon(Icons.calendar_month),
//   //                             ),
//   //                             readOnly: true,
//   //                           ),
//   //                         ),
//   //                       ),
//   //                     ),
//   //                   ],
//   //                 ),
//   //               ],
//   //             ),
//   //
//   //
//   //             SizedBox(height: 16.0),
//   //             // Submit Button
//   //             Center(
//   //                 child: GradientButton(
//   //                   buttonText: "Submit",
//   //                   onPressed: () {
//   //
//   //                   },)
//   //             ),
//   //           ],
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }
//
// }
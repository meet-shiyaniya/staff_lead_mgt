import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
// import 'package:inquiry_management_ui/Utils/Colors/app_Colors.dart';

import '../Model/contact_Model.dart';
import '../Utils/Colors/app_Colors.dart';
import '../Utils/Custom widgets/custom_buttons.dart';

class BlockedContactsScreen extends StatefulWidget {
  @override
  _BlockedContactsScreenState createState() => _BlockedContactsScreenState();
}

class _BlockedContactsScreenState extends State<BlockedContactsScreen> {
  List<BlockedContact> blockedContacts = [
    BlockedContact(id: 1, name: 'Dhruvi Vithalani', number: '12332222'),
    BlockedContact(id: 2, name: 'Dhruvi Vithalani', number: '5222222222'),
    BlockedContact(id: 3, name: 'Dhruvi Vithalani', number: '4444444444'),
    BlockedContact(id: 4, name: 'Dhruvi Vithalani', number: '5217832879'),
    BlockedContact(id: 5, name: 'Dhruvi Vithalani', number: '5557890123'),
    BlockedContact(id: 6, name: 'Dhruvi Vithalani', number: '5554321123'),
  ];

  void _unblockContact(int id) {
    setState(() {
      blockedContacts.removeWhere((element) => element.id == id);
    });
  }

  String _getInitials(String name) {
    List<String> parts = name.trim().split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts.last[0]).toUpperCase();
  }

  Future<Map<String, String?>?> showdialog(BuildContext context) async {
    return await showDialog<Map<String, String?>?>(
      context: context,
      builder: (BuildContext context) {
        return const NumberBlockDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.MainColor, // Replace with your color
        title: const Text(
          'Blocked Contacts',
          style: TextStyle(fontFamily: "poppins_thin", color: Colors.white,fontSize: 20),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        actions: const [SizedBox(width: 10)],
      ),
      body: blockedContacts.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.block_outlined, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No blocked contacts',
              style: TextStyle(fontSize: 16, color: Colors.grey, fontFamily: "poppins_thin"),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        itemCount: blockedContacts.length,
        itemBuilder: (context, index) {
          final contact = blockedContacts[index];
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Card(
              elevation: 15,
              child: ListTile(
                leading: CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColor.Buttoncolor, // Replace with your color
                  child: contact.image == null
                      ? Text(
                    _getInitials(contact.name),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                      : null,
                ),
                title: Text(
                  contact.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: "poppins_thin",
                  ),
                ),
                subtitle: Text(
                  contact.number,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: "poppins_thin",
                  ),
                ),
                trailing:IconButton(onPressed: () {
                  _unblockContact(contact.id!);
                }, icon: Icon(Icons.delete,color: Colors.red,))

              ),
            ),
          );
        },
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    floatingActionButton: FloatingActionButton(
    elevation: 20,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    onPressed: () async {
      final result = await showdialog(context);
      if (result != null) {
        print('Data from Dialog: $result');
      }
    },
    child: const Icon(Icons.add, color: Colors.white, size: 30),
    backgroundColor: AppColor.MainColor, // Replace with your color
          )
    );
  }
}
class NumberBlockDialog extends StatefulWidget {
  const NumberBlockDialog({super.key});

  @override
  State<NumberBlockDialog> createState() => _NumberBlockDialogState();
}

class _NumberBlockDialogState extends State<NumberBlockDialog> {
  String? selectedAction;
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dialog Title and Close Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Number Block',
                  style: TextStyle(fontSize: 18, fontFamily: "poppins_thin"),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Country Code and Mobile Number
            Row(
              children: [
                Container(
                  width: 90,
                  child: DropdownButton2(
                    isExpanded: true,
                    hint: Text('+91',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: "poppins_thin")),
                    value: selectedAction,
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
                    underline: Center(),
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      elevation: 10,
                    ),
                    items: [
                      DropdownMenuItem(
                          value: '+87',
                          child: Text('+87',
                              style: TextStyle(
                                  fontFamily: "poppins_thin"))),
                      DropdownMenuItem(
                          value: '+78',
                          child: Text('+91',
                              style: TextStyle(
                                  fontFamily: "poppins_thin"))),
                      DropdownMenuItem(
                          value: '+73',
                          child: Text('+85',
                              style: TextStyle(
                                  fontFamily: "poppins_thin"))),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedAction = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: mobileNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'Mobile Number',
                      hintStyle: const TextStyle(fontFamily: "poppins_thin"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // User Name Field
            TextField(
              controller: userNameController,
              decoration: InputDecoration(
                hintText: 'User name',
                hintStyle: const TextStyle(fontFamily: "poppins_thin"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(width: 8),
                GradientButton(
                  buttonText: "Add",
                  height: 40,
                  width: 100,
                  onPressed: () {
                    if (mobileNumberController.text.isEmpty ||
                        userNameController.text.isEmpty) {
                      // Validate input
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill all fields')),
                      );
                    } else {
                      // Add Logic
                      Navigator.of(context).pop({
                        'userName': userNameController.text,
                        'mobileNumber':
                        '$selectedAction ${mobileNumberController.text}'
                      });
                    }
                  },
                  // gradientColors: [Colors.green, Colors.teal],
                  borderRadius: 20,
                  textStyle: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontFamily: "poppins_thin",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

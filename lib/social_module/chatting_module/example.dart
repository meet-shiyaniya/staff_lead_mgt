import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


import '../colors/colors.dart';
import '../custom_widget/appbar_button.dart';
import '../login_screen/login_screen.dart';
import 'chat_screen.dart';


class ExampleTabbar extends StatefulWidget {
  const ExampleTabbar({super.key});

  @override
  State<ExampleTabbar> createState() => _ExampleTabbarState();
}

class _ExampleTabbarState extends State<ExampleTabbar> {
  final String font = "poppins";
  final String font_light = "poppins_light";
  final String font_thin = "poppins_thin";
  int _selectedIndex = 0;

  final List<Map<String, String>> allContacts = [
    {
      'name': 'Amit Sharma',
      'message': 'Hello!',
      'image': 'https://randomuser.me/api/portraits/men/1.jpg',
      'time': '10:00 AM'
    },
    {
      'name': 'Priya Patel',
      'message': 'How are you?',
      'image': 'https://randomuser.me/api/portraits/women/2.jpg',
      'time': '11:15 AM'
    },
    {
      'name': 'Neha Singh',
      'message': 'See you soon.',
      'image': 'https://randomuser.me/api/portraits/women/4.jpg',
      'time': '1:00 PM'
    },
  ];

  final List<Map<String, String>> whatsappContacts = [
    {
      'name': 'Sanjay Verma',
      'message': 'Meeting at 5 PM.',
      'image': 'https://randomuser.me/api/portraits/men/5.jpg',
      'time': '2:30 PM'
    },
    {
      'name': 'Anjali Gupta',
      'message': 'Great job!',
      'image': 'https://randomuser.me/api/portraits/women/6.jpg',
      'time': '3:45 PM'
    },
  ];

  final List<Map<String, String>> messengerContacts = [
    {
      'name': 'Rahul Joshi',
      'message': 'On my way.',
      'image': 'https://randomuser.me/api/portraits/men/7.jpg',
      'time': '4:20 PM'
    },
    {
      'name': 'Pooja Mehta',
      'message': 'See you tomorrow.',
      'image': 'https://randomuser.me/api/portraits/women/8.jpg',
      'time': '5:50 PM'
    },
  ];

  List<Map<String, String>> currentContacts = [];

  @override
  void initState() {
    super.initState();
    currentContacts = allContacts + whatsappContacts + messengerContacts;
  }

  void updateContacts(List<Map<String, String>> contacts, int index) {
    setState(() {
      currentContacts = contacts;
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 4.5,
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                  color: AppColors.primaryColor.withOpacity(0.7),
                ),
                child: Column(
                  children: [
                    AppBar(
                      backgroundColor: const Color.fromRGBO(193, 133, 232, 0),
                      leading: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomAppBarButton(
                          icon: Icons.arrow_back_ios_rounded,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                      elevation: 0,
                      actions: [
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()));
                            },
                            child: CustomAppBarButton(
                                icon: Icons.notifications_none,
                                color: Colors.white.withOpacity(0.7)))
                      ],
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: "Search...",
                          hintStyle:
                              TextStyle(color: Colors.black, fontFamily: font),
                          fillColor: Colors.white.withOpacity(0.6),
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 15,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: currentContacts.length,
                  itemBuilder: (context, index) {
                    final contact = currentContacts[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(contact['image']!),
                      ),
                      title:
                          Text(contact['name']!, style: GoogleFonts.poppins()),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(contact['message']!,
                              style: GoogleFonts.poppins()),
                          Text(contact['time']!,
                              style: GoogleFonts.poppins(fontSize: 12)),
                        ],
                      ),
                      onTap: () => viewChatDetail(contact),
                    );
                  },
                ),
              ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 5.1,
            left: MediaQuery.of(context).size.width / 17,
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => updateContacts(
                          allContacts + whatsappContacts + messengerContacts,
                          0),
                      child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width / 4.5,
                        margin: const EdgeInsets.only(left: 5, right: 5),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: _selectedIndex == 0
                              ? Colors.grey.shade200
                              : Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade400,
                              offset: const Offset(1, 3),
                              blurRadius: 3,
                              spreadRadius: 1,
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.clear_all),
                            Text("All",
                                style: TextStyle(fontFamily: font_thin)),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => updateContacts(whatsappContacts, 1),
                      child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width / 3.4,
                        margin: const EdgeInsets.only(left: 5, right: 5),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: _selectedIndex == 1
                              ? Colors.grey.shade200
                              : Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade400,
                              offset: const Offset(1, 3),
                              blurRadius: 3,
                              spreadRadius: 1,
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("asset/social_module/images/icon/whatsapp.png",
                                height: 20, width: 20),
                            Text("Whatsapp",
                                style: TextStyle(fontFamily: font_thin)),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => updateContacts(messengerContacts, 2),
                      child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width / 3.3,
                        margin: const EdgeInsets.only(left: 5, right: 5),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: _selectedIndex == 2
                              ? Colors.grey.shade200
                              : Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade400,
                              offset: const Offset(1, 3),
                              blurRadius: 3,
                              spreadRadius: 1,
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("asset/social_module/images/icon/messenger.png",
                                height: 20, width: 20),
                            Text("Messenger",
                                style: TextStyle(fontFamily: font_thin)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void viewChatDetail(Map<String, String> contact) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(contact: contact),
      ),
    );
  }
}

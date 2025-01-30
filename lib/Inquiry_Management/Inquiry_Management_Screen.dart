import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
// import 'package:inquiry_management_ui/Utils/Colors/app_Colors.dart';
import 'package:lottie/lottie.dart';
import 'Inquiry Management Screens/all_inquiries_Screen.dart';
import 'Inquiry Management Screens/assign_to_other_Screen.dart';
import 'Inquiry Management Screens/contact_block_Screen.dart';
import 'Inquiry Management Screens/dismiss_request_Screen.dart';
import 'Inquiry Management Screens/followup_and_cnr_Screen.dart';
import 'Utils/Custom widgets/custom_widgets.dart';

class InquiryManagementScreen extends StatefulWidget {
  const InquiryManagementScreen({super.key});

  @override
  State<InquiryManagementScreen> createState() =>
      _InquiryManagementScreenState();
}

class _InquiryManagementScreenState extends State<InquiryManagementScreen> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 600;

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(
      //     "Inquiry Management",
      //     style: TextStyle(fontFamily: "poppins_thin", color: Colors.white,fontSize: 20),
      //   ),
      //   backgroundColor: AppColor.MainColor,
      // ),
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Effortless Inquiry ",style: TextStyle(fontSize: 24,fontFamily: "poppins_light"),),
                Text("Tracking & Management",style: TextStyle(fontSize: 28,fontFamily: "poppins_thin"),),
                // Header Section
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0,horizontal: 6),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.orange.shade100, Colors.orangeAccent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                    BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),],),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 24.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: isLargeScreen ? 150 : 120,
                          width: isLargeScreen ? 150 : 120,
                          child: Lottie.asset(
                            'asset/Inquiry_module/inquiry_manage.json',
                            fit: BoxFit.contain,
                          ),
                        ),
                        Flexible(
                          child: AutoSizeText(
                            'Manage Inquiries \nEffortlessly',
                            style: TextStyle(
                              fontSize: screenWidth * 0.06,
                              fontFamily: "poppins_thin",
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            minFontSize: 10, // Adjust as needed
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("All Leads",style: TextStyle(fontFamily: "poppins_thin",fontSize: 28,color: Colors.black),),
                ),
                Row(
                  children: [
                    // Left Column
                    Expanded(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        FollowupAndCnrScreen()),
                              );
                            },
                            child: TaskContainer(
                              title: 'Followup And \nCNR',
                              color: Colors.blue.shade100,
                              imagePath: 'asset/Inquiry_module/rating.png',
                              height: screenHeight * 0.28,
                              imageHeight: screenHeight * 0.1,
                              imageWidth: screenWidth * 0.18,
                            ),
                          ),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                  const AllInquiriesScreen(),
                                ),
                              );
                            },
                            child: TaskContainer(
                              title: 'All Inquiries',
                              color: Colors.green.shade100,
                              imagePath: 'asset/Inquiry_module/all.png',
                              height: screenHeight * 0.20,
                              imageHeight: screenHeight * 0.08,
                              imageWidth: screenWidth * 0.16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Right Column
                    Expanded(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                  const DismissRequestScreen(),
                                ),
                              );
                            },
                            child: TaskContainer(
                              title: 'Dismiss Request',
                              color: Colors.purple.shade100,
                              imagePath: 'asset/Inquiry_module/job.png',
                              height: screenHeight * 0.24,
                              imageHeight: screenHeight * 0.08,
                              imageWidth: screenWidth * 0.16,
                            ),
                          ),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                  const AssignToOtherScreen(),
                                ),
                              );
                            },
                            child: TaskContainer(
                              title: 'Assign to Other',
                              color: Colors.orange.shade100,
                              imagePath: 'asset/Inquiry_module/other.png',
                              height: screenHeight * 0.24,
                              imageHeight: screenHeight * 0.08,
                              imageWidth: screenWidth * 0.18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlockedContactsScreen(),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 6,
                    color: Colors.orange.shade100,
                    child: Container(
                      height: screenHeight * 0.12,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.red.shade100,
                            Colors.redAccent.shade100,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Contact Block',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: "poppins_thin",
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Manage blocked contacts',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "poppins_thin",
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          const Icon(Icons.arrow_forward, color: Colors.black54),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

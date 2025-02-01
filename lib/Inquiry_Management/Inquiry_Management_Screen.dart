import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 22),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final screenWidth = constraints.maxWidth;
                final screenHeight = MediaQuery.of(context).size.height;
                final isLargeScreen = screenWidth > 600;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Section
                    AutoSizeText(
                      "Effortless Inquiry ",
                      style: TextStyle(
                          fontSize: isLargeScreen ? 28 : 24,
                          fontFamily: "poppins_light"),
                      maxLines: 1,
                      minFontSize: 18,
                    ),
                    AutoSizeText(
                      "Tracking & Management",
                      style: TextStyle(
                          fontSize: isLargeScreen ? 32 : 28,
                          fontFamily: "poppins_thin"),
                      maxLines: 1,
                      minFontSize: 22,
                    ),
                    const SizedBox(height: 16),

                    // Header Section
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 6),
                      child: Container(
                        height: isLargeScreen
                            ? screenHeight * 0.25
                            : screenHeight * 0.2,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.orange.shade100,
                              Colors.orangeAccent
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 24.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: isLargeScreen
                                  ? screenHeight * 0.2
                                  : screenHeight * 0.15,
                              width: isLargeScreen
                                  ? screenWidth * 0.2
                                  : screenWidth * 0.3,
                              child: Lottie.asset(
                                'asset/Inquiry_module/inquiry_manage.json',
                                fit: BoxFit.contain,
                              ),
                            ),
                            Flexible(
                              child: AutoSizeText(
                                'Manage Inquiries \nEffortlessly',
                                style: TextStyle(
                                  fontSize: isLargeScreen
                                      ? screenWidth * 0.04
                                      : screenWidth * 0.06,
                                  fontFamily: "poppins_thin",
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                minFontSize: 10,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // All Leads Section
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AutoSizeText(
                        "All Leads",
                        style: TextStyle(
                          fontFamily: "poppins_thin",
                          fontSize: isLargeScreen ? 32 : 28,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        minFontSize: 22,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Task Containers
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
                                          FollowupAndCnrScreen(),
                                    ),
                                  );
                                },
                                child: TaskContainer(
                                  title: 'Followup And \nCNR',
                                  color: Colors.blue.shade100,
                                  imagePath: 'asset/Inquiry_module/rating.png',
                                  height: isLargeScreen
                                      ? screenHeight * 0.28
                                      : screenHeight * 0.25,
                                  imageHeight: isLargeScreen
                                      ? screenHeight * 0.1
                                      : screenHeight * 0.08,
                                  imageWidth: isLargeScreen
                                      ? screenWidth * 0.18
                                      : screenWidth * 0.2,
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
                                  height: isLargeScreen
                                      ? screenHeight * 0.20
                                      : screenHeight * 0.18,
                                  imageHeight: isLargeScreen
                                      ? screenHeight * 0.08
                                      : screenHeight * 0.06,
                                  imageWidth: isLargeScreen
                                      ? screenWidth * 0.16
                                      : screenWidth * 0.18,
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
                                  title: 'Dismiss \n Request',
                                  color: Colors.purple.shade100,
                                  imagePath: 'asset/Inquiry_module/job.png',
                                  height: isLargeScreen
                                      ? screenHeight * 0.24
                                      : screenHeight * 0.22,
                                  imageHeight: isLargeScreen
                                      ? screenHeight * 0.08
                                      : screenHeight * 0.06,
                                  imageWidth: isLargeScreen
                                      ? screenWidth * 0.16
                                      : screenWidth * 0.18,
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
                                  height: isLargeScreen
                                      ? screenHeight * 0.24
                                      : screenHeight * 0.22,
                                  imageHeight: isLargeScreen
                                      ? screenHeight * 0.08
                                      : screenHeight * 0.06,
                                  imageWidth: isLargeScreen
                                      ? screenWidth * 0.18
                                      : screenWidth * 0.20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Contact Block Section
                GestureDetector(
                onTap: () {
                Navigator.push(
                context,
                MaterialPageRoute(
                builder: (context) =>  BlockedContactsScreen(), // Make sure this exists
                ),
                );
                },
                child: LayoutBuilder(
                builder: (context, constraints) {
                // screenWidth and screenHeight for relative sizing

                final screenWidth = constraints.maxWidth;
                final cardHeight =
                constraints.maxHeight != double.infinity ? constraints.maxHeight : screenWidth * 0.3;

                return Card(
                elevation: 6,
                color: Colors.orange.shade100,
                child: Container(
                height: cardHeight, // Relative height
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
                Expanded(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                AutoSizeText(
                'Contact Block',
                style: TextStyle(
                fontSize: screenWidth * 0.05, // Responsive font size
                fontFamily: "poppins_thin",
                ),
                maxLines: 1,
                minFontSize: 14,
                ),
                SizedBox(height: screenWidth * 0.01), // Responsive spacing
                AutoSizeText(
                'Manage blocked contacts',
                style: TextStyle(
                fontSize: screenWidth * 0.035, // Responsive font size
                fontFamily: "poppins_thin",
                color: Colors.black54,
                ),
                maxLines: 1,
                minFontSize: 12,
                ),
                ],
                ),
                ),
                const Icon(Icons.arrow_forward, color: Colors.black54),
                ],
                ),
                ),
                );
                },
                ),
                ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hr_app/All%20Reports/conversion_Reports_Screen.dart';
import 'package:hr_app/All%20Reports/daily_Reports_Screen.dart';
import 'package:hr_app/All%20Reports/inquiry_Report_Screen.dart';
import 'package:hr_app/All%20Reports/lead_Reports_Screen.dart';
import 'package:hr_app/All%20Reports/performance_Report_Screen.dart';
import 'package:hr_app/All%20Reports/site_Reports_Screen.dart';
import 'package:hr_app/All%20Reports/visit_Reports_Screen.dart';

import '../Inquiry_Management/Utils/Custom widgets/category_Card.dart';

class allReportsDashboardScreen extends StatefulWidget {
  const allReportsDashboardScreen({super.key});

  @override
  State<allReportsDashboardScreen> createState() =>
      _allReportsDashboardScreenState();
}

class _allReportsDashboardScreenState extends State<allReportsDashboardScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 22),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;
              final isLargeScreen = screenWidth > 600;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      "Reports Management",
                      style: TextStyle(
                          fontSize: isLargeScreen ? 24 : 20,
                          fontFamily: "poppins_thin"),
                      maxLines: 1,
                      minFontSize: 22,
                    ),

                    SizedBox(height: 20,),
                    
                    Container(
                      
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        
                        image: DecorationImage(image: AssetImage("asset/report.png"), fit: BoxFit.cover)

                      ),
                      
                    ),

                    SizedBox(height: 20,),
                    
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
                      child: AutoSizeText(
                        "All Reports",
                        style: TextStyle(
                          fontFamily: "poppins_thin",
                          fontSize: isLargeScreen ? 16 : 14,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        minFontSize: 16,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    InquiryReportScreen()),
                              );
                            },
                            child: CategoryCard(
                              icon: Icons.assignment_rounded, // For inquiries/questions
                              title: 'Inquiry Reports',
                            ),
                          ),
                          SizedBox(height: 12),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    SiteReportsScreen()),
                              );
                            },
                            child: CategoryCard(
                              icon: Icons.location_city, // For site/location
                              title: 'Site Reports',
                            ),
                          ),
                          SizedBox(height: 12),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PerformanceReportScreen()),
                              );
                            },
                            child: CategoryCard(
                              icon: Icons.trending_up, // For performance metrics
                              title: 'Performance Reports',
                            ),
                          ),
                          SizedBox(height: 12),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    ConversionReportsScreen()),
                              );
                            },
                            child: CategoryCard(
                              icon: Icons.transform, // For conversions
                              title: 'Conversion Reports',
                            ),
                          ),
                          SizedBox(height: 12),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    VisitReportsScreen()),
                              );
                            },
                            child: CategoryCard(
                              icon: Icons.directions_walk, // For visits
                              title: 'Visit Reports',
                            ),
                          ),
                          SizedBox(height: 12),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LeadReportsScreen()),
                              );
                            },
                            child: CategoryCard(
                              icon: Icons.people_outline, // For leads/prospects
                              title: 'Lead Reports',
                            ),
                          ),
                          SizedBox(height: 12),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => dailyReportsScreen()),
                              );
                            },
                            child: CategoryCard(
                              icon: Icons.today, // For daily/time-based
                              title: 'Daily Reports',
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
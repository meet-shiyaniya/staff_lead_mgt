import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hr_app/Inquiry_Management/Utils/Custom%20widgets/add_lead_Screen.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
// import 'package:realtosmart/Provider/UserProvider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Provider/UserProvider.dart';
import '../Model/Api Model/allInquiryModel.dart';

class LeadDetailScreen extends StatefulWidget {
  final Inquiry InquiryInfoList;

  const LeadDetailScreen({
    super.key,
    required this.InquiryInfoList,
  });

  @override
  State<LeadDetailScreen> createState() => _LeadDetailScreenState();
}

class _LeadDetailScreenState extends State<LeadDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch timeline data when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false)
          .fetchInquiryTimeline(inquiryId: widget.InquiryInfoList.id ?? "95542");
    });
  }
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double textScale = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
        backgroundColor: Colors.grey[100],
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                // Header Section
                Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.055),
                  decoration: const BoxDecoration(
                    color: Color(0xffebf0f4),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,


                              children: [

                              IconButton(
                                icon: const Icon(Icons.arrow_back_ios,
                                    color: Colors.black),
                                onPressed: () => Navigator.pop(context),
                              ),

                                PopupMenuButton<String>(
                                  icon: const Icon(
                                    Icons.more_vert_outlined,
                                    color: Colors.black,
                                    size: 20, // Smaller icon
                                  ),
                                  onSelected: (String value) {
                                    if (value == 'edit') {
                                      print("Edit tapped");
                                    } else if (value == 'delete') {
                                      print("Delete tapped");
                                    }
                                  },
                                  offset: const Offset(0, 45,), // Adjust the position slightly

                                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                    PopupMenuItem<String>(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddLeadScreen(isEdit: true,),));
                                      },
                                      value: 'edit',
                                      height: 30, // Reduces item height
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit, color: Colors.blue, size: 18), // Smaller icon
                                          SizedBox(width: 8), // Small space between icon and text
                                          Text(
                                            'Edit',
                                            style: TextStyle(fontFamily: "poppins_thin", fontSize: 12), // Smaller text
                                          ),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem<String>(
                                      value: 'delete',
                                      height: 30, // Reduces item height
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete, color: Colors.red, size: 18), // Smaller icon
                                          SizedBox(width: 8),
                                          Text(
                                            'Delete',
                                            style: TextStyle(fontFamily: "poppins_thin", fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8), // Slightly smaller radius
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 100, // Reduce width of the menu
                                    maxWidth: 120,
                                  ),
                                ),


                              ],),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start, // Keeps the column content left-aligned
                                children: [
                                  SizedBox(
                                      height:
                                      MediaQuery.of(context).size.height * 0.01),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Centers the Container horizontally in the Row
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Row(
                                          //   mainAxisAlignment: MainAxisAlignment.start,
                                          //   children: [
                                          //     Icon(Icons.key,size: 18,color: Colors.orange.shade300,),
                                          //     SizedBox(width: 5,),
                                          //     Text(
                                          //       widget.InquiryInfoList.id ?? "N/A",
                                          //       style: TextStyle(
                                          //         fontFamily: "poppins_thin",
                                          //         // color: Colors.grey,
                                          //         fontSize: 15 * MediaQuery.of(context).textScaleFactor,
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),
                                          SizedBox(height: 10),

                                          Row(
                                            children: [

                                              Icon(Icons.person,size: 18,color: Colors.grey,),
                                              SizedBox(width: 5,),


                                              Text(
                                                widget.InquiryInfoList.fullName ?? "N/A",
                                                style: TextStyle(
                                                  fontFamily: "poppins_thin",
                                                  color: Colors.black87,
                                                  fontSize: 16 * MediaQuery.of(context).textScaleFactor,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Icon(Icons.call_outlined,size: 18,color: Colors.green.shade300,),
                                              SizedBox(width: 5,),
                                              Text(
                                                widget.InquiryInfoList.mobileno ?? "N/A",
                                                style: TextStyle(
                                                  fontFamily: "poppins_light",
                                                  color: Colors.black,
                                                  fontSize: 15 * MediaQuery.of(context).textScaleFactor,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),

                                      ],
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.only(right: 10,bottom: 5),
                                        child: Container(
                                          height: 34,
                                          decoration: BoxDecoration(
                                            color: getLabelColor(widget.InquiryInfoList.InqStage),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(child: Text(getInquiryStageText(widget.InquiryInfoList.InqStage),style: TextStyle(fontFamily: "poppins_thin",color: Colors.white,fontSize: 11),)),
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Text(
                            //   "ID: ${widget.InquiryInfoList.id ?? 'N/A'}",
                            //   style: TextStyle(
                            //     fontFamily: "poppins_thin",
                            //     color: Colors.black,
                            //     fontSize: 14 * MediaQuery.of(context).textScaleFactor,
                            //   ),
                            // ),

                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildActionButton(
                                  icon: Icons.call,
                                  color: Colors.green,
                                  onTap: () => _makeDirectPhoneCall(
                                      widget.InquiryInfoList.mobileno, context),
                                ),
                                _buildActionButton(
                                  icon: Icons.message,
                                  color: Colors.blue,
                                  onTap: () async {
                                    String phoneNumber =
                                        widget.InquiryInfoList.mobileno;
                                    String message =
                                        "Hello! This is a test message";
                                    await _launchSMS(phoneNumber, message);
                                  },
                                ),
                                _buildActionButton(
                                  icon: Icons.email,
                                  color: Colors.orange,
                                  onTap: () async {
                                    String email = widget.InquiryInfoList.email;
                                    String subject = "Test Email";
                                    String body = "Hello! This is a test email";
                                    await _launchEmail(
                                        email: email,
                                        subject: subject,
                                        body: body);
                                  },
                                ),
                                _buildActionButton(
                                  icon: FontAwesomeIcons.whatsapp,
                                  color: Colors.green,
                                  onTap: () async {
                                    String phoneNumber =
                                        widget.InquiryInfoList.mobileno;
                                    String message =
                                        "Hello! This is a test message";
                                    await _launchWhatsApp(phoneNumber, message);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xffebf0f4),
                    // borderRadius: BorderRadius.only(
                    //   bottomLeft: Radius.circular(20),
                    //   bottomRight: Radius.circular(20),
                    // ),
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height *
                        0.7, // Define a height constraint
                    child: DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          Container(
                            color: Colors.white,
                            child: const TabBar(
                              tabs: [
                                Tab(text: 'Info'),
                                Tab(text: 'Timeline'),
                              ],
                              labelColor: Colors.black,
                              unselectedLabelColor: Colors.grey,
                              indicatorColor: Colors.black,
                              labelStyle: TextStyle(
                                fontFamily:
                                    "poppins_thin", // Change to your desired font family
                                fontSize: 16, // Optional: adjust size as needed
                              ),
                              unselectedLabelStyle: TextStyle(
                                fontFamily:
                                    "poppins_thin", // Same font for unselected tabs
                                fontSize: 16, // Optional: adjust size as needed
                              ),
                            ),
                          ),
                          Expanded(
                            // This now works because it has a bounded parent (SizedBox)
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: TabBarView(
                                  children: [
                                    // Details Tab
                                    SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 15),
                                          _buildSectionTitle("Lead Details"),
                                          _buildInfoCard([
                                            _buildInfoRow("Source",
                                                widget.InquiryInfoList.inquiry_source_type),
                                            _buildInfoRow("Inquiry Type",
                                                widget.InquiryInfoList.InqType),
                                          ]),
                                          const SizedBox(height: 30),
                                          _buildSectionTitle("Interest Site"),
                                          _buildInfoCard([
                                            _buildInfoRow(
                                                "Site",
                                                widget.InquiryInfoList
                                                    .intersted_site_name),
                                            _buildInfoRow(
                                                "Property Type",
                                                widget.InquiryInfoList
                                                    .property_type),
                                            _buildInfoRow(
                                                "Sub Type",
                                                widget.InquiryInfoList
                                                    .property_sub_type),
                                            _buildInfoRow("Budget",
                                                widget.InquiryInfoList.budget),
                                            _buildInfoRow(
                                                "Approx Buying",
                                                widget.InquiryInfoList
                                                    .approx_buy),
                                            _buildInfoRow(
                                                "Purpose",
                                                widget.InquiryInfoList
                                                    .PurposeBuy),
                                            _buildInfoRow("Area",
                                                widget.InquiryInfoList.InqArea),
                                          ]),
                                          const SizedBox(height: 20),
                                        ],
                                      ),
                                    ),

                                    Consumer<UserProvider>(
                                      builder: (context, inquiryProvider, child) {
                                        final timeline = inquiryProvider.inquiryTimeline;
                                        if (timeline == null || timeline.data == null || timeline.data!.isEmpty) {
                                          return const Center(child: Text("No timeline data available",style: TextStyle(fontFamily: "poppins_thin"),));
                                        }
                                        // Add this helper function in your _LeadDetailScreenState class
// Returns a Map with separate date and time

// Returns a Map with separate date and time
                                        Map<String, String> formatCreatedAt(String? createdAt) {
                                          if (createdAt == null || createdAt.isEmpty) {
                                            return {'date': 'N/A', 'time': 'N/A'};
                                          }

                                          // Remove HTML <br> (if present) and clean up the string
                                          String cleanDate = createdAt.replaceAll('<br>', ' ').trim();

                                          try {
                                            // Parse the date string into a DateTime object
                                            // Handles "24 Feb 2025 12:53 PM" or "24 Feb , 2025 12:53 PM"
                                            DateTime parsedDate;
                                            try {
                                              parsedDate = DateFormat("dd MMM yyyy hh:mm a").parse(cleanDate);
                                            } catch (e) {
                                              // Fallback for the old format with comma
                                              parsedDate = DateFormat("dd MMM , yyyy hh:mm a").parse(cleanDate);
                                            }

                                            // Separate date and time
                                            String date = DateFormat("dd MMM yyyy").format(parsedDate); // "24 Feb 2025"
                                            String time = DateFormat("hh:mm a").format(parsedDate);     // "12:53 PM"
                                            return {'date': date, 'time': time};
                                          } catch (e) {
                                            print("Error parsing date: $e");
                                            // Fallback: split manually if parsing fails
                                            List<String> parts = cleanDate.split(' ');
                                            if (parts.length >= 5) {
                                              String dateFallback = parts.sublist(0, 3).join(' '); // "24 Feb 2025"
                                              String timeFallback = parts.sublist(3).join(' ');    // "12:53 PM"
                                              return {'date': dateFallback, 'time': timeFallback};
                                            }
                                            return {'date': cleanDate, 'time': 'N/A'}; // Last resort
                                          }
                                        }                                        return Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              _buildSectionTitle("Timeline"),
                                              Expanded(
                                                child: ListView.builder(
                                                  itemCount: timeline.data!.length,
                                                  itemBuilder: (context, index) {
                                                    final item = timeline.data![index];
                                                    return Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        // Date (left side)
                                                        Padding(
                                                          padding: const EdgeInsets.only(top: 8.0),
                                                          child: Container(
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  formatCreatedAt(item.createdAt)['date'] ?? 'N/A',
                                                                  style: const TextStyle(
                                                                    fontFamily: "poppins_thin",
                                                                    fontSize: 14,
                                                                    color: Colors.grey,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  formatCreatedAt(item.createdAt)['time'] ?? 'N/A',
                                                                  style: const TextStyle(
                                                                    fontFamily: "poppins_thin",
                                                                    fontSize: 14,
                                                                    color: Colors.grey,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),                                                        const SizedBox(width: 16),
                                                        // Timeline line and dot
                                                        Column(
                                                          children: [
                                                            Container(
                                                              width: 2,
                                                              height: 20,
                                                              color: index == 0 ? Colors.transparent : Colors.grey,
                                                            ),
                                                            Container(
                                                              width: 12,
                                                              height: 12,
                                                              decoration: const BoxDecoration(
                                                                color: Colors.blue,
                                                                shape: BoxShape.circle,
                                                              ),
                                                            ),
                                                            Container(
                                                              width: 2,
                                                              height: 60,
                                                              color: index == timeline.data!.length - 1
                                                                  ? Colors.transparent
                                                                  : Colors.grey,
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(width: 16),
                                                        // Activity description (right side)
                                                        Expanded(
                                                          child: Container(
                                                            margin: const EdgeInsets.only(bottom: 10),
                                                            padding: const EdgeInsets.all(12),
                                                            decoration: BoxDecoration(
                                                              color: Colors.white,
                                                              borderRadius: BorderRadius.circular(12),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors.grey.withOpacity(0.2),
                                                                  blurRadius: 6,
                                                                  offset: const Offset(0, 3),
                                                                ),
                                                              ],
                                                            ),
                                                            child:
                                                            Column(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                if (item.stagesId != null) // Only show if stagesId is not null
                                                                  Padding(
                                                                    padding: const EdgeInsets.symmetric(horizontal: 3.0),
                                                                    child: Container(
                                                                      height: 21,
                                                                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                                                                      constraints: const BoxConstraints(maxWidth: 70),
                                                                      decoration: BoxDecoration(
                                                                        color: getLabelColor(item.stagesId),
                                                                        borderRadius: BorderRadius.circular(8),
                                                                      ),
                                                                      child: Center(
                                                                        child: Text(
                                                                          getInquiryStageText(item.stagesId) ?? '', // Fallback to empty string if function returns null
                                                                          style: const TextStyle(
                                                                            fontFamily: "poppins_thin",
                                                                            color: Colors.white,
                                                                            fontSize: 9,
                                                                          ),
                                                                          overflow: TextOverflow.ellipsis,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                if (item.remarktext != "") // Only show if remarktext is not null
                                                                  Row(
                                                                    children: [
                                                                      const Icon(
                                                                        Icons.note, // Example icon (a note symbol)
                                                                        size: 16,   // Adjust size to match text
                                                                        color: Colors.grey, // Match text color
                                                                      ),
                                                                      const SizedBox(width: 4), // Space between icon and text
                                                                      Expanded(
                                                                        child: Text(
                                                                          ": ${item.remarktext}",
                                                                          style: const TextStyle(
                                                                            fontFamily: "poppins_thin",
                                                                            fontSize: 12,
                                                                            color: Colors.black87,
                                                                          ),
                                                                        ),
                                                                      )                                                                    ],
                                                                  ),
                                                                if (item.inquiryLog != null) // Only show if inquiryLog is not null
                                                                  Text(
                                                                    "${item.inquiryLog}",
                                                                    style: const TextStyle(
                                                                      fontFamily: "poppins_thin",
                                                                      fontSize: 10,
                                                                      color: Colors.black87,
                                                                    ),
                                                                  ),
                                                              ],
                                                            ),                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
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
              ],
            ),
          ),
        ));
  }

  // Action Button with Label
  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    // required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(25),
              // border: Border.all(color: color, width: 1.5),
              // boxShadow: [
              //   BoxShadow(
              //     color: color.withOpacity(0.3),
              //     blurRadius: 8,
              //     offset: const Offset(0, 4),
              //   ),
              // ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(height: 10),
          // Text(
          //   label,
          //   style: const TextStyle(
          //     fontFamily: "poppins_thin",
          //     fontSize: 14,
          //     color: Colors.black87,
          //   ),
          // ),
        ],
      ),
    );
  }
  String getInquiryStageText(String? stage) {
    switch (stage) {
      case "1":
        return "Fresh";
      case "2":
        return "Contacted";
      case "3":
        return "Appointment";
      case "4":
        return "Visited";

      case "6":
        return "Negotiation";
      case "9": // Feedback reassigned to its only active case
        return "Feedback";
      case "10":
        return "Reappointment";
      case "11":
        return "Re-Visited";
      case "12":
        return "Converted";
      default:
        return "Unknown";
    }
  }
  Color getLabelColor(String? stage) {
    switch (stage) {
      case "1": // Fresh
        return Color(0xff0093c8); // Vibrant teal for new beginnings
      case "2": // Contacted
        return Color(0xff007aff); // Light blue for initial engagement
      case "3": // Appointment
        return Color(0xff154889); // Warm amber for scheduling
      case "4": // Visited
        return Color(0xff007aff);// Solid blue for progress
      case "6": // Negotiation
        return Color(0xffaf2da9); // Deep indigo for discussions
      case "9": // Feedback
        return Color(0xff26b43a); // Bright orange for insights
      case "10": // Reappointment
        return Color(0xff113e78); // Rich purple for renewal
      case "11": // Re-Visited
        return Color(0xfff1ba71); // Strong yellow for second chances
      case "12": // Converted
        return Color(0xff52c191); // Solid green for success
      default: // Unknown
        return Colors.grey.shade400; // Neutral grey for undefined
    }
  }  // Enhanced Information Row with Shadow
  Widget _buildInfoRow(String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0), // Increased spacing
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.2),
        //     blurRadius: 6,
        //     offset: const Offset(0, 3),
        //   ),
        // ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "$label:",
              style: const TextStyle(
                fontFamily: "poppins_thin",
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(width: 15), // Increased spacing
            Expanded(
              child: Text(
                value.isEmpty ? "N/A" : value,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontFamily: "poppins_thin",
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Card for Info Sections
  Widget _buildInfoCard(List<Widget> children) {
    return Card(
      elevation: 6,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  // Section Title
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: "poppins_thin",
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
      ),
    );
  }

  // Confirmation Dialog
  void _showConfirmationDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Confirm Action",
          style: TextStyle(
              fontFamily: "poppins_thin", fontWeight: FontWeight.bold),
        ),
        content: Text(
          message,
          style: const TextStyle(fontFamily: "poppins_thin"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              // Add delete/block logic here
              Navigator.pop(context);
            },
            child: const Text("Confirm", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

Future<void> _launchEmail({
  required String email,
  required String subject,
  required String body,
}) async {
  // Construct mailto URI with encoded subject and body
  String encodedSubject = Uri.encodeComponent(subject);
  String encodedBody = Uri.encodeComponent(body);
  String mailUri = 'mailto:$email?subject=$encodedSubject&body=$encodedBody';

  debugPrint('Attempting Email URI: $mailUri');

  if (await canLaunchUrl(Uri.parse(mailUri))) {
    await launchUrl(Uri.parse(mailUri), mode: LaunchMode.externalApplication);
    debugPrint('Email launched successfully');
  } else {
    // Fallback: try without subject/body
    String fallbackUri = 'mailto:$email';
    debugPrint('Attempting fallback Email URI: $fallbackUri');

    if (await canLaunchUrl(Uri.parse(fallbackUri))) {
      await launchUrl(Uri.parse(fallbackUri),
          mode: LaunchMode.externalApplication);
      debugPrint('Fallback Email launched successfully');
    } else {
      debugPrint('No Email handler available');
    }
  }
}

Future<void> _launchSMS(String phoneNumber, String message) async {
  String encodedMessage = Uri.encodeComponent(message);
  String smsUri = 'sms:$phoneNumber?body=$encodedMessage';

  debugPrint('Attempting primary URI: $smsUri');
  if (await canLaunchUrl(Uri.parse(smsUri))) {
    await launchUrl(Uri.parse(smsUri), mode: LaunchMode.externalApplication);
    debugPrint('SMS launched successfully');
  } else {
    debugPrint('Primary URI not supported');
    await _tryFallback(phoneNumber, message);
  }
}

Future<void> _tryFallback(String phoneNumber, String message) async {
  String fallbackUri = 'sms:$phoneNumber';
  debugPrint('Attempting fallback URI: $fallbackUri');

  if (await canLaunchUrl(Uri.parse(fallbackUri))) {
    await launchUrl(Uri.parse(fallbackUri),
        mode: LaunchMode.externalApplication);
    debugPrint('Fallback SMS launched successfully');
  } else {
    debugPrint('Fallback URI not supported');

    // Try SMSTO scheme as last resort
    String smstoUri = 'smsto:$phoneNumber?body=${Uri.encodeComponent(message)}';
    debugPrint('Attempting SMSTO URI: $smstoUri');
    if (await canLaunchUrl(Uri.parse(smstoUri))) {
      await launchUrl(Uri.parse(smstoUri),
          mode: LaunchMode.externalApplication);
      debugPrint('SMSTO launched successfully');
    } else {
      debugPrint('No SMS handler available on device');
    }
  }
}

Future<void> _makeDirectPhoneCall(
    String phoneNumber, BuildContext context) async {
  // Clean the phone number
  phoneNumber = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
  if (!phoneNumber.startsWith('+')) {
    phoneNumber = '$phoneNumber'; // Add country code if needed
  }

  // Request CALL_PHONE permission
  final permissionStatus = await Permission.phone.request();

  if (permissionStatus.isGranted) {
    final phoneUrl = Uri.parse('tel:$phoneNumber');
    try {
      await launchUrl(
          phoneUrl); // This will attempt to call directly on Android
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error making call: $e')),
      );
    }
  } else if (permissionStatus.isDenied) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Call permission denied')),
    );
  } else if (permissionStatus.isPermanentlyDenied) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Please enable call permission in settings')),
    );
    await openAppSettings(); // Prompt user to enable permission in settings
  }
}

// Function to launch WhatsApp
Future<void> _launchWhatsApp(String phoneNumber, String message) async {
  // Remove any non-digit characters except the leading '+' from phoneNumber
  String cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
  String encodedMessage = Uri.encodeComponent(message);
  // WhatsApp URL scheme: whatsapp://send?phone={number}&text={message}
  String whatsappUri =
      'whatsapp://send?phone=$cleanNumber&text=$encodedMessage';

  debugPrint('Attempting WhatsApp URI: $whatsappUri');

  if (await canLaunchUrl(Uri.parse(whatsappUri))) {
    await launchUrl(Uri.parse(whatsappUri),
        mode: LaunchMode.externalApplication);
    debugPrint('WhatsApp launched successfully');
  } else {
    debugPrint('WhatsApp not available');
  }
}

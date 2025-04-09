import 'package:flutter/material.dart';
import 'package:hr_app/All%20Reports/daily_Reports_Screen.dart';
import 'package:hr_app/Inquiry_Management/Utils/Custom%20widgets/lead_Details_Screen.dart';
import 'package:intl/intl.dart';
import '../../../Model/Api Model/assignToOther_Model.dart';
import '../../../Utils/Custom widgets/booking_Screen.dart';

class clockWiseCard extends StatefulWidget {
  final String id;
  final String name;
  final String username;
  final String followUpDate;
  final String nextFollowUpDate;
  final String inquiryType;
  final String intArea;
  final String purposeBuy;
  final bool isSelected;
  final VoidCallback onSelect;
  final InquiryFollowup data;
  final VoidCallback ontap;
  final VoidCallback? onRefresh;

  const clockWiseCard({
    Key? key,
    required this.id,
    required this.name,
    required this.username,
    required this.followUpDate,
    required this.nextFollowUpDate,
    required this.inquiryType,
    required this.intArea,
    required this.purposeBuy,
    this.isSelected = false,
    required this.onSelect,
    required this.data,
    required this.ontap,
    this.onRefresh,
  }) : super(key: key);

  @override
  _clockWiseCardState createState() => _clockWiseCardState();
}

class _clockWiseCardState extends State<clockWiseCard> {
  bool isExpanded = false;

  void showDialogBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: SizedBox(
            height: 120,
            child: Center(
              child: Text(
                widget.data.remark,
                style: const TextStyle(fontFamily: "poppins_thin", fontSize: 12),
              ),
            ),
          ),
        );
      },
    );
  }

  String formatIndianDateTime(String dateTimeString) {
    try {
      DateTime dateTime = DateTime.parse(dateTimeString);
      final DateFormat formatter = DateFormat('dd-MM-yyyy hh:mm a');
      return formatter.format(dateTime);
    } catch (e) {
      return dateTimeString;
    }
  }

  String formatTimeOnly(String dateTimeString) {
    try {
      DateTime dateTime = DateTime.parse(dateTimeString);
      final DateFormat formatter = DateFormat('hh:mm a');
      return formatter.format(dateTime);
    } catch (e) {
      return dateTimeString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double fontScale = screenWidth < 400 ? 0.9 : 1.0;

    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded; // Toggle the card state on tap
        });
      },
      onLongPress: widget.onSelect,
      child: Card(
        margin: const EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: widget.isSelected ? 10.0 : 3.0,
        color: widget.isSelected ? Colors.deepPurple.shade100 : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: isExpanded
              ? _buildExpandedView(fontScale, screenWidth)
              : _buildCompactView(fontScale, screenWidth),
        ),
      ),
    );
  }

  // Compact view (default: Green dot, ID, name, time, phone icon)
  Widget _buildCompactView(double fontScale, double screenWidth) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Green dot
        Container(
          width: 10 * fontScale,
          height: 10 * fontScale,
          decoration: BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: screenWidth * 0.02),
        // ID in purple box
        Container(
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade300,
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Text(
            widget.id,
            style: TextStyle(
              fontSize: 10 * fontScale,
              fontFamily: "poppins_thin",
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(width: screenWidth * 0.02),
        // Name
        Expanded(
          child: Text(
            widget.name,
            style: TextStyle(
              fontSize: 15 * fontScale,
              fontFamily: "poppins_thin",
            ),
            overflow: TextOverflow.ellipsis,
            softWrap: false,
          ),
        ),
        // Time
        Text(
          formatTimeOnly(widget.nextFollowUpDate),
          style: TextStyle(
            fontSize: 12 * fontScale,
            fontFamily: "poppins_thin",
            color: Colors.grey.shade600,
          ),
        ),
        SizedBox(width: screenWidth * 0.02),
        // Phone icon
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => dailyReportsScreen()));
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade300,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(offset: Offset(1, 3), color: Colors.black12, blurRadius: 8),
              ],
            ),
            child: Icon(
              Icons.phone,
              color: Colors.white,
              size: 18 * fontScale,
            ),
          ),
        ),
      ],
    );
  }

  // Expanded view (full card details with time, call icon, and new icons in the same row)
  Widget _buildExpandedView(double fontScale, double screenWidth) {
    return GestureDetector(
      onTap: widget.ontap, // Navigate to LeadDetailFollowupScreen
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Green dot
              Container(
                width: 10 * fontScale,
                height: 10 * fontScale,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: screenWidth * 0.02),
              // ID in purple box
              Container(
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade300,
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                child: Text(
                  widget.id,
                  style: TextStyle(
                    fontSize: 10 * fontScale,
                    fontFamily: "poppins_thin",
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.02),
              // Name and Username
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: TextStyle(
                        fontSize: 15 * fontScale,
                        fontFamily: "poppins_thin",
                      ),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                    SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.person, size: 12 * fontScale),
                        SizedBox(width: 2),
                        Text(
                          ": ${widget.username}",
                          style: TextStyle(
                            fontSize: 12 * fontScale,
                            fontFamily: "poppins_thin",
                            color: Colors.grey.shade600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Time
              Text(
                formatTimeOnly(widget.nextFollowUpDate),
                style: TextStyle(
                  fontSize: 12 * fontScale,
                  fontFamily: "poppins_thin",
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(width: screenWidth * 0.02),
              // Phone icon
              GestureDetector(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingScreen(inquiryId: widget.id),
                    ),
                  );
                  if (result == true && widget.onRefresh != null) {
                    widget.onRefresh!();
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade300,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(offset: Offset(1, 3), color: Colors.black12, blurRadius: 8),
                    ],
                  ),
                  child: Icon(
                    Icons.phone,
                    color: Colors.white,
                    size: 18 * fontScale,
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.02),
              // Add New Booking Icon
              GestureDetector(
                onTap: () {
                  // Navigate to Add New Booking screen (replace with your actual screen)
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => AddBookingScreen(inquiryId: widget.id)),
                  // );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade300,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(offset: Offset(1, 3), color: Colors.black12, blurRadius: 8),
                    ],
                  ),
                  child: Icon(
                    Icons.book,
                    color: Colors.white,
                    size: 18 * fontScale,
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.02),
              // Add New Visit Icon
              GestureDetector(
                onTap: () {
                  // Navigate to Add New Visit screen (replace with your actual screen)
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => AddVisitScreen(inquiryId: widget.id)),
                  // );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade300,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(offset: Offset(1, 3), color: Colors.black12, blurRadius: 8),
                    ],
                  ),
                  child: Icon(
                    Icons.event,
                    color: Colors.white,
                    size: 18 * fontScale,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenWidth * 0.015),
          Row(
            children: [
              Image.asset(
                "asset/Inquiry_module/transfer.png",
                height: 19,
                width: 19,
              ),
              SizedBox(width: screenWidth * 0.01),
              Text(
                "${formatIndianDateTime(widget.followUpDate)}",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontFamily: "poppins_thin",
                  fontSize: 11 * fontScale,
                ),
              ),
            ],
          ),
          SizedBox(height: screenWidth * 0.01),
          Row(
            children: [
              Image.asset(
                "asset/Inquiry_module/transfer.png",
                height: 19,
                width: 19,
              ),
              SizedBox(width: screenWidth * 0.01),
              Text(
                "${formatIndianDateTime(widget.nextFollowUpDate)}",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontFamily: "poppins_thin",
                  fontSize: 11 * fontScale,
                ),
              ),
            ],
          ),
          SizedBox(height: screenWidth * 0.01),
          Row(
            children: [
              Text(
                "Inq type: ",
                style: TextStyle(
                  fontFamily: "poppins_thin",
                  fontSize: 11 * fontScale,
                ),
              ),
              Text(
                widget.inquiryType,
                style: TextStyle(
                  fontFamily: "poppins_thin",
                  fontSize: 11 * fontScale,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          SizedBox(height: screenWidth * 0.01),
          Row(
            children: [
              Text(
                "Int Area: ",
                style: TextStyle(
                  fontFamily: "poppins_thin",
                  fontSize: 11 * fontScale,
                ),
              ),
              Text(
                widget.intArea,
                style: TextStyle(
                  fontFamily: "poppins_thin",
                  fontSize: 11 * fontScale,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          SizedBox(height: screenWidth * 0.01),
          Row(
            children: [
              Text(
                "Purpose of Buying: ",
                style: TextStyle(
                  fontFamily: "poppins_thin",
                  fontSize: 11 * fontScale,
                ),
              ),
              Text(
                widget.purposeBuy,
                style: TextStyle(
                  fontFamily: "poppins_thin",
                  fontSize: 11 * fontScale,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          if (widget.isSelected)
            Align(
              alignment: Alignment.centerRight,
              child: Checkbox(
                value: widget.isSelected,
                onChanged: (bool? value) {
                  widget.onSelect();
                },
              ),
            ),
        ],
      ),
    );
  }
}
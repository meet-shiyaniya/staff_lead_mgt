import 'package:flutter/material.dart';
import 'package:hr_app/Inquiry_Management/Model/Api%20Model/allInquiryModel.dart';

class LeadDetailScreen extends StatefulWidget {
  // String? fullname;
  // String? id;
  // String? number;
  // String? source;
  // String?
  Inquiry InquiryInfoList;
  LeadDetailScreen({
    super.key,
    required this.InquiryInfoList,
  });

  @override
  State<LeadDetailScreen> createState() => _LeadDetailScreenState();
}

class _LeadDetailScreenState extends State<LeadDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("Lead Details")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lead Information
            Row(
              children: [
                Column(
                  children: [
                    Text("${widget.InquiryInfoList.fullName}",
                        style: TextStyle(fontFamily: "poppins_thin", fontSize: 18)),
                    SizedBox(height: 4,),
                    Text("${widget.InquiryInfoList.mobileno}",
                        style: TextStyle(fontFamily: "poppins_thin", fontSize: 16)),
                  ],
                ),
                SizedBox(height: 16),
                Spacer(),
                Row(

                  children: [
                    _buildCircularButton(Icons.call, Colors.green),
                    SizedBox(width: 10,),
                    _buildCircularButton(Icons.message, Colors.blue),
                    SizedBox(width: 10,),
                    _buildCircularButton(Icons.email, Colors.orange),
                  ],
                ),
              ],
            ),
            SizedBox(height: 4),


            // Call Action Buttons

            SizedBox(height: 16),

            // Lead Details
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    _buildInfoRow("Source", "${widget.InquiryInfoList.InqType}"),
                    _buildInfoRow("Inq Type", "${widget.InquiryInfoList.InqType}"),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),

            // Interest Site Information
            Text("Int Site", style: _sectionTitleStyle()),
            _buildCard([
              _buildInfoRow("Int Site", "Villas"),
              _buildInfoRow("Property Type", "Residential"),
              _buildInfoRow("Property Sub Type", "Row House"),
              _buildInfoRow("Budget", "30 Lakh"),
              _buildInfoRow("Approx Buying", "Week"),
              _buildInfoRow("Purpose Of Buying", "Personal Use"),
              _buildInfoRow("Int Area", "Olpad"),
            ]),
            SizedBox(height: 12),

            // Follow-Up Information
            Text("Follow-up", style: _sectionTitleStyle()),
            _buildCard([
              _buildInfoRow("Next Followup", "${widget.InquiryInfoList.nxtfollowup}"),
              _buildInfoRow("Created At", "${widget.InquiryInfoList.createdAt}"),
            ]),
            SizedBox(height: 16),

            // Action Buttons (Delete & Block)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle Delete action
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text("Delete", style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle Block action
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  child: Text("Block", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Helper method to create a circular icon button
  Widget _buildCircularButton(IconData icon, Color color) {
    return Container(
      height: 40,
      width: 40,
      decoration:
      BoxDecoration(borderRadius: BorderRadius.circular(20), color: color),
      child: Center(child: Icon(icon, color: Colors.white)),
    );
  }

  // Helper method to create an information row
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$label :", style: TextStyle(fontFamily: "poppins_thin")),
          SizedBox(width: 5,),
          Text(value,
              style:
              TextStyle(fontFamily: "poppins_thin", color: Colors.black)),
        ],
      ),
    );
  }

  // Helper method to create a card section
  Widget _buildCard(List<Widget> children) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(children: children),
      ),
    );
  }

  // Helper method for section title styling
  TextStyle _sectionTitleStyle() {
    return TextStyle(
        fontFamily: "poppins_thin", fontSize: 16, fontWeight: FontWeight.bold);
  }
}

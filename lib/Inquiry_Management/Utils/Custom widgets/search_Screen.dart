
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hr_app/Inquiry_Management/Utils/Colors/app_Colors.dart';
import 'package:hr_app/Inquiry_Management/Utils/Custom%20widgets/pending_Card.dart';
import 'package:lottie/lottie.dart';

import '../../Inquiry Management Screens/lead_Detail_Screen.dart';
import '../../Model/Api Model/allInquiryModel.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool isSearching = false;
  List<Inquiry> allLeads = [
    Inquiry(
      id: '1',
      fullName: 'John Doe',
      mobileno: '1234567890',
      InqStage: 'Pending',
      createdAt: '2024-02-01',
      nxtfollowup: '2024-02-10',
      InqType: 'Type A',
      InqArea: 'Area 1',
      PurposeBuy: 'Investment',
      dayskip: '0',
      hourskip: '0', remark: '', budget: '', InqStatus: '',
    ),
    Inquiry(
      id: '2',
      fullName: 'Jane Smith',
      mobileno: '0987654321',
      InqStage: 'Completed',
      createdAt: '2024-01-15',
      nxtfollowup: '2024-02-12',
      InqType: 'Type B',
      InqArea: 'Area 2',
      PurposeBuy: 'Residential',
      dayskip: '1',
      hourskip: '2', remark: '', budget: '', InqStatus: '',
    ),
  ];

  List<Inquiry> filteredLeads = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    filteredLeads = allLeads;
  }

  void _filterLeads(String query) {
    setState(() {
      isSearching = query.isNotEmpty;
      if (query.isEmpty) {
        filteredLeads = []; // Show nothing when search is empty
      } else {
        filteredLeads = allLeads.where((lead) =>
        lead.fullName.toLowerCase().contains(query.toLowerCase()) ||
            lead.mobileno.toLowerCase().contains(query.toLowerCase()) ||
            lead.id.toString().contains(query)
        ).toList();
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.Buttoncolor,
        title: TextField(
          controller: _searchController,
          cursorColor: Colors.white,
          style: TextStyle(color: Colors.white,fontFamily: "poppins_thin"),
          decoration: InputDecoration(
            hintText: 'Search leads...',
            hintStyle: TextStyle(color: Colors.white,fontFamily: "poppins_thin"),
            border: InputBorder.none,

          ),
          onChanged: _filterLeads,
          autofocus: true,
        ),
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: Icon(CupertinoIcons.back,color: Colors.white,)),
        iconTheme: IconThemeData(color: Colors.white),
        // actionsIconTheme: IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: isSearching
            ? filteredLeads.isEmpty
            ? Center(
          child: Lottie.asset(
            'asset/loader.json',
            fit: BoxFit.contain,
            width: 100,
            height: 100,
          ),
        )
            : ListView.builder(
          controller: _scrollController,
          itemCount: filteredLeads.length,
          itemBuilder: (BuildContext context, int index) {
            Inquiry inquiry = filteredLeads[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LeadDetailScreen(
                      InquiryInfoList: inquiry,
                    ),
                  ),
                );
              },
              child: TestCard(
                id: inquiry.id,
                name: inquiry.fullName,
                username: inquiry.mobileno,
                label: inquiry.InqStage,
                followUpDate: inquiry.createdAt,
                nextFollowUpDate: inquiry.nxtfollowup,
                inquiryType: inquiry.InqType,
                intArea: inquiry.InqArea,
                purposeBuy: inquiry.PurposeBuy,
                daySkip: inquiry.dayskip,
                hourSkip: inquiry.hourskip,
                source: inquiry.mobileno,
                isSelected: false,
                onSelect: () {},
                callList: [],
                selectedcallFilter: '',
                data: inquiry,
                isTiming: true,
                nextFollowupcontroller: TextEditingController(),
              ),
            );
          },
        ): Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                  child: Lottie.asset(
                  'asset/Inquiry_module/search.json', // Use a general search animation
            width: 350,
            height: 350,
                  ),
                ),
            Text("Search Anything you want",style: TextStyle(fontFamily: "poppins_thin",color: AppColor.MainColor,fontSize: 20),)
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

}

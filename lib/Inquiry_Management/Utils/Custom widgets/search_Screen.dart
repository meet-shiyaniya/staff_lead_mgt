import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hr_app/Inquiry_Management/Utils/Colors/app_Colors.dart';
import 'package:hr_app/Inquiry_Management/Utils/Custom%20widgets/pending_Card.dart';
import 'package:hr_app/Provider/UserProvider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../Inquiry Management Screens/lead_Detail_Screen.dart';
import '../../Model/Api Model/allInquiryModel.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    final inquiryProvider = Provider.of<UserProvider>(context, listen: false);

    setState(() {
      isSearching = query.isNotEmpty;
    });

    inquiryProvider.fetchInquiries(search: query);
  }

  @override
  Widget build(BuildContext context) {
    final inquiryProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.Buttoncolor,
        title: TextField(
          controller: _searchController,
          cursorColor: Colors.white,
          style: TextStyle(color: Colors.white, fontFamily: "poppins_thin"),
          decoration: InputDecoration(
            hintText: 'Search leads...',
            hintStyle: TextStyle(color: Colors.white, fontFamily: "poppins_thin"),
            border: InputBorder.none,
          ),
          autofocus: true,
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(CupertinoIcons.back, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: isSearching
            ? inquiryProvider.isLoading
            ? Center(
          child: Lottie.asset(
            'asset/loader.json',
            width: 100,
            height: 100,
          ),
        )
            : inquiryProvider.inquiries.isEmpty
            ? _buildNoResultsView()
            : ListView.builder(
          controller: _scrollController,
          itemCount: inquiryProvider.inquiries.length,
          itemBuilder: (context, index) {
            Inquiry inquiry = inquiryProvider.inquiries[index];
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
        )
            : _buildSearchPromptView(),
      ),
    );
  }

  // Widget to show when no results found
  Widget _buildNoResultsView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'asset/Inquiry_module/search.json',
            width: 250,
            height: 250,
          ),
          Text(
            "No Results Found",
            style: TextStyle(
              fontFamily: "poppins_thin",
              color: AppColor.MainColor,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  // Widget to show when no search input yet
  Widget _buildSearchPromptView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'asset/Inquiry_module/search.json',
            width: 300,
            height: 300,
          ),
          Text(
            "Search Anything You Want",
            style: TextStyle(
              fontFamily: "poppins_thin",
              color: AppColor.MainColor,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

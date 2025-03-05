import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
// import 'package:inquiry_management_ui/Inquiry%20Management%20Screens/Followup%20Screen/cnr_Screen.dart';

import '../Model/followup_Model.dart';
import '../Utils/Colors/app_Colors.dart';
import '../Utils/Custom widgets/custom_search.dart';
import '../Utils/Custom widgets/filter_Bottomsheet.dart';
// import '../test_Screen.dart';
import 'Followup Screen/cnr_Screen.dart';
import 'Followup Screen/pending_Screen.dart';
import 'Followup Screen/todays_Lead_Screen.dart';

class FollowupAndCnrScreen extends StatefulWidget {
  const FollowupAndCnrScreen({super.key});

  @override
  State<FollowupAndCnrScreen> createState() => _FollowupAndCnrScreenState();
}

class _FollowupAndCnrScreenState extends State<FollowupAndCnrScreen> {



  // void showBottomModalSheet(BuildContext context) {
  //   showModalBottomSheet(
  //       context: context,
  //       // isScrollControlled: true,
  //       isScrollControlled: true,
  //       constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
  //       ),
  //       builder: (context) => FractionallySizedBox(
  //           heightFactor: 0.8, child:  FilterModal()
  //       ));
  // }



  @override
  Widget build(BuildContext context) {
    return DefaultTabController (
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple.shade300,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          title: Text(
            "Leads",
            style: TextStyle(color: Colors.white, fontFamily: "poppins_thin"),
          ),
          actions: [
            // SearchBar1(),
            // SizedBox(width: 5,),
            // CircleAvatar(
            //   backgroundColor: Colors.white,
            //   child: IconButton(
            //     icon: Icon(Icons.filter_list, color: Colors.black),
            //     onPressed: () {
            //       // showBottomModalSheet(context);
            //     },
            //   ),
            // ),
            // SizedBox(width: 10,)
          ],
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.list), text: "Today's Followup"),
              Tab(icon: Icon(Icons.group), text: "Pending Followup"),
              Tab(icon: Icon(Icons.person), text: "CNR"),
            ],
          ),
        ),
        backgroundColor: Colors.grey.shade200,
        body: TabBarView(
          children: [
            ShiftsList(),
            LeadsList(),
            CnrScreen()

            // Center(child: Text("My Leads", style: TextStyle(fontSize: 18.0))),
            // Center(child: Text("CNR", style: TextStyle(fontSize: 18.0))),
          ],
        ),
      ),
    );
  }
}

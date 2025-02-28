import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../Provider/UserProvider.dart';
import '../../../Model/Realtomodels/Realtoallstaffleavesmodel.dart';
import '../../Color/app_Color.dart';
import 'package:http/http.dart' as http;

class allStaffLeavesScreen extends StatefulWidget {
  const allStaffLeavesScreen({super.key});

  @override
  State<allStaffLeavesScreen> createState() => _allStaffLeavesScreenState();
}

class _allStaffLeavesScreenState extends State<allStaffLeavesScreen> {

  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  List<Data> leavesStaff = [];

  Future<void> _fetchLeavesData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.fetchAllStaffLeavesData();

    setState(() {
      // Filter leaves where status == "0"
      leavesStaff = userProvider.allStaffLeavesData?.data
          ?.where((leave) => leave.status == "0")
          .toList()
          .reversed
          .toList() ?? [];
    });
  }

  Future<void> _sendApproveReject({
    required String leaveId,
    required String action,
  }) async {
    final url = Uri.parse("https://admin.dev.ajasys.com/api/leave_request_action");

    try {
      String? token = await _secureStorage.read(key: 'token');
      if (token == null) return;

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': token, 'leave_id': leaveId, 'action': action}),
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "Send Success");

        // Close the dialog before updating UI
        Navigator.pop(context);

        _fetchLeavesData();

      } else {
        Fluttertoast.showToast(msg: "Failed to update leave request.");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Send not Success");
    }
  }

  void _showDialog(BuildContext context,String title, String id, String action) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: appColor.subFavColor,
          // contentPadding: EdgeInsets.symmetric(horizontal: 40),
          title: Text("Confirm ${title}", style: TextStyle(fontSize: 20, color: Colors.black, fontFamily: "poppins_thin"),),
          content: Text("Are you sure you want to\n${title} this Leave request?", textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w100),),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text("Cancel", style: TextStyle(color: appColor.favColor, fontFamily: "poppins_thin", fontSize: 14)),
            ),
            ElevatedButton(
              onPressed: (){

                _sendApproveReject(leaveId: id, action: action);

              },
              child: Text("${title}", style: TextStyle(color: Colors.white, fontFamily: "poppins_thin", fontSize: 14)),
              style: ElevatedButton.styleFrom(

                  backgroundColor: appColor.favColor

              ),
            ),

          ],
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchLeavesData();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.white,

      body: Padding(

        padding: const EdgeInsets.symmetric(horizontal: 16.0),

        child: Column(

          children: [

            SizedBox(height: 35,),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Icon(FontAwesomeIcons.solidCalendarDays, size: 19, color: appColor.bodymainTxtColor,),

                SizedBox(width: 10,),

                Text("All Staff Leave Request", style: TextStyle(color: appColor.bodymainTxtColor, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),),

              ],
            ),

            SizedBox(height: 25,),

            leavesStaff.isEmpty ?

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Image.asset("asset/HR Screen Images/Leave/Warning-rafiki.png"),

                Text("No leave requests yet!", style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: "poppins_thin",),),

              ],
            ) :

            Expanded(

              child: ListView.builder(

                itemCount: leavesStaff.length,

                itemBuilder: (context, index) {

                  final leave = leavesStaff[index];

                  return Padding(

                    padding: const EdgeInsets.only(bottom: 20.0),

                    child: Container(

                      height: 250,
                      width: MediaQuery.of(context).size.width.toDouble(),

                      decoration: BoxDecoration(

                        color: appColor.subPrimaryColor,

                        borderRadius: BorderRadius.circular(12),

                      ),

                      child: Column(

                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [

                          SizedBox(height: 8,),

                          ListTile(

                            leading: Container(

                              height: 46,
                              width: 46,

                              decoration: BoxDecoration(

                                shape: BoxShape.circle,

                                color: appColor.primaryColor,

                                image: DecorationImage(image: NetworkImage("https://vertex-academy.com/en/images/reviews/5.jpg"),),

                              ),

                            ),

                            title: Text("${leave.fullName}", style: TextStyle(color: appColor.bodymainTxtColor, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),),

                            subtitle: Text("Team: ${leave.underTeam}", style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.w600, fontFamily: "poppins_thin"),),

                            trailing: Container(

                              height: 28,
                              width: 80,

                              decoration: BoxDecoration(

                                color: leave.typeOfLeave == "Paid Leave" ? Colors.green.shade100 : Colors.red.shade100,

                                borderRadius: BorderRadius.circular(20),

                                border: Border.all(color: leave.typeOfLeave == "Paid Leave" ? Colors.green.shade600 : Colors.red.shade600,),

                              ),

                              child: Center(

                                  child: Text("${leave.typeOfLeave}", style: TextStyle(color: leave.typeOfLeave == "Paid Leave" ? Colors.green.shade600 : Colors.red.shade600, fontSize: 10, fontWeight: FontWeight.w700),)

                              ),

                            ),

                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Text("${leave.leaveFromDate} to ${leave.leaveToDate}", style: TextStyle(color: Colors.deepPurple.shade600, fontWeight: FontWeight.bold, fontFamily: "poppins_thin", fontSize: 13),),

                            ],
                          ),

                          SizedBox(height: 5,),

                          Padding(

                            padding: const EdgeInsets.symmetric(horizontal: 18.0),

                            child: Divider(color: Colors.grey.shade400, thickness: 1.2,),

                          ),

                          SizedBox(height: 10,),

                          Padding(

                            padding: const EdgeInsets.symmetric(horizontal: 18.0),

                            child: Row(

                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                              children: [

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Text("Reason", style: TextStyle(color: Colors.grey.shade700, fontSize: 12, fontFamily: "poppins_thin", fontWeight: FontWeight.w500,),),

                                    SizedBox(height: 2,),

                                    Container(

                                        height: 17,
                                        width: 100,

                                        child: Text("${leave.leaveReason}", style: TextStyle(color: Colors.black, fontSize: 12, fontFamily: "poppins_thin", fontWeight: FontWeight.bold,), maxLines: 1, overflow: TextOverflow.ellipsis,)

                                    ),

                                  ],

                                ),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Text("Type", style: TextStyle(color: Colors.grey.shade700, fontSize: 12, fontFamily: "poppins_thin", fontWeight: FontWeight.w500,),),

                                    SizedBox(height: 2,),

                                    Container(

                                        height: 17,
                                        width: 100,

                                        child: Text("${leave.typeOfLeave}", style: TextStyle(color: Colors.black, fontSize: 12, fontFamily: "poppins_thin", fontWeight: FontWeight.bold,), maxLines: 1, overflow: TextOverflow.ellipsis,)

                                    ),

                                  ],
                                ),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Text("Apply Days", style: TextStyle(color: Colors.grey.shade700, fontSize: 12, fontFamily: "poppins_thin", fontWeight: FontWeight.w500,),),

                                    SizedBox(height: 2,),

                                    Container(

                                        height: 17,
                                        width: 100,

                                        child: Text("${leave.leaveApplyDays}", style: TextStyle(color: Colors.black, fontSize: 12, fontFamily: "poppins_thin", fontWeight: FontWeight.bold,), maxLines: 1, overflow: TextOverflow.ellipsis,)

                                    ),

                                  ],
                                ),

                              ],

                            ),

                          ),

                          SizedBox(height: 20,),

                          Padding(

                            padding: const EdgeInsets.symmetric(horizontal: 18.0),

                            child: Row(

                              mainAxisAlignment: MainAxisAlignment.spaceAround,

                              children: [

                                ElevatedButton(

                                  onPressed: (){

                                    _showDialog(context, "Reject", "${leave.id}", "reject");

                                  },

                                  child: Text("Reject", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: "poppins_thin", fontSize: 13.4,),),

                                  style: ElevatedButton.styleFrom(

                                    shape: RoundedRectangleBorder(

                                      borderRadius: BorderRadius.circular(6),

                                    ),

                                    backgroundColor: Colors.red.shade900,

                                    fixedSize: Size(150, 40),

                                  ),

                                ),

                                // Spacer(),

                                ElevatedButton(

                                  onPressed: (){

                                    _showDialog(context, "Approve", "${leave.id}", "approve");

                                  },

                                  child: Text("Approve", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: "poppins_thin", fontSize: 13,),),

                                  style: ElevatedButton.styleFrom(

                                    shape: RoundedRectangleBorder(

                                      borderRadius: BorderRadius.circular(6),

                                    ),

                                    backgroundColor: Colors.green.shade900,

                                    fixedSize: Size(150, 40),

                                  ),

                                ),

                              ],

                            ),
                          ),

                        ],

                      ),

                    ),

                  );

                },

              ),

            ),

            SizedBox(height: 2,),

          ],
        ),
      ),

      // floatingActionButton: FloatingActionButton(
      //
      //   backgroundColor: appColor.primaryColor,
      //
      //   child: Icon(Icons.add, color: appColor.appbarTxtColor, size: 26,),
      //
      //   onPressed: () {
      //
      //     Navigator.push(context, MaterialPageRoute(builder: (context) => addRequestScreen()));
      //
      //   },
      //
      //   shape: RoundedRectangleBorder(
      //
      //     borderRadius: BorderRadius.circular(30),
      //
      //   ),
      //
      //   elevation: 4,
      //
      // ),

    );

  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../Provider/UserProvider.dart';
import '../../../Model/Realtomodels/Realtostaffleavesmodel.dart';
import '../../Color/app_Color.dart';
import 'add_Leave_Request_Screen.dart';

class leaveRequestScreen extends StatefulWidget {
  const leaveRequestScreen({super.key});

  @override
  State<leaveRequestScreen> createState() => _leaveRequestScreenState();
}

class _leaveRequestScreenState extends State<leaveRequestScreen> {

  List<Data> leavesStaff = [];

  Future<void> _fetchLeavesData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.fetchStaffLeavesData();
    setState(() {
      leavesStaff = userProvider.staffLeavesData?.data?.reversed.toList() ?? [];
    });
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

                Icon(Icons.request_page_rounded, size: 22, color: appColor.bodymainTxtColor,),

                SizedBox(width: 10,),

                Text("Requested Leave", style: TextStyle(color: appColor.bodymainTxtColor, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),),

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

                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(1, 3),),
                          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(1, 3),),
                          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(1, 3),),
                        ],

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

                              Text("${leave.leaveFromDate} - ${leave.leaveToDate}", style: TextStyle(color: Colors.deepPurple.shade600, fontWeight: FontWeight.bold, fontFamily: "poppins_thin", fontSize: 13),),

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

                                    Text("Status", style: TextStyle(color: Colors.grey.shade700, fontSize: 12, fontFamily: "poppins_thin", fontWeight: FontWeight.w500,),),

                                    SizedBox(height: 2,),

                                    Container(

                                        height: 17,
                                        width: 70,
                                        // color: Colors.blue,

                                        child: Text(leave.status == "0" ? "Pending" : leave.status == "1" ? "Approved" : "Rejected", style: TextStyle(color: leave.status == "0" ? Colors.orange.shade700 : leave.status == "2" ? Colors.red.shade900 : Colors.green.shade900, fontSize: 12, fontFamily: "poppins_thin", fontWeight: FontWeight.bold,), maxLines: 1, overflow: TextOverflow.ellipsis,),

                                    ),

                                  ],

                                ),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [

                                    Text("Leave Type", style: TextStyle(color: Colors.grey.shade700, fontSize: 12, fontFamily: "poppins_thin", fontWeight: FontWeight.w500,),),

                                    SizedBox(height: 2,),

                                    Container(

                                        height: 17,
                                        width: 130,
                                        // color: Colors.blue,

                                        child: Center(
                                          child: Text("${leave.typeOfLeave}", style: TextStyle(color: Colors.black, fontSize: 12, fontFamily: "poppins_thin", fontWeight: FontWeight.bold,), maxLines: 1, overflow: TextOverflow.ellipsis,)
                                        ),

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
                                        width: 70,
                                        // color: Colors.blue,

                                        child: Text("${leave.leaveApplyDays} Days", style: TextStyle(color: Colors.black, fontSize: 12, fontFamily: "poppins_thin", fontWeight: FontWeight.bold,), maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.right,)

                                    ),

                                  ],
                                ),

                              ],

                            ),

                          ),

                          SizedBox(height: 8,),

                          Padding(

                            padding: const EdgeInsets.symmetric(horizontal: 18.0),

                            child: Container(

                              height: 36,
                              width: MediaQuery.of(context).size.width.toDouble(),
                              // color: Colors.green,

                              child: Text("Leave Reason : ${leave.leaveReason}", style: TextStyle(color: Colors.grey.shade700, fontSize: 13, fontFamily: "poppins_thin", fontWeight: FontWeight.bold,), maxLines: 2, overflow: TextOverflow.ellipsis),

                            ),

                          ),

                          SizedBox(height: 6,),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text("Approver : ${leave.reportingTo}", style: TextStyle(color: Colors.grey.shade800, fontSize: 13, fontFamily: "poppins_thin", fontWeight: FontWeight.bold,), maxLines: 2, overflow: TextOverflow.ellipsis),
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

      floatingActionButton: FloatingActionButton(

        backgroundColor: appColor.primaryColor,

        child: Icon(Icons.add, color: appColor.appbarTxtColor, size: 26,),

        onPressed: () {

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => addLeaveRequestScreen()),
          ).then((value) {
            if (value == true) {
              _fetchLeavesData();  // Refresh data when returning
            }
          });

        },

        shape: RoundedRectangleBorder(

          borderRadius: BorderRadius.circular(30),

        ),

        elevation: 4,

      ),

    );

  }
}
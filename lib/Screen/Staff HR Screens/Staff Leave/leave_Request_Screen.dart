import 'package:flutter/material.dart';
import 'package:hr_app/Model/Staff%20HR%20Screen%20Model/leave_Req_Model.dart';
import 'package:hr_app/Screen/Staff%20HR%20Screens/Staff%20Leave/add_Leave_Request_Screen.dart';
import '../../Color/app_Color.dart';

class leaveRequestScreen extends StatefulWidget {
  const leaveRequestScreen({super.key});

  @override
  State<leaveRequestScreen> createState() => _leaveRequestScreenState();
}

class _leaveRequestScreenState extends State<leaveRequestScreen> {

  List<leaveReqModel> employeeLeaveList = [

    leaveReqModel(1, 'admin_Meet', 'https://scontent.famd1-2.fna.fbcdn.net/v/t39.30808-6/475131181_635656495479414_715511376224210954_n.jpg?_nc_cat=105&ccb=1-7&_nc_sid=6ee11a&_nc_ohc=s2nw4seXsIMQ7kNvgEfaYO6&_nc_zt=23&_nc_ht=scontent.famd1-2.fna&_nc_gid=AY4ArClBOcybX-Lubhk0KGY&oh=00_AYCwSlw-LcFI4nSfdPA7XEO6DKJpv6nix_Q3re2cMQedSg&oe=679F93EC', 'Flutter Developer', '01-02-2025', '02-02-2025', 'Sick Leave', 'Feeling unwell and not so good at the time that is reason.', 2, 'Paid', "Pending"),

    leaveReqModel(2, 'admin_Meet', 'https://scontent.famd1-2.fna.fbcdn.net/v/t39.30808-6/475131181_635656495479414_715511376224210954_n.jpg?_nc_cat=105&ccb=1-7&_nc_sid=6ee11a&_nc_ohc=s2nw4seXsIMQ7kNvgEfaYO6&_nc_zt=23&_nc_ht=scontent.famd1-2.fna&_nc_gid=AY4ArClBOcybX-Lubhk0KGY&oh=00_AYCwSlw-LcFI4nSfdPA7XEO6DKJpv6nix_Q3re2cMQedSg&oe=679F93EC', 'Flutter Developer', '03-02-2025', '05-02-2025', 'Casual Leave', 'Personal work with some notice work and give report', 3, 'Paid', "Approved"),

    leaveReqModel(3, 'admin_Meet', 'https://scontent.famd1-2.fna.fbcdn.net/v/t39.30808-6/475131181_635656495479414_715511376224210954_n.jpg?_nc_cat=105&ccb=1-7&_nc_sid=6ee11a&_nc_ohc=s2nw4seXsIMQ7kNvgEfaYO6&_nc_zt=23&_nc_ht=scontent.famd1-2.fna&_nc_gid=AY4ArClBOcybX-Lubhk0KGY&oh=00_AYCwSlw-LcFI4nSfdPA7XEO6DKJpv6nix_Q3re2cMQedSg&oe=679F93EC', 'Flutter Developer', '10-02-2025', '12-02-2025', 'Vacation Leave', 'Family vacation to went to a goa with some days', 3, 'Unpaid', "Approved"),

    leaveReqModel(4, 'admin_Meet', 'https://scontent.famd1-2.fna.fbcdn.net/v/t39.30808-6/475131181_635656495479414_715511376224210954_n.jpg?_nc_cat=105&ccb=1-7&_nc_sid=6ee11a&_nc_ohc=s2nw4seXsIMQ7kNvgEfaYO6&_nc_zt=23&_nc_ht=scontent.famd1-2.fna&_nc_gid=AY4ArClBOcybX-Lubhk0KGY&oh=00_AYCwSlw-LcFI4nSfdPA7XEO6DKJpv6nix_Q3re2cMQedSg&oe=679F93EC', 'Flutter Developer', '15-02-2025', '16-02-2025', 'Emergency Leave', 'Medical emergency, sick emergency and blood', 2, 'Paid', "Rejected"),

    leaveReqModel(5, 'admin_Meet', 'https://scontent.famd1-2.fna.fbcdn.net/v/t39.30808-6/475131181_635656495479414_715511376224210954_n.jpg?_nc_cat=105&ccb=1-7&_nc_sid=6ee11a&_nc_ohc=s2nw4seXsIMQ7kNvgEfaYO6&_nc_zt=23&_nc_ht=scontent.famd1-2.fna&_nc_gid=AY4ArClBOcybX-Lubhk0KGY&oh=00_AYCwSlw-LcFI4nSfdPA7XEO6DKJpv6nix_Q3re2cMQedSg&oe=679F93EC', 'Flutter Developer', '20-02-2025', '22-02-2025', 'Maternity Leave', 'new member comes with a new happiness in home', 3, 'Paid', "Pending"),

    leaveReqModel(6, 'admin_Meet', 'https://scontent.famd1-2.fna.fbcdn.net/v/t39.30808-6/475131181_635656495479414_715511376224210954_n.jpg?_nc_cat=105&ccb=1-7&_nc_sid=6ee11a&_nc_ohc=s2nw4seXsIMQ7kNvgEfaYO6&_nc_zt=23&_nc_ht=scontent.famd1-2.fna&_nc_gid=AY4ArClBOcybX-Lubhk0KGY&oh=00_AYCwSlw-LcFI4nSfdPA7XEO6DKJpv6nix_Q3re2cMQedSg&oe=679F93EC', 'Flutter Developer','25-02-2025','26-02-2025','Sick Leave','Flu symptoms and accident with car so very effect',2,'Unpaid', "Rejected"),

  ];

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

            Expanded(

              child: ListView.builder(

                itemCount: employeeLeaveList.length,

                itemBuilder: (context, index) {

                  final leave = employeeLeaveList[index];

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

                                image: DecorationImage(image: NetworkImage(leave.imageUrl), fit: BoxFit.cover),

                              ),

                            ),

                            title: Text(leave.name, style: TextStyle(color: appColor.bodymainTxtColor, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),),

                            subtitle: Text(leave.developerType, style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.w600, fontFamily: "poppins_thin"),),

                            trailing: Container(

                              height: 28,
                              width: 80,

                              decoration: BoxDecoration(

                                color: leave.leavePaymentType == "Paid" ? Colors.green.shade100 : Colors.red.shade100,

                                borderRadius: BorderRadius.circular(20),

                                border: Border.all(color: leave.leavePaymentType == "Paid" ? Colors.green.shade600 : Colors.red.shade600,),

                              ),

                              child: Center(

                                  child: Text(leave.leavePaymentType, style: TextStyle(color: leave.leavePaymentType == "Paid" ? Colors.green.shade600 : Colors.red.shade600, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),)

                              ),

                            ),

                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Text("${leave.startLeaveDate} - ${leave.endLeaveDate}", style: TextStyle(color: Colors.green.shade900, fontWeight: FontWeight.bold, fontFamily: "poppins_thin", fontSize: 13),),

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
                                        width: 100,

                                        child: Text(leave.status, style: TextStyle(color: leave.status == "Pending" ? Colors.orange.shade700 : leave.status == "Rejected" ? Colors.red.shade900 : Colors.green.shade900, fontSize: 12, fontFamily: "poppins_thin", fontWeight: FontWeight.bold,), maxLines: 1, overflow: TextOverflow.ellipsis,),

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

                                        child: Text(leave.leaveType, style: TextStyle(color: Colors.black, fontSize: 12, fontFamily: "poppins_thin", fontWeight: FontWeight.bold,), maxLines: 1, overflow: TextOverflow.ellipsis,)

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

                                        child: Text("${leave.leaveApplyDays} Days", style: TextStyle(color: Colors.black, fontSize: 12, fontFamily: "poppins_thin", fontWeight: FontWeight.bold,), maxLines: 1, overflow: TextOverflow.ellipsis,)

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
                                Text("Approver : Dishant Dhameliya", style: TextStyle(color: Colors.grey.shade800, fontSize: 13, fontFamily: "poppins_thin", fontWeight: FontWeight.bold,), maxLines: 2, overflow: TextOverflow.ellipsis),
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

          Navigator.push(context, MaterialPageRoute(builder: (context) => addLeaveRequestScreen()));

        },

        shape: RoundedRectangleBorder(

          borderRadius: BorderRadius.circular(30),

        ),

        elevation: 4,

      ),

    );

  }
}
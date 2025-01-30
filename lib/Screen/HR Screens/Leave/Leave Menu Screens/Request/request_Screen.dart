import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../../Model/HR Screen Models/Leave/request_Model.dart';
import '../../../../Color/app_Color.dart';
import 'add_Request_Screen.dart';

class requestScreen extends StatefulWidget {
  const requestScreen({super.key});

  @override
  State<requestScreen> createState() => _requestScreenState();
}

class _requestScreenState extends State<requestScreen> {

  List<requestModel> employeeLeaveList = [

    requestModel(1, 'John Doe', 'https://www.corporatephotographylondon.com/wp-content/uploads/2019/11/HKstrategies-1029-1024x683.jpg', 'Flutter Developer', '01-02-2025', '02-02-2025', 'Sick Leave', 'Feeling unwell', 2, 'Paid',),

    requestModel(2, 'Jane Smith', 'https://files.gotocon.com/uploads/portraits/1020/square_medium/alexander_aghassipour_1618410338.png', 'Front-end Developer', '03-02-2025', '05-02-2025', 'Casual Leave', 'Personal work', 3, 'Paid',),

    requestModel(3, 'Robert Johnson', 'https://www.corporatephotographylondon.com/wp-content/uploads/2019/11/HKstrategies-1663-1-1024x683.jpg', 'Back-end Developer', '10-02-2025', '12-02-2025', 'Vacation Leave', 'Family vacation', 3, 'Unpaid',),

    requestModel(4, 'Alice Brown', 'https://www.corporatephotographylondon.com/wp-content/uploads/2019/11/HKstrategies-797.jpg', 'Full-stack Developer', '15-02-2025', '16-02-2025', 'Emergency Leave', 'Medical emergency', 2, 'Paid',),

    requestModel(5, 'Michael Davis', 'https://www.corporatephotographylondon.com/wp-content/uploads/2019/11/HKstrategies-2582.jpg', 'DevOps Engineer', '20-02-2025', '22-02-2025', 'Maternity Leave', 'new member', 3, 'Paid',),

    requestModel(6,'Emma Wilson','https://newspringcapital.com/assets/img/team/Annie-1981.jpg','Mobile App Developer','25-02-2025','26-02-2025','Sick Leave','Flu symptoms',2,'Unpaid',),

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

                                    Text("Reason", style: TextStyle(color: Colors.grey.shade700, fontSize: 12, fontFamily: "poppins_thin", fontWeight: FontWeight.w500,),),

                                    SizedBox(height: 2,),

                                    Container(

                                      height: 17,
                                      width: 100,

                                      child: Text(leave.leaveReason, style: TextStyle(color: Colors.black, fontSize: 12, fontFamily: "poppins_thin", fontWeight: FontWeight.bold,), maxLines: 1, overflow: TextOverflow.ellipsis,)

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

                          SizedBox(height: 20,),
                          
                          Padding(
                            
                            padding: const EdgeInsets.symmetric(horizontal: 18.0),
                            
                            child: Row(

                              mainAxisAlignment: MainAxisAlignment.spaceAround,

                              children: [
                                
                                ElevatedButton(
                                  
                                  onPressed: (){

                                    Fluttertoast.showToast(msg: "Leave Rejected");

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

                                    Fluttertoast.showToast(msg: "Leave Approved");

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

      floatingActionButton: FloatingActionButton(

        backgroundColor: appColor.primaryColor,

        child: Icon(Icons.add, color: appColor.appbarTxtColor, size: 26,),

        onPressed: () {

          Navigator.push(context, MaterialPageRoute(builder: (context) => addRequestScreen()));

        },

        shape: RoundedRectangleBorder(

          borderRadius: BorderRadius.circular(30),

        ),

        elevation: 4,

      ),

    );

  }
}
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../../Model/HR Screen Models/Leave/Leave Menu/approve_Model.dart';
import '../../../../Color/app_Color.dart';

class rejectLeaveScreen extends StatefulWidget {
  const rejectLeaveScreen({super.key});

  @override
  State<rejectLeaveScreen> createState() => _rejectLeaveScreenState();
}

class _rejectLeaveScreenState extends State<rejectLeaveScreen> {

  final List<approveModel> approveList = [

    approveModel(1, "John Doe", "https://thumbs.dreamstime.com/b/profile-picture-caucasian-male-employee-posing-office-happy-young-worker-look-camera-workplace-headshot-portrait-smiling-190186649.jpg", "Flutter Developer", "2025-01-10", "2025-01-15", "Sick Leave", "High fever", 5, "Paid", "Approve",),

    approveModel(2, "Jane Smith", "https://www.corporatephotographylondon.com/wp-content/uploads/2019/11/HKstrategies-846.jpg", "Backend Developer", "2025-01-08", "2025-01-12", "Casual Leave", "Family function", 4, "Unpaid", "Approve",),

    approveModel(3, "Michael Brown", "https://www.corporatephotographylondon.com/wp-content/uploads/2019/11/HKstrategies-846.jpg", "Frontend Developer", "2025-01-20", "2025-01-22", "Maternity Leave", "Wife's support", 3, "Paid", "Approve",),

    approveModel(4, "Emily Davis", "https://www.corporatephotographylondon.com/wp-content/uploads/2019/11/HKstrategies-855-2-1024x683.jpg", "Full-Stack Developer", "2025-02-01", "2025-02-05", "Vacation Leave", "Traveling", 5, "Paid", "Approve",),

    approveModel(5, "Chris Wilson", "https://www.corporatephotographylondon.com/wp-content/uploads/2019/11/HKstrategies-797-1024x683.jpg", "QA Engineer", "2025-03-10", "2025-03-12","Emergency Leave", "Personal emergency", 2, "Unpaid", "Approve",),

    approveModel(6, "Sophia Taylor", "https://th.bing.com/th/id/OIP.heGvD55MfTLHKgiLUi-LVgAAAA?w=432&h=371&rs=1&pid=ImgDetMain", "Project Manager", "2025-03-15","2025-03-20", "Paternity Leave", "Newborn care", 6, "Paid", "Approve",),

  ];


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.white,

      appBar: AppBar(

        backgroundColor: appColor.primaryColor,

        title: Text("Leave Details", style: TextStyle(color: appColor.appbarTxtColor, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),),

        centerTitle: true,

        foregroundColor: Colors.transparent,

        leading: IconButton(

          onPressed: (){
            Navigator.pop(context);
          },

          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20,),

        ),

      ),

      body: Padding(

        padding: const EdgeInsets.symmetric(horizontal: 12.0),

        child: Column(

          children: [

            SizedBox(height: 35,),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Icon(Icons.cancel, size: 22, color: Colors.red.shade900,),

                SizedBox(width: 10,),

                Text("Rejected Leave", style: TextStyle(color: appColor.bodymainTxtColor, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),),

              ],
            ),

            SizedBox(height: 25,),

            Expanded(

              child: ListView.builder(

                itemCount: approveList.length,

                itemBuilder: (context, index) {

                  final leave = approveList[index];

                  return Padding(

                    padding: const EdgeInsets.only(bottom: 20.0),

                    child: Card(

                      elevation: 3,

                      shadowColor: Colors.grey.shade200,

                      color: Colors.transparent,

                      child: Container(

                        height: 250,
                        width: MediaQuery.of(context).size.width.toDouble(),

                        decoration: BoxDecoration(

                          color: appColor.subPrimaryColor,

                          borderRadius: BorderRadius.circular(16),

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

                                Text("${leave.startLeaveDate} - ${leave.endLeaveDate}", style: TextStyle(color: Colors.red.shade900, fontWeight: FontWeight.bold, fontFamily: "poppins_thin", fontSize: 13),),

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

                                      Text("Reason", style: TextStyle(color: Colors.grey.shade700, fontSize: 12, fontFamily: "poppins_thin", fontWeight: FontWeight.w500,), overflow: TextOverflow.ellipsis,),

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

                                crossAxisAlignment: CrossAxisAlignment.center,

                                children: [

                                  Image.network("https://i.pinimg.com/originals/65/8e/07/658e0702ed408e5f62ec06d754eaa087.png", height: 50,),

                                  Spacer(),

                                  ElevatedButton(

                                    onPressed: (){

                                      Fluttertoast.showToast(msg: "Leave Approved");

                                    },

                                    child: Text("Rejected", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: "poppins_thin", fontSize: 13,),),

                                    style: ElevatedButton.styleFrom(

                                      shape: RoundedRectangleBorder(

                                        borderRadius: BorderRadius.circular(6),

                                      ),

                                      backgroundColor: Colors.red.shade900,

                                      fixedSize: Size(150, 40),

                                    ),

                                  ),

                                ],

                              ),
                            ),

                          ],

                        ),

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

    );

  }
}

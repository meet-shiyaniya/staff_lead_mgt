import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import '../../../../../Inquiry_Management/Model/Realtoallstaffleavesmodel.dart';
// import '../../../../../Provider/UserProvider.dart';
// import '../../../../../../Inquiry_Management/Model/Api Model/inquiryTimeLineModel.dart';
import '../../../../../../Provider/UserProvider.dart';
// import '../../../../../Model/Realtomodels/Realtoallstaffleavesmodel.dart';
// import '../../../../Model/Realtomodels/Realtostaffleavesmodel.dart';
import '../../../../Model/Realtomodels/Realtoallstaffleavesmodel.dart';
import '../../../Color/app_Color.dart';

class rejectScreen extends StatefulWidget {
  const rejectScreen({super.key});

  @override
  State<rejectScreen> createState() => _rejectScreenState();
}

class _rejectScreenState extends State<rejectScreen> {

  final List<Data> approveList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.microtask(() async{

      final userProvider = Provider.of<UserProvider>(context, listen: false);

      await userProvider.fetchStaffLeavesData();

      List<Data> staffAllLeaves = userProvider.allStaffLeavesData?.data?.reversed.toList() ?? [];

      approveList.clear();

      for (int i = 0; i < staffAllLeaves.length; i++) {

        if (staffAllLeaves[i].status == "2") {

          setState(() {
            approveList.add(staffAllLeaves[i]);
          });

        }

      }

    });

  }

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

            approveList.isEmpty ?

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Image.asset("asset/HR Screen Images/Leave/Warning-rafiki.png"),

                Text("Your leave requests is not Rejected yet!", style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: "poppins_thin",),),

              ],
            ) :

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

                                  image: DecorationImage(image: NetworkImage("https://vertex-academy.com/en/images/reviews/5.jpg"),),

                                ),

                              ),

                              title: Text("${leave.fullName}", style: TextStyle(color: appColor.bodymainTxtColor, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),),

                              subtitle: Text("${leave.underTeam}", style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.w600, fontFamily: "poppins_thin"),),

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

                                Text("${leave.leaveFromDate} - ${leave.leaveToDate}", style: TextStyle(color: Colors.green.shade900, fontWeight: FontWeight.bold, fontFamily: "poppins_thin", fontSize: 13),),

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
                                          width: 110,
                                          // color: Colors.blue,

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
                                          // color: Colors.blue,

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
                                          width: 70,
                                          // color: Colors.blue,

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
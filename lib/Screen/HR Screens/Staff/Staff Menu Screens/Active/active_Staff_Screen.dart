import 'package:flutter/material.dart';
import 'package:hr_app/Model/HR%20Screen%20Models/Staff/staff_Model.dart';
import 'package:hr_app/Screen/HR%20Screens/Staff/Staff%20Menu%20Screens/staff_Indetails_Screen.dart';
import '../../../../Color/app_Color.dart';

class activeStaffScreen extends StatefulWidget {

  List<staffModel> activeStaffList;

  activeStaffScreen({

    super.key,

    required this.activeStaffList

  });

  @override
  State<activeStaffScreen> createState() => _activeStaffScreenState();
}

class _activeStaffScreenState extends State<activeStaffScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,

      body: Padding(

        padding: const EdgeInsets.symmetric(horizontal: 16.0),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            SizedBox(height: 35,),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Icon(Icons.verified_user, size: 22, color: appColor.bodymainTxtColor,),

                SizedBox(width: 10,),

                Text("Active Staff Details", style: TextStyle(color: appColor.bodymainTxtColor, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),),

              ],
            ),

            SizedBox(height: 25),

            Expanded(

              child: ListView.builder(

                itemCount: widget.activeStaffList.length,

                itemBuilder: (context, index) {

                  final staff = widget.activeStaffList[index];

                  return Padding(

                    padding: const EdgeInsets.only(top: 18.0),

                    child: GestureDetector(

                      onTap: () {

                        Navigator.push(context, MaterialPageRoute(builder: (context) => staffIndetailsScreen(

                          staffData: staff,

                        )));

                      },

                      child: Container(

                        height: 170,
                        width: MediaQuery.of(context).size.width.toDouble(),

                        decoration: BoxDecoration(

                          color: appColor.subPrimaryColor,

                          borderRadius: BorderRadius.circular(12),

                          boxShadow: [

                            BoxShadow(
                              color: Colors.blueGrey.withOpacity(0.1),
                              blurRadius: 5,
                              spreadRadius: 2,
                              offset: Offset(0, 4), // Subtle bottom shadow
                            ),

                          ],

                        ),

                        child: Stack(

                          children: [

                            Container(

                              height: 170,
                              width: MediaQuery.of(context).size.width.toDouble(),

                              decoration: BoxDecoration(

                                borderRadius: BorderRadius.circular(12),

                                color: appColor.subPrimaryColor,

                              ),

                              child: Column(

                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [

                                  SizedBox(height: 15,),

                                  index.isEven ? Row(
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [

                                      SizedBox(width: 80,),

                                      SizedBox(

                                        height: 20,
                                        width: 160,

                                        child: Text(staff.staffName, style: TextStyle(color: appColor.bodymainTxtColor, fontFamily: "poppins_thin", fontSize: 15, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis,),

                                      ),

                                      Spacer(),

                                      Container(

                                        height: 30,
                                        width: 80,

                                        decoration: BoxDecoration(

                                          borderRadius: BorderRadius.circular(6),

                                          color: Colors.green.shade900,

                                        ),

                                        child: Center(

                                          child: Text(staff.type, style: TextStyle(color: Colors.white, fontFamily: "poppins_thin", fontSize: 13, fontWeight: FontWeight.bold),),

                                        ),

                                      ),

                                      SizedBox(width: 15,),

                                    ],
                                  ) : Row(
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [

                                      SizedBox(width: 15,),

                                      Container(

                                        height: 30,
                                        width: 80,

                                        decoration: BoxDecoration(

                                          borderRadius: BorderRadius.circular(6),

                                          color: Colors.green.shade900,

                                        ),

                                        child: Center(

                                          child: Text(staff.type, style: TextStyle(color: Colors.white, fontFamily: "poppins_thin", fontSize: 13, fontWeight: FontWeight.bold),),

                                        ),

                                      ),

                                      Spacer(),

                                      Text(staff.staffName, style: TextStyle(color: appColor.bodymainTxtColor, fontFamily: "poppins_thin", fontSize: 15, fontWeight: FontWeight.bold),),

                                      SizedBox(width: 80,),

                                    ],
                                  ),

                                  SizedBox(height: 6,),

                                  Row(

                                    mainAxisAlignment: MainAxisAlignment.center,

                                    children: [

                                      Text("Head : ", style: TextStyle(color: Colors.grey.shade700, fontFamily: "poppins_thin", fontSize: 13, fontWeight: FontWeight.w500),),

                                      Text(staff.headName, style: TextStyle(color: Colors.grey.shade800, fontFamily: "poppins_thin", fontSize: 14, fontWeight: FontWeight.w500),),

                                    ],

                                  ),

                                  SizedBox(height: 3,),

                                  Padding(

                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),

                                    child: Divider(color: Colors.grey.shade400, thickness: 1.5,),

                                  ),

                                  SizedBox(height: 8,),

                                  Padding(

                                    padding: const EdgeInsets.symmetric(horizontal: 18.0),

                                    child: Row(

                                      crossAxisAlignment: CrossAxisAlignment.center,

                                      children: [

                                        Image.network("https://icon-library.com/images/role-icon/role-icon-2.jpg", height: 20,),

                                        SizedBox(width: 6,),

                                        Text(staff.role, style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.w500, fontSize: 13.5, fontFamily: "poppins_thin"),),

                                        Spacer(),

                                        Text(staff.department, style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.w500, fontSize: 13.5, fontFamily: "poppins_thin"),),

                                        SizedBox(width: 6,),

                                        Image.network("https://cdn.iconscout.com/icon/premium/png-256-thumb/employee-363-641794.png", height: 19,),

                                      ],

                                    ),

                                  ),

                                  SizedBox(height: 15,),

                                  Padding(

                                    padding: const EdgeInsets.symmetric(horizontal: 18.0),

                                    child: Row(

                                      crossAxisAlignment: CrossAxisAlignment.center,

                                      children: [

                                        Icon(Icons.calendar_month_rounded, color: Colors.black, size: 20,),

                                        SizedBox(width: 4,),

                                        Text(staff.joiningDate, style: TextStyle(color: Colors.grey.shade900, fontWeight: FontWeight.w500, fontSize: 13.5, fontFamily: "poppins_light"),),

                                        Spacer(),

                                        Text(staff.email, style: TextStyle(color: Colors.grey.shade900, fontWeight: FontWeight.w500, fontSize: 13.5, fontFamily: "poppins_light"),),

                                        SizedBox(width: 4,),

                                        Icon(Icons.email_rounded, color: Colors.black, size: 20,),

                                      ],

                                    ),

                                  ),

                                ],

                              ),

                            ),

                            index.isEven ? Positioned(

                              left: -10,
                              top: -10,

                              child: Container(

                                height: 78,
                                width: 78,

                                decoration: BoxDecoration(

                                  shape: BoxShape.circle,

                                  color: Colors.white,

                                ),

                                child: Center(

                                  child: Container(

                                    height: 58,
                                    width: 58,

                                    decoration: BoxDecoration(

                                      shape: BoxShape.circle,

                                      image: DecorationImage(image: NetworkImage(staff.profileImg), fit: BoxFit.cover),

                                    ),

                                  ),

                                ),

                              ),

                            ) : Positioned(

                              right: -10,
                              top: -10,

                              child: Container(

                                height: 78,
                                width: 78,

                                decoration: BoxDecoration(

                                  shape: BoxShape.circle,

                                  color: Colors.white,

                                ),

                                child: Center(

                                  child: Container(

                                    height: 58,
                                    width: 58,

                                    decoration: BoxDecoration(

                                      shape: BoxShape.circle,

                                      color: appColor.primaryColor,

                                      image: DecorationImage(image: NetworkImage(staff.profileImg), fit: BoxFit.cover),

                                    ),

                                  ),

                                ),

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

          ],

        ),

      ),

    );

  }

}

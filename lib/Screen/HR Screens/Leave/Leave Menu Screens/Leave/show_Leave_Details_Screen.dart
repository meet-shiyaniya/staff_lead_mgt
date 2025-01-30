import 'package:flutter/material.dart';
import 'package:hr_app/Screen/HR%20Screens/Leave/Leave%20Menu%20Screens/Leave/approve_Leave_Screen.dart';
import 'package:hr_app/Screen/HR%20Screens/Leave/Leave%20Menu%20Screens/Leave/pending_Leave_Screen.dart';
import 'package:hr_app/Screen/HR%20Screens/Leave/Leave%20Menu%20Screens/Leave/reject_Leave_Screen.dart';
import '../../../../Color/app_Color.dart';

class showLeaveDetailsScreen extends StatefulWidget {
  const showLeaveDetailsScreen({super.key});

  @override
  State<showLeaveDetailsScreen> createState() => _showLeaveDetailsScreenState();
}

class _showLeaveDetailsScreenState extends State<showLeaveDetailsScreen> {
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

                Icon(Icons.leave_bags_at_home_rounded, size: 22, color: appColor.bodymainTxtColor,),

                SizedBox(width: 10,),

                Text("Leave Details", style: TextStyle(color: appColor.bodymainTxtColor, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),),

              ],
            ),

            SizedBox(height: 25),

            Expanded(

              child: ListView(

                children: [

                  _buildOptionTile(

                    context,

                    title: "Approved",

                    color: Colors.green.shade900,

                    icon: Icons.check_circle,

                    onTap: () {

                      Navigator.push(context, MaterialPageRoute(builder: (context) => approveLeaveScreen()));

                    },

                  ),

                  _buildOptionTile(

                    context,

                    title: "Pending",

                    color: Colors.orange.shade900,

                    icon: Icons.hourglass_top,

                    onTap: () {

                      Navigator.push(context, MaterialPageRoute(builder: (context) => pendingLeaveScreen()));

                    },

                  ),

                  _buildOptionTile(

                    context,

                    title: "Rejected",

                    color: Colors.red.shade900,

                    icon: Icons.cancel,

                    onTap: () {

                      Navigator.push(context, MaterialPageRoute(builder: (context) => rejectLeaveScreen()));

                    },

                  ),

                ],

              ),

            ),

          ],

        ),

      ),

    );

  }

  Widget _buildOptionTile(

      BuildContext context, {

        required String title,

        required Color color,

        required IconData icon,

        required VoidCallback onTap,

      }) {

    return Card(

      color: appColor.subPrimaryColor,

      elevation: 2,

      shadowColor: Colors.grey.shade300,

      margin: const EdgeInsets.symmetric(vertical: 8.0),

      child: ListTile(

        leading: Icon(icon, color: color),

        title: Text(

          title,

          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: "poppins_thin", color: appColor.bodymainTxtColor,),),

        trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey.shade700, size: 16),

        onTap: onTap,

      ),

    );

  }

}

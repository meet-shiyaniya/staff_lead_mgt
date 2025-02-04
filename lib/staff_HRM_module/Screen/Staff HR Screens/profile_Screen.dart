import 'package:flutter/material.dart';
import 'package:hr_app/social_module/login_screen/login_screen.dart';
import 'package:hr_app/staff_HRM_module/Screen/Color/app_Color.dart';
import 'package:hr_app/staff_HRM_module/Screen/Staff%20HR%20Screens/Attendannce/attendance_Screen.dart';
import 'package:hr_app/staff_HRM_module/Screen/Staff%20HR%20Screens/Profile/staff_Profile_Screen.dart';
import 'package:hr_app/staff_HRM_module/Screen/Staff%20HR%20Screens/Staff%20Leave/staff_Leave_Home_Screen.dart';
import 'package:hr_app/staff_HRM_module/Screen/Staff%20HR%20Screens/Staff%20Working%20Details/staff_Work_Det_Screen.dart';

class profileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 18),
          _buildProfileCard(context),
          SizedBox(height: 20),
          Expanded(child: _buildSettingsList(context)),
        ],
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {

    return Container(

      height: 140,
      width: MediaQuery.of(context).size.width.toDouble(),
      margin: EdgeInsets.symmetric(horizontal: 15),
      padding: EdgeInsets.symmetric(horizontal: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(1, 3)),
        ],
      ),

      child: Row(

        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [

          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage("https://funylife.in/wp-content/uploads/2022/11/20221118_172834.jpg"),
          ),

          SizedBox(width: 30,),

          Column(

            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              // SizedBox(height: 10),
              Text("Jhonson King", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: "poppins_thin", color: Colors.black)),
              Text("jhonking@gmail.com", style: TextStyle(color: Colors.grey.shade500, fontFamily: "poppins_light", fontWeight: FontWeight.w800, fontSize: 13)),
              SizedBox(height: 10),
              GestureDetector(

                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => staffProfileScreen()));
                },

                child: Container(

                  height: 30,
                  width: 126,

                  decoration: BoxDecoration(

                    color: Colors.deepPurple.shade300,
                    borderRadius: BorderRadius.circular(8),

                  ),

                  child: Center(

                    child: Text("View More", style: TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),),

                  ),

                ),
              ),

            ],

          ),

        ],

      ),

    );

  }

  Widget _buildSettingsList(BuildContext context) { // Pass context here
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Text("Account", style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: "poppins_thin", fontWeight: FontWeight.bold),),
        ),
        SizedBox(height: 5,),
        _buildListItem(context, Icons.calendar_month_rounded, "Attendance", 0),
        _buildListItem(context, Icons.leave_bags_at_home_rounded, "Leave", 1),
        _buildListItem(context, Icons.laptop_mac_rounded, "Working Details", 2),
        SizedBox(height: 20,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Text("Notification", style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: "poppins_thin", fontWeight: FontWeight.bold),),
        ),
        SizedBox(height: 5,),
        _buildListItem(context, Icons.notifications_rounded, "Pop-up Notification", 3),
        SizedBox(height: 20,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Text("Account Logout", style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: "poppins_thin", fontWeight: FontWeight.bold),),
        ),
        SizedBox(height: 5,),
        _buildListItem(context, Icons.power_settings_new_rounded, "Log Out", 4),
      ],
    );
  }

  Widget _buildListItem(BuildContext context, IconData icon, String text, int index) { // Add context here
    return Container(
      width: MediaQuery.of(context).size.width.toDouble(),
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      decoration: BoxDecoration(

        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(1, 3)),
        ],

      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple.shade300, size: 24),
        title: Text(text, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: "poppins_thin", color: Colors.grey.shade800)),
        trailing: index == 4 ? null : Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade800),
        onTap: () {
          if (index == 4) {
            _showLogoutDialog(context);
          } else if (index == 3) {

          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => index == 0 ? attendanceScreen() : index == 1 ? staffLeaveHomeScreen() : staffWorkDetScreen(),
              ),
            );
          }
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: appColor.subFavColor,
          title: Text("Confirm Logout", style: TextStyle(fontSize: 22, color: Colors.black, fontFamily: "poppins_thin"),),
          content: Text("Are you sure you want to logout?", textAlign: TextAlign.center, style: TextStyle(fontSize: 13.5, color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w100),),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text("Cancel", style: TextStyle(color: appColor.favColor, fontFamily: "poppins_thin", fontSize: 14)),
            ),
            ElevatedButton(
              onPressed: (){

                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false,);

              },
              child: Text("Logout", style: TextStyle(color: Colors.white, fontFamily: "poppins_thin", fontSize: 14)),
              style: ElevatedButton.styleFrom(

                backgroundColor: Colors.red.shade400

              ),
            ),

          ],
        );
      },
    );
  }


}
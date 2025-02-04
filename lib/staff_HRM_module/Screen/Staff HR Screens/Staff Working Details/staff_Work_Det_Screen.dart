import 'package:flutter/material.dart';
import 'package:hr_app/staff_HRM_module/Screen/Color/app_Color.dart';

class staffWorkDetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Working Details', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18, fontFamily: "poppins_thin"),),
        backgroundColor: appColor.primaryColor,
        centerTitle: true,
        foregroundColor: Colors.white,
        leading: IconButton(

          onPressed: (){
            Navigator.pop(context);
          },

          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20,),

        ),
      ),

      backgroundColor: Colors.white,

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          SizedBox(height: 10,),

          Center(

            child: Image.asset("asset/HR Screen Images/Working/Working-amico.png", height: 170,),

          ),

          Expanded(

            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              
                  SizedBox(height: 10),
              
                  _buildProfileDetail(context,'Role', 'Software Engineer', Icons.work),
                  _buildProfileDetail(context,'Department', 'Development', Icons.business),
                  _buildProfileDetail(context,'Reporting to', 'Jane Smith', Icons.supervisor_account),
                  _buildProfileDetail(context,'Work Shift', '09:00 AM - 06:30 PM', Icons.access_time),
                  _buildProfileDetail(context,'Location', 'Main Office, Dabholi Char Rasta, Katargam, Surat', Icons.location_on),
                  _buildProfileDetail(context,'Session', 'Full Time', Icons.schedule),
                  _buildProfileDetail(context,'Join Date', '2020-05-14', Icons.calendar_today),
                  _buildProfileDetail(context,'Week Off', 'Saturday, Sunday', Icons.weekend),
                  _buildProfileDetail(context,'Active Time', '09:00 AM to 06:30 PM', Icons.timer),
                  SizedBox(height: 20,),

                ],
              
              ),
            ),

          ),

        ],
      ),
    );
  }

  Widget _buildProfileDetail(BuildContext context, String title, String data, IconData icon) {
    return Container(

      height: 80,
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(

        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(1, 3))],

      ),

      child: Row(

        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [

          Icon(icon, color: Colors.deepPurple.shade300),

          SizedBox(width: 12,),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: VerticalDivider(color: Colors.grey.shade300, thickness: 1.2,),
          ),

          SizedBox(width: 15,),

          Column(

            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "poppins_thin", fontSize: 15, color: Colors.black)),
              Container(

                height: title == "Location" ? 37 : 18,
                width: MediaQuery.of(context).size.width.toDouble() * 0.65,
                // color: Colors.red.shade100,
                child: Text(data, style: TextStyle(fontWeight: FontWeight.w100, fontFamily: "poppins_thin", fontSize: 13, color: Colors.grey.shade600,), maxLines: title == "Location" ? 2 : 1, overflow: TextOverflow.ellipsis,),

              ),

            ],

          ),

        ],

      ),

    );
  }
}
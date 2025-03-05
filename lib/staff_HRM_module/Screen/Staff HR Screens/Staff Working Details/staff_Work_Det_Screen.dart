import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import '../../../../Provider/UserProvider.dart';
import '../../../../../Provider/UserProvider.dart';
// import '../../../Model/Realtomodels/Realtostaffprofilemodel.dart';
// import '../../../../Model/Realtomodels/Realtostaffprofilemodel.dart';
import '../../../Model/Realtomodels/Realtostaffprofilemodel.dart';
import '../../Color/app_Color.dart';

class staffWorkDetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final userProvider = Provider.of<UserProvider>(context);

    // Show loading indicator while data is being fetched
    // if (userProvider.profileData == null) {
    //   return const Center(child: CircularProgressIndicator(color: Colors.white,));
    // }

    Realtostaffprofilemodel? profile = userProvider.profileData;

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

                  _buildProfileDetail(context, 'Role', profile?.staffProfile?.userRole ?? "N/A", Icons.work),
                  _buildProfileDetail(context, 'Department', profile?.staffProfile?.department ?? "N/A", Icons.business),
                  _buildProfileDetail(context, 'Reporting to', profile?.staffProfile?.headName ?? "N/A", Icons.supervisor_account),
                  _buildProfileDetail(context, 'Work Shift', profile?.staffProfile?.workShift ?? "N/A", Icons.access_time),
                  _buildProfileDetail(context, 'Job Location', profile?.staffProfile?.jobLocation ?? "N/A", Icons.location_on),
                  _buildProfileDetail(context, 'Session', profile?.staffProfile?.sessionActive ?? "N/A", Icons.schedule),
                  _buildProfileDetail(context, 'Joining Date', profile?.staffProfile?.joinDate ?? "N/A", Icons.calendar_today),
                  _buildProfileDetail(context, 'Week Off Day', profile?.staffProfile?.weekofday ?? "N/A", Icons.weekend),
                  _buildProfileDetail(context, 'Active From Time', profile?.staffProfile?.activeFromTime ?? "N/A", Icons.timer),
                  _buildProfileDetail(context, 'Active To Time', profile?.staffProfile?.activeToTime ?? "N/A", Icons.timer),

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
                width: MediaQuery.of(context).size.width.toDouble() / 1.6,
                // color: Colors.red.shade100,
                child: Text(data == "" ? "-" : data, style: TextStyle(fontWeight: FontWeight.w100, fontFamily: "poppins_thin", fontSize: 13, color: Colors.grey.shade600,), maxLines: title == "Location" ? 2 : 1, overflow: TextOverflow.ellipsis,),

              ),

            ],

          ),

        ],

      ),

    );
  }
}
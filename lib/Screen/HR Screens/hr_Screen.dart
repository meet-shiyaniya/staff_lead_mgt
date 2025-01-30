import 'package:flutter/material.dart';
import 'package:hr_app/Model/HR%20Screen%20Models/hr_Option_Model.dart';
import 'package:hr_app/Screen/Color/app_Color.dart';
import 'package:hr_app/Screen/HR%20Screens/HR%20Master/hr_Master_Screen.dart';
import 'package:hr_app/Screen/HR%20Screens/Leave/leave_Home_Screen.dart';
import 'package:hr_app/Screen/HR%20Screens/Staff/staff_Home_Screen.dart';

class hrScreen extends StatefulWidget {
  const hrScreen({super.key});

  @override
  State<hrScreen> createState() => _hrScreenState();
}

class _hrScreenState extends State<hrScreen> {

  List<hrOptionModel> hrOptionList = [

    hrOptionModel("HR Master", "hr.png"),
    hrOptionModel("HR Settings", "settings.png"),
    hrOptionModel("Staff", "staff.png"),
    hrOptionModel("Payroll", "payroll.png"),
    hrOptionModel("Leave", "leave.png"),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: appColor.backgroundColor,

      appBar: AppBar(

        backgroundColor: appColor.primaryColor,

        title: Text("HR Management", style: TextStyle(color: appColor.appbarTxtColor, fontSize: 17, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),),

        centerTitle: true,

        foregroundColor: appColor.appbarTxtColor,

        leading: Builder(

          builder: (context) => IconButton(

            icon: Icon(Icons.menu_rounded, size: 20,),

            onPressed: () {

              Scaffold.of(context).openDrawer(); // Correct context access

            },

          ),

        ),

      ),

      drawer: CustomDrawer(),

      body: Padding(

        padding: const EdgeInsets.symmetric(horizontal: 18.0),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            SizedBox(height: 35,),

            Text("Human Resource", style: TextStyle(color: appColor.bodymainTxtColor, fontWeight: FontWeight.bold, fontSize: 22, fontFamily: "poppins_thin"),),

            SizedBox(height: 25,),

            Expanded(

              child: GridView.builder(

                itemCount: hrOptionList.length,

                physics: NeverScrollableScrollPhysics(),

                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(

                  crossAxisCount: 2,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 20,
                  mainAxisExtent: 160,

                ),

                itemBuilder: (context, index) {
                  
                  final option = hrOptionList[index];

                  return GestureDetector(

                    onTap: () {

                      Navigator.push(context, MaterialPageRoute(builder: (context) => index == 0 ? hrMasterScreen() : index == 2 ? staffHomeScreen() : leaveHomeScreen()));

                    },

                    child: Container(

                      decoration: BoxDecoration(

                        color: appColor.subPrimaryColor,

                        boxShadow: [

                          BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 3, blurRadius: 8, offset: Offset(3, 3),),

                        ],

                        borderRadius: BorderRadius.circular(10),

                        border: Border.all(color: appColor.primaryColor),

                      ),

                      child: Column(
                        children: [

                          SizedBox(height: 24,),

                          Container(

                            height: 80,

                            child: Image.asset("asset/HR Screen Images/${option.img}", fit: BoxFit.cover,),

                          ),

                          Spacer(),

                          Text(option.title, style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: "thin"),),

                          SizedBox(height: 16,),

                        ],
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

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Drawer(

      backgroundColor: Colors.white,

      child: Column(

        children: [

          Container(

            height: 210,

            width: MediaQuery.of(context).size.width.toDouble(),

            decoration: BoxDecoration(

              // gradient: LinearGradient(
              //
              //   colors: [Colors.deepPurple.shade400, Colors.deepPurple.shade600, Colors.deepPurple.shade800],
              //
              //   begin: Alignment.topLeft,
              //
              //   end: Alignment.bottomRight,
              //
              // ),

              color: appColor.primaryColor

            ),

            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,

              children: [

                SizedBox(height: 20,),

                CircleAvatar(

                  radius: 45,

                  backgroundImage: NetworkImage('https://scontent.famd1-2.fna.fbcdn.net/v/t39.30808-6/475131181_635656495479414_715511376224210954_n.jpg?_nc_cat=105&ccb=1-7&_nc_sid=6ee11a&_nc_ohc=5Op-SRW735IQ7kNvgFhoOpr&_nc_zt=23&_nc_ht=scontent.famd1-2.fna&_nc_gid=AAUfIvEs58rsimJ8gJAEzyo&oh=00_AYDQPcbNXtWcZ2cBI22nuuERNlAQy9m6xquUptEQPyheTQ&oe=679CF0EC',),

                ),

                SizedBox(height: 8),

                Text('Meet Patel', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, fontFamily: "poppins_thin", color: Colors.white,),),

                Text('Flutter Developer', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, fontFamily: "poppins_light", color: Colors.grey.shade200,),),

              ],

            ),
          ),

          SizedBox(height: 20),

          DrawerItem(icon: Icons.person, text: 'My Profile',),

          DrawerItem(icon: Icons.work_rounded, text: 'Employee Working Details'),

          DrawerItem(icon: Icons.phone, text: 'Contacts'),

          DrawerItem(icon: Icons.security_rounded, text: 'Password'),

          DrawerItem(icon: Icons.monetization_on_rounded, text: 'Financial Details'),

          DrawerItem(icon: Icons.call, text: 'Emergency Contact'),

          DrawerItem(icon: Icons.power_settings_new_rounded, text: 'Logout'),

        ],

      ),

    );

  }
}

class DrawerItem extends StatelessWidget {

  final IconData icon;

  final String text;

  final String? badge;

  final bool highlighted;

  DrawerItem({

    required this.icon,

    required this.text,

    this.badge,

    this.highlighted = false,

  });

  @override
  Widget build(BuildContext context) {

    return Container(

      color: highlighted ? Colors.purple.withOpacity(0.1) : Colors.transparent,

      child: ListTile(

        leading: Icon(icon, color: Colors.black, size: 23,),

        title: Text(text, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),),

        trailing: badge != null ? CircleAvatar(

          backgroundColor: Colors.purple,

          radius: 10,

          child: Text(badge!, style: TextStyle(color: Colors.white, fontSize: 12)),

        ) : null,

        onTap: () {},

      ),

    );

  }

}
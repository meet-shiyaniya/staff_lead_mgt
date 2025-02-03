import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../Model/Staff HR Screen Model/profile_Model.dart';
import '../../Color/app_Color.dart';

class staffProfileScreen extends StatefulWidget {
  const staffProfileScreen({super.key});

  @override
  State<staffProfileScreen> createState() => _staffProfileScreenState();
}

class _staffProfileScreenState extends State<staffProfileScreen> {

  List<profileModel> profileDataList = [

    profileModel(FontAwesomeIcons.solidIdCard, "Employee ID", "122"),
    profileModel(FontAwesomeIcons.user, "User Name", "admin_Meet"),
    profileModel(FontAwesomeIcons.birthdayCake, "Date Of Birth", "16/08/2004"),
    profileModel(FontAwesomeIcons.person, "Gender", "Male"),
    profileModel(FontAwesomeIcons.solidHeart, "Marital Status", "Unmarried"),
    profileModel(FontAwesomeIcons.house, "Address", "102, Vrundavan Society, Dabholi Char Rasta, Katargam, Surat - 395004"),
    profileModel(FontAwesomeIcons.city, "City", "Surat"),
    profileModel(FontAwesomeIcons.mapPin, "Pin Code", "395004"),
    profileModel(FontAwesomeIcons.tint, "Blood Group", "A+"),

  ];

  List<profileModel> contactDataList = [

    profileModel(FontAwesomeIcons.phone, "Phone Number", "9828756476"),
    profileModel(FontAwesomeIcons.simCard, "Sim allocation number", "+91"),
    profileModel(FontAwesomeIcons.phone, "Alt Number", "9268969245"),
    profileModel(FontAwesomeIcons.solidEnvelope, "Email", "meetpatel579@gmail.com"),
    profileModel(FontAwesomeIcons.solidEnvelope, "Work Email", "admin179@gmail.com"),
    profileModel(FontAwesomeIcons.skype, "Skype", "live:.cid.mk0l8spdb2e7jh7y"),

  ];

  bool isSelected = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        backgroundColor: appColor.primaryColor,

        foregroundColor: Colors.transparent,

        leading: IconButton(

          onPressed: (){
            Navigator.pop(context);
          },

          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20,),

        ),

      ),

      backgroundColor: Colors.grey.shade100,

      body: Container(

        height: MediaQuery.of(context).size.height.toDouble() - 84,
        width: MediaQuery.of(context).size.width.toDouble(),

        child: Stack(

          children: [

            Container(

              height: 130,
              width: MediaQuery.of(context).size.width.toDouble(),

              decoration: BoxDecoration(

                borderRadius: BorderRadius.only(

                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),

                ),

                color: appColor.primaryColor,

              ),

            ),

            Positioned(

              top: 50,
              left: 16,
              right: 16,

              child: Container(

                height: 620,
                width: MediaQuery.of(context).size.width.toDouble(),

                decoration: BoxDecoration(

                  borderRadius: BorderRadius.circular(15),

                  boxShadow: [BoxShadow(color: Colors.deepPurple.shade50, blurRadius: 15)],

                  color: Colors.white,

                ),

                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    SizedBox(height: 55,),

                    Center(child: Text("Meet Patel", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),)),
                    Center(child: Text("meetpatel579@gmail.com", style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: "poppins_light"),)),

                    SizedBox(height: 8,),

                    Divider(color: Colors.grey.shade300, thickness: 1,),

                    SizedBox(height: 8,),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(

                        mainAxisAlignment: MainAxisAlignment.spaceAround,

                        children: [

                          GestureDetector(

                            onTap: () {

                              setState(() {

                                isSelected = false;

                              });

                            },

                            child: Container(

                              height: 35,
                              width: 148,
                              decoration: BoxDecoration(

                                borderRadius: BorderRadius.circular(6),
                                color: isSelected ? Colors.white : appColor.boxColor,
                                border: Border.all(color: isSelected ? Colors.deepPurple.shade800 : appColor.boxColor, width: 1),

                              ),

                              child: Row(

                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,

                                children: [

                                  Icon(Icons.person, color: isSelected ? Colors.black : Colors.deepPurple.shade800, size: 20,),

                                  SizedBox(width: 6,),

                                  Text("Profile Info", style: TextStyle(color: isSelected ? Colors.black : Colors.deepPurple.shade800, fontWeight: FontWeight.bold, fontSize: 14),),

                                ],

                              ),

                            ),
                          ),

                          GestureDetector(

                            onTap: () {

                              setState(() {

                                isSelected = true;

                              });

                            },

                            child: Container(

                              height: 35,
                              width: 148,
                              decoration: BoxDecoration(

                                borderRadius: BorderRadius.circular(6),
                                color: isSelected ? appColor.boxColor : Colors.white,
                                border: Border.all(color: isSelected ? appColor.boxColor : Colors.deepPurple.shade800, width: 1),

                              ),

                              child: Row(

                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,

                                children: [

                                  Icon(Icons.phone, color: isSelected ? Colors.deepPurple.shade800 : Colors.black, size: 20,),

                                  SizedBox(width: 6,),

                                  Text("Contact Info", style: TextStyle(color: isSelected ? Colors.deepPurple.shade800 : Colors.black, fontWeight: FontWeight.bold, fontSize: 14),),

                                ],

                              ),

                            ),
                          ),

                        ],

                      ),
                    ),

                    SizedBox(height: 20,),

                    Expanded(

                      child: ListView.builder(

                        itemCount: isSelected ? contactDataList.length : profileDataList.length,

                        itemBuilder: (context, index) {

                          final profile = isSelected ? contactDataList[index] : profileDataList[index];

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5),
                            child: Container(

                              height: 60,
                              width: MediaQuery.of(context).size.width.toDouble(),

                              decoration: BoxDecoration(

                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade50,
                                // boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],

                              ),

                              child: Row(

                                children: [

                                  Container(

                                    height: 50,
                                    width: 50,

                                    child: Center(

                                      child: FaIcon(profile.icon, size: 17, color: Colors.deepPurple.shade300,),

                                    ),

                                  ),

                                  Container(

                                    height: 40,
                                    width: 1,
                                    color: Colors.grey.shade300,

                                  ),

                                  SizedBox(width: 15,),

                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Text(profile.title, style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.bold),),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 10, left: 0),
                                        child: Container(

                                          height: profile.title == "Address" ? 36 : 18,
                                          width: MediaQuery.of(context).size.width.toDouble() - 132,
                                          // color: Colors.green,

                                          child: Text(profile.value, style: TextStyle(fontFamily: "poppins_thin",color: Colors.grey.shade800, fontSize: 13, fontWeight: FontWeight.bold,), maxLines: profile.title == "Address" ? 2 : 1, overflow: TextOverflow.ellipsis,),

                                        ),
                                      ),

                                    ],

                                  ),

                                ],

                              ),

                            ),
                          );

                        },

                      ),

                    ),

                    SizedBox(height: 8,),

                  ],

                ),

              ),

            ),

            Positioned(

              left: 0,
              right: 0,

              child: Container(

                height: 100,
                width: 100,

                decoration: BoxDecoration(

                  shape: BoxShape.circle,

                  // color: Colors.red,

                  border: Border.all(color: Colors.deepPurple.shade900, width: 2),

                  image: DecorationImage(image: NetworkImage("https://funylife.in/wp-content/uploads/2022/11/20221118_172834.jpg")),

                ),

              ),
            ),

          ],

        ),

      ),

    );
  }
}
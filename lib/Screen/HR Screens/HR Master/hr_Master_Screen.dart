import 'package:flutter/material.dart';
import 'package:hr_app/Model/HR%20Screen%20Models/HR%20Master%20Models/hr_Mast_Menu_Model.dart';
import 'package:hr_app/Screen/Color/app_Color.dart';
import 'package:hr_app/Screen/HR%20Screens/HR%20Master/HR%20Master%20Menu%20Screens/Leave%20Screens/leave_Screen.dart';
import 'package:hr_app/Screen/HR%20Screens/HR%20Master/HR%20Master%20Menu%20Screens/Holiday%20Screens/holiday_Screen.dart';
import 'package:hr_app/Screen/HR%20Screens/HR%20Master/HR%20Master%20Menu%20Screens/Shift%20Management/shift_Management_Screen.dart';
import 'package:hr_app/Screen/HR%20Screens/HR%20Master/HR%20Master%20Menu%20Screens/Worktime%20Management/work_Management_Screen.dart';

class hrMasterScreen extends StatefulWidget {
  const hrMasterScreen({super.key});

  @override
  State<hrMasterScreen> createState() => _hrMasterScreenState();
}

class _hrMasterScreenState extends State<hrMasterScreen> {

  List<hrMastMenuModel> hrMastMenuList = [

    hrMastMenuModel("Shift Management", Icon(Icons.cases_sharp, size: 20,)),
    hrMastMenuModel("Leave Management", Icon(Icons.home_work, size: 20,)),
    hrMastMenuModel("Holiday Management", Icon(Icons.wallet_giftcard_rounded, size: 20,)),
    hrMastMenuModel("Worktime Management", Icon(Icons.calendar_month_rounded, size: 20,)),

  ];

  int selectedMenuIndex = 0;

  // Dynamically Load Widgets Based on Index

  Widget _buildCustomWidget(int index) {

    switch (index) {

      case 0:

        return shiftManagementScreen();

      case 1:

        return leaveScreen();

      case 2:

        return holidayScreen();

      case 3:

        return workManagementScreen();

      default:

        return Center(child: Text("Unknown Screen"));

    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: appColor.backgroundColor,

      appBar: AppBar(

        backgroundColor: appColor.primaryColor,

        title: Text("HR Master", style: TextStyle(color: appColor.appbarTxtColor, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),),

        centerTitle: true,

        foregroundColor: Colors.transparent,

        leading: IconButton(

          onPressed: (){
            Navigator.pop(context);
          },

          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20,),

        ),

      ),

      body: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          // SizedBox(height: 30,),

          Container(

            height: 84,
            width: MediaQuery.of(context).size.width.toDouble(),
            color: Colors.grey.shade100,

            child: Padding(

              padding: const EdgeInsets.symmetric(horizontal: 16.0),

              child: ListView.builder(

                scrollDirection: Axis.horizontal,

                itemCount: hrMastMenuList.length,

                itemBuilder: (context, index) {

                  final hrMenu = hrMastMenuList[index];

                  bool isMenuSelected = selectedMenuIndex == index;

                  return Padding(

                    padding: const EdgeInsets.only(right: 10.0),

                    child: GestureDetector(

                      onTap: () {

                        setState(() {

                          selectedMenuIndex = index;

                        });

                      },

                      child: Center(

                        child: Container(

                          height: 44,
                          width: 200,

                          decoration: BoxDecoration(

                            borderRadius: BorderRadius.circular(50),

                            color: isMenuSelected ? appColor.primaryColor : Colors.white,

                            border: Border.all(color: isMenuSelected ? Colors.transparent : appColor.primaryColor, width: 1.5),

                          ),

                          child: Row(
                            children: [

                              SizedBox(width: 2,),

                              Container(

                                height: 40,
                                width: 40,

                                decoration: BoxDecoration(

                                  shape: BoxShape.circle,

                                  color: isMenuSelected ? Colors.white : Colors.deepPurple.shade100,

                                ),

                                child: Center(

                                  child: hrMenu.icon,

                                ),

                              ),

                              SizedBox(width: 5,),

                              Text(hrMenu.title,  style: TextStyle(color: isMenuSelected ? Colors.white : Colors.black, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 11),),

                            ],
                          ),

                        ),
                      ),
                    ),
                  );

                },

              ),
            ),

          ),

          Expanded(

            child: _buildCustomWidget(selectedMenuIndex),

          ),

          SizedBox(height: 5,),

        ],
      ),

    );
  }
}
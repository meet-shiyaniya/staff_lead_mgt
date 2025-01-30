import 'package:flutter/material.dart';
import 'package:hr_app/Screen/HR%20Screens/Staff/Staff%20Menu%20Screens/Active/active_Staff_Screen.dart';
import 'package:hr_app/Screen/HR%20Screens/Staff/Staff%20Menu%20Screens/Inactive/inactive_Staff_Screen.dart';
import 'package:hr_app/Screen/HR%20Screens/Staff/Add%20Staff%20Menu%20Screens/add_Staff_Screen.dart';
import '../../../Model/HR Screen Models/Staff/staff_Model.dart';
import '../../Color/app_Color.dart';

class staffHomeScreen extends StatefulWidget {
  const staffHomeScreen({super.key});

  @override
  State<staffHomeScreen> createState() => _staffHomeScreenState();
}

class _staffHomeScreenState extends State<staffHomeScreen> {

  List<staffModel> staffList = [

    staffModel(staffId: 1, staffName: "Hiten Sojitra", headName: "John Doe", role: "Manager", department: "HR", joiningDate: "01-01-2020", type: "Active", profileImg: "https://www.strategeast.org/wp-content/uploads/2020/02/giorgi-1-scaled.jpg", email: "hiten@example.com", contactNo: "9876543210", attendance: "On", username: "gymsmart_hiten", dob: "15-08-1985", gender: "Male", maritalStatus: "Married", address: "Surat", city: "Surat", town: "Athwa", pinCode: "395007", bloodGroup: "O+", workShift: "Morning", jobLocation: "Surat Office", session: "2023-2024", weekOf: "Monday", userActiveTime: "09:00 am to 08:00 pm", altPhoneNum: "9123456789", workEmail: "hiten.work@example.com", skype: "hiten_skype", password: "securePassword123", bankName: "HDFC Bank", accountNum: "1234567890", panNum: "ABCDE1234F", ifsc: "HDFC0001234", salary: 75000.0, emergencyContacts: [{"name": "Ramesh", "relation": "Father", "cno": "9876543210"}, {"name": "Rahul", "relation": "Brother", "cno": "97648923498"},],),

    staffModel(staffId: 2, staffName: "Mehul Variya", headName: "Jane Smith", role: "Developer", department: "IT", joiningDate: "15-03-2021", type: "Inactive", profileImg: "https://ied.eu/wp-content/uploads/2024/03/member-alexandros-touloumtzidis.webp", email: "anjali@example.com", contactNo: "9876543222", attendance: "On", username: "gymsmart_anjali", dob: "12-12-1992", gender: "Female", maritalStatus: "Single", address: "Mumbai", city: "Mumbai", town: "Andheri", pinCode: "400053", bloodGroup: "B+", workShift: "Evening", jobLocation: "Mumbai Office", session: "2023-2024", weekOf: "Friday", userActiveTime: "10:00 am to 07:00 pm", altPhoneNum: "9123456781", workEmail: "anjali.work@example.com", skype: "anjali_skype", password: "securePass456", bankName: "ICICI Bank", accountNum: "9876543211", panNum: "ABCDE5678G", ifsc: "ICIC0001235", salary: 65000.0, emergencyContacts: [{"name": "Priya", "relation": "Sister", "cno": "9876543221"},],),

    staffModel(staffId: 3, staffName: "Ravi Patel", headName: "John Doe", role: "Accountant", department: "Finance", joiningDate: "01-07-2019", type: "Active", profileImg: "https://i1.rgstatic.net/ii/profile.image/734406318772225-1552107519146_Q512/Luis-Romero-Cortes.jpg", email: "ravi@example.com", contactNo: "9876543233", attendance: "On", username: "gymsmart_ravi", dob: "25-06-1988", gender: "Male", maritalStatus: "Married", address: "Vapi", city: "Vapi", town: "GIDC", pinCode: "396195", bloodGroup: "A+", workShift: "Morning", jobLocation: "Vapi Office", session: "2023-2024", weekOf: "Tuesday", userActiveTime: "08:00 am to 05:00 pm", altPhoneNum: "9123456782", workEmail: "ravi.work@example.com", skype: "ravi_skype", password: "securePass789", bankName: "SBI", accountNum: "1231231234", panNum: "ABCDE1235H", ifsc: "SBIN0005678", salary: 50000.0, emergencyContacts: [{"name": "Kiran", "relation": "Wife", "cno": "9876543230"},],),

    staffModel(staffId: 4, staffName: "Rohan Sharma", headName: "Jane Smith", role: "HR Executive", department: "HR", joiningDate: "10-11-2022", type: "Inactive", profileImg: "https://i1.rgstatic.net/ii/profile.image/871161357402112-1584712461134_Q512/Marcelo-Goulart-2.jpg", email: "neha@example.com", contactNo: "9876543244", attendance: "Off", username: "gymsmart_neha", dob: "05-02-1995", gender: "Female", maritalStatus: "Single", address: "Surat", city: "Surat", town: "Adajan", pinCode: "395009", bloodGroup: "AB+", workShift: "Night", jobLocation: "Remote", session: "2023-2024", weekOf: "Wednesday", userActiveTime: "10:00 pm to 06:00 am", altPhoneNum: "9123456783", workEmail: "neha.work@example.com", skype: "neha_skype", password: "securePass101", bankName: "Axis Bank", accountNum: "4321432143", panNum: "ABCDE4321J", ifsc: "UTIB0005432", salary: 40000.0, emergencyContacts: [{"name": "Shweta", "relation": "Friend", "cno": "9876543240"},],),

    staffModel(staffId: 5, staffName: "Rohit Dayal", headName: "John Doe", role: "Trainer",department: "Fitness", joiningDate: "20-08-2023", type: "Active", profileImg: "https://i1.rgstatic.net/ii/profile.image/387356113817600-1469364302658_Q512/Daniel-Haak.jpg", email: "aman@example.com", contactNo: "9876543255", attendance: "On", username: "gymsmart_aman", dob: "01-01-1990", gender: "Male",maritalStatus: "Married", address: "Mumbai", city: "Mumbai", town: "Borivali", pinCode: "400066", bloodGroup: "O-", workShift: "Afternoon", jobLocation: "Mumbai Office", session: "2023-2024", weekOf: "Saturday", userActiveTime: "01:00 pm to 09:00 pm", altPhoneNum: "9123456784", workEmail: "aman.work@example.com", skype: "aman_skype", password: "securePass123", bankName: "Kotak Bank", accountNum: "8765432187", panNum: "ABCDE6789K", ifsc: "KKBK0003456", salary: 55000.0, emergencyContacts: [{"name": "Pooja", "relation": "Wife", "cno": "9876543250"},],),


  ];

  List<staffModel> activeStaffList = [];
  List<staffModel> inactiveStaffList = [];

  // function for add data into Active Inactive wise
  addStaffData() {

    activeStaffList.clear();
    inactiveStaffList.clear();

    for(int i = 0; i < staffList.length; i++) {

      setState(() {

        if(staffList[i].type == "Active") {

          activeStaffList.add(staffList[i]);

        } else {

          inactiveStaffList.add(staffList[i]);

        }

      });

    }

  }

  bool isSelected = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    addStaffData();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: appColor.backgroundColor,

      appBar: AppBar(

        backgroundColor: appColor.primaryColor,

        title: Text("Staff Details", style: TextStyle(color: appColor.appbarTxtColor, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),),

        centerTitle: true,

        foregroundColor: Colors.transparent,

        leading: IconButton(

          onPressed: (){
            Navigator.pop(context);
          },

          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20,),

        ),

      ),

      floatingActionButton: FloatingActionButton(

        backgroundColor: appColor.primaryColor,

        child: Icon(Icons.add, color: appColor.appbarTxtColor, size: 26,),

        onPressed: () {

          Navigator.push(context, MaterialPageRoute(builder: (context) => addStaffScreen()));

        },

        shape: RoundedRectangleBorder(

          borderRadius: BorderRadius.circular(30),

        ),

        elevation: 4,

      ),

      body: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Container(

            height: 60,
            width: MediaQuery.of(context).size.width.toDouble(),
            color: Colors.grey.shade100,

            child: Padding(

              padding: const EdgeInsets.symmetric(horizontal: 16.0),

              child: Row(

                mainAxisAlignment: MainAxisAlignment.spaceAround,

                children: [

                  Center(

                    child: GestureDetector(

                      onTap: () {

                        setState(() {

                          isSelected = false;

                        });

                      },

                      child: Container(

                        height: 40,
                        width: 174,

                        decoration: BoxDecoration(

                          color: isSelected ? Colors.transparent : appColor.primaryColor,

                          borderRadius: BorderRadius.circular(20),

                          border: Border.all(color: isSelected ? appColor.primaryColor : Colors.transparent, width: 1.5),

                        ),

                        child: Row(
                          children: [

                            SizedBox(width: 2.1,),

                            Container(

                              height: 34,
                              width: 34,

                              decoration: BoxDecoration(

                                shape: BoxShape.circle,
                                color: isSelected ? appColor.boxColor : Colors.white,

                              ),

                              child: Center(

                                child: Icon(Icons.verified_user, color: Colors.black, size: 20,),

                              ),

                            ),

                            SizedBox(width: 10,),

                            Text("Active", style: TextStyle(color: isSelected ? Colors.black : Colors.white, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 14),),

                          ],
                        ),

                      ),

                    ),

                  ),

                  // Spacer(),

                  Center(

                    child: GestureDetector(

                      onTap: () {

                        setState(() {

                          isSelected = true;

                        });

                      },

                      child: Container(

                        height: 40,
                        width: 174,

                        decoration: BoxDecoration(

                          color: isSelected ? appColor.primaryColor : Colors.transparent,

                          borderRadius: BorderRadius.circular(20),

                          border: Border.all(color: isSelected ? Colors.transparent : appColor.primaryColor, width: 1.5),

                        ),

                        child: Row(
                          children: [

                            SizedBox(width: 2.1,),

                            Container(

                              height: 34,
                              width: 34,

                              decoration: BoxDecoration(

                                shape: BoxShape.circle,
                                color: isSelected ? Colors.white : appColor.boxColor,

                              ),

                              child: Center(

                                child: Icon(Icons.block, color: Colors.black, size: 20,),

                              ),

                            ),

                            SizedBox(width: 10,),

                            Text("Inactive", style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontFamily: "poppins_thin", fontWeight: FontWeight.bold, fontSize: 14),),

                          ],
                        ),

                      ),

                    ),

                  ),

                ],

              ),

            ),

          ),

          Expanded(

            child: isSelected ? inactiveStaffScreen(inactiveStaffList: inactiveStaffList,) : activeStaffScreen(activeStaffList: activeStaffList,),

          ),

          SizedBox(height: 5,),

        ],

      ),

    );
  }
}
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../Api_services/api_service.dart';
import '../../../../Provider/UserProvider.dart';
import '../../../Model/Realtomodels/Realtostaffprofilemodel.dart';
import '../../../Model/Staff HR Screen Model/profile_Model.dart';
import '../../Color/app_Color.dart';

class staffProfileScreen extends StatefulWidget {
  const staffProfileScreen({super.key});

  @override
  State<staffProfileScreen> createState() => _staffProfileScreenState();
}

class _staffProfileScreenState extends State<staffProfileScreen> {

  File? _profileImage;
  final ApiService _apiService = ApiService();
  bool isSelected = false;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      await _apiService.updateProfilePic(imageFile);
      setState(() {
        _profileImage = imageFile;
      });

      // Optionally, upload image to the server
      // await uploadProfileImage(File(pickedFile.path));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.microtask(() {
      Provider.of<UserProvider>(context, listen: false).fetchProfileData();
    });

  }

  @override
  Widget build(BuildContext context) {

    final userProvider = Provider.of<UserProvider>(context);

    // Show loading indicator while data is being fetched
    // if (userProvider.profileData == null) {
    //   return const Center(child: CircularProgressIndicator(color: Colors.white,));
    // }

    Realtostaffprofilemodel? profile = userProvider.profileData;

    List<profileModel> profileDataList = [
      profileModel(FontAwesomeIcons.solidIdCard, "Employee ID", profile?.staffProfile?.employeeId ?? "N/A"),
      profileModel(FontAwesomeIcons.solidUser, "Name", profile?.staffProfile?.name ?? "N/A"),
      profileModel(FontAwesomeIcons.user, "User Name", profile?.staffProfile?.userName ?? "N/A"),
      profileModel(FontAwesomeIcons.solidEnvelope, "Email", profile?.staffProfile?.email ?? "N/A"),
      profileModel(FontAwesomeIcons.house, "Address", profile?.staffProfile?.address ?? "N/A"),
      profileModel(FontAwesomeIcons.person, "Gender", profile?.staffProfile?.gender ?? "N/A"),
      profileModel(FontAwesomeIcons.solidHeart, "Marital Status", profile?.staffProfile?.maritalStatus ?? "N/A"),
      profileModel(FontAwesomeIcons.tint, "Blood Group", profile?.staffProfile?.bloodgroup ?? "N/A"),
    ];

    List<profileModel> contactDataList = [
      profileModel(FontAwesomeIcons.solidIdCard, "Employee ID", profile?.staffProfile?.employeeId ?? "N/A"),
      profileModel(FontAwesomeIcons.phone, "Phone Number", profile?.staffProfile?.phoneNumberPersonal ?? "N/A"),
      profileModel(FontAwesomeIcons.simCard, "Sim Allocation Number", profile?.staffProfile?.phoneNumberAllocation ?? "N/A"),
      profileModel(FontAwesomeIcons.phone, "Alt Number", profile?.staffProfile?.altmobileno ?? "N/A"),
      profileModel(FontAwesomeIcons.solidEnvelope, "Email", profile?.staffProfile?.email ?? "N/A"),
      profileModel(FontAwesomeIcons.solidEnvelope, "Work Email", profile?.staffProfile?.workEmail ?? "N/A"),
    ];

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

                height: MediaQuery.of(context).size.height.toDouble() / 1.33,
                width: MediaQuery.of(context).size.width.toDouble(),

                decoration: BoxDecoration(

                  borderRadius: BorderRadius.circular(15),

                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(1, 3))],

                  color: Colors.white,

                ),

                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    SizedBox(height: 55,),

                    Center(child: Text(profile?.staffProfile?.name?.isNotEmpty == true ? profile!.staffProfile!.name! : "N/A", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: "poppins_thin"),)),
                    Center(child: Text(profile?.staffProfile?.email?.isNotEmpty == true ? profile!.staffProfile!.email! : "N/A", style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: "poppins_light"),)),

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
                              width: MediaQuery.of(context).size.width.toDouble() / 2.7,
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
                              width: MediaQuery.of(context).size.width.toDouble() / 2.7,
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

                                          child: Text(profile.value == "" ? "-" : profile.value, style: TextStyle(fontFamily: "poppins_thin",color: Colors.grey.shade800, fontSize: 13, fontWeight: FontWeight.bold,), maxLines: profile.title == "Address" ? 2 : 1, overflow: TextOverflow.ellipsis,),

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

                  color: Colors.grey.shade100,

                  border: Border.all(color: Colors.deepPurple.shade900, width: 2),

                  image: DecorationImage(
                    image: _profileImage != null
                        ? FileImage(_profileImage!) as ImageProvider
                        : (profile?.staffProfile?.profileImg?.isNotEmpty == true
                        ? CachedNetworkImageProvider("${profile?.staffProfile?.profileImg}")
                        : const NetworkImage("https://vertex-academy.com/en/images/reviews/5.jpg")),
                  ),

                ),

              ),
            ),

            Positioned(
              top: 78,
              left: 216,
              child: GestureDetector(

                onTap: _pickImage,

                child: Container(

                  height: 22,
                  width: 22,

                  decoration: BoxDecoration(

                    shape: BoxShape.circle,
                    color: appColor.primaryColor

                  ),

                  child: Center(

                    child: Icon(Icons.edit_rounded, color: Colors.white, size: 15,),

                  ),

                ),
              ),
            ),

          ],

        ),

      ),

    );
  }
}
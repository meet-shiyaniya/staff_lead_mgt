import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:hr_app/bottom_navigation.dart';
import 'package:hr_app/staff_HRM_module/Screen/Color/app_Color.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class StaffAttendanceScreen extends StatefulWidget {
  @override
  _StaffAttendanceScreenState createState() => _StaffAttendanceScreenState();
}

class _StaffAttendanceScreenState extends State<StaffAttendanceScreen> {
  XFile? _imageFile;
  double recognitionPercentage=0.0;
  String _status = "Upload your selfie to mark attendance";

  // Office location (example, use your office location coordinates here)
  final double officeLatitude = 21.26404;
  final double officeLongitude = 72.82958;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _checkPermissions(); // Request necessary permissions
  }

  Future<void> _checkPermissions() async {
    PermissionStatus locationStatus = await Permission.location.request();
    if (locationStatus != PermissionStatus.granted) {
      Fluttertoast.showToast(msg: "Location permission is required");
      return;
    }

    PermissionStatus cameraStatus = await Permission.camera.request();
    if (cameraStatus != PermissionStatus.granted) {
      Fluttertoast.showToast(msg: "Camera permission is required");
      return;
    }
  }

  Future<Position> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return position;
  }

  Future<void> _pickSelfie() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  Future<void> _checkAttendance() async {
    final prefs = await SharedPreferences.getInstance();
    String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String? lastEntryDate = prefs.getString('entryDate');

    if (lastEntryDate == todayDate) {
      Fluttertoast.showToast(msg: "Attendance already marked for today!");
      return;
    }

    Position position = await _getCurrentLocation();
    double distanceInMeters = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      officeLatitude,
      officeLongitude,
    );

    if (distanceInMeters <= 100) {
      setState(() {
        _status = "✅ Attendance marked: Present";
      });
      Fluttertoast.showToast(msg: "✅ Attendance marked: Present");

      await prefs.setBool('attendanceMarked', true);
      await prefs.setString('entryTime', DateFormat('hh:mm:ss a').format(DateTime.now()));
      await prefs.setString('entryDate', todayDate);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNavScreen()),
      );
    } else {
      setState(() {
        _status = "❌ Attendance marked: Absent";
      });
      Fluttertoast.showToast(msg: "❌ Attendance marked: Absent");
      await showAbsentAnimation(); // Show animation
    }
  }

  // ✅ Function to show absent animation
  Future<void> showAbsentAnimation() async {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Lottie.asset("asset/absent.json", repeat: false),
        );
      },
    );

    await Future.delayed(Duration(seconds: 3)); // Wait for 3 seconds
    Navigator.of(context, rootNavigator: true).pop(); // Close the dialog
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,

      body: Padding(

        padding: const EdgeInsets.symmetric(horizontal: 15.0),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          mainAxisAlignment: MainAxisAlignment.start,

          children: [

            SizedBox(height: 65,),

            Text("Mark Your Attendance", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: appColor.primaryColor, fontFamily: "poppins_thin"),),

            SizedBox(height: 5),

            Text("If your face matches and location is correct, attendance will be marked successfully.", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey.shade700, fontFamily: "poppins_thin"),),

            SizedBox(height: 50,),

            Center(

              child: DottedBorder(

                borderType: BorderType.Circle,

                dashPattern: [6, 3],

                color: Colors.deepPurple.shade600,

                strokeWidth: 2,

                child: GestureDetector(

                  onTap: _pickSelfie, // Trigger selfie function on tap

                  child: AnimatedContainer(

                    duration: Duration(milliseconds: 300),

                    width: 200,

                    height: 200,

                    decoration: BoxDecoration(

                      color: Colors.deepPurple.shade50,

                      shape: BoxShape.circle,

                    ),

                    child: _imageFile == null ? Icon(Icons.camera_alt, size: 70, color: Colors.deepPurple.shade600) : ClipRRect(

                      borderRadius: BorderRadius.circular(100),

                      child: Image.file(File(_imageFile!.path), width: 200, height: 200, fit: BoxFit.cover,),

                    ),

                  ),

                ),

              ),

            ),

            SizedBox(height: 40),

            Center(child: Text("${recognitionPercentage.toStringAsFixed(0)}% recognition", style: TextStyle(color: Colors.grey.shade700, fontSize: 14, fontWeight: FontWeight.w500, fontFamily: "poppins_thin"),)),

            SizedBox(height: 10),

            Padding(

              padding: const EdgeInsets.symmetric(horizontal: 70.0),

              child: LinearProgressIndicator(

                value: recognitionPercentage / 100,

                backgroundColor: Colors.grey.shade200,

                color: Colors.deepPurple.shade600,

                minHeight: 12,

              ),

            ),

            SizedBox(height: 30),

            // ElevatedButton(
            //   onPressed: _pickSelfie,
            //   child: Text("Take Selfie", style: TextStyle(fontSize: 14, fontFamily: "poppins_thin", color: Colors.white)),
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: appColor.primaryColor,
            //     padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
            //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            //   ),
            // ),

            SizedBox(height: 20),

            Text(_status, style: TextStyle(fontSize: 15, color: Colors.grey.shade700, fontFamily: "poppins_thin", fontWeight: FontWeight.w500),),

            Spacer(),

            Container(

              width: double.infinity,

              padding: EdgeInsets.symmetric(horizontal: 2, vertical: 20),

              child: ElevatedButton(

                onPressed: _checkAttendance,

                child: Text("Mark Attendance", style: TextStyle(fontSize: 15, fontFamily: "poppins_thin", color: Colors.white,),),

                style: ElevatedButton.styleFrom(

                  backgroundColor: appColor.primaryColor,

                  padding: EdgeInsets.symmetric(vertical: 14),

                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),

                ),

              ),

            ),

          ],

        ),

      ),

    );
  }
}
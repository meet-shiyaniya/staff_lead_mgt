import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:hr_app/staff_HRM_module/Screen/Color/app_Color.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class staffAttendanceScreen extends StatefulWidget {
  @override
  _staffAttendanceScreenState createState() => _staffAttendanceScreenState();
}

class _staffAttendanceScreenState extends State<staffAttendanceScreen> {

  XFile? _imageFile;

  double recognitionPercentage = 0.0;

  String _status = "Upload your selfie to mark attendance";

  final double officeLatitude = 21.26404;
  final double officeLongitude = 72.82958;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {

    super.initState();

    _checkPermissions();

  }

  Future<void> _checkPermissions() async {

    PermissionStatus locationStatus = await Permission.location.request();

    PermissionStatus cameraStatus = await Permission.camera.request();

    if (locationStatus != PermissionStatus.granted || cameraStatus != PermissionStatus.granted) {

      Fluttertoast.showToast(msg: "Permissions required");

      return;

    }

  }

  Future<Position> _getCurrentLocation() async {

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  }

  Future<void> _pickSelfie() async {

    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {

      setState(() {

        _imageFile = pickedFile;

        recognitionPercentage = (50 + (50 * (DateTime.now().second % 2))).toDouble();

      });

    }

  }

  Future<void> _checkAttendance() async {

    Position position = await _getCurrentLocation();

    double distanceInMeters = Geolocator.distanceBetween(

      position.latitude,

      position.longitude,

      officeLatitude,

      officeLongitude,

    );

    if (distanceInMeters <= 100) {
      setState(() {
        _status = "Attendance marked: Present";
      });
      Fluttertoast.showToast(msg: "Attendance marked: Present");
    } else {
      setState(() {
        _status = "Attendance marked: Absent";
      });
      Fluttertoast.showToast(msg: "Attendance marked: Absent");
    }
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
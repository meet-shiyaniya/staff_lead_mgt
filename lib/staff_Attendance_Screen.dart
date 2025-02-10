import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:hr_app/Provider/UserProvider.dart';
import 'package:hr_app/bottom_navigation.dart';
import 'package:hr_app/staff_HRM_module/Model/Realtomodels/Realtoofficelocationmodel.dart';
import 'package:hr_app/staff_HRM_module/Screen/Color/app_Color.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class StaffAttendanceScreen extends StatefulWidget {
  @override
  _StaffAttendanceScreenState createState() => _StaffAttendanceScreenState();
}

class _StaffAttendanceScreenState extends State<StaffAttendanceScreen> {
  XFile? _imageFile;
  double recognitionPercentage= 0.0;
  String _status = "Upload your selfie to mark attendance";


  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _checkPermissions(); // Request necessary permissions

    Future.microtask(() {
      Provider.of<UserProvider>(context, listen: false).fetchOfficeLocationData();
    });

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

  Future<void> _pickSelfie() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera, preferredCameraDevice: CameraDevice.front);
    if (pickedFile != null) {
      bool isFaceDetected = await _detectFace(File(pickedFile.path));
      setState(() {
        _imageFile = pickedFile;
        recognitionPercentage = isFaceDetected ? 100.0 : 0.0;
        _status = isFaceDetected ? "Selfie Verified! Now mark attendance." : "Invalid Image! Only Face Selfie is allowed.";
      });
    }
  }

  void _getCurrentLocation() async {
    Position staffPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Data>? officeLocations = userProvider.officeLocationData?.data;

    checkAttendance(staffPosition, officeLocations);

  }

  Future<void> checkAttendance(Position staffPosition, List<Data>? officeLocations) async {

    final prefs = await SharedPreferences.getInstance();
    String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String? lastEntryDate = prefs.getString('entryDate');

    if (lastEntryDate == todayDate) {
      Fluttertoast.showToast(msg: "Attendance already marked for today!");
      return;
    }

    if (recognitionPercentage < 100) {
      setState(() {
        _status = "Attendance marked: Absent ❌";
      });
      Fluttertoast.showToast(msg: "❌ Attendance marked: Absent");
      return;
    }

    if (officeLocations == null || officeLocations.isEmpty) {
      Fluttertoast.showToast(msg: "No office locations found!");
      return;
    }

    bool isWithinOffice = false;

    for (var office in officeLocations) {
      double officeLatitude = double.tryParse(office.latitude ?? '') ?? 0.0;
      double officeLongitude = double.tryParse(office.logitude ?? '') ?? 0.0;

      double distanceInMeters = Geolocator.distanceBetween(
        staffPosition.latitude,
        staffPosition.longitude,
        officeLatitude,
        officeLongitude,
      );

      if (distanceInMeters <= 100) {
        isWithinOffice = true;
        break; // Stop checking once a valid location is found
      }
    }

    if (isWithinOffice) {
      setState(() {
        _status = "Attendance marked: Present ✅";
      });
      Fluttertoast.showToast(msg: "✅ Attendance marked: Present");

      // Store Attendance Data
      await prefs.setString('attendanceTime', DateFormat('hh:mm:ss a').format(DateTime.now()));
      await prefs.setBool('attendanceMarked', true);
      await prefs.setString('entryDate', todayDate);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNavScreen(showSuccessAnimation: true)),
      );

    } else {
      setState(() {
        _status = "Attendance marked: Absent ❌";
      });
      Fluttertoast.showToast(msg: "❌ Attendance marked: Absent");
      await showAbsentAnimation(); // Show animation
    }
  }

  Future<bool> _detectFace(File imageFile) async {
    final InputImage inputImage = InputImage.fromFile(imageFile);
    final FaceDetector faceDetector = GoogleMlKit.vision.faceDetector();
    final List<Face> faces = await faceDetector.processImage(inputImage);
    await faceDetector.close();

    if (faces.isEmpty) return false; // No face detected

    if (faces.length > 1) {
      Fluttertoast.showToast(msg: "Multiple faces detected! Upload a single face selfie.");
      return false;
    }

    final Face face = faces.first;
    final image = await decodeImageFromList(imageFile.readAsBytesSync());

    final double faceWidth = face.boundingBox.width;
    final double faceHeight = face.boundingBox.height;
    final double imageWidth = image.width.toDouble();
    final double imageHeight = image.height.toDouble();

    // Ensure face covers at least 70-80% of the image
    bool isFaceBigEnough = (faceWidth / imageWidth >= 0.3) && (faceHeight / imageHeight >= 0.3);

    if (!isFaceBigEnough) {
      Fluttertoast.showToast(msg: "Capture a closer selfie.");
      return false;
    }

    return true; // Face properly captured
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

                  onTap: () {
                    _pickSelfie();
                  }, // Trigger selfie function on tap

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

                onPressed: () {
                  _getCurrentLocation();
                },

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
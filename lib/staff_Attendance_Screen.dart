import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:hr_app/staff_HRM_module/Screen/Color/app_Color.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:google_ml_kit/google_ml_kit.dart';

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
      bool isFaceDetected = await _detectFace(File(pickedFile.path));
      setState(() {
        _imageFile = pickedFile;
        recognitionPercentage = isFaceDetected ? 100.0 : 0.0;
        _status = isFaceDetected ? "Selfie Verified! Now mark attendance." : "Invalid Image! Only selfies are allowed.";
      });
    }
  }

  Future<bool> _detectFace(File imageFile) async {
    final InputImage inputImage = InputImage.fromFile(imageFile);
    final FaceDetector faceDetector = GoogleMlKit.vision.faceDetector();
    final List<Face> faces = await faceDetector.processImage(inputImage);
    await faceDetector.close();
    return faces.isNotEmpty;
  }

  Future<void> _checkAttendance() async {
    if (recognitionPercentage < 100) {
      setState(() {
        _status = "Attendance marked: Absent";
      });
      Fluttertoast.showToast(msg: "Attendance marked: Absent");
      return;
    }

    Position position = await _getCurrentLocation();
    double distanceInMeters = Geolocator.distanceBetween(position.latitude, position.longitude, officeLatitude, officeLongitude);
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
            SizedBox(height: 65),
            Text("Mark Your Attendance", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: appColor.primaryColor, fontFamily: "poppins_thin")),
            SizedBox(height: 5),
            Text("Upload a valid selfie to proceed with attendance.", style: TextStyle(fontSize: 14, color: Colors.grey.shade700, fontFamily: "poppins_thin")),
            SizedBox(height: 50),
            Center(
              child: DottedBorder(
                borderType: BorderType.Circle,
                dashPattern: [6, 3],
                color: Colors.deepPurple.shade600,
                strokeWidth: 2,
                child: GestureDetector(
                  onTap: _pickSelfie,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: _imageFile == null
                        ? Icon(Icons.camera_alt, size: 70, color: Colors.deepPurple.shade600)
                        : ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.file(File(_imageFile!.path), width: 200, height: 200, fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            Center(child: Text("${recognitionPercentage.toStringAsFixed(0)}% recognition", style: TextStyle(color: Colors.grey.shade700, fontSize: 14, fontFamily: "poppins_thin"))),
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
            Text(_status, style: TextStyle(fontSize: 15, color: Colors.grey.shade700, fontFamily: "poppins_thin")),
            Spacer(),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 20),
              child: ElevatedButton(
                onPressed: _checkAttendance,
                child: Text("Mark Attendance", style: TextStyle(fontSize: 15, color: Colors.white, fontFamily: "poppins_thin")),
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
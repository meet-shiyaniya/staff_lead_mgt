import 'package:flutter/material.dart';
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
    } else {
      setState(() {
        _status = "❌ Attendance marked: Absent";
      });
      Fluttertoast.showToast(msg: "❌ Attendance marked: Absent");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Staff Attendance", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Mark Your Attendance",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blueAccent),
              ),
              SizedBox(height: 20),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 3,
                    ),
                  ],
                  border: Border.all(color: Colors.blueAccent, width: 2),
                ),
                child: _imageFile == null
                    ? Icon(
                  Icons.camera_alt,
                  size: 100,
                  color: Colors.blueAccent,
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.file(
                    File(_imageFile!.path),
                    width: 220,
                    height: 220,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _pickSelfie,
                icon: Icon(Icons.camera, size: 24),
                label: Text("Capture Selfie", style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 5,
                ),
              ),
              SizedBox(height: 15),
              ElevatedButton.icon(
                onPressed: _checkAttendance,
                icon: Icon(Icons.check_circle, size: 24),
                label: Text("Mark Attendance", style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 5,
                ),
              ),
              SizedBox(height: 20),
              Text(
                _status,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
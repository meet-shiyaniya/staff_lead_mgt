import 'dart:io';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:http/http.dart' as http;

class StaffAttendanceScreen extends StatefulWidget {
  @override
  _StaffAttendanceScreenState createState() => _StaffAttendanceScreenState();
}

class _StaffAttendanceScreenState extends State<StaffAttendanceScreen> {
  XFile? _imageFile;
  double recognitionPercentage = 0.0;
  String _status = "Upload your selfie to mark attendance";

  final String apiUrl = "https://admin.dev.ajasys.com/api/SelfiPunchAttendance";
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    await Permission.location.request();
    await Permission.camera.request();
  }

  Future<void> _pickSelfie() async {
    final pickedFile = await _picker.pickImage(
        source: ImageSource.camera, preferredCameraDevice: CameraDevice.front);
    if (pickedFile != null) {
      bool isFaceDetected = await _detectFace(File(pickedFile.path));
      setState(() {
        _imageFile = pickedFile;
        recognitionPercentage = isFaceDetected ? 100.0 : 0.0;
        _status = isFaceDetected
            ? "Selfie Verified! Now mark attendance."
            : "Invalid Image! Only Face Selfie is allowed.";
      });

      if (isFaceDetected) {
        _uploadSelfie(File(pickedFile.path));
      }
    }
  }

  Future<bool> _detectFace(File imageFile) async {
    final InputImage inputImage = InputImage.fromFile(imageFile);
    final FaceDetector faceDetector = GoogleMlKit.vision.faceDetector();
    final List<Face> faces = await faceDetector.processImage(inputImage);
    await faceDetector.close();

    if (faces.isEmpty) return false;

    if (faces.length > 1) {
      Fluttertoast.showToast(
          msg: "Multiple faces detected! Upload a single face selfie.");
      return false;
    }

    final Face face = faces.first;
    final image = await decodeImageFromList(imageFile.readAsBytesSync());

    final double faceWidth = face.boundingBox.width;
    final double faceHeight = face.boundingBox.height;
    final double imageWidth = image.width.toDouble();
    final double imageHeight = image.height.toDouble();

    bool isFaceBigEnough =
        (faceWidth / imageWidth >= 0.3) && (faceHeight / imageHeight >= 0.3);

    if (!isFaceBigEnough) {
      Fluttertoast.showToast(msg: "Capture a closer selfie.");
      return false;
    }

    return true;
  }

  Future<void> _uploadSelfie(File imageFile) async {
    try {
      // Fetch current location
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      String latitude = position.latitude.toString();
      String longitude = position.longitude.toString();

      // Get current date and time
      String currentDateTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());

      // Static token
      String token = "ZXlKMWMyVnlibUZ0WlNJNkltUmxiVzlmWVdGMWMyZ2lMQ0p3WVhOemQyOXlaQ0k2SWtvNWVpTk5TVEJQTmxkTWNEQlZjbUZ6Y0RCM0lpd2lhV1FpT2lJeU1qUWlMQ0p3Y205a2RXTjBYMmxrSWpvaU1TSjk=";

      var request = http.MultipartRequest("POST", Uri.parse(apiUrl));

      // Attach the image file
      request.files.add(await http.MultipartFile.fromPath('photoData', imageFile.path));

      // Add form fields
      request.fields['location'] = '$latitude, $longitude';
      request.fields['datetime'] = currentDateTime;

      // Add headers with the token
      request.headers['Authorization'] = 'Bearer $token';

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        print("Photo uploaded");
        Fluttertoast.showToast(msg: "✅ Selfie uploaded successfully");
        print(responseData);
      } else {
        Fluttertoast.showToast(msg: "❌ Failed to upload selfie");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }


  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: "Location services are disabled.");
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: "Location permissions are denied");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(msg: "Location permissions are permanently denied.");
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    Fluttertoast.showToast(
        msg: "Location: Lat ${position.latitude}, Lng ${position.longitude}");
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
            Text(
              "Mark Your Attendance",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: appColor.primaryColor,
                  fontFamily: "poppins_thin"),
            ),
            SizedBox(height: 5),
            Text(
              "If your face matches and location is correct, attendance will be marked successfully.",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                  fontFamily: "poppins_thin"),
            ),
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
                        ? Icon(Icons.camera_alt,
                        size: 70, color: Colors.deepPurple.shade600)
                        : ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.file(
                        File(_imageFile!.path),
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            Center(
                child: Text(
                  "${recognitionPercentage.toStringAsFixed(0)}% recognition",
                  style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: "poppins_thin"),
                )),
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
            SizedBox(height: 20),
            Text(
              _status,
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade700,
                  fontFamily: "poppins_thin",
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

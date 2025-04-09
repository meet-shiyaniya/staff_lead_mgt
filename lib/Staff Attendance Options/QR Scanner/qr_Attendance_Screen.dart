import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_app/Provider/UserProvider.dart';
import 'package:hr_app/Staff%20Attendance%20Options/QR%20Scanner/custom_Dialog.dart';
import 'package:hr_app/Staff%20Attendance%20Options/QR%20Scanner/custom_Dialog_Worn_Qr.dart';
import 'package:hr_app/bottom_navigation.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

class qrAttendanceScreen extends StatefulWidget {
  const qrAttendanceScreen({Key? key}) : super(key: key);

  @override
  State<qrAttendanceScreen> createState() => _qrAttendanceScreenState();
}

class _qrAttendanceScreenState extends State<qrAttendanceScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  bool isScanning = true;
  bool showSuccessAnimation = false;
  bool showWrong = false;
  bool hasClosed = false;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.location,
    ].request();

    if (!statuses[Permission.camera]!.isGranted) {
      Fluttertoast.showToast(
        msg: "We need camera access to scan the QR code. Please enable it in your settings!",
        toastLength: Toast.LENGTH_LONG,
      );
      if (mounted) Navigator.pop(context);
    }

    if (!statuses[Permission.location]!.isGranted) {
      Fluttertoast.showToast(
        msg: "We need your location to mark attendance. Please allow it in settings!",
        toastLength: Toast.LENGTH_LONG,
      );
      if (mounted) Navigator.pop(context);
    }
  }

  Future<Position?> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Fluttertoast.showToast(
          msg: "Location services are off. Please turn them on to continue!",
          toastLength: Toast.LENGTH_LONG,
        );
        return null;
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Oops! We couldn’t get your location. Please try again.",
        toastLength: Toast.LENGTH_LONG,
      );
      return null;
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() => this.controller = controller);

    controller.scannedDataStream.listen((scanData) async {
      if (!isScanning || scanData.code == null || scanData.code!.isEmpty) return;

      setState(() => isScanning = false);
      controller.pauseCamera();

      final userProvider = Provider.of<UserProvider>(context, listen: false);

      Position? position = await _getCurrentLocation();

      if (position == null) {
        setState(() {
          showWrong = true;
          isScanning = true;
        });
        controller.resumeCamera();
        return;
      }

      bool success = await userProvider.sendMemberAttendance(
        qrAttendance: scanData.code!,
        latitude: position.latitude,
        longitude: position.longitude,
      );

      if (!mounted) return;

      if (success) {
        final prefs = await SharedPreferences.getInstance();
        final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
        await prefs.setString('attendanceTime', DateFormat('hh:mm:ss a').format(DateTime.now()));
        await prefs.setBool('attendanceMarked_$today', true);
        await prefs.setString('entryDate', today);
        setState(() => showSuccessAnimation = true);
        await Future.delayed(const Duration(seconds: 3));
        if (!hasClosed && mounted) {
          hasClosed = true;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BottomNavScreen()),
          );
        }
      } else {
        setState(() => showWrong = true);
        Fluttertoast.showToast(
          msg: "Something went wrong with the QR code. Please try scanning again!",
          toastLength: Toast.LENGTH_LONG,
        );
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          setState(() {
            showWrong = false;
            isScanning = true;
          });
          controller.resumeCamera();
        }
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'QR Code Scanner',
          style: TextStyle(fontSize: 17, fontFamily: "poppins_thin"),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.grey,
              borderRadius: 22,
              borderLength: 37,
              borderWidth: 13,
              cutOutSize: 300,
            ),
          ),
          if (showSuccessAnimation)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 200),
              child: customDialog(),
            ),
          if (showWrong)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 200),
              child: customDialogWornQr(),
            ),
        ],
      ),
    );
  }
}
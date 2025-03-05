import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

// import '../../../../Provider/UserProvider.dart';
// import '../../../../bottom_navigation.dart';
// import '../../../../custom_Dialog.dart';
import '../../../../../Provider/UserProvider.dart';
import '../../../../../Staff Attendance Options/QR Scanner/custom_Dialog.dart';
import '../../../../../bottom_navigation.dart';
import 'custom_Dialog_Worn_Qr.dart';

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
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    PermissionStatus status = await Permission.camera.request();
    if (!status.isGranted) {
      Fluttertoast.showToast(msg: "Camera permission is required to scan QR codes.");
      if (mounted) Navigator.pop(context); // Return to previous screen if permission denied
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() => this.controller = controller);

    controller.scannedDataStream.listen((scanData) async {
      if (!isScanning || scanData.code == null || scanData.code!.isEmpty) return;

      setState(() => isScanning = false);
      controller.pauseCamera();

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      bool success = await userProvider.sendMemberAttendance(qrAttendance: scanData.code!);

      if (!mounted) return;

      if (success) {
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
              child: customDialog(), // Assuming this is your success dialog widget
            ),
          if (showWrong)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 200),
              child: customDialogWornQr(), // Assuming this is your error dialog widget
            ),
        ],
      ),
    );
  }
}
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_app/Staff%20Attendance%20Options/QR%20Scanner/custom_Dialog.dart';
import 'package:hr_app/Staff%20Attendance%20Options/QR%20Scanner/custom_Dialog_Worn_Qr.dart';
import 'package:hr_app/bottom_navigation.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class qrAttendanceScreen extends StatefulWidget {
  const qrAttendanceScreen({Key? key}) : super(key: key);

  @override
  State<qrAttendanceScreen> createState() => _qrAttendanceScreenState();
}

class _qrAttendanceScreenState extends State<qrAttendanceScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  bool isScanning = true;
  bool showSuccessAnimation = false;
  bool showWrong = false;
  bool hasClosed = false;

  static const String baseUrl = 'https://admin.dev.ajasys.com/api';

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    if (await Permission.camera.request().isGranted) {
      setState(() {});
    } else {
      Fluttertoast.showToast(msg: "Camera permission is required to scan QR codes.");
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() => this.controller = controller);

    controller.scannedDataStream.listen((scanData) async {
      if (!isScanning || scanData.code == null || scanData.code!.isEmpty) return;
      setState(() => isScanning = false);

      controller.pauseCamera();
      Fluttertoast.showToast(msg: scanData.code!);

      int status = await _sendMemberAttendance(qrAttendance: scanData.code!);

      if (!mounted) return;

      if (status == 1) {
        setState(() => showSuccessAnimation = true);
        await Future.delayed(const Duration(seconds: 3));
        if (!hasClosed) {
          hasClosed = true;
          if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavScreen()));
        }
      } else {
        setState(() => showWrong = true);
        await Future.delayed(const Duration(seconds: 2));
        setState(() => showWrong = false);
        controller.resumeCamera();
        setState(() => isScanning = true);
      }
    });
  }

  Future<int> _sendMemberAttendance({required String qrAttendance}) async {
    final url = Uri.parse('$baseUrl/memberAttendanceInsert');
    try {
      String? token = await _secureStorage.read(key: 'token');
      // String token = "ZXlKMWMyVnlibUZ0WlNJNkltUmxiVzlmWVdGcllYTm9JaXdpY0dGemMzZHZjbVFpT2lJeE1qTWlMQ0pwWkNJNklqSXpNU0lzSW5CeWIyUjFZM1JmYVdRaU9pSXhJbjA9";

      if (token == null) return 0;

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': token, 'qrAttendance': qrAttendance}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        Fluttertoast.showToast(msg: responseData['status'] == 1
            ? 'Attendance recorded successfully.'
            : 'Wrong QR code.');
        return responseData['status'] ?? 2;
      }
    } catch (_) {}
    Fluttertoast.showToast(msg: 'Failed to add attendance.');
    return 2;
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
        title: const Text('QR Code Scanner', style: TextStyle(fontSize: 17, fontFamily: "poppins_thin")),
        centerTitle: true,
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
          if (showSuccessAnimation) Padding(
            padding: const EdgeInsets.symmetric(vertical: 200),
            child: customDialog(),
          ),
          if (showWrong) Padding(
            padding: const EdgeInsets.symmetric(vertical: 200),
            child: customDialogWornQr(),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class customDialogWornQr extends StatelessWidget {
  const customDialogWornQr({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      content: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
          height: MediaQuery.of(context).size.width * 0.8, // Maintain square ratio
          child: Lottie.asset('asset/Attendance Animations/qrFail.json', fit: BoxFit.contain, repeat: false),
        ),
      ),
    );
  }
}

void showCustomDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const customDialogWornQr(); // Show the CustomDialog widget
    },
  );
}
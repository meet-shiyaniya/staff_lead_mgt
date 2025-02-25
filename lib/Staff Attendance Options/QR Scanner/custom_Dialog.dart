import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class customDialog extends StatelessWidget {
  const customDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      content: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
          height: MediaQuery.of(context).size.width * 0.8, // Maintain square ratio
          child: Lottie.asset('asset/Attendance Animations/QRsuccess.json', fit: BoxFit.contain, repeat: false),
        ),
      ),

    );
  }
}

void showCustomDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const customDialog(); // Show the CustomDialog widget
    },
  );
}
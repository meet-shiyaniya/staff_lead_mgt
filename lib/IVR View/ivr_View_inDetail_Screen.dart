import 'package:flutter/material.dart';
import 'package:hr_app/IVR%20View/Models/ivr_Data_Model.dart';
import '../staff_HRM_module/Screen/Color/app_Color.dart';

class ivrViewinDetailScreen extends StatefulWidget {
  final List<UserAppointment> userAppointmentsList;
  final int currentIndex;

  ivrViewinDetailScreen({
    required this.userAppointmentsList,
    required this.currentIndex,
    super.key,
  });

  @override
  State<ivrViewinDetailScreen> createState() => _ivrViewinDetailScreenState();
}

class _ivrViewinDetailScreenState extends State<ivrViewinDetailScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  void _goToNext() {
    if (_currentIndex < widget.userAppointmentsList.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      // Optionally, you can pop back to the previous screen when reaching the end
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentData = widget.userAppointmentsList[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: appColor.primaryColor,
        centerTitle: true,
        title: Text(
          "Follow up",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: "poppins_thin",
          ),
        ),
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height.toDouble(),
        width: MediaQuery.of(context).size.width.toDouble(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${currentData.name}",
              style: TextStyle(
                color: Colors.black,
                fontSize: 26,
                fontFamily: "poppins_thin",
              ),
            ),
            SizedBox(height: 20),
            Text(
              "ID: ${currentData.id}",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
                fontFamily: "poppins_thin",
              ),
            ),
            Text(
              "Date: ${currentData.date} ${currentData.time}",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
                fontFamily: "poppins_thin",
              ),
            ),
            Text(
              "Status: ${currentData.status}",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
                fontFamily: "poppins_thin",
              ),
            ),
            Text(
              "Type: ${currentData.type}",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
                fontFamily: "poppins_thin",
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: _goToNext,
        child: Container(
          height: 54,
          width: 54,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.deepPurple.shade600,
          ),
          child: Center(
            child: Icon(
              Icons.navigate_next_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
        ),
      ),
    );
  }
}
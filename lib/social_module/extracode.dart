import 'dart:async';
import 'package:flutter/material.dart';

class DayProgressTracker extends StatefulWidget {
  @override
  _DayProgressTrackerState createState() => _DayProgressTrackerState();
}

class _DayProgressTrackerState extends State<DayProgressTracker> {
  double progressValue = 0.0;
  Timer? timer;
  final int totalDuration = 8 * 60; // 8 minutes in seconds for testing

  void startDay() {
    setState(() {
      progressValue = 0.0; // Reset progress on new start
    });

    timer?.cancel(); // Cancel any existing timer

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        progressValue += 1 / totalDuration;

        if (progressValue >= 1) {
          timer.cancel(); // Stop the timer after progress completes
          progressValue = 1.0;
        }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Day Progress Tracker')),
      body: Container(
        height: 200,
        width: double.infinity,
        margin: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 25,
              width: 120,
              margin: const EdgeInsets.only(left: 30, top: 25),
              decoration: BoxDecoration(
                color: Colors.white38,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: GestureDetector(
                  onTap: startDay,
                  child: const Text(
                    "Connect Now",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Progress bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              height: 10,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(5),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progressValue,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Progress: ${(progressValue * 100).toStringAsFixed(1)}%',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

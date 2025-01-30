import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
// import 'package:auto_size_text/auto_size_text.dart';

class TaskContainer extends StatelessWidget {
  final String title;
  final Color color;
  final String imagePath; // Path to the image
  final double? height; // Optional height parameter
  final double imageHeight; // Height for the image
  final double imageWidth; // Width for the image

  const TaskContainer({
    Key? key,
    required this.title,
    required this.color,
    required this.imagePath, // Image path passed to the widget
    this.height, // Optional height parameter
    this.imageHeight = 40.0, // Default height if not provided
    this.imageWidth = 40.0,  // Default width if not provided
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      color: color,
      child: Container(
        height: height ?? 100.0, // Default height if not provided
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with adjustable height and width
            SizedBox(
              height: imageHeight, // Adjustable height for each image
              width: imageWidth,   // Adjustable width for each image
              child: Image.asset(imagePath), // Display the image using Image.asset
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AutoSizeText(
                    title,
                    maxLines: 2, // Limit to 2 lines
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: "poppins_thin",
                    ),
                    overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
                  ),
                ),
                const Icon(Icons.arrow_forward, color: Colors.black54),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class TaskContainer extends StatelessWidget {
  final String title;
  final Color color;
  final String imagePath;
  final double? height;
  final double imageHeight;
  final double imageWidth;

  const TaskContainer({
    Key? key,
    required this.title,
    required this.color,
    required this.imagePath,
    this.height,
    this.imageHeight = 40.0,
    this.imageWidth = 40.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      color: color,
      child: Container(
        height: height ?? 100.0,
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Flexible(
              child: SizedBox(
                height: imageHeight,
                width: imageWidth,
                child: Image.asset(imagePath),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.spaceBetween,
              children: [
                AutoSizeText(
                  title,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: "poppins_thin",
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                ],
            ),

          ],
        ),
      ),
    );
  }
}
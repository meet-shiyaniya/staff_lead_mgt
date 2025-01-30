import 'package:flutter/material.dart';

class CustomAppBarButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  // final VoidCallback onPressed;
  // final String? tooltip;

  const CustomAppBarButton({
    super.key,
    required this.icon,
    // required this.onPressed,
    required this.color,
    // this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: Icon(icon),
    );
  }
}

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
    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: Container(
        height: 44,
        width: 44,
        // margin: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.grey.shade400, blurRadius: 3, offset: Offset(1, 3)),],
        ),
        child: Icon(icon, size: 22,),
      ),
    );
  }
}

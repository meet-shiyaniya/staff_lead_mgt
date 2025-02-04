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
      height: 44,
      width: 44,
      // margin: EdgeInsets.all(7),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            offset: Offset(1,3),
            blurRadius: 3,
            color: Colors.grey.shade400
          )
        ]
      ),
      child: Icon(icon,size: 20,),
    );
  }
}

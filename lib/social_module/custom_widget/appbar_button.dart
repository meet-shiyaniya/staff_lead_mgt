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
      margin: EdgeInsets.only(right:10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            offset: Offset(1,3),
            blurRadius: 5,
            color: Colors.grey.shade400
          )
        ]
      ),
      child: Icon(icon,size: 18,),
    );
  }
}

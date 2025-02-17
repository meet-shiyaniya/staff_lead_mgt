import 'package:flutter/material.dart';
import 'package:hr_app/staff_HRM_module/Screen/Staff%20HR%20Screens/Notification/notification_Screen.dart';

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
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationScreen()));
      },
      child: Container(
        height: 40,
        width: 40,
        margin: EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: [
            BoxShadow(
              offset: Offset(1,3),
              blurRadius: 2,
              color: Colors.grey.shade400
            )
          ]
        ),
        child: Icon(icon,size: 20,),
      ),
    );
  }
}

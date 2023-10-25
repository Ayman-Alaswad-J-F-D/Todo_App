import 'package:flutter/material.dart';

class IconTask extends StatelessWidget {
  const IconTask({
    Key? key,
    required this.icon,
    required this.backColor,
    required this.iconColor,
    this.click,
  }) : super(key: key);

  final IconData icon;
  final Color backColor;
  final Color iconColor;
  final Function()? click;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 23,
      backgroundColor: backColor,
      child: IconButton(
        icon: Icon(icon, color: iconColor),
        onPressed: click,
      ),
    );
  }
}

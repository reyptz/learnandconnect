import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;
  final double borderRadius;

  const CustomButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.color = const Color(0xFFFF7733),
    this.textColor = Colors.white,
    this.borderRadius = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      ),
      child: Text(
        label,
        style: TextStyle(color: textColor, fontSize: 16),
      ),
    );
  }
}

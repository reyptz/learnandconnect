import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String imageUrl;
  final double radius;
  final VoidCallback onTap;

  const ProfileAvatar({
    Key? key,
    required this.imageUrl,
    this.radius = 40,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(imageUrl),
        child: Align(
          alignment: Alignment.bottomRight,
          child: CircleAvatar(
            radius: radius / 4,
            backgroundColor: Colors.white,
            child: Icon(Icons.camera_alt, size: radius / 2, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}

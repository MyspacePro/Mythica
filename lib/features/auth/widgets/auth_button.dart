import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;   // ✅ nullable
  final Color backgroundColor;
  final Color textColor;
  final double height;
  final double borderRadius;
  final double elevation;

  const AuthButton({
    super.key,
    required this.text,
    this.onTap,  // ✅ required hata diya
    this.backgroundColor = Colors.amber,
    this.textColor = Colors.black,
    this.height = 50,
    this.borderRadius = 14,
    this.elevation = 4,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: onTap, // null hoga to button disabled ho jayega
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          shadowColor: Colors.black45,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class HomeSearchBar extends StatelessWidget {
  final String hintText;
  final IconData prefixIcon;
  final ValueChanged<String>? onChanged;
  final Color backgroundColor;
  final double borderRadius;

  const HomeSearchBar({
    super.key,
    this.hintText = "Search books, authors, categories",
    this.prefixIcon = Icons.search,
    this.onChanged,
    this.backgroundColor = const Color(0xFF1E1E1E),
    this.borderRadius = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white54),
        prefixIcon: Icon(prefixIcon, color: Colors.white70),
        filled: true,
        fillColor: backgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}

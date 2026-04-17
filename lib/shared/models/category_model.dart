import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;

  CategoryModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      icon: Icons.menu_book,
    );
  }
}
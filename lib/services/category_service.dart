import 'package:mythica/features/home/mainicon/category_icon/category_dashboard.dart' show CategoryModel;
import 'package:flutter/material.dart';

class CategoryService {

  Future<List<CategoryModel>> fetchCategories() async {

    await Future.delayed(const Duration(milliseconds: 600));

    return [

      CategoryModel(
        id: "fiction",
        title: "Fiction",
        subtitle: "24k books",
        icon: Icons.menu_book,
      ),

      CategoryModel(
        id: "self_growth",
        title: "Self Growth",
        subtitle: "12k books",
        icon: Icons.trending_up,
      ),

      CategoryModel(
        id: "romance",
        title: "Romance",
        subtitle: "8k books",
        icon: Icons.favorite,
      ),

      CategoryModel(
        id: "comics",
        title: "Comics",
        subtitle: "3k books",
        icon: Icons.auto_stories,
      ),

      CategoryModel(
        id: "fantasy",
        title: "Fantasy",
        subtitle: "6k books",
        icon: Icons.auto_awesome,
      ),

      CategoryModel(
        id: "mystery",
        title: "Mystery",
        subtitle: "4k books",
        icon: Icons.visibility,
      ),

      CategoryModel(
        id: "history",
        title: "History",
        subtitle: "2k books",
        icon: Icons.account_balance,
      ),

      CategoryModel(
        id: "science",
        title: "Science",
        subtitle: "5k books",
        icon: Icons.science,
      ),

    ];
  }

}
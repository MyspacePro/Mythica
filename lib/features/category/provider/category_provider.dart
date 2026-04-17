import 'package:mythica/features/home/mainicon/category_icon/category_dashboard.dart' show CategoryModel;
import 'package:flutter/material.dart';
import '../services/category_service.dart';

class CategoryProvider extends ChangeNotifier {

  final CategoryService _service = CategoryService();

  List<CategoryModel> categories = [];

  bool isLoading = true;

  Future<void> loadCategories() async {

    isLoading = true;
    notifyListeners();

    categories = await _service.fetchCategories();

    isLoading = false;
    notifyListeners();
  }

  void openCategory(BuildContext context, CategoryModel category) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${category.title} clicked"),
      ),
    );

    /// future navigation
    /// Navigator.push(...)
  }

}
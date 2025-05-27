import 'package:flutter/material.dart';
import 'package:fintrack/screens/Categories/categories.dart';
import 'package:fintrack/screens/Categories/transictions_add.dart';
import 'package:fintrack/screens/Categories/category_detail.dart';

class CategoriesTab extends StatefulWidget {
  const CategoriesTab({super.key});

  @override
  State<CategoriesTab> createState() => _CategoriesTabState();
}

class _CategoriesTabState extends State<CategoriesTab> {
  String? currentView;
  Map<String, dynamic>? selectedCategory;

  void openAddTransictions() {
    setState(() {
      currentView = 'add';
    });
  }

  void openCategoryDetail(Map<String, dynamic> category) {
    setState(() {
      currentView = 'detail';
      selectedCategory = category;
    });
  }

  void backToCategories() {
    setState(() {
      currentView = null;
      selectedCategory = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentView == 'add') {
      return AddTransictionsScreen(onBack: backToCategories);
    }

    if (currentView == 'detail' && selectedCategory != null) {
      return CategoryDetailPage(
        categoryLabel: selectedCategory!['label'],
        categoryId: selectedCategory!['id'],
        iconId: selectedCategory!['iconId'],
        onAddTransictions: openAddTransictions,
      );
    }

    return CategoriesPage(
      onAddPressed: openAddTransictions,
      onCategoryPressed: openCategoryDetail,
    );
  }
}

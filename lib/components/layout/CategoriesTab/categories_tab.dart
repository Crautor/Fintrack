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
  int? editingTransactionId;

  void openAddTransictions() {
    setState(() {
      currentView = 'add';
    });
  }

  void openCategoryDetail(Map<String, dynamic> category) {
    setState(() {
      currentView = 'detail';
      selectedCategory = {'id': category['id']};
    });
  }

  void openEditTransaction(int categoryId, int transactionId) {
    setState(() {
      selectedCategory = {'id': categoryId};
      editingTransactionId = transactionId;
      currentView = 'add';
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
    if (currentView == 'detail' && selectedCategory != null) {
      return CategoryDetailPage(
        key: ValueKey(selectedCategory!['id']), 
        categoryId: selectedCategory!['id'],
        onAddTransictions: openAddTransictions,
        onEditTransaction: openEditTransaction,
        onBack: backToCategories,
      );
    }

    if (currentView == 'add' && selectedCategory != null) {
      return AddTransictionsScreen(
        categoryId: selectedCategory!['id'],
        transactionId: editingTransactionId,
        onBack: () {
          setState(() {
            currentView = 'detail';
            editingTransactionId = null;
          });
        },
      );
    }

    return CategoriesPage(
      onAddPressed: openAddTransictions,
      onCategoryPressed: openCategoryDetail,
    );
  }
}

import 'package:fintrack/screens/Categories/categories.dart';
import 'package:fintrack/screens/Categories/expense_add.dart';
import 'package:flutter/material.dart';

class CategoriesTab extends StatefulWidget {
  const CategoriesTab({super.key});

  @override
  State<CategoriesTab> createState() => _CategoriesTabState();
}

class _CategoriesTabState extends State<CategoriesTab> {
  bool showAddExpense = false;

  void openAddExpense() => setState(() => showAddExpense = true);
  void backToCategories() => setState(() => showAddExpense = false);

  @override
  Widget build(BuildContext context) {
    return showAddExpense
        ? AddExpenseScreen(onBack: backToCategories)
        : CategoriesPage(onAddPressed: openAddExpense);
  }
}

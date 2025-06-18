import 'package:flutter/material.dart';
import 'package:fintrack/screens/Categories/categories.dart';
import 'package:fintrack/screens/Categories/transictions_add.dart';
import 'package:fintrack/screens/Categories/category_detail.dart';
import 'package:fintrack/screens/Categories/financial_goal_detail.dart';
import 'package:fintrack/screens/Categories/add_income.dart';

class CategoriesTab extends StatefulWidget {
  const CategoriesTab({super.key});

  @override
  State<CategoriesTab> createState() => _CategoriesTabState();
}

class _CategoriesTabState extends State<CategoriesTab> {
  String? currentView;
  Map<String, dynamic>? selectedCategory;
  Map<String, dynamic>? selectedGoal;
  int? editingTransactionId;
  int? editingSavingId;

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

  void openGoalDetail(Map<String, dynamic> goal) {
    setState(() {
      currentView = 'goal-detail';
      selectedGoal = {'id': goal['id']};
    });
  }

  void openEditTransaction(int categoryId, int transactionId) {
    setState(() {
      selectedCategory = {'id': categoryId};
      editingTransactionId = transactionId;
      currentView = 'add';
    });
  }

  void openAddSavingToGoal(int goalId) {
    setState(() {
      selectedGoal = {'id': goalId};
      editingSavingId = null;
      currentView = 'add-saving';
    });
  }

  void openEditSaving(int goalId, int savingId) {
    setState(() {
      selectedGoal = {'id': goalId};
      editingSavingId = savingId;
      currentView = 'add-saving';
    });
  }

  void backToCategories() {
    setState(() {
      currentView = null;
      selectedCategory = null;
      selectedGoal = null;
      editingTransactionId = null;
      editingSavingId = null;
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

    if (currentView == 'goal-detail' && selectedGoal != null) {
      return FinancialGoalDetailPage(
        key: ValueKey(selectedGoal!['id']),
        goalId: selectedGoal!['id'],
        onBack: backToCategories,
        onAddSaving: openAddSavingToGoal,
        onEditSaving: openEditSaving,
      );
    }

    if (currentView == 'add-saving' && selectedGoal != null) {
      return AddSavingScreen(
        financialGoalId: selectedGoal!['id'],
        savingId: editingSavingId,
        onBack: () {
          setState(() {
            currentView = 'goal-detail';
            editingSavingId = null;
          });
        },
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
      onGoalPressed: openGoalDetail,
    );
  }
}

import 'package:fintrack/screens/Categories/expense_add.dart';
import 'package:flutter/material.dart';

class CategoriesPage extends StatelessWidget {
  final VoidCallback? onAddPressed;
  const CategoriesPage({super.key, this.onAddPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ElevatedButton.icon(
          onPressed: onAddPressed, 
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text('Adicionar Despesa'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00D09E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
        ),
      ),
    );
  }
}

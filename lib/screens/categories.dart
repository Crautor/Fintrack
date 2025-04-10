import 'package:flutter/material.dart';
import 'home.dart';
import 'package:fintrack/components/custom_nav_bar.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text('Categorias')),
      bottomNavigationBar: CustomNavBar(currentIndex: 3),
    );
  }
}

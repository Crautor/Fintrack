import 'package:fintrack/components/categoryItem/category_item.dart';
import 'package:flutter/material.dart';
import 'package:fintrack/components/headers/default_header.dart';
import 'package:fintrack/components/overviews/general_overview.dart';

class CategoriesPage extends StatelessWidget {
  final VoidCallback? onAddPressed;

  const CategoriesPage({super.key, this.onAddPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9FFF9),
      body: Column(
        children: [
          const DefaultHeader(
            title: 'Categorias',
            subtitle: 'Gerencie suas despesas',
            isBackButtonVisible: false,
            child: GeneralOverview(
              balance: 7783.00,
              expense: 1187.40,
              goal: 20000.00,
              percentage: 0.3,
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                children: [
                  CategoryItem(icon: Icons.restaurant, label: "Comida"),
                  CategoryItem(icon: Icons.directions_bus, label: "Transporte"),
                  CategoryItem(icon: Icons.health_and_safety, label: "Saúde"),
                  CategoryItem(
                    icon: Icons.local_grocery_store,
                    label: "Alimentos",
                  ),
                  CategoryItem(icon: Icons.vpn_key, label: "Aluguel"),
                  CategoryItem(icon: Icons.card_giftcard, label: "Presentes"),
                  CategoryItem(icon: Icons.savings, label: "Poupança"),
                  CategoryItem(icon: Icons.movie, label: "Entretenimento"),
                  CategoryItem(
                    icon: Icons.add,
                    label: "Mais",
                    onTap: onAddPressed,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

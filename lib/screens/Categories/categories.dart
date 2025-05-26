import 'package:fintrack/components/categoryItem/category_item.dart';
import 'package:fintrack/components/headers/default_header.dart';
import 'package:fintrack/components/overviews/general_overview.dart';
import 'package:fintrack/screens/Categories/category_modal.dart';
import 'package:flutter/material.dart';
import 'package:fintrack/utils/icons.dart';

class CategoriesPage extends StatelessWidget {
  final VoidCallback? onAddPressed;

  const CategoriesPage({super.key, this.onAddPressed});

  final List<Map<String, dynamic>> userCategories = const [
    {"id": 1, "label": "Comida", "iconId": 1},
    {"id": 2, "label": "Transporte", "iconId": 2},
    {"id": 3, "label": "Saúde", "iconId": 3},
    {"id": 4, "label": "Alimentos", "iconId": 4},
    {"id": 5, "label": "Aluguel", "iconId": 5},
    {"id": 6, "label": "Presentes", "iconId": 6},
    {"id": 7, "label": "Poupança", "iconId": 7},
    {"id": 8, "label": "Entretenimento", "iconId": 8},
    {"id": 9, "label": "Compras", "iconId": 9},
    {"id": 10, "label": "Educação", "iconId": 10},
    {"id": 11, "label": "Viagens", "iconId": 11},
    {"id": 12, "label": "Investimentos", "iconId": 12},
    {"id": 13, "label": "Carro", "iconId": 13},
    {"id": 14, "label": "Animais", "iconId": 14},
    {"id": 15, "label": "Tecnologia", "iconId": 15},
  ];

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
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              padding: EdgeInsets.zero,
              child: GridView.count(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                crossAxisCount: 3,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 0.8,
                children: [
                  ...userCategories.map((category) {
                    final iconData =
                        getCategoryIconById(category["id"])?.icon ?? Icons.help_outline;
                    return CategoryItem(
                      icon: iconData,
                      label: category["label"],
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/category-detail',
                          arguments: {
                            'categoryLabel': category["label"],
                            'categoryId': category["id"],
                            'iconId': category["iconId"],
                          },
                        );
                      },
                    );
                  }).toList(),
                  CategoryItem(
                    icon: Icons.add,
                    label: "Criar",
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CategoryModal(
                            onSave: (name, icon) {
                              print(
                                'Nova categoria criada: $name com ícone ${icon.label}',
                              );
                            },
                          );
                        },
                      );
                    },
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


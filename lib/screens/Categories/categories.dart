import 'package:fintrack/components/categoryItem/category_item.dart';
import 'package:fintrack/components/headers/default_header.dart';
import 'package:fintrack/components/overviews/general_overview.dart';
import 'package:fintrack/screens/Categories/category_modal.dart';
import 'package:flutter/material.dart';
import 'package:fintrack/utils/icons.dart';

class CategoriesPage extends StatelessWidget {
  final VoidCallback? onAddPressed;

  const CategoriesPage({super.key, this.onAddPressed});

  // Simulando o que viria do backend:
  final List<Map<String, dynamic>> userCategories = const [
    {"id": 1, "label": "Comida"},
    {"id": 2, "label": "Transporte"},
    {"id": 3, "label": "Saúde"},
    {"id": 4, "label": "Alimentos"},
    {"id": 5, "label": "Aluguel"},
    {"id": 6, "label": "Presentes"},
    {"id": 7, "label": "Poupança"},
    {"id": 8, "label": "Entretenimento"},
    {"id": 9, "label": "Compras"},
    {"id": 10, "label": "Educação"},
    {"id": 11, "label": "Viagens"},
    {"id": 12, "label": "Investimentos"},
    {"id": 13, "label": "Carro"},
    {"id": 14, "label": "Animais"},
    {"id": 15, "label": "Tecnologia"},
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
                        getCategoryIconById(category["id"])?.icon ??
                        Icons.help_outline;
                    return CategoryItem(
                      icon: iconData,
                      label: category["label"],
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
                              // Aqui você recebe o nome e o ícone escolhido
                              print(
                                'Nova categoria criada: $name com ícone ${icon.label}',
                              );
                              // Aqui você pode adicionar na lista, chamar API etc.
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

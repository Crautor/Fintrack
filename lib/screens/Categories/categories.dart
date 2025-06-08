import 'package:flutter/material.dart';
import 'package:fintrack/components/categoryItem/category_item.dart';
import 'package:fintrack/components/headers/default_header.dart';
import 'package:fintrack/components/overviews/general_overview.dart';
import 'package:fintrack/screens/Categories/category_modal.dart';
import 'package:fintrack/services/CategoryService/category_service.dart';
import 'package:fintrack/models/Category/category.dart';
import 'package:fintrack/utils/icons.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CategoriesPage extends StatefulWidget {
  final VoidCallback? onAddPressed;
  final void Function(Map<String, dynamic>)? onCategoryPressed;

  const CategoriesPage({super.key, this.onAddPressed, this.onCategoryPressed});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  List<Category> userCategories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  Future<void> loadCategories() async {
    try {
      final categories = await CategoryService.getCategories();
      setState(() {
        userCategories = categories;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      Fluttertoast.showToast(
        msg: 'Erro ao carregar categorias',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  void handleCreateCategory(String name, CategoryIcon icon) async {
    try {
      await CategoryService.createCategory(
        Category(name: name, icon: icon.id.toString()),
      );
      await loadCategories();
      Fluttertoast.showToast(
        msg: 'Categoria criada com sucesso!',
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Erro ao criar categoria',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

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
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : GridView.count(
                        padding: const EdgeInsets.all(20),
                        crossAxisCount: 3,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15,
                        childAspectRatio: 0.8,
                        children: [
                          ...userCategories.map((category) {
                            final iconData =
                                getCategoryIconById(
                                  int.tryParse(category.icon ?? '') ?? 0,
                                )?.icon ??
                                Icons.help_outline;

                            return CategoryItem(
                              icon: iconData,
                              label: category.name,
                              onTap:
                                  () => widget.onCategoryPressed?.call({
                                    "id": category.categoryId,
                                  }),
                            );
                          }),
                          CategoryItem(
                            icon: Icons.add,
                            label: "Criar",
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return CategoryModal(
                                    onSave: handleCreateCategory,
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

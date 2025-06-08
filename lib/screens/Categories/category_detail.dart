import 'package:fintrack/screens/Categories/category_modal.dart';
import 'package:flutter/material.dart';
import 'package:fintrack/components/headers/default_header.dart';
import 'package:fintrack/components/overviews/general_overview.dart';
import 'package:fintrack/models/Category/category.dart';
import 'package:fintrack/services/CategoryService/category_service.dart';
import 'package:fintrack/utils/icons.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CategoryDetailPage extends StatefulWidget {
  final int categoryId;
  final VoidCallback? onAddTransictions;
  final VoidCallback? onBack;

  const CategoryDetailPage({
    super.key,
    required this.categoryId,
    this.onAddTransictions,
    this.onBack,
  });

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  Category? category;
  bool isLoading = true;

  final List<Map<String, dynamic>> expenses = [
    {'title': 'Jantar', 'time': '18:27', 'date': 'April 30', 'value': 26.00},
    {
      'title': 'Delivery Pizza',
      'time': '15:00',
      'date': 'April 24',
      'value': 18.35,
    },
    {'title': 'Almoço', 'time': '12:30', 'date': 'April 15', 'value': 15.40},
    {
      'title': 'Café Da Manhã',
      'time': '09:30',
      'date': 'April 08',
      'value': 12.13,
    },
    {'title': 'Jantar', 'time': '20:50', 'date': 'March 31', 'value': 27.20},
  ];

  @override
  void initState() {
    super.initState();
    loadCategory();
  }

  Future<void> loadCategory() async {
    try {
      final result = await CategoryService.getCategoryById(widget.categoryId);
      setState(() {
        category = result;
        isLoading = false;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: 'Erro ao carregar categoria');
      setState(() => isLoading = false);
    }
  }

  void _handleDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Remover categoria'),
            content: const Text(
              'Tem certeza que deseja remover esta categoria?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Remover',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (confirm != true) return;

    try {
      await CategoryService.deleteCategory(widget.categoryId);
      Fluttertoast.showToast(
        msg: 'Categoria removida com sucesso!',
        backgroundColor: Colors.green,
      );

      if (!mounted) return;

      if (widget.onBack != null) {
        widget.onBack!();
      } else {
        Navigator.pop(context);
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Erro ao remover categoria',
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (category == null) {
      return const Scaffold(
        body: Center(child: Text("Categoria não encontrada")),
      );
    }
    final iconData =
        getCategoryIconById(int.tryParse(category!.icon ?? '') ?? 0)?.icon ??
        Icons.help_outline;

    return Scaffold(
      backgroundColor: const Color(0xFFF4FFFB),
      body: Column(
        children: [
          DefaultHeader(
            title: category!.name,
            isBackButtonVisible: true,
            onBack: widget.onBack,
            extraActions: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                tooltip: 'Editar categoria',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return CategoryModal(
                        initialName: category!.name,
                        initialIconId: int.tryParse(category!.icon ?? ''),
                        onSave: (updatedName, updatedIcon) async {
                          await CategoryService.updateCategory(
                            category!.categoryId!,
                            Category(
                              categoryId: category!.categoryId!,
                              name: updatedName,
                              icon: updatedIcon.id.toString(),
                            ),
                          );
                          await loadCategory();
                        },
                      );
                    },
                  );
                },
              ),
            ],
            child: const GeneralOverview(
              balance: 7783.00,
              expense: 1187.40,
              goal: 20000.00,
              percentage: 0.30,
            ),
          ),

          const SizedBox(height: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: [
                  _buildTransictionsSection(
                    "Abril",
                    expenses.sublist(0, 4),
                    iconData,
                  ),
                  const SizedBox(height: 20),
                  _buildTransictionsSection(
                    "Março",
                    expenses.sublist(4),
                    iconData,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00D09E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: widget.onAddTransictions,
                        child: const Text(
                          "Adicionar Transação",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: _handleDelete,
                        child: const Text(
                          "Remover Categoria",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransictionsSection(
    String month,
    List<Map<String, dynamic>> items,
    IconData iconData,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          month,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...items.map((item) => _buildTransictionsItem(item, iconData)),
      ],
    );
  }

  Widget _buildTransictionsItem(Map<String, dynamic> item, IconData iconData) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFE1F3FF),
            child: Icon(iconData, color: const Color(0xFF187DFE)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${item['time']} – ${item['date']}",
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
          ),
          Text(
            "-\$${item['value'].toStringAsFixed(2)}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF187DFE),
            ),
          ),
        ],
      ),
    );
  }
}

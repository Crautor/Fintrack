import 'package:fintrack/models/Transaction/transaction.dart';
import 'package:fintrack/screens/Categories/category_modal.dart';
import 'package:flutter/material.dart';
import 'package:fintrack/components/headers/default_header.dart';
import 'package:fintrack/components/overviews/general_overview.dart';
import 'package:fintrack/models/Category/category.dart';
import 'package:fintrack/services/CategoryService/category_service.dart';
import 'package:fintrack/services/TransactionService/transaction_service.dart';
import 'package:fintrack/utils/icons.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CategoryDetailPage extends StatefulWidget {
  final int categoryId;
  final VoidCallback? onAddTransictions;
  final VoidCallback? onBack;
  final void Function(int categoryId, int transactionId)? onEditTransaction;

  const CategoryDetailPage({
    super.key,
    required this.categoryId,
    this.onAddTransictions,
    this.onBack,
    this.onEditTransaction,
  });

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  Category? category;
  bool isLoading = true;
  bool _isLoadingCategory = false;
  List<TransactionItem> transactions = [];
  List<TransactionItem> allTransactions = [];
  final storage = const FlutterSecureStorage();
  String? userEmail;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => isLoading = true);
    await Future.wait([loadCategory(), loadTransactions()]);
    setState(() => isLoading = false);
  }

  Future<void> loadCategory() async {
    if (_isLoadingCategory || category != null) return;

    _isLoadingCategory = true;
    try {
      final storedEmail = await storage.read(key: 'user-mail');
      if (!mounted || storedEmail == null) return;
      userEmail = storedEmail;

      final cat = await CategoryService.getCategoryById(
        widget.categoryId,
        storedEmail,
      );

      if (mounted && cat != null) {
        setState(() => category = cat);
      }
    } catch (e, stack) {
      print('[ERROR loadCategory] $e\n$stack');
      Fluttertoast.showToast(
        msg: 'Erro ao carregar dados da categoria',
        backgroundColor: Colors.red,
      );
    } finally {
      _isLoadingCategory = false;
    }
  }

  Future<void> loadTransactions() async {
    try {
      final storedEmail = await storage.read(key: 'user-mail');
      if (!mounted || storedEmail == null) return;
      userEmail = storedEmail;

      final fetched = await TransactionService.getAll(storedEmail);

      final filtered =
          fetched.where((t) => t.categoryId == widget.categoryId).toList();

      if (mounted) {
        setState(() {
          allTransactions = fetched;
          transactions = filtered;
        });
      }
    } catch (e) {
      print('[ERROR loadTransactions] $e');
      Fluttertoast.showToast(
        msg: 'Erro ao carregar transações',
        backgroundColor: Colors.red,
      );
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
      widget.onBack?.call();
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

    final incomeTotal = transactions
        .where((item) => item.type == 'Income')
        .fold<double>(0.0, (sum, item) => sum + item.value);

    final expenseTotal = transactions
        .where((item) => item.type == 'Expense')
        .fold<double>(0.0, (sum, item) => sum + item.value);

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
                          widget.onBack?.call();
                        },
                      );
                    },
                  );
                },
              ),
            ],
            child: GeneralOverview(balance: incomeTotal, expense: expenseTotal),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: [
                  _buildTransictionsSection(
                    "Transações",
                    transactions,
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
    String title,
    List<TransactionItem> items,
    IconData iconData,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...items.map((item) => _buildTransictionsItem(item, iconData)),
      ],
    );
  }

  Widget _buildTransictionsItem(TransactionItem item, IconData iconData) {
    final date = DateTime.tryParse(item.transactionDate);
    final formattedDate =
        date != null
            ? "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}"
            : "Data inválida";

    final isIncome = item.type == 'Income';
    final valueColor =
        isIncome ? const Color(0xFF00D084) : const Color(0xFF187DFE);
    final valuePrefix = isIncome ? '+R\$' : '-R\$';
    return GestureDetector(
      onTap: () {
        if (widget.onEditTransaction != null && item.transactionId != null) {
          widget.onEditTransaction!(item.categoryId, item.transactionId!);
        }
      },
      child: Container(
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
                    item.description ?? 'Sem descrição',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formattedDate,
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                ],
              ),
            ),

            Text(
              "$valuePrefix${item.value.toStringAsFixed(2)}",
              style: TextStyle(fontWeight: FontWeight.bold, color: valueColor),
            ),
          ],
        ),
      ),
    );
  }
}

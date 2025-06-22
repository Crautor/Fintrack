import 'package:fintrack/components/graph/pizza.dart';
import 'package:fintrack/models/Category/category.dart';
import 'package:fintrack/models/Transaction/transaction.dart';
import 'package:fintrack/services/CategoryService/category_service.dart';
import 'package:fintrack/services/TransactionService/transaction_service.dart';
import 'package:flutter/material.dart';
import 'package:fintrack/components/headers/default_header.dart';
import 'package:fintrack/components/calendar/custom_calendar.dart';
import 'package:fintrack/components/buttons/toggle_button_calendar.dart';
import 'package:fintrack/components/cards/transactions/transaction_card.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CalendarPage extends StatefulWidget {
  final VoidCallback onBack;

  const CalendarPage({super.key, required this.onBack});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  bool showCategories = false;
  DateTime selectedDate = DateTime.now();
  final storage = const FlutterSecureStorage();
  List<Category> allCategories = [];

  List<TransactionItem> allTransactions = [];
  List<TransactionItem> transactionsForSelected = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadTransactions();
  }

  Future<void> _loadCategories() async {
    try {
      final storedEmail = await storage.read(key: 'user-mail');
      if (storedEmail == null) {
        Fluttertoast.showToast(
          msg: 'Usuário não autenticado',
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return;
      }
      final categories = await CategoryService.getCategories(storedEmail);
      setState(() {
        allCategories = categories;
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Erro ao carregar categorias',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<void> _loadTransactions() async {
    try {
      final storedEmail = await storage.read(key: 'user-mail');
      if (storedEmail == null) {
        Fluttertoast.showToast(
          msg: 'Usuário não autenticado',
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return;
      }

      final transactions = await TransactionService.getAll(storedEmail);

      setState(() {
        allTransactions = transactions;
        _filterTransactionsForSelected();
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Erro ao carregar transações: $e',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  void _filterTransactionsForSelected() {
    transactionsForSelected =
        allTransactions.where((transaction) {
          final txDate = DateTime.tryParse(transaction.transactionDate);
          return txDate?.day == selectedDate.day &&
              txDate?.month == selectedDate.month &&
              txDate?.year == selectedDate.year;
        }).toList();

    setState(() {});
  }

  List<CategoryData> _getCategoryData() {
    final categoryTotals = <String, double>{};

    for (final tx in transactionsForSelected) {
      final categoryName =
          allCategories
              .firstWhere(
                (cat) => cat.categoryId == tx.categoryId,
                orElse:
                    () => Category(
                      categoryId: tx.categoryId,
                      name: 'Categoria ${tx.categoryId}',
                      icon: '0',
                    ),
              )
              .name;

      categoryTotals[categoryName] =
          (categoryTotals[categoryName] ?? 0) + tx.value;
    }

    final totalAmount = categoryTotals.values.fold(
      0.0,
      (sum, val) => sum + val,
    );

    return categoryTotals.entries.map((e) {
      final percentage = totalAmount > 0 ? (e.value / totalAmount) * 100 : 0.0;
      return CategoryData(id: e.key, name: e.key, percentage: percentage);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00D09E),
      body: Column(
        children: [
          DefaultHeader(
            title: "Calendário",
            isBackButtonVisible: true,
            onBack: widget.onBack,
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                children: [
                  CustomCalendar(
                    onDateSelected: (date) {
                      setState(() {
                        selectedDate = date;
                        _filterTransactionsForSelected();
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ToggleButton(
                          text: "Transações",
                          isActive: !showCategories,
                          onPressed:
                              () => setState(() => showCategories = false),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ToggleButton(
                          text: "Categorias",
                          isActive: showCategories,
                          onPressed:
                              () => setState(() => showCategories = true),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  showCategories
                      ? PizzaChart(data: _getCategoryData())
                      : Column(
                        children:
                            transactionsForSelected
                                .map(
                                  (item) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    child: TransactionCard(item: item),
                                  ),
                                )
                                .toList(),
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

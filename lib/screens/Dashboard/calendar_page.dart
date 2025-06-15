import 'package:fintrack/components/graph/pizza.dart';
import 'package:fintrack/models/Category/category.dart';
import 'package:fintrack/models/Transaction/list_transaction.dart';
import 'package:fintrack/services/CategoryService/category_service.dart';
import 'package:fintrack/services/TransactionService/transaction_service.dart';
import 'package:fintrack/utils/icons.dart';
import 'package:flutter/material.dart';
import 'package:fintrack/components/headers/default_header.dart';
import 'package:fintrack/components/calendar/custom_calendar.dart';
import 'package:fintrack/components/buttons/toggle_button_calendar.dart';
import 'package:fintrack/components/cards/transactions/transaction_card.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

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
    _loadTransactions();
    _loadCategories();
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

      List<TransactionItem> converted =
          transactions.map((tx) {
            final parsedDate = DateTime.tryParse(tx.transactionDate);
            final dateStr =
                parsedDate != null
                    ? DateFormat('dd/MM/yyyy').format(parsedDate)
                    : '';
            final timeStr =
                parsedDate != null
                    ? DateFormat('HH:mm').format(parsedDate)
                    : '';

            return TransactionItem(
              title: tx.description ?? 'Sem descrição',
              time: timeStr,
              date: dateStr,
              category:
                  getCategoryIconById(tx.categoryId)?.label ?? 'Desconhecido',
              amount: tx.value,
              icon: getCategoryIconById(tx.categoryId)?.icon ?? Icons.help,
              isIncome: tx.type.toLowerCase() == 'income',
            );
          }).toList();

      setState(() {
        allTransactions = converted;
        _filterTransactionsForSelected();
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Erro ao carregar transações',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  void _filterTransactionsForSelected() {
    transactionsForSelected =
        allTransactions.where((transaction) {
          final txDate = DateTime.tryParse(
            transaction.date.split('/').reversed.join('-'),
          );
          return txDate?.day == selectedDate.day &&
              txDate?.month == selectedDate.month &&
              txDate?.year == selectedDate.year;
        }).toList();

    setState(() {});
  }

  List<CategoryData> _getCategoryData() {
    final categoryTotals = <String, double>{};

    for (final tx in transactionsForSelected) {
      categoryTotals[tx.category] =
          (categoryTotals[tx.category] ?? 0) + tx.amount;
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
            title: "Calendar",
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
                          text: "Transactions",
                          isActive: !showCategories,
                          onPressed:
                              () => setState(() => showCategories = false),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ToggleButton(
                          text: "Categories",
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

import 'package:fintrack/components/buttons/toggle_button.dart';
import 'package:fintrack/components/cards/dashboard/expense_card.dart';
import 'package:fintrack/components/cards/dashboard/income_card.dart';
import 'package:fintrack/components/charts/income_expense_bar_chart.dart';
import 'package:fintrack/components/headers/default_header.dart';
import 'package:fintrack/components/overviews/general_overview.dart';
import 'package:fintrack/models/Category/category.dart';
import 'package:fintrack/models/Transaction/transaction.dart';
import 'package:fintrack/models/transaction_item_data.dart';
import 'package:fintrack/services/CategoryService/category_service.dart';
import 'package:fintrack/services/TransactionService/transaction_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DashboardPage extends StatefulWidget {
  final VoidCallback? onCalendarPressed;

  const DashboardPage({super.key, this.onCalendarPressed});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int selectedToggleIndex = 2;

  List<TransactionItem> dailyTransactions = [];
  List<TransactionItem> weeklyTransactions = [];
  List<TransactionItem> monthlyTransactions = [];
  List<TransactionItem> yearlyTransactions = [];

  DateTime now = DateTime.now();

  final storage = const FlutterSecureStorage();

  Map<String, double> calculateIncomeExpense(
    List<TransactionItemData> transactions,
  ) {
    double income = 0;
    double expense = 0;

    for (var tx in transactions) {
      final sanitized = tx.amount.replaceAll(RegExp(r'[^\d.,-]'), '');
      final noThousandsSeparator = sanitized.replaceAll(
        RegExp(r'(?<=\d)[.,](?=\d{3})'),
        '',
      );
      final normalized = noThousandsSeparator.replaceAll(',', '.');

      final amount = double.tryParse(normalized) ?? 0;

      if (amount >= 0) {
        income += amount;
      } else {
        expense += amount.abs();
      }
    }
    return {'income': income, 'expense': expense};
  }

  DateTime getLastSunday(DateTime date) {
    return date.subtract(Duration(days: date.weekday % 7));
  }

  Future<void> _loadTransactions() async {
    try {
      final storedEmail = await storage.read(key: 'user-mail');
      if (storedEmail == null) {
        print('[ERROR] Email do usuário não encontrado no storage');
        return;
      }

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final lastSunday = getLastSunday(today);
      final fourWeeksAgo = lastSunday.subtract(Duration(days: 28));
      final sixMonthsAgo = DateTime(today.year, today.month - 5, 1);
      final fourYearsAgo = DateTime(today.year - 3, 1, 1);

      String formatDate(DateTime date) {
        return '${date.year.toString().padLeft(4, '0')}-'
            '${date.month.toString().padLeft(2, '0')}-'
            '${date.day.toString().padLeft(2, '0')}';
      }

      dailyTransactions = await TransactionService.getTransactionsByPeriod(
        storedEmail,
        formatDate(lastSunday),
        formatDate(today),
      );

      weeklyTransactions = await TransactionService.getTransactionsByPeriod(
        storedEmail,
        formatDate(fourWeeksAgo),
        formatDate(today),
      );

      monthlyTransactions = await TransactionService.getTransactionsByPeriod(
        storedEmail,
        formatDate(sixMonthsAgo),
        formatDate(today),
      );

      yearlyTransactions = await TransactionService.getTransactionsByPeriod(
        storedEmail,
        formatDate(fourYearsAgo),
        formatDate(today),
      );

      setState(() {});
    } catch (e) {
      print('[ERROR] Falha ao carregar transações: $e');
      Fluttertoast.showToast(
        msg: 'Erro ao carregar transações',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  List<TransactionItem> getSelectedTransactions() {
    switch (selectedToggleIndex) {
      case 0:
        return dailyTransactions;
      case 1:
        return weeklyTransactions;
      case 2:
        return monthlyTransactions;
      case 3:
        return yearlyTransactions;
      default:
        return [];
    }
  }

  Future<List<Category>> getCategories() async {
    try {
      final storedEmail = await storage.read(key: 'user-mail');
      if (storedEmail == null) {
        print('[ERROR] Email do usuário não encontrado no storage');
        return [];
      }
      return await CategoryService.getCategories(storedEmail);
    } catch (e) {
      print('[ERROR] Falha ao carregar categorias: $e');
      Fluttertoast.showToast(
        msg: 'Erro ao carregar categorias',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final selectedTransactions = getSelectedTransactions();

    return FutureBuilder<List<Category>>(
      future: getCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Erro ao carregar categorias'));
        }

        final categories = snapshot.data ?? [];

        final transactionDataList =
            selectedTransactions.map((item) {
              var category = categories.firstWhere(
                (cat) => cat.categoryId == item.categoryId,
                orElse: () => Category(name: 'Unknown', categoryId: 0),
              );
              return TransactionItemData.fromApi({
                'category': {
                  'categoryId': category.categoryId,
                  'name': category.name,
                  'icon': category.icon,
                },
                'description': item.description,
                'transactionDate': item.transactionDate,
                'type': item.type,
                'value': item.value,
              });
            }).toList();

        final incomeExpense = calculateIncomeExpense(transactionDataList);

        return Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            height: screenHeight,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Color(0xFFDAF7E9)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                const DefaultHeader(
                  title: 'Análise Financeira',
                  subtitle: 'Veja como está sua saúde financeira',
                  isBackButtonVisible: false,
                  child: GeneralOverview(
                    balance: 7783.00,
                    expense: 1187.40,
                    goal: 20000.00,
                    percentage: 0.3,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          ToggleButton(
                            isSelected: List.generate(
                              4,
                              (index) => index == selectedToggleIndex,
                            ),
                            toggleLabels: const [
                              "Diária",
                              "Semanal",
                              "Mensal",
                              "Anual",
                            ],
                            onToggle: (index) {
                              setState(() {
                                selectedToggleIndex = index;
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 320,
                            child: IncomeExpenseBarChart(
                              transactions: transactionDataList,
                              viewType:
                                  [
                                    'daily',
                                    'weekly',
                                    'monthly',
                                    'yearly',
                                  ][selectedToggleIndex],
                              onCalendarPressed: widget.onCalendarPressed,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IncomeCard(incomeExpense: incomeExpense),
                              const SizedBox(width: 16),
                              ExpenseCard(incomeExpense: incomeExpense),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

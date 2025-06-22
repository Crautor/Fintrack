import 'package:fintrack/components/headers/default_header.dart';
import 'package:fintrack/components/overviews/general_overview.dart';
import 'package:fintrack/components/overviews/last_week_overview.dart';
import 'package:fintrack/components/tables/transaction_section.dart';
import 'package:fintrack/models/Category/category.dart';
import 'package:fintrack/models/Transaction/transaction.dart';
import 'package:fintrack/services/CategoryService/category_service.dart';
import 'package:fintrack/services/TransactionService/transaction_service.dart';
import 'package:fintrack/services/SavingService/saving_service.dart';
import 'package:fintrack/services/FinancialGoalService/financial_goal_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static final GlobalKey<_HomePageState> globalKey = GlobalKey();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedToggleIndex = 2;
  bool isLoading = true;

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  List<Category> allCategories = [];

  List<TransactionItem> dailyTransactions = [];
  List<TransactionItem> weeklyTransactions = [];
  List<TransactionItem> monthlyTransactions = [];

  double totalIncome = 0;
  double totalExpense = 0;

  double lastWeekIncome = 0;
  double lastWeekExpense = 0;
  double goalPercentage = 0.0;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadTransactions();
  }

  void refreshData() {
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
    setState(() => isLoading = true);

    final storage = FlutterSecureStorage();
    final storedEmail = await storage.read(key: 'user-mail');
    if (storedEmail == null) return;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastSunday = today.subtract(Duration(days: today.weekday % 7));
    final startOfMonth = DateTime(today.year, today.month, 1);

    String formatDate(DateTime date) =>
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    dailyTransactions = await TransactionService.getTransactionsByPeriod(
      storedEmail,
      formatDate(today),
      formatDate(today),
    );

    weeklyTransactions = await TransactionService.getTransactionsByPeriod(
      storedEmail,
      formatDate(lastSunday),
      formatDate(today),
    );

    monthlyTransactions = await TransactionService.getTransactionsByPeriod(
      storedEmail,
      formatDate(startOfMonth),
      formatDate(today),
    );

    final lastWeekStart = lastSunday.subtract(const Duration(days: 7));
    final lastWeekEnd = lastSunday.subtract(const Duration(days: 1));

    final lastWeekTransactions =
        await TransactionService.getTransactionsByPeriod(
          storedEmail,
          formatDate(lastWeekStart),
          formatDate(lastWeekEnd),
        );

    lastWeekIncome = 0;
    lastWeekExpense = 0;

    for (var tx in lastWeekTransactions) {
      if (tx.type == 'Income') {
        lastWeekIncome += tx.value;
      } else {
        lastWeekExpense += tx.value;
      }
    }

    final savings = await SavingService.getAll(storedEmail);
    final goals = await FinancialGoalService.getAll(storedEmail);

    final totalSavings = savings.fold<double>(0, (sum, s) => sum + s.value);
    final totalGoals = goals.fold<double>(0, (sum, g) => sum + g.value);

    goalPercentage =
        (totalGoals > 0) ? (totalSavings / totalGoals).clamp(0.0, 1.0) : 0.0;

    setState(() => isLoading = false);
  }

  List<TransactionItem> getSelectedTransactions() {
    totalIncome = 0;
    totalExpense = 0;

    List<TransactionItem> selected;
    switch (selectedToggleIndex) {
      case 0:
        selected = dailyTransactions;
        break;
      case 1:
        selected = weeklyTransactions;
        break;
      case 2:
      default:
        selected = monthlyTransactions;
    }

    for (var tx in selected) {
      if (tx.type.toLowerCase() == 'income') {
        totalIncome += tx.value;
      } else {
        totalExpense += tx.value;
      }
    }

    return selected;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Container(
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
                      title: 'Olá, Bem-vindo ao FinTrack!',
                      subtitle: 'Gerencie suas finanças',
                      isBackButtonVisible: false,
                      child: GeneralOverview(),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              LastWeekOverview(
                                revenue: lastWeekIncome,
                                expense: lastWeekExpense,
                                goalPercentage: goalPercentage,
                              ),
                              const SizedBox(height: 20),
                              TransactionSection(
                                toggleLabels: ["Diária", "Semanal", "Mensal"],
                                isSelected: List.generate(
                                  3,
                                  (index) => index == selectedToggleIndex,
                                ),
                                onToggle: (index) {
                                  setState(() {
                                    selectedToggleIndex = index;
                                  });
                                },
                                transactions: getSelectedTransactions(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}

import 'package:fintrack/services/TransactionService/transaction_service.dart';
import 'package:fintrack/services/SavingService/saving_service.dart';
import 'package:fintrack/services/FinancialGoalService/financial_goal_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class GeneralOverview extends StatefulWidget {
  final double? balance;
  final double? expense;
  final double? goal;
  final double? percentage;

  const GeneralOverview({
    super.key,
    this.balance,
    this.expense,
    this.goal,
    this.percentage,
  });

  @override
  State<GeneralOverview> createState() => _GeneralOverviewState();
}

class _GeneralOverviewState extends State<GeneralOverview> {
  double totalIncome = 0;
  double totalExpense = 0;
  double totalGoals = 0;
  double totalSavings = 0;
  double percentage = 0;
  bool isLoading = true;

  bool get isStandalone => widget.balance == null && widget.expense == null;

  @override
  void initState() {
    super.initState();
    if (isStandalone) {
      _loadData();
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<void> _loadData() async {
    final storage = FlutterSecureStorage();
    final email = await storage.read(key: 'user-mail');
    if (email == null) return;

    final transactions = await TransactionService.getAll(email);
    for (var tx in transactions) {
      if (tx.type == 'Income') {
        totalIncome += tx.value;
      } else {
        totalExpense += tx.value;
      }
    }

    final savings = await SavingService.getAll(email);
    final goals = await FinancialGoalService.getAll(email);

    totalSavings = savings.fold(0, (sum, s) => sum + s.value);
    totalGoals = goals.fold(0, (sum, g) => sum + g.value);

    percentage =
        (totalGoals > 0) ? (totalSavings / totalGoals).clamp(0.0, 1.0) : 0.0;

    if (!mounted) return;
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final income = widget.balance ?? totalIncome;
    final expense = widget.expense ?? totalExpense;
    final goal = widget.goal ?? totalGoals;
    final goalPercentage = widget.percentage ?? percentage;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.trending_up, size: 16, color: Colors.black),
                      SizedBox(width: 4),
                      Text(
                        "Rendas Totais",
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "R\$${income.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 40,
              width: 1,
              color: Colors.grey.shade300,
              margin: const EdgeInsets.symmetric(horizontal: 12),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.trending_down, size: 16, color: Colors.black),
                      SizedBox(width: 4),
                      Text(
                        "Despesas Totais",
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "-R\$${expense.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF187DFE),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (goal > 0) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      height: 18,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: goalPercentage,
                      child: Container(
                        height: 18,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: goalPercentage,
                      child: Container(
                        height: 18,
                        alignment: Alignment.center,
                        child: Text(
                          "${(goalPercentage * 100).toStringAsFixed(0)}%",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "R\$${goal.toStringAsFixed(2)}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

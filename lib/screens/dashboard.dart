import 'package:fintrack/components/buttons/toggle_button.dart';
import 'package:fintrack/components/cards/dashboard/expense_card.dart';
import 'package:fintrack/components/cards/dashboard/income_card.dart';
import 'package:fintrack/components/cards/dashboard/target_progress_card.dart';
import 'package:fintrack/components/charts/income_expense_bar_chart.dart';
import 'package:fintrack/components/headers/default_header.dart';
import 'package:fintrack/components/overviews/general_overview.dart';
import 'package:fintrack/models/transaction_item_data.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int selectedToggleIndex = 2;

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

  final List<TransactionItemData> dailyTransactions = [
    TransactionItemData(
      icon: Icons.coffee,
      label: "Coffee",
      time: "2025-06-02 08:30",
      category: "Food",
      amount: "-\$4.50",
      amountColor: Colors.blue,
    ),
    TransactionItemData(
      icon: Icons.bus_alert,
      label: "Bus",
      time: "2025-06-03 08:30",
      category: "Transport",
      amount: "-\$3.20",
      amountColor: Colors.blue,
    ),
    TransactionItemData(
      icon: Icons.bus_alert,
      label: "Bus",
      time: "2025-06-03 08:30",
      category: "Transport",
      amount: "-\$3.20",
      amountColor: Colors.blue,
    ),
    TransactionItemData(
      icon: Icons.bus_alert,
      label: "Bus",
      time: "2025-06-04 08:30",
      category: "Transport",
      amount: "-\$3.20",
      amountColor: Colors.blue,
    ),
    TransactionItemData(
      icon: Icons.bus_alert,
      label: "Bus",
      time: "2025-06-05 08:30",
      category: "Transport",
      amount: "-\$3.20",
      amountColor: Colors.blue,
    ),
    TransactionItemData(
      icon: Icons.bus_alert,
      label: "Bus",
      time: "2025-06-06 08:30",
      category: "Transport",
      amount: "-\$3.20",
      amountColor: Colors.blue,
    ),
    TransactionItemData(
      icon: Icons.bus_alert,
      label: "Bus",
      time: "2025-06-07 08:30",
      category: "Transport",
      amount: "-\$3.20",
      amountColor: Colors.blue,
    ),
    TransactionItemData(
      icon: Icons.bus_alert,
      label: "Bus",
      time: "2025-06-08 08:30",
      category: "Transport",
      amount: "-\$3.20",
      amountColor: Colors.blue,
    ),
  ];

  final List<TransactionItemData> weeklyTransactions = [
    TransactionItemData(
      icon: Icons.shopping_cart,
      label: "Supermarket",
      time: "2025-06-03 08:30",
      category: "Shopping",
      amount: "-\$150.00",
      amountColor: Colors.blue,
    ),
    TransactionItemData(
      icon: Icons.restaurant,
      label: "Lunch",
      time: "2025-06-08 08:30",
      category: "Restaurant",
      amount: "-\$25.00",
      amountColor: Colors.blue,
    ),
    TransactionItemData(
      icon: Icons.shopping_cart,
      label: "Supermarket",
      time: "2025-06-15 08:30",
      category: "Shopping",
      amount: "-\$150.00",
      amountColor: Colors.blue,
    ),
    TransactionItemData(
      icon: Icons.shopping_cart,
      label: "Supermarket",
      time: "2025-06-15 08:30",
      category: "Shopping",
      amount: "-\$150.00",
      amountColor: Colors.blue,
    ),
    TransactionItemData(
      icon: Icons.shopping_cart,
      label: "Supermarket",
      time: "2025-06-22 08:30",
      category: "Shopping",
      amount: "-\$150.00",
      amountColor: Colors.blue,
    ),
  ];

  final List<TransactionItemData> monthlyTransactions = [
    TransactionItemData(
      icon: Icons.payments,
      label: "Salary",
      time: "2025-05-03 08:30",
      category: "Revenue",
      amount: "\$4,000.00",
      amountColor: Colors.black,
    ),
    TransactionItemData(
      icon: Icons.home,
      label: "Rent",
      time: "2025-06-03 08:30",
      category: "Fixed Expenses",
      amount: "-\$674.40",
      amountColor: Colors.blue,
    ),
  ];

  final List<TransactionItemData> yearlyTransactions = [
    TransactionItemData(
      icon: Icons.payments,
      label: "Annual Bonus",
      time: "2024-06-03 08:30",
      category: "Revenue",
      amount: "\$10,000.00",
      amountColor: Colors.black,
    ),
    TransactionItemData(
      icon: Icons.home,
      label: "House Maintenance",
      time: "2025-06-03 08:30",
      category: "Fixed Expenses",
      amount: "-\$6,150.40",
      amountColor: Colors.blue,
    ),
  ];

  List<TransactionItemData> getSelectedTransactions() {
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

  final List<Map<String, dynamic>> selectedTargets = [
    {'percentage': 0.75, 'title': 'Emergency Fund'},
    {'percentage': 0.45, 'title': 'Vacation'},
    {'percentage': 0.60, 'title': 'New Car'},
    {'percentage': 0.30, 'title': 'Home Renovation'},
    {'percentage': 0.50, 'title': 'Education Fund'},
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final selectedTransactions = getSelectedTransactions();
    final incomeExpense = calculateIncomeExpense(selectedTransactions);

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
              title: 'Analysis',
              subtitle: 'Your financial overview',
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
                          "Daily",
                          "Weekly",
                          "Monthly",
                          "Yearly",
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
                          transactions: selectedTransactions,
                          viewType:
                              const [
                                "daily",
                                "weekly",
                                "monthly",
                                "yearly",
                              ][selectedToggleIndex],
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

                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'My Targets',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        alignment:
                            selectedTargets.length == 1
                                ? WrapAlignment.center
                                : WrapAlignment.start,
                        children:
                            selectedTargets.map((target) {
                              return TargetProgressCard(
                                percentage: target['percentage'],
                                title: target['title'],
                              );
                            }).toList(),
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

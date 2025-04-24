import 'package:flutter/material.dart';

class TransactionsHeader extends StatelessWidget {
  final double totalBalance;
  final double income;
  final double expenses;
  final String? selectedFilter; // 'income', 'expense', or null
  final Function(String filter)? onFilterChanged;

  const TransactionsHeader({
    super.key,
    required this.totalBalance,
    required this.income,
    required this.expenses,
    this.selectedFilter,
    this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF00D09E),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 11, 20, 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/main');
                    },
                  ),
                  const Text(
                    'Transações',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0E3E3E),
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.notifications_none,
                        color: Color(0xFF093030),
                      ),
                      onPressed: () => {},
                      splashRadius: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Total balance
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Saldo Total',
                      style: TextStyle(
                        color: Color(0xFF0E3E3E),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'R\$${totalBalance.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Color(0xFF0E3E3E),
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Filters
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => onFilterChanged?.call('income'),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color:
                              selectedFilter == 'income'
                                  ? const Color(0xFF005CE6) // Azul ativo
                                  : const Color(0xFFDFF7E2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.arrow_downward,
                                  color:
                                      selectedFilter == 'income'
                                          ? Colors.white
                                          : Colors.green,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Entradas',
                                  style: TextStyle(
                                    color:
                                        selectedFilter == 'income'
                                            ? Colors.white
                                            : const Color(0xFF0E3E3E),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'R\$${income.toStringAsFixed(2)}',
                              style: TextStyle(
                                color:
                                    selectedFilter == 'income'
                                        ? Colors.white
                                        : const Color(0xFF0E3E3E),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => onFilterChanged?.call('expense'),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color:
                              selectedFilter == 'expense'
                                  ? const Color(0xFF005CE6)
                                  : const Color(0xFFDFF7E2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.arrow_upward,
                                  color:
                                      selectedFilter == 'expense'
                                          ? Colors.white
                                          : Colors.redAccent,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Saídas',
                                  style: TextStyle(
                                    color:
                                        selectedFilter == 'expense'
                                            ? Colors.white
                                            : const Color(0xFF0E3E3E),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'R\$${expenses.toStringAsFixed(2)}',
                              style: TextStyle(
                                color:
                                    selectedFilter == 'expense'
                                        ? Colors.white
                                        : const Color(0xFF0E3E3E),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

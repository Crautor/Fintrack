import 'package:fintrack/components/cards/transactions/transaction_card.dart';
import 'package:fintrack/components/headers/transactions_header.dart';
import 'package:fintrack/models/Transaction/list_transaction.dart';
import 'package:flutter/material.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String? selectedFilter;

  final Map<String, List<TransactionItem>> groupedTransactions = {
    'April': [
      TransactionItem(
        title: 'Salário',
        time: '18:27',
        date: 'April 30',
        category: 'Monthly',
        amount: 4000.00,
        icon: Icons.attach_money,
        isIncome: true,
      ),
      TransactionItem(
        title: 'Groceries',
        time: '17:00',
        date: 'April 24',
        category: 'Pantry',
        amount: 100.00,
        icon: Icons.shopping_cart,
      ),
      TransactionItem(
        title: 'Rent',
        time: '08:30',
        date: 'April 15',
        category: 'Rent',
        amount: 674.40,
        icon: Icons.home,
      ),
      TransactionItem(
        title: 'Transport',
        time: '07:30',
        date: 'April 08',
        category: 'Fuel',
        amount: 4.13,
        icon: Icons.directions_bus,
      ),
    ],
    'March': [
      TransactionItem(
        title: 'Food',
        time: '19:30',
        date: 'March 31',
        category: 'Dinner',
        amount: 70.40,
        icon: Icons.restaurant,
      ),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFF00D09E),
      body: Column(
        children: [
          TransactionsHeader(
            totalBalance: 7783.00,
            income: 4120.00,
            expenses: 1187.40,
            selectedFilter: selectedFilter,
            onFilterChanged: (filter) {
              setState(() {
                if (selectedFilter == filter) {
                  selectedFilter = null; 
                } else {
                  selectedFilter = filter; 
                }
              });
            },
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                children:
                    groupedTransactions.entries.map((entry) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.key,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0E3E3E),
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...entry.value.map(
                            (item) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: TransactionCard(item: item),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      );
                    }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

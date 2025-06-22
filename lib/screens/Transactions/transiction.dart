import 'package:fintrack/components/cards/transactions/transaction_card.dart';
import 'package:fintrack/components/headers/transactions_header.dart';
import 'package:fintrack/models/Transaction/transaction.dart';
import 'package:fintrack/services/TransactionService/transaction_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  static final GlobalKey<_TransactionsScreenState> globalKey = GlobalKey();

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final storage = const FlutterSecureStorage();

  void refreshData() {
    fetchTransactions();
  }

  String? selectedFilter;
  DateTime? selectedDate;

  List<TransactionItem> allTransactions = [];
  double totalBalance = 0;
  double totalIncome = 0;
  double totalExpenses = 0;

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    final email = await storage.read(key: 'user-mail');
    if (email == null) return;

    final transactions = await TransactionService.getAll(email);
    double income = 0;
    double expenses = 0;

    for (var item in transactions) {
      if (item.type.toLowerCase() == 'income') {
        income += item.value;
      } else {
        expenses += item.value;
      }
    }

    transactions.sort(
      (a, b) => DateTime.parse(
        b.transactionDate,
      ).compareTo(DateTime.parse(a.transactionDate)),
    );

    setState(() {
      allTransactions = transactions;
      totalIncome = income;
      totalExpenses = expenses;
      totalBalance = income - expenses;
    });
  }

  Map<String, List<TransactionItem>> groupTransactionsByMonth(
    List<TransactionItem> transactions,
  ) {
    final Map<String, List<TransactionItem>> grouped = {};

    for (var item in transactions) {
      final date = DateTime.parse(item.transactionDate);
      final key = DateFormat('MMMM yyyy', 'pt_BR').format(date);

      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(item);
    }

    return Map.fromEntries(
      grouped.entries.toList()..sort(
        (a, b) => DateFormat(
          'MMMM yyyy',
          'pt_BR',
        ).parse(b.key).compareTo(DateFormat('MMMM yyyy', 'pt_BR').parse(a.key)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final grouped = groupTransactionsByMonth(allTransactions);

    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFF00D09E),
      body: Column(
        children: [
          TransactionsHeader(
            totalBalance: totalBalance,
            income: totalIncome,
            expenses: totalExpenses,
            selectedFilter: selectedFilter,
            onFilterChanged: (filter) {
              setState(() {
                selectedFilter = selectedFilter == filter ? null : filter;
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
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 12),
                      if (selectedDate != null)
                        Text(
                          DateFormat('dd/MM/yyyy').format(selectedDate!),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF0E3E3E),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child:
                        allTransactions.isEmpty
                            ? const Center(
                              child: Text(
                                'Nenhuma transação encontrada.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF0E3E3E),
                                ),
                              ),
                            )
                            : ListView(
                              children:
                                  grouped.entries.map((entry) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 8,
                                            top: 16,
                                          ),
                                          child: Text(
                                            entry.key,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF0E3E3E),
                                            ),
                                          ),
                                        ),
                                        ...entry.value.map((item) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 10,
                                            ),
                                            child: TransactionCard(item: item),
                                          );
                                        }),
                                      ],
                                    );
                                  }).toList(),
                            ),
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

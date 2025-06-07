import 'package:fintrack/components/buttons/primary_button.dart';
import 'package:fintrack/components/headers/default_header.dart';
import 'package:fintrack/components/inputs/custom_text_field.dart';
import 'package:fintrack/components/inputs/custom_select_field.dart';
import 'package:fintrack/components/inputs/custom_radio_group.dart';
import 'package:fintrack/components/inputs/date_picker_text_field.dart';
import 'package:fintrack/models/transaction_item_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? selectedCategory;
  DateTime? selectedDate;
  String? reportType;
  String searchText = '';
  bool searchPerformed = false;

  final TextEditingController searchController = TextEditingController();

  List<TransactionItemData> filteredTransactions = [];

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

  List<TransactionItemData> get allTransactions => [
    ...dailyTransactions,
    ...weeklyTransactions,
    ...monthlyTransactions,
    ...yearlyTransactions,
  ];

  @override
  void initState() {
    super.initState();
    filteredTransactions = allTransactions; // Exibe tudo inicialmente
  }

  void filterTransactions() {
    setState(() {
      searchPerformed = true;
      filteredTransactions =
          allTransactions.where((transaction) {
            final transactionDate = DateTime.parse(transaction.time);

            if (searchText.isNotEmpty &&
                !transaction.label.toLowerCase().contains(
                  searchText.toLowerCase(),
                )) {
              return false;
            }

            if (selectedCategory != null &&
                selectedCategory!.isNotEmpty &&
                transaction.category != selectedCategory) {
              return false;
            }

            if (selectedDate != null) {
              final isSameDay =
                  transactionDate.year == selectedDate!.year &&
                  transactionDate.month == selectedDate!.month &&
                  transactionDate.day == selectedDate!.day;
              if (!isSameDay) return false;
            }

            if (reportType != null) {
              final isIncome = transaction.amount.startsWith('\$');
              if (reportType == 'Income' && !isIncome) return false;
              if (reportType == 'Expense' && isIncome) return false;
            }

            return true;
          }).toList();
    });
  }

  String formatDateTime(String datetimeStr) {
    final date = DateTime.parse(datetimeStr);
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00D09E),
      body: Column(
        children: [
          DefaultHeader(
            title: "Search",
            isBackButtonVisible: true,
            child: CustomTextField(
              controller: searchController,
              hintText: 'Search for a transaction label...',
              onChanged: (value) {
                searchText = value;
              },
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Categories',
                        style: TextStyle(
                          color: Color(0xFF093030),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomSelectField<String>(
                        hintText: 'Select a category',
                        items: const [
                          DropdownMenuItem(value: 'Food', child: Text('Food')),
                          DropdownMenuItem(
                            value: 'Transport',
                            child: Text('Transport'),
                          ),
                          DropdownMenuItem(
                            value: 'Shopping',
                            child: Text('Shopping'),
                          ),
                          DropdownMenuItem(
                            value: 'Restaurant',
                            child: Text('Restaurant'),
                          ),
                          DropdownMenuItem(
                            value: 'Revenue',
                            child: Text('Revenue'),
                          ),
                          DropdownMenuItem(
                            value: 'Fixed Expenses',
                            child: Text('Fixed Expenses'),
                          ),
                        ],
                        value: selectedCategory,
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Date',
                        style: TextStyle(
                          color: Color(0xFF093030),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DatePickerField(
                        hintText: 'Select a date',
                        initialDate: selectedDate,
                        onDateSelected: (date) {
                          setState(() {
                            selectedDate = date;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomRadioGroup(
                        label: 'Report',
                        selectedValue: reportType,
                        options: const ['Income', 'Expense'],
                        onChanged: (value) {
                          setState(() {
                            reportType = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      PrimaryButton(
                        text: 'Search',
                        onPressed: filterTransactions,
                      ),
                      const SizedBox(height: 20),
                      if (filteredTransactions.isNotEmpty)
                        ...filteredTransactions.map(
                          (transaction) => ListTile(
                            leading: Icon(
                              transaction.icon,
                              color: transaction.amountColor,
                            ),
                            title: Text(transaction.label),
                            subtitle: Text(
                              '${transaction.category} • ${formatDateTime(transaction.time)}',
                            ),
                            trailing: Text(
                              transaction.amount,
                              style: TextStyle(
                                color: transaction.amountColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      if (searchPerformed && filteredTransactions.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Text(
                              'No transactions found',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

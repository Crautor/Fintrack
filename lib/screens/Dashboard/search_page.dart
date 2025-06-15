import 'package:fintrack/components/buttons/primary_button.dart';
import 'package:fintrack/components/headers/default_header.dart';
import 'package:fintrack/components/inputs/custom_select_field.dart';
import 'package:fintrack/components/inputs/custom_radio_group.dart';
import 'package:fintrack/components/inputs/custom_text_field.dart';
import 'package:fintrack/components/inputs/date_picker_text_field.dart';
import 'package:fintrack/models/Category/category.dart';
import 'package:fintrack/models/Transaction/transaction.dart';
import 'package:fintrack/models/transaction_item_data.dart';
import 'package:fintrack/services/CategoryService/category_service.dart';
import 'package:fintrack/services/TransactionService/transaction_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchText = '';
  String? selectedCategory;
  DateTime? selectedDate;
  String? reportType;

  final storage = const FlutterSecureStorage();

  List<TransactionItem> allTransactions = [];
  List<Category> allCategories = [];

  List<TransactionItemData> filteredTransactions = [];
  bool searchPerformed = false;

  final TextEditingController searchController = TextEditingController();

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
      final transactions = await TransactionService.getTransactionsByPeriod(
        storedEmail,
        '2010-01-01',
        DateFormat('yyyy-MM-dd').format(DateTime.now()),
      );

      setState(() {
        allTransactions = transactions;
        filteredTransactions =
            allTransactions.map(_mapTransactionToData).toList();
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Erro ao carregar transações',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  TransactionItemData _mapTransactionToData(TransactionItem tx) {
    final category = allCategories.firstWhere(
      (cat) => cat.categoryId == tx.categoryId,
      orElse: () => Category(name: 'Unknown', categoryId: 0),
    );

    return TransactionItemData.fromApi({
      'category': {
        'categotyId': category.categoryId,
        'name': category.name,
        'icon': category.icon,
      },
      'description': tx.description,
      'transactionDate': tx.transactionDate,
      'type': tx.type,
      'value': tx.value,
    });
  }

  void filterTransactions() {
    setState(() {
      searchPerformed = true;

      filteredTransactions =
          allTransactions
              .where((tx) {
                final lowerLabel = tx.description?.toLowerCase() ?? '';
                if (searchText.isNotEmpty &&
                    !lowerLabel.contains(searchText.toLowerCase())) {
                  return false;
                }

                if (selectedCategory != null && selectedCategory!.isNotEmpty) {
                  final cat = allCategories.firstWhere(
                    (cat) => cat.name == selectedCategory,
                    orElse: () => Category(name: '', categoryId: 0),
                  );
                  if (tx.categoryId != cat.categoryId) {
                    return false;
                  }
                }

                if (selectedDate != null) {
                  final txDate = DateTime.parse(tx.transactionDate);
                  if (!(txDate.year == selectedDate!.year &&
                      txDate.month == selectedDate!.month &&
                      txDate.day == selectedDate!.day)) {
                    return false;
                  }
                }

                if (reportType != null) {
                  final isIncome = tx.type.toString().toLowerCase().contains(
                    'income',
                  );
                  if (reportType == 'Income' && !isIncome) return false;
                  if (reportType == 'Expense' && isIncome) return false;
                }

                return true;
              })
              .map(_mapTransactionToData)
              .toList();
    });
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
                        items:
                            allCategories
                                .map(
                                  (cat) => DropdownMenuItem<String>(
                                    value: cat.name,
                                    child: Text(cat.name),
                                  ),
                                )
                                .toList(),
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
                              '${transaction.category} • ${transaction.labelTime}',
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

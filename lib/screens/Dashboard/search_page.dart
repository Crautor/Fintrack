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
import 'package:fintrack/utils/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
      var categories = await CategoryService.getCategories(storedEmail);
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

      setState(() {
        allTransactions = transactions;
        filteredTransactions =
            allTransactions.map(_mapTransactionToData).toList();
        filterCategories();
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
      orElse:
          () => Category(
            categoryId: tx.categoryId,
            name: 'Categoria Desconhecida',
            icon: '0',
          ),
    );

    final categoryIcon = getCategoryIconById(tx.categoryId)?.icon;

    return TransactionItemData.fromApi({
      'category': {
        'categotyId': category.categoryId ?? 0,
        'name': category.name,
        'icon': categoryIcon ?? Icons.help_outline,
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
                  if (reportType == 'Renda' && !isIncome) return false;
                  if (reportType == 'Despesa' && isIncome) return false;
                }

                return true;
              })
              .map(_mapTransactionToData)
              .toList();
    });
  }

  void filterCategories() {
    allCategories =
        allCategories.where((cat) {
          return allTransactions.any((tx) => tx.categoryId == cat.categoryId);
        }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00D09E),
      body: Column(
        children: [
          DefaultHeader(
            title: "Pesquisar",
            isBackButtonVisible: true,
            child: CustomTextField(
              controller: searchController,
              hintText: 'Pesquise pelo nome da transação...',
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
                        'Categoria',
                        style: TextStyle(
                          color: Color(0xFF093030),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomSelectField<String>(
                        hintText: 'Selecione uma categoria',
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
                        'Data',
                        style: TextStyle(
                          color: Color(0xFF093030),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DatePickerField(
                        hintText: 'Selecione uma data',
                        initialDate: selectedDate,
                        onDateSelected: (date) {
                          setState(() {
                            selectedDate = date;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomRadioGroup(
                        label: 'Tipo de Transação',
                        selectedValue: reportType,
                        options: const ['Renda', 'Despesa'],
                        onChanged: (value) {
                          setState(() {
                            reportType = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      PrimaryButton(
                        text: 'Pesquisar',
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
                              'Nenhum resultado encontrado',
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

import 'package:fintrack/components/inputs/custom_text_field.dart';
import 'package:fintrack/components/inputs/date_picker_text_field.dart';
import 'package:fintrack/components/texts/form_label.dart';
import 'package:flutter/material.dart';
import 'package:fintrack/components/buttons/primary_button.dart';
import 'package:fintrack/components/headers/form_header.dart';
import 'package:fintrack/components/buttons/radio_button.dart';
import 'package:fintrack/models/Transaction/transaction.dart';
import 'package:fintrack/services/TransactionService/transaction_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AddTransictionsScreen extends StatefulWidget {
  final int categoryId;
  final int? transactionId;
  final VoidCallback? onBack;

  const AddTransictionsScreen({
    super.key,
    required this.categoryId,
    this.transactionId,
    this.onBack,
  });

  @override
  State<AddTransictionsScreen> createState() => _AddTransictionsScreenState();
}

class _AddTransictionsScreenState extends State<AddTransictionsScreen> {
  DateTime? selectedDate;
  String? recurrence = 'One Time';
  String? type = '2';

  final amountController = TextEditingController();
  final titleController = TextEditingController();
  final messageController = TextEditingController();

  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    if (widget.transactionId != null) {
      _loadTransaction();
    }
  }

  Future<void> _loadTransaction() async {
    final storedEmail = await storage.read(key: 'user-mail');
    if (storedEmail == null) return;

    final transaction = await TransactionService.getTransactionById(
      widget.transactionId!,
      storedEmail,
    );

    setState(() {
      selectedDate = DateTime.tryParse(transaction.transactionDate);
      recurrence = transaction.recurrence == true ? 'Monthly' : 'One Time';
      type = transaction.type == 'Income' ? '1' : '2';
      amountController.text = transaction.value.toStringAsFixed(2);
      titleController.text = transaction.description ?? '';
      messageController.text = transaction.description ?? '';
    });
  }

  Future<void> _handleDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Remover Transação'),
            content: const Text(
              'Tem certeza que deseja remover esta transação?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Remover',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (confirm != true) return;

    try {
      await TransactionService.deleteTransaction(widget.transactionId!);
      Fluttertoast.showToast(
        msg: 'Transação removida com sucesso!',
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      widget.onBack?.call();
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Erro ao remover transação',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00D09E),
      body: SafeArea(
        child: Column(
          children: [
            FormHeader(
              title:
                  widget.transactionId != null
                      ? 'Editar Transação'
                      : 'Adicionar Transação',
              onBack: widget.onBack,
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
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 40,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomRadioGroup<String>(
                        label: 'Recorrência',
                        selectedValue: recurrence,
                        onChanged: (value) {
                          setState(() {
                            recurrence = value;
                          });
                        },
                        options: const [
                          CustomRadioOption(label: 'Mensal', value: 'Monthly'),
                          CustomRadioOption(label: 'Único', value: 'One Time'),
                        ],
                      ),
                      const SizedBox(height: 16),

                      const FormLabel("Data"),
                      DatePickerField(
                        hintText: 'Selecione a data',
                        initialDate: selectedDate,
                        onDateSelected: (date) {
                          setState(() {
                            selectedDate = date;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      const FormLabel("Título da Despesa"),
                      CustomTextField(
                        hintText: 'Informe um título',
                        controller: messageController,
                      ),
                      const SizedBox(height: 16),

                      const FormLabel("Valor"),
                      CustomTextField(
                        hintText: 'R\$ Informe o valor gasto',
                        controller: amountController,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),

                      if (widget.transactionId != null)
                        ElevatedButton(
                          onPressed: _handleDelete,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            "Remover Transação",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),

                      const SizedBox(height: 16),

                      PrimaryButton(
                        text: 'Salvar',
                        onPressed: () async {
                          if (selectedDate == null ||
                              amountController.text.isEmpty ||
                              messageController.text.isEmpty) {
                            Fluttertoast.showToast(
                              msg: 'Preencha todos os campos obrigatórios',
                            );
                            return;
                          }

                          try {
                            final storedEmail = await storage.read(
                              key: 'user-mail',
                            );
                            if (storedEmail == null) return;

                            final transaction = TransactionItem(
                              transactionId: widget.transactionId,
                              value:
                                  double.tryParse(
                                    amountController.text.replaceAll(',', '.'),
                                  ) ??
                                  0.0,
                              categoryId: widget.categoryId,
                              transactionDate:
                                  selectedDate!.toUtc().toIso8601String(),
                              description: messageController.text,
                              recurrence: recurrence == 'Monthly',
                              type: 'Expense',
                              email: storedEmail,
                            );

                            final transactionUpdate = TransactionItem(
                              transactionId: widget.transactionId,
                              value:
                                  double.tryParse(
                                    amountController.text.replaceAll(',', '.'),
                                  ) ??
                                  0.0,
                              categoryId: widget.categoryId,
                              transactionDate:
                                  selectedDate!.toUtc().toIso8601String(),
                              description: messageController.text,
                              recurrence: recurrence == 'Monthly',
                              type: 'Expense',
                            );

                            if (widget.transactionId != null) {
                              await TransactionService.updateTransaction(
                                widget.transactionId!,
                                transactionUpdate,
                              );
                            } else {
                              await TransactionService.createTransaction(
                                transaction,
                              );
                            }

                            Fluttertoast.showToast(
                              msg: 'Transação salva com sucesso!',
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                            );

                            widget.onBack?.call();
                          } catch (e) {
                            Fluttertoast.showToast(
                              msg: 'Erro ao salvar transação',
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                            );
                          }
                        },
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

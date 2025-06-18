import 'package:fintrack/components/buttons/primary_button.dart';
import 'package:fintrack/components/headers/form_header.dart';
import 'package:fintrack/components/inputs/custom_text_field.dart';
import 'package:fintrack/components/texts/form_label.dart';
import 'package:fintrack/models/Saving/saving.dart';
import 'package:fintrack/services/SavingService/saving_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fintrack/components/inputs/date_picker_text_field.dart';

class AddSavingScreen extends StatefulWidget {
  final int financialGoalId;
  final int? savingId;
  final VoidCallback? onBack;

  const AddSavingScreen({
    super.key,
    required this.financialGoalId,
    this.savingId,
    this.onBack,
  });

  @override
  State<AddSavingScreen> createState() => _AddSavingScreenState();
}

class _AddSavingScreenState extends State<AddSavingScreen> {
  final amountController = TextEditingController();
  final titleController = TextEditingController();
  final messageController = TextEditingController();
  final storage = const FlutterSecureStorage();
  bool isLoading = false;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    if (widget.savingId != null) {
      _loadSaving();
    }
  }

  Future<void> _loadSaving() async {
    try {
      setState(() => isLoading = true);
      final storedEmail = await storage.read(key: 'user-mail');
      if (storedEmail == null) return;

      final saving = await SavingService.getById(widget.savingId!, storedEmail);
      titleController.text = saving.title;
      amountController.text = saving.value.toStringAsFixed(2);
      messageController.text = saving.description ?? '';
      selectedDate = DateTime.tryParse(saving.createdAt ?? '');
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Erro ao carregar depósito',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      setState(() => isLoading = false);
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
                  widget.savingId != null
                      ? 'Editar Receita'
                      : 'Adicionar Receita',
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
                child:
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : SingleChildScrollView(
                          padding: EdgeInsets.only(
                            bottom:
                                MediaQuery.of(context).viewInsets.bottom + 40,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const FormLabel("Data"),
                              DatePickerField(
                                hintText: 'Data do depósito',
                                initialDate: selectedDate,
                                onDateSelected: (picked) {
                                  setState(() => selectedDate = picked);
                                },
                              ),
                              const SizedBox(height: 16),
                              const FormLabel("Título"),
                              CustomTextField(
                                hintText: 'Ex: Salário, Bônus, etc.',
                                controller: titleController,
                              ),
                              const SizedBox(height: 16),
                              const FormLabel("Descrição"),
                              CustomTextField(
                                hintText: 'Opcional',
                                controller: messageController,
                              ),
                              const SizedBox(height: 16),
                              const FormLabel("Valor"),
                              CustomTextField(
                                hintText: 'R\$ Informe o valor recebido',
                                controller: amountController,
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(height: 16),
                              PrimaryButton(
                                text: 'Salvar',
                                onPressed: _handleSubmit,
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

  Future<void> _handleSubmit() async {
    if (amountController.text.isEmpty || titleController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Preencha os campos obrigatórios',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    if (selectedDate == null) {
      Fluttertoast.showToast(
        msg: 'Selecione uma data válida',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    try {
      final parsedValue =
          double.tryParse(amountController.text.replaceAll(',', '.')) ?? 0.0;
      final storedEmail = await storage.read(key: 'user-mail');
      if (storedEmail == null) {
        Fluttertoast.showToast(
          msg: 'Usuário não autenticado.',
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return;
      }

      final saving = Saving(
        value: parsedValue,
        financialGoalId: widget.financialGoalId,
        description: messageController.text,
        title: titleController.text,
        email: storedEmail,
        createdAt: selectedDate!.toUtc().toIso8601String(),
      );

      final savingUpdate = Saving(
        value: parsedValue,
        financialGoalId: widget.financialGoalId,
        description: messageController.text,
        title: titleController.text,
        createdAt: selectedDate!.toUtc().toIso8601String(),
      );

      if (widget.savingId != null) {
        await SavingService.update(widget.savingId!, savingUpdate);
        Fluttertoast.showToast(
          msg: 'Depósito atualizado com sucesso!',
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      } else {
        await SavingService.create(saving);
        Fluttertoast.showToast(
          msg: 'Depósito salvo com sucesso!',
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      }

      widget.onBack?.call();
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Erro ao salvar receita: ${e.toString()}',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
}

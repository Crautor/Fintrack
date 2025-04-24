import 'package:fintrack/components/inputs/custom_text_area.dart';
import 'package:fintrack/components/inputs/custom_text_field.dart';
import 'package:fintrack/components/inputs/date_picker_text_field.dart';
import 'package:fintrack/components/texts/form_label.dart';
import 'package:flutter/material.dart';
import 'package:fintrack/components/buttons/primary_button.dart';
import 'package:fintrack/components/headers/form_header.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  DateTime? selectedDate;
  String? selectedCategory;

  final amountController = TextEditingController();
  final titleController = TextEditingController();
  final messageController = TextEditingController();

  final List<String> categories = [
    'Food',
    'Transport',
    'Shopping',
    'Health',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00D09E),
      body: SafeArea(
        child: Column(
          children: [
            const FormHeader(title: 'Add Expenses'),
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

                      const FormLabel("Categoria"),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDFF7E2),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: selectedCategory,
                          hint: const Text(
                            'Selecione a categoria',
                            style: TextStyle(color: Color(0xFF093030)),
                          ),
                          items:
                              categories.map((String category) {
                                return DropdownMenuItem<String>(
                                  value: category,
                                  child: Text(category),
                                );
                              }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCategory = value;
                            });
                          },
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          icon: const Icon(Icons.keyboard_arrow_down_rounded),
                          dropdownColor: const Color(0xFFDFF7E2),
                        ),
                      ),
                      const SizedBox(height: 16),

                      const FormLabel("Valor"),
                      CustomTextField(
                        hintText: '\$ Informe o valor gasto',
                        controller: amountController,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),

                      const FormLabel("Titulo da Despesa"),
                      CustomTextField(
                        hintText: 'Informe o titulo da despesa',
                        controller: titleController,
                      ),
                      const SizedBox(height: 16),

                      const FormLabel("Mensagem"),
                      CustomTextArea(
                        hintText: 'Digite uma mensagem',
                        controller: messageController,
                      ),

                      
                      const SizedBox(height: 24),

                      PrimaryButton(
                        text: 'Save',
                        onPressed: () {
                          // salvar gasto
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

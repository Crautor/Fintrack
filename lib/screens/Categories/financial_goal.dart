import 'package:fintrack/components/inputs/custom_text_field.dart';
import 'package:fintrack/components/inputs/custom_icon_picker_field.dart';
import 'package:flutter/material.dart';
import 'package:fintrack/utils/icons.dart';
import 'package:fintrack/models/Financial_Goal/financial_goal.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FinancialGoalModal extends StatefulWidget {
  final void Function(FinancialGoal) onSave;

  const FinancialGoalModal({super.key, required this.onSave});

  @override
  State<FinancialGoalModal> createState() => _FinancialGoalModalState();
}

class _FinancialGoalModalState extends State<FinancialGoalModal> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  CategoryIcon? _selectedIcon;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Nova Meta Financeira',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF093030),
                ),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hintText: 'Título da meta...',
                controller: _titleController,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hintText: 'Descrição...',
                controller: _descriptionController,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hintText: 'Valor da meta (R\$)',
                controller: _valueController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              CustomIconPickerField(
                selectedIcon: _selectedIcon,
                onTap: () => _openIconPicker(context),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final title = _titleController.text.trim();
                  final value = double.tryParse(_valueController.text.trim());
                  final description = _descriptionController.text.trim();

                  if (title.isNotEmpty &&
                      value != null &&
                      _selectedIcon != null) {
                    final storage = FlutterSecureStorage();
                    final userId = await storage.read(key: 'user-mail');

                    // if (userId == null) {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(
                    //       content: Text(
                    //         'Usuário não encontrado. Faça login novamente.',
                    //       ),
                    //       backgroundColor: Colors.red,
                    //     ),
                    //   );
                    //   return;
                    // }

                    final goal = FinancialGoal(
                      title: title,
                      value: value,
                      description: description,
                      iconId: _selectedIcon!.id,
                      // userId: userId,
                    );

                    widget.onSave(goal);
                    if (context.mounted) Navigator.pop(context);
                  }
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00C49A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Salvar',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDFF7E2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(
                    color: Color(0xFF093030),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openIconPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SizedBox(
          height: 400,
          child: GridView.count(
            crossAxisCount: 4,
            padding: const EdgeInsets.all(16),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children:
                categoryIcons.map((icon) {
                  final isSelected = _selectedIcon?.id == icon.id;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedIcon = icon);
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? const Color(0xFF0075FF)
                                : const Color(0xFFB2D8FF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Icon(icon.icon, color: Colors.white, size: 28),
                      ),
                    ),
                  );
                }).toList(),
          ),
        );
      },
    );
  }
}

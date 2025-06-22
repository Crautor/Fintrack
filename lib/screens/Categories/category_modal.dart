import 'package:fintrack/components/inputs/custom_text_field.dart';
import 'package:fintrack/components/inputs/custom_icon_picker_field.dart';
import 'package:flutter/material.dart';
import 'package:fintrack/utils/icons.dart';

class CategoryModal extends StatefulWidget {
  final void Function(String name, CategoryIcon icon) onSave;
  final String? initialName;
  final int? initialIconId;

  const CategoryModal({
    super.key,
    required this.onSave,
    this.initialName,
    this.initialIconId,
  });

  @override
  State<CategoryModal> createState() => _CategoryModalState();
}

class _CategoryModalState extends State<CategoryModal> {
  final TextEditingController _nameController = TextEditingController();
  CategoryIcon? _selectedIcon;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialName ?? '';
    if (widget.initialIconId != null) {
      _selectedIcon = categoryIcons.firstWhere(
        (icon) => icon.id == widget.initialIconId,
        orElse: () => categoryIcons.first,
      );
    }
  }

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
              Text(
                widget.initialName != null
                    ? 'Editar Categoria'
                    : 'Nova Categoria',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF093030),
                ),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hintText: 'Nome da categoria...',
                controller: _nameController,
              ),
              const SizedBox(height: 20),
              CustomIconPickerField(
                selectedIcon: _selectedIcon,
                onTap: () => _openIconPicker(context),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_nameController.text.isNotEmpty &&
                      _selectedIcon != null) {
                    widget.onSave(_nameController.text, _selectedIcon!);
                    Navigator.pop(context);
                  } else {
                    print('[DEBUG] Campos inválidos - onSave NÃO chamado');
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

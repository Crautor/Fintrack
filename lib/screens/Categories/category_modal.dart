import 'package:fintrack/components/inputs/custom_text_field.dart';
import 'package:fintrack/components/inputs/custom_icon_picker_field.dart';
import 'package:flutter/material.dart';
import 'package:fintrack/utils/icons.dart';

class CategoryModal extends StatefulWidget {
  final void Function(String name, CategoryIcon icon) onSave;

  const CategoryModal({super.key, required this.onSave});

  @override
  State<CategoryModal> createState() => _CategoryModalState();
}

class _CategoryModalState extends State<CategoryModal> {
  final TextEditingController _nameController = TextEditingController();
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
                'New Category',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF093030),
                ),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hintText: 'Write...',
                controller: _nameController,
              ),
              const SizedBox(height: 20),
              CustomIconPickerField(
                selectedIcon: _selectedIcon,
                onTap: () {
                  _openIconPicker(context);
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_nameController.text.isNotEmpty && _selectedIcon != null) {
                    widget.onSave(_nameController.text, _selectedIcon!);
                    Navigator.pop(context);
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
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDFF7E2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Cancel',
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
            children: categoryIcons.map((icon) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIcon = icon;
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: _selectedIcon?.id == icon.id
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

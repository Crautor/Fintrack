import 'package:flutter/material.dart';
import 'package:fintrack/utils/icons.dart'; // onde tá o categoryIcons

class CustomIconPickerField extends StatelessWidget {
  final CategoryIcon? selectedIcon;
  final VoidCallback onTap;

  const CustomIconPickerField({
    super.key,
    this.selectedIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFDFF7E2),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            selectedIcon != null
                ? Icon(selectedIcon!.icon, color: const Color(0xFF093030), size: 28)
                : const Icon(Icons.category, color: Color(0xFF093030), size: 28),
            const SizedBox(width: 12),
            Text(
              selectedIcon?.label ?? 'Select Icon...',
              style: const TextStyle(color: Color(0xFF093030)),
            ),
            const Spacer(),
            const Icon(Icons.arrow_drop_down, color: Color(0xFF093030)),
          ],
        ),
      ),
    );
  }
}

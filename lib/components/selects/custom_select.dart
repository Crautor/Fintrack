import 'package:flutter/material.dart';
import 'package:fintrack/components/texts/form_label.dart';

class CustomSelect<T> extends StatelessWidget {
  final String? label;
  final String hintText;
  final List<T> items;
  final T? value;
  final ValueChanged<T?> onChanged;

  const CustomSelect({
    super.key,
    this.label,
    required this.hintText,
    required this.items,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[FormLabel(label!)],
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFDFF7E2),
            borderRadius: BorderRadius.circular(30),
          ),
          child: DropdownButtonFormField<T>(
            value: value,
            hint: Text(
              hintText,
              style: const TextStyle(color: Color(0xFF093030)),
            ),
            style: const TextStyle(
              color: Color(0xFF093030),
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),

            items:
                items.map((item) {
                  return DropdownMenuItem<T>(
                    value: item,
                    child: Text(item.toString()),
                  );
                }).toList(),
            onChanged: onChanged,
            decoration: const InputDecoration(border: InputBorder.none),
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
            dropdownColor: const Color(0xFFDFF7E2),
          ),
        ),
      ],
    );
  }
}

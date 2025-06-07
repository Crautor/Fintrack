import 'package:flutter/material.dart';

class CustomSelectField<T> extends StatelessWidget {
  final String hintText;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?> onChanged;

  const CustomSelectField({
    super.key,
    required this.hintText,
    required this.items,
    required this.onChanged,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFF093030)),
        filled: true,
        fillColor: const Color(0xFFDFF7E2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      dropdownColor: const Color(0xFFDFF7E2),
      style: const TextStyle(color: Color(0xFF093030)),
      icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF093030)),
    );
  }
}

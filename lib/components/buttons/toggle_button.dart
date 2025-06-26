import 'package:flutter/material.dart';

class ToggleButton extends StatelessWidget {
  final List<bool> isSelected;
  final List<String> toggleLabels;
  final void Function(int index) onToggle;

  const ToggleButton({
    super.key,
    required this.isSelected,
    required this.toggleLabels,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      isSelected: isSelected,
      onPressed: onToggle,
      borderRadius: BorderRadius.circular(10),
      selectedColor: Colors.white,
      fillColor: const Color(0xFF00D084),
      color: Colors.black87,
      constraints: const BoxConstraints(minWidth: 78, minHeight: 40),
      children:
          toggleLabels
              .map((label) => Text(label, style: const TextStyle(fontSize: 16)))
              .toList(),
    );
  }
}

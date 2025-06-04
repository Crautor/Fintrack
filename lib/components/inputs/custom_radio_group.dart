import 'package:flutter/material.dart';

class CustomRadioGroup extends StatelessWidget {
  final String label;
  final String? selectedValue;
  final ValueChanged<String> onChanged;
  final List<String> options;

  const CustomRadioGroup({
    super.key,
    required this.label,
    required this.selectedValue,
    required this.onChanged,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF093030),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:
              options.map((option) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () => onChanged(option),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio<String>(
                          value: option,
                          groupValue: selectedValue,
                          onChanged: (value) {
                            if (value != null) {
                              onChanged(value);
                            }
                          },
                          activeColor: const Color(0xFF00D09E),
                          visualDensity: const VisualDensity(
                            horizontal: -4,
                            vertical: -4,
                          ),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                        Text(option),
                      ],
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }
}

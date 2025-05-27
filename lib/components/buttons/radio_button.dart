import 'package:flutter/material.dart';

class CustomRadioGroup<T> extends StatelessWidget {
  final String label;
  final List<CustomRadioOption<T>> options;
  final T? selectedValue;
  final ValueChanged<T> onChanged;
  final bool isHorizontal;

  const CustomRadioGroup({
    super.key,
    required this.label,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
    this.isHorizontal = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Color(0xFF263238),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Wrap(
            spacing: 30,
            direction: isHorizontal ? Axis.horizontal : Axis.vertical,
            children:
                options.map((option) {
                  final isSelected = option.value == selectedValue;

                  return InkWell(
                    onTap: () => onChanged(option.value),
                    borderRadius: BorderRadius.circular(24),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF00D09E),
                              width: 2,
                            ),
                          ),
                          child:
                              isSelected
                                  ? Center(
                                    child: Container(
                                      width: 10,
                                      height: 10,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFF00D09E),
                                      ),
                                    ),
                                  )
                                  : null,
                        ),
                        Text(
                          option.label,
                          style: TextStyle(
                            fontSize: 14,
                            color:
                                isSelected
                                    ? const Color(0xFF00D09E)
                                    : Colors.grey[800],
                            fontWeight:
                                isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }
}

class CustomRadioOption<T> {
  final String label;
  final T value;

  const CustomRadioOption({required this.label, required this.value});
}

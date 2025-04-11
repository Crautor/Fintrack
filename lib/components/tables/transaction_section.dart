import 'package:fintrack/components/tables/transaction_tile.dart';
import 'package:fintrack/models/transaction_item_data.dart';
import 'package:flutter/material.dart';

class TransactionSection extends StatelessWidget {
  final List<String> toggleLabels;
  final List<bool> isSelected;
  final void Function(int index) onToggle;
  final List<TransactionItemData> transactions;

  const TransactionSection({
    super.key,
    required this.toggleLabels,
    required this.isSelected,
    required this.onToggle,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: ToggleButtons(
            isSelected: isSelected,
            onPressed: onToggle,
            borderRadius: BorderRadius.circular(10),
            selectedColor: Colors.white,
            fillColor: const Color(0xFF00D084),
            color: Colors.black87,
            constraints: const BoxConstraints(minWidth: 120, minHeight: 40),
            children:
                toggleLabels
                    .map(
                      (label) =>
                          Text(label, style: const TextStyle(fontSize: 16)),
                    )
                    .toList(),
          ),
        ),
        const SizedBox(height: 20),
        ...transactions.map((tx) => TransactionTile(data: tx)).toList(),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fintrack/models/Transaction/transaction.dart';
import 'package:fintrack/components/cards/transactions/transaction_card.dart';
import 'package:fintrack/components/buttons/toggle_button.dart';

class TransactionSection extends StatelessWidget {
  final List<String> toggleLabels;
  final List<bool> isSelected;
  final void Function(int index) onToggle;
  final List<TransactionItem> transactions;

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
          child: ToggleButton(
            isSelected: isSelected,
            toggleLabels: toggleLabels,
            onToggle: onToggle,
          ),
        ),
        const SizedBox(height: 20),
        ...transactions.map(
          (tx) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TransactionCard(item: tx),
          ),
        ),
      ],
    );
  }
}

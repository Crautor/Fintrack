import 'package:fintrack/models/Transaction/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionCard extends StatelessWidget {
  final TransactionItem item;

  const TransactionCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final date = DateTime.parse(item.transactionDate);
    final formattedDate = DateFormat('dd MMM').format(date);
    final formattedTime = DateFormat('HH:mm').format(date);
    final isIncome = item.type.toLowerCase() == 'income';

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isIncome ? const Color(0xFFD4F8E8) : const Color(0xFFE8F4FF),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isIncome ? Icons.arrow_downward : Icons.arrow_upward,
            color: isIncome ? Colors.green : Colors.red,
          ),
        ),
        const SizedBox(width: 12),

        // Detalhes principais
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.description ?? 'Sem descrição',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '$formattedTime – $formattedDate',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                'Categoria ${item.categoryId}',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),

        // Valor
        Text(
          '${isIncome ? '+' : '-'} R\$${item.value.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isIncome ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }
}

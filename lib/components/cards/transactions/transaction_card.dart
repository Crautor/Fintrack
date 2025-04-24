import 'package:fintrack/models/Transaction/list_transaction.dart';
import 'package:flutter/material.dart';


class TransactionCard extends StatelessWidget {
  final TransactionItem item;

  const TransactionCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            color: Color(0xFFB8EFFF),
            shape: BoxShape.circle,
          ),
          child: Icon(item.icon, color: Colors.blue[800]),
        ),
        const SizedBox(width: 12),

        // Detalhes principais
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${item.time} – ${item.date}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                item.category,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),

        // Valor
        Text(
          '${item.isIncome ? '+' : '-'} R\$${item.amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: item.isIncome ? Colors.green : Colors.blue,
          ),
        ),
      ],
    );
  }
}

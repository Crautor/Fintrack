import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionItemData {
  final IconData icon;
  final String label;
  final String? labelTime;
  final String time;
  final String category;
  final String amount;
  final Color amountColor;

  TransactionItemData({
    required this.icon,
    required this.label,
    this.labelTime,
    required this.time,
    required this.category,
    required this.amount,
    required this.amountColor,
  });

  factory TransactionItemData.fromApi(Map<String, dynamic> json) {
    final parsed = DateTime.tryParse(json['transactionDate']!);

    return TransactionItemData(
      icon: json['category']['icon'] ?? Icons.help_outline,
      label: json['description'] ?? 'Sem descrição',
      labelTime:
          parsed != null
              ? DateFormat('dd/MM/yyyy - HH:mm').format(parsed.toLocal())
              : '',
      time: parsed?.toString().split(' ').first ?? '',
      category: json['category']['name'] ?? '',
      amount:
          (json['type'] == 'Income' ? '' : '-') +
          '\$${json['value'].toStringAsFixed(2)}',
      amountColor: json['type'] == 'Income' ? Colors.black : Colors.blue,
    );
  }
}

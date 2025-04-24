import 'package:flutter/material.dart';

class TransactionItem {
  final String title;
  final String time;
  final String date;
  final String category;
  final double amount;
  final IconData icon;
  final bool isIncome;

  TransactionItem({
    required this.title,
    required this.time,
    required this.date,
    required this.category,
    required this.amount,
    required this.icon,
    this.isIncome = false,
  });
}

import 'package:flutter/material.dart';

class TransactionItemData {
  final IconData icon;
  final String label;
  final String time;
  final String category;
  final String amount;
  final Color amountColor;

  TransactionItemData({
    required this.icon,
    required this.label,
    required this.time,
    required this.category,
    required this.amount,
    required this.amountColor,
  });
}

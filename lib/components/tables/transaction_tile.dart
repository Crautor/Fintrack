import 'package:fintrack/models/transaction_item_data.dart';
import 'package:flutter/material.dart';

class TransactionTile extends StatelessWidget {
  final TransactionItemData data;

  const TransactionTile({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue.shade100,
        child: Icon(data.icon, color: Colors.blue),
      ),
      title: Text(data.label),
      subtitle: Text("${data.time} • ${data.category}"),
      trailing: Text(
        data.amount,
        style: TextStyle(
          color: data.amountColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

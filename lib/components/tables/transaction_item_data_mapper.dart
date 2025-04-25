import 'package:fintrack/models/Transaction/list_transaction.dart';
import 'package:fintrack/models/transaction_item_data.dart';

extension TransactionItemDataMapper on TransactionItemData {
  TransactionItem toTransactionItem() {
    final parsedAmount = double.tryParse(
      amount.replaceAll(RegExp(r'[^\d,.-]'), '').replaceAll(',', '.'),
    ) ?? 0.0;

    return TransactionItem(
      icon: icon,
      title: label,
      time: time.split(" - ").first.trim(),
      date: time.split(" - ").last.trim(),
      category: category,
      amount: parsedAmount.abs(),
      isIncome: parsedAmount >= 0,
    );
  }
} 

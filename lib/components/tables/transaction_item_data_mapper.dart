import 'package:fintrack/models/Transaction/list_transaction.dart';
import 'package:fintrack/models/transaction_item_data.dart';

extension TransactionItemDataMapper on TransactionItemData {
  TransactionItem toTransactionItem() {
    final sanitized = amount.replaceAll(RegExp(r'[^\d.,-]'), '');
    final noThousandsSeparator = sanitized.replaceAll(
      RegExp(r'(?<=\d)[.,](?=\d{3})'),
      '',
    );
    final normalized = noThousandsSeparator.replaceAll(',', '.');

    final parsedAmount = double.tryParse(normalized);

    return TransactionItem(
      icon: icon,
      title: label,
      time: time.split(" - ").first.trim(),
      date: time.split(" - ").last.trim(),
      category: category,
      amount: parsedAmount?.abs() ?? 0.0,
      isIncome: (parsedAmount ?? 0) >= 0,
    );
  }
}

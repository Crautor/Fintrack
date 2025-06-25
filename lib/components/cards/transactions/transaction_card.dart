import 'package:fintrack/models/Transaction/transaction.dart';
import 'package:fintrack/services/CategoryService/category_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class TransactionCard extends StatelessWidget {
  final TransactionItem item;
  final storage = const FlutterSecureStorage();

  const TransactionCard({super.key, required this.item});

  Future<String?> getCategoryName(int id) async {
    try {
      final storedEmail = await storage.read(key: 'user-mail');
      if (storedEmail == null) {
        return 'Desconhecida';
      }
      final result = await CategoryService.getCategoryById(
        item.categoryId,
        storedEmail,
      );
      return result?.name ?? 'Desconhecida';
    } catch (e) {
      print('[ERROR] getCategoryById → $e');
      return 'Desconhecida';
    }
  }

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
              FutureBuilder<String?>(
                future: getCategoryName(item.categoryId),
                builder: (context, snapshot) {
                  final category = snapshot.data ?? 'Carregando...';
                  return Text(category, style: const TextStyle(fontSize: 12));
                },
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

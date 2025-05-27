import 'package:flutter/material.dart';
import 'package:fintrack/components/headers/default_header.dart';
import 'package:fintrack/components/overviews/general_overview.dart';
import 'package:fintrack/utils/icons.dart';

class CategoryDetailPage extends StatelessWidget {
  final int currentIndex = 3;
  final String categoryLabel;
  final int categoryId;
  final int iconId;
  final VoidCallback? onAddTransictions;


  final List<Map<String, dynamic>> expenses = [
    {'title': 'Jantar', 'time': '18:27', 'date': 'April 30', 'value': 26.00},
    {
      'title': 'Delivery Pizza',
      'time': '15:00',
      'date': 'April 24',
      'value': 18.35,
    },
    {'title': 'Almoço', 'time': '12:30', 'date': 'April 15', 'value': 15.40},
    {
      'title': 'Café Da Manhã',
      'time': '09:30',
      'date': 'April 08',
      'value': 12.13,
    },
    {'title': 'Jantar', 'time': '20:50', 'date': 'March 31', 'value': 27.20},
  ];

  CategoryDetailPage({
    super.key,
    required this.categoryLabel,
    required this.categoryId,
    required this.iconId,
    this.onAddTransictions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FFFB),

      body: Column(
        children: [
          DefaultHeader(
            title: categoryLabel,
            isBackButtonVisible: true,
            child: GeneralOverview(
              balance: 7783.00,
              expense: 1187.40,
              goal: 20000.00,
              percentage: 0.30,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: [
                  _buildTransictionsSection("Abril", expenses.sublist(0, 4)),
                  const SizedBox(height: 20),
                  _buildTransictionsSection("Março", expenses.sublist(4)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00D09E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: onAddTransictions,
                    child: const Text(
                      "Adicionar Transação",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransictionsSection(String month, List<Map<String, dynamic>> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          month,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...items.map((item) => _buildTransictionsItem(item)).toList(),
      ],
    );
  }

  Widget _buildTransictionsItem(Map<String, dynamic> item) {
    final categoryIcon = getCategoryIconById(iconId);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFE1F3FF),
            child: Icon(
              categoryIcon?.icon ?? Icons.help_outline,
              color: const Color(0xFF187DFE),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${item['time']} – ${item['date']}",
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
          ),
          Text(
            "-\$${item['value'].toStringAsFixed(2)}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF187DFE),
            ),
          ),
        ],
      ),
    );
  }
}

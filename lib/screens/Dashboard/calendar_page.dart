import 'package:fintrack/components/graph/pizza.dart';
import 'package:fintrack/models/Transaction/list_transaction.dart';
import 'package:flutter/material.dart';
import 'package:fintrack/components/headers/default_header.dart';
import 'package:fintrack/components/calendar/custom_calendar.dart';
import 'package:fintrack/components/buttons/toggle_button_calendar.dart';
import 'package:fintrack/components/cards/transactions/transaction_card.dart';

class CalendarPage extends StatefulWidget {
  final VoidCallback onBack;

  const CalendarPage({super.key, required this.onBack});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  bool showCategories = false;

  final List<TransactionItem> spends = [
    TransactionItem(
      title: 'Padaria',
      time: '08:30',
      date: '04/06/2025',
      category: 'Alimentação',
      amount: 12.50,
      icon: Icons.local_cafe,
      isIncome: false,
    ),
    TransactionItem(
      title: 'Uber',
      time: '14:00',
      date: '04/06/2025',
      category: 'Transporte',
      amount: 22.80,
      icon: Icons.directions_car,
      isIncome: false,
    ),
  ];

  List<CategoryData> _getCategoryData() {
    return [
      CategoryData(id: '1', name: 'Alimentação', percentage: 35),
      CategoryData(id: '2', name: 'Educação', percentage: 25),
      CategoryData(id: '3', name: 'Saúde', percentage: 20),
      CategoryData(id: '4', name: 'Outros', percentage: 20),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00D09E),
      body: Column(
        children: [
          DefaultHeader(
            title: "Calendar",
            isBackButtonVisible: true,
            onBack: widget.onBack,
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                children: [
                  CustomCalendar(
                    onDateSelected: (date) {
                      print('Data selecionada: $date');
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ToggleButton(
                          text: "Spends",
                          isActive: !showCategories,
                          onPressed:
                              () => setState(() => showCategories = false),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ToggleButton(
                          text: "Categories",
                          isActive: showCategories,
                          onPressed:
                              () => setState(() => showCategories = true),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  showCategories
                      ? PizzaChart(data: _getCategoryData())
                      : Column(
                        children:
                            spends
                                .map(
                                  (item) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    child: TransactionCard(item: item),
                                  ),
                                )
                                .toList(),
                      ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

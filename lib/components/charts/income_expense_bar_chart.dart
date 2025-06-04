import 'package:fintrack/models/transaction_item_data.dart';
import 'package:fintrack/screens/Dashboard/calendar_page.dart';
import 'package:fintrack/screens/Dashboard/search_page.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class IncomeExpenseBarChart extends StatelessWidget {
  final List<TransactionItemData> transactions;
  final String viewType;

  const IncomeExpenseBarChart({
    super.key,
    required this.transactions,
    required this.viewType,
  });

  Map<String, Map<String, double>> groupTransactionsByPeriod({
    required List<TransactionItemData> transactions,
    required String periodType,
  }) {
    Map<String, Map<String, double>> grouped = {};

    for (var tx in transactions) {
      DateTime date = DateTime.parse(tx.time);
      String periodKey;

      switch (periodType) {
        case "daily":
          periodKey = _getWeekdayAbbreviation(date.weekday);
          break;
        case "weekly":
          int week = ((date.day - 1) ~/ 7) + 1;
          switch (week) {
            case 1:
              periodKey = '1st';
              break;
            case 2:
              periodKey = '2nd';
              break;
            case 3:
              periodKey = '3rd';
              break;
            case 4:
              periodKey = '4th';
              break;
            default:
              periodKey = '';
          }
          break;
        case "monthly":
          periodKey = _getMonthAbbreviation(date.month);
          break;
        case "yearly":
          periodKey = date.year.toString();
          break;
        default:
          periodKey = '';
      }

      final sanitized = tx.amount.replaceAll(RegExp(r'[^\d.,-]'), '');
      final noThousandsSeparator = sanitized.replaceAll(
        RegExp(r'(?<=\d)[.,](?=\d{3})'),
        '',
      );
      final normalized = noThousandsSeparator.replaceAll(',', '.');
      final amount = double.tryParse(normalized) ?? 0;

      String category = amount >= 0 ? 'income' : 'expense';

      grouped.putIfAbsent(periodKey, () => {'income': 0, 'expense': 0});
      grouped[periodKey]![category] =
          grouped[periodKey]![category]! + amount.abs();
    }

    return grouped;
  }

  String _getWeekdayAbbreviation(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[(weekday - 1) % 7];
  }

  List<String> getLabels() {
    final now = DateTime.now();
    switch (viewType) {
      case 'daily':
        return ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
      case 'weekly':
        return ['1st', '2nd', '3rd', '4th'];
      case 'monthly':
        List<String> months = [];
        for (int i = 5; i >= 0; i--) {
          DateTime date = DateTime(now.year, now.month - i);
          months.add(_getMonthAbbreviation(date.month));
        }
        return months;
      case 'yearly':
        int currentYear = now.year;
        return [
          '${currentYear - 3}',
          '${currentYear - 2}',
          '${currentYear - 1}',
          '$currentYear',
        ];
      default:
        return [];
    }
  }

  List<BarChartGroupData> getBarGroups(
    Map<String, Map<String, double>> grouped,
    List<String> labels,
  ) {
    return List.generate(labels.length, (index) {
      final period = labels[index];
      final income = grouped[period]?['income'] ?? 0;
      final expense = grouped[period]?['expense'] ?? 0;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: income,
            color: Colors.green,
            width: 15,
            borderRadius: BorderRadius.circular(4),
          ),
          BarChartRodData(
            toY: expense,
            color: Colors.blue,
            width: 15,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    });
  }

  String _getMonthAbbreviation(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  String formatNumber(double value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}k';
    } else {
      return value.toStringAsFixed(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final grouped = groupTransactionsByPeriod(
      transactions: transactions,
      periodType: viewType,
    );

    final labels = getLabels();
    final barGroups = getBarGroups(grouped, labels);

    double maxGroupedValue = 0;
    for (var entry in grouped.entries) {
      final income = entry.value['income'] ?? 0;
      final expense = entry.value['expense'] ?? 0;
      final localMax = income > expense ? income : expense;
      if (localMax > maxGroupedValue) {
        maxGroupedValue = localMax;
      }
    }

    final maxY = maxGroupedValue * 1.2;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Text(
                'Income & Expenses',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF00D084),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SearchPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.search, color: Colors.white),
                  tooltip: 'Search',
                  splashRadius: 20,
                  padding: EdgeInsets.zero,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF00D084),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CalendarPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.calendar_month, color: Colors.white),
                  tooltip: 'Calendar',
                  splashRadius: 20,
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AspectRatio(
            aspectRatio: 1.6,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: maxY / 4,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 12,
                          child: Text(
                            formatNumber(value),
                            style: const TextStyle(
                              fontSize: 10,
                              overflow: TextOverflow.visible,
                            ),
                            softWrap: false,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        int index = value.toInt();
                        if (index >= 0 && index < labels.length) {
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 4,
                            child: Text(
                              labels[index],
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: barGroups,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

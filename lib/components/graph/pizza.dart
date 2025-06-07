import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CategoryData {
  final String id;
  final String name;
  final double percentage;

  CategoryData({
    required this.id,
    required this.name,
    required this.percentage,
  });
}

class PizzaChart extends StatelessWidget {
  final List<CategoryData> data;

  const PizzaChart({super.key, required this.data});

  List<Color> _generateUniqueColors(int count) {
    final List<Color> colors = [];
    final random = Random();

    while (colors.length < count) {
      final color = Color.fromARGB(
        255,
        random.nextInt(200),
        random.nextInt(200),
        random.nextInt(200),
      );

      if (!colors.contains(color)) {
        colors.add(color);
      }
    }

    return colors;
  }

  @override
  Widget build(BuildContext context) {
    final colors = _generateUniqueColors(data.length);

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 2.0,
          child: PieChart(
            PieChartData(
              sectionsSpace: 4,
              centerSpaceRadius: 40,
              sections: List.generate(data.length, (index) {
                final item = data[index];
                return PieChartSectionData(
                  color: colors[index],
                  value: item.percentage,
                  title: '${item.name}\n${item.percentage.toStringAsFixed(0)}%',
                  radius: 50,
                  titleStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                );
              }),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 16,
          runSpacing: 8,
          children: List.generate(data.length, (index) {
            final item = data[index];
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 12, height: 12, color: colors[index]),
                const SizedBox(width: 6),
                Text(
                  '${item.name} – ${item.percentage.toStringAsFixed(0)}%',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}

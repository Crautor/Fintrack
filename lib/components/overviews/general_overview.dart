import 'package:flutter/material.dart';

class GeneralOverview extends StatelessWidget {
  final double balance;
  final double expense;
  final double? goal;
  final double? percentage;

  const GeneralOverview({
    super.key,
    required this.balance,
    required this.expense,
    this.goal,
    this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.trending_up, size: 16, color: Colors.black),
                      SizedBox(width: 4),
                      Text(
                        "Total Balance",
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "R\$${balance.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 40,
              width: 1,
              color: Colors.grey.shade300,
              margin: const EdgeInsets.symmetric(horizontal: 12),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.trending_down, size: 16, color: Colors.black),
                      SizedBox(width: 4),
                      Text(
                        "Total Expense",
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "-R\$${expense.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF187DFE),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (percentage != null && goal != null) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      height: 18,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: percentage!.clamp(0.0, 1.0),
                      child: Container(
                        height: 18,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: percentage!.clamp(0.0, 1.0),
                      child: Container(
                        height: 18,
                        alignment: Alignment.center,
                        child: Text(
                          "${(percentage! * 100).toStringAsFixed(0)}%",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "R\$${(goal ?? 0).toStringAsFixed(2)}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

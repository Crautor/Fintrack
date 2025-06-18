import 'package:flutter/material.dart';

class GoalProgressBar extends StatelessWidget {
  final double amountSaved;
  final double goalValue;

  const GoalProgressBar({
    super.key,
    required this.amountSaved,
    required this.goalValue,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (amountSaved / goalValue).clamp(0.0, 1.0);
    final percentageLabel = "${(percent * 100).toStringAsFixed(0)}%";

    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Container(
        height: 32,
        decoration: const BoxDecoration(color: Color.fromARGB(255, 1, 99, 71)),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: percent,
                child: Container(
                  decoration: const BoxDecoration(color: Color(0xFF00D09E)),
                ),
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      percentageLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "R\$ ${goalValue.toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

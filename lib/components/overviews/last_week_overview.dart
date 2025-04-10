import 'package:flutter/material.dart';

class LastWeekOverview extends StatelessWidget {
  final Color backgroundColor;
  final double revenue;
  final double expense;

  const LastWeekOverview({
    super.key,
    required this.backgroundColor,
    required this.revenue,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: const [
              Icon(Icons.directions_car, size: 30),
              Text("Savings\nOn Goals", textAlign: TextAlign.center),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Revenue Last Week",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "\$${revenue.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                "Food Last Week",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "-\$${expense.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

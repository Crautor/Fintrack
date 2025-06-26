import 'package:flutter/material.dart';

class GoalSummaryCard extends StatelessWidget {
  final double goalValue;
  final double amountSaved;
  final IconData icon;

  const GoalSummaryCard({
    super.key,
    required this.goalValue,
    required this.amountSaved,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (amountSaved / goalValue).clamp(0, 1).toDouble();
    final formattedGoal = goalValue.toStringAsFixed(2);
    final formattedSaved = amountSaved.toStringAsFixed(2);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.flag, size: 14),
                    SizedBox(width: 4),
                    Text("Meta:", style: TextStyle(fontSize: 14)),
                  ],
                ),
                Text(
                  "\$$formattedGoal",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: const [
                    Icon(Icons.savings_outlined, size: 14),
                    SizedBox(width: 4),
                    Text("Quantia\npoupada:", style: TextStyle(fontSize: 14)),
                  ],
                ),
                Text(
                  "\$$formattedSaved",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00B386),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 91, 171, 246),
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                SizedBox(
                  width: 90,
                  height: 90,
                  child: CircularProgressIndicator(
                    value: percent,
                    strokeWidth: 6,
                    backgroundColor: Colors.white,
                    valueColor: const AlwaysStoppedAnimation(
                      Color.fromARGB(255, 0, 66, 133),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(icon, size: 36, color: Colors.white)],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class TargetProgressCard extends StatelessWidget {
  final double percentage;
  final String title;

  const TargetProgressCard({
    super.key,
    required this.percentage,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width - 60) / 2,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF6DB6FE),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  value: percentage,
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    const Color(0xFF004FCC),
                  ),
                  backgroundColor: Colors.white,
                ),
              ),
              Text(
                '${(percentage * 100).toInt()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

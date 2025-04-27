import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const CategoryItem({
    super.key,
    required this.icon,
    required this.label,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min, 
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? const Color(0xFF0075FF)
                        : const Color(0xFFB2D8FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 36, 
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ToggleButton extends StatelessWidget {
  final String text;
  final bool isActive;
  final VoidCallback onPressed;

  const ToggleButton({
    super.key,
    required this.text,
    required this.isActive,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isActive ? const Color(0xFF00D09E) : const Color(0xFFE0F2EF),
          foregroundColor: isActive ? const Color(0xFF093030) : Colors.black54,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: isActive ? const Color(0xFF093030) : Colors.black54,
          ),
        ),
      ),
    );
  }
}

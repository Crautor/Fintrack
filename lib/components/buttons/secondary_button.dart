import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: const Color(0xFFDFF7E2),
        foregroundColor: const Color(0xFF1C1C1C),
        side: const BorderSide(color: Color(0xFFE0E0E0)),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF0E3E3E), 
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
    );
  }
}

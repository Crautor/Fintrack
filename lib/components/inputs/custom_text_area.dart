import 'package:flutter/material.dart';

class CustomTextArea extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final int maxLines;

  const CustomTextArea({
    super.key,
    required this.hintText,
    this.controller,
    this.maxLines = 5,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFF00D09E)),
        filled: true,
        fillColor: const Color(0xFFDFF7E2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

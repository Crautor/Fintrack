import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final bool isBackButtonVisible;
  final VoidCallback? onBack;

  const AuthHeader({
    super.key,
    required this.title,
    this.isBackButtonVisible = false,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 175,
      decoration: const BoxDecoration(
        color: Color(0xFF00D09E),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            if (isBackButtonVisible)
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: onBack ?? () => Navigator.pop(context),
                  ),
                ),
              ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0E3E3E),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

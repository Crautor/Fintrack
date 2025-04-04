import 'package:flutter/material.dart';

class OnBoardingHeader extends StatelessWidget {
  final String title;

  const OnBoardingHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 275,
      decoration: BoxDecoration(
        color: Color(0xFF00D09E),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: Color(0xFF0E3E3E),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

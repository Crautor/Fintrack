import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomNavBar({super.key, required this.currentIndex});

  void _navigate(BuildContext context, int index) {
    const routes = [
      '/home',
      '/dashboard',
      '/transactions',
      '/categories',
      '/profile',
    ];

    if (ModalRoute.of(context)?.settings.name != routes[index]) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        routes[index],
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconPaths = [
      'assets/images/home_icon.png',
      'assets/images/dashboard_icon.png',
      'assets/images/transactions_icon.png',
      'assets/images/categories_icon.png',
      'assets/images/profile_icon.png',
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xFFE9FFF9),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(5, (index) {
          final isSelected = index == currentIndex;

          return IconButton(
            onPressed: () => _navigate(context, index),
            icon: ColorFiltered(
              colorFilter: ColorFilter.mode(
                isSelected ? Colors.teal[800]! : Colors.grey[600]!,
                BlendMode.srcIn,
              ),
              child: Image.asset(
                iconPaths[index],
                width: 24,
                height: 24,
              ),
            ),
          );
        }),
      ),
    );
  }
}


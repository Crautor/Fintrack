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
    return Container(
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
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => _navigate(context, index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: Colors.teal[800],
        unselectedItemColor: Colors.grey[600],
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
                'assets/images/home_icon.png',
                width: 24,
                height: 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/dashboard_icon.png',
              width: 24,
              height: 24,
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/transactions_icon.png',
              width: 24,
              height: 24,
            ),
            label: 'Transações',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/categories_icon.png',
              width: 24,
              height: 24,
            ),
            label: 'Categorias',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/profile_icon.png',
              width: 24,
              height: 24,
            ),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

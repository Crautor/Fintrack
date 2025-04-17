import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFE9FFF9),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap, // agora usa o que vem do MainScreen
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: Colors.teal[800],
        unselectedItemColor: Colors.grey[600],
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    currentIndex == 0
                        ? const Color(0xFF00D09E)
                        : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'assets/images/home_icon.png',
                width: 24,
                height: 24,
              ),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    currentIndex == 1
                        ? const Color(0xFF00D09E)
                        : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'assets/images/dashboard_icon.png',
                width: 24,
                height: 24,
              ),
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    currentIndex == 2
                        ? const Color(0xFF00D09E)
                        : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'assets/images/transactions_icon.png',
                width: 24,
                height: 24,
              ),
            ),
            label: 'Transações',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    currentIndex == 3
                        ? const Color(0xFF00D09E)
                        : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'assets/images/categories_icon.png',
                width: 24,
                height: 24,
              ),
            ),
            label: 'Categorias',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    currentIndex == 4
                        ? const Color(0xFF00D09E)
                        : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'assets/images/profile_icon.png',
                width: 24,
                height: 24,
              ),
            ),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

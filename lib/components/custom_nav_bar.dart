import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  Widget _buildIcon(String asset, int index) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:
            currentIndex == index
                ? const Color(0xFF00D09E)
                : Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: Image.asset(asset, width: 24, height: 24),
    );
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
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap, // agora só controla o índice da aba
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: Colors.teal[800],
        unselectedItemColor: Colors.grey[600],
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: _buildIcon('assets/images/home_icon.png', 0),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon('assets/images/dashboard_icon.png', 1),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon('assets/images/transactions_icon.png', 2),
            label: 'Transações',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon('assets/images/categories_icon.png', 3),
            label: 'Categorias',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon('assets/images/profile_icon.png', 4),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

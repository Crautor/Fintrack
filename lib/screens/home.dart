import 'package:fintrack/components/headers/default_header.dart';
import 'package:fintrack/components/overviews/general_overview.dart';
import 'package:fintrack/components/overviews/last_week_overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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

  int _getCurrentIndex(BuildContext context) {
    final name = ModalRoute.of(context)?.settings.name;
    switch (name) {
      case '/home':
        return 0;
      case '/dashboard':
        return 1;
      case '/transactions':
        return 2;
      case '/categories':
        return 3;
      case '/profile':
        return 4;
      default:
        return 0;
    }
  }

  final Color mainGreen = const Color(0xFF00D084);
  final Color lightGreen = const Color(0xFFDAF7E9);

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getCurrentIndex(context);

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
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
              label: 'Categories',
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
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const DefaultHeader(
              title: 'Hi, Welcome Back',
              subtitle: 'Good Morning',
              isBackButtonVisible: false,
              child: GeneralOverview(
                balance: 7783.00,
                expense: 1187.40,
                goal: 20000.00,
                percentage: 0.3,
              ),
            ),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Color(0xFFDAF7E9)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  LastWeekOverview(
                    backgroundColor: Color(0xFFDAF7E9),
                    revenue: 4000.00,
                    expense: 100.00,
                  ),
                  const SizedBox(height: 20),
                  ToggleButtons(
                    isSelected: [false, false, true],
                    onPressed: (_) {},
                    borderRadius: BorderRadius.circular(10),
                    selectedColor: Colors.white,
                    fillColor: mainGreen,
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text("Daily"),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text("Weekly"),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text("Monthly"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const TransactionTile(
                    icon: Icons.payments,
                    label: "Salary",
                    time: "18:27 - April 30",
                    category: "Monthly",
                    amount: "\$4,000.00",
                    amountColor: Colors.black,
                  ),
                  const TransactionTile(
                    icon: Icons.shopping_cart,
                    label: "Groceries",
                    time: "17:00 - April 24",
                    category: "Pantry",
                    amount: "-\$100.00",
                    amountColor: Colors.blue,
                  ),
                  const TransactionTile(
                    icon: Icons.home,
                    label: "Rent",
                    time: "8:30 - April 15",
                    category: "Rent",
                    amount: "-\$674.40",
                    amountColor: Colors.blue,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String time;
  final String category;
  final String amount;
  final Color amountColor;

  const TransactionTile({
    required this.icon,
    required this.label,
    required this.time,
    required this.category,
    required this.amount,
    required this.amountColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue.shade100,
        child: Icon(icon, color: Colors.blue),
      ),
      title: Text(label),
      subtitle: Text("$time • $category"),
      trailing: Text(
        amount,
        style: TextStyle(
          color: amountColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

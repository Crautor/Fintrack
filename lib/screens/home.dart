import 'package:fintrack/components/headers/default_header.dart';
import 'package:fintrack/components/overviews/general_overview.dart';
import 'package:fintrack/components/overviews/last_week_overview.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final Color mainGreen = const Color(0xFF00D084);
  final Color lightGreen = const Color(0xFFDAF7E9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // trocar pelo componente de navbar depois
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        selectedItemColor: mainGreen,
        unselectedItemColor: Colors.grey[400],
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.compare_arrows), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.layers), label: ''),
        ],
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

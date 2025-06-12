import 'package:fintrack/components/headers/default_header.dart';
import 'package:fintrack/components/overviews/general_overview.dart';
import 'package:fintrack/components/overviews/last_week_overview.dart';
import 'package:fintrack/components/tables/transaction_section.dart';
import 'package:fintrack/models/transaction_item_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Color mainGreen = const Color(0xFF00D084);
  final Color lightGreen = const Color(0xFFDAF7E9);
  int selectedToggleIndex = 2;

  final List<TransactionItemData> dailyTransactions = [
    TransactionItemData(
      icon: Icons.coffee,
      label: "Coffee",
      time: "08:30 - April 10",
      category: "Food",
      amount: "-\$4.50",
      amountColor: Colors.blue,
    ),
    TransactionItemData(
      icon: Icons.bus_alert,
      label: "Bus",
      time: "09:00 - April 10",
      category: "Transport",
      amount: "-\$3.20",
      amountColor: Colors.blue,
    ),
  ];

  final List<TransactionItemData> weeklyTransactions = [
    TransactionItemData(
      icon: Icons.shopping_cart,
      label: "Supermarket",
      time: "17:00 - April 08",
      category: "Shopping",
      amount: "-\$150.00",
      amountColor: Colors.blue,
    ),
    TransactionItemData(
      icon: Icons.restaurant,
      label: "Lunch",
      time: "12:30 - April 07",
      category: "Restaurant",
      amount: "-\$25.00",
      amountColor: Colors.blue,
    ),
  ];

  final List<TransactionItemData> monthlyTransactions = [
    TransactionItemData(
      icon: Icons.payments,
      label: "Salary",
      time: "18:27 - April 01",
      category: "Revenue",
      amount: "\$4000.00",
      amountColor: Colors.black,
    ),
    TransactionItemData(
      icon: Icons.home,
      label: "Rent",
      time: "08:30 - April 05",
      category: "Fixed Expenses",
      amount: "-\$674.40",
      amountColor: Colors.blue,
    ),
  ];

  List<TransactionItemData> getSelectedTransactions() {
    switch (selectedToggleIndex) {
      case 0:
        return dailyTransactions;
      case 1:
        return weeklyTransactions;
      case 2:
      default:
        return monthlyTransactions;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadAndPrintAuthInfo();
  }
  
Future<void> _loadAndPrintAuthInfo() async {
  print('[DEBUG] Iniciando leitura dos tokens...');
  final storage = FlutterSecureStorage();
  final token = await storage.read(key: 'auth_token');
  final storedEmail = await storage.read(key: 'user-mail');

  print('[DEBUG] auth_token: $token');
  print('[DEBUG] user-mail: $storedEmail');
}
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: screenHeight,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFDAF7E9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const DefaultHeader(
              title: 'Hello, Welcome Back',
              subtitle: 'Good Morning',
              isBackButtonVisible: false,
              child: GeneralOverview(
                balance: 7783.00,
                expense: 1187.40,
                goal: 20000.00,
                percentage: 0.3,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      LastWeekOverview(
                        revenue: 4000.00,
                        expense: 100.00,
                        goalPercentage: 0.5,
                      ),
                      const SizedBox(height: 20),
                      TransactionSection(
                        toggleLabels: ["Daily", "Weekly", "Monthly"],
                        isSelected: List.generate(
                          3,
                          (index) => index == selectedToggleIndex,
                        ),
                        onToggle: (index) {
                          setState(() {
                            selectedToggleIndex = index;
                          });
                        },
                        transactions: getSelectedTransactions(),
                      ),
                    ],
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

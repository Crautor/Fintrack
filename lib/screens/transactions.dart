import 'package:flutter/material.dart';
import 'home.dart';
import 'package:fintrack/components/custom_nav_bar.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text('Transações')),
      bottomNavigationBar: CustomNavBar(currentIndex: 2),
    );
  }
}

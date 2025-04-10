import 'package:flutter/material.dart';
import 'home.dart';
import 'package:fintrack/components/custom_nav_bar.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text('Dashboard')),
      bottomNavigationBar: CustomNavBar(currentIndex: 1),
    );
  }
}

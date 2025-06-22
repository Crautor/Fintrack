import 'package:flutter/material.dart';
import 'package:fintrack/components/custom_nav_bar.dart';
import 'package:fintrack/screens/home.dart';
import 'package:fintrack/screens/Transactions/transiction.dart';
import 'package:fintrack/screens/profile.dart';
import 'package:fintrack/components/layout/DashboardTab/dashboard_tab.dart';
import 'package:fintrack/components/layout/CategoriesTab/categories_tab.dart';
import 'package:fintrack/screens/dashboard.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  static MainScreenState? of(BuildContext context) =>
      context.findAncestorStateOfType<MainScreenState>();

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  List<Widget> _buildPages() {
    return [
      HomePage(key: HomePage.globalKey),
      DashboardTab(key: DashboardPage.globalKey),
      TransactionsScreen(key: TransactionsScreen.globalKey),
      CategoriesTab(key: ValueKey(_currentIndex == 3 ? DateTime.now() : null)),
      ProfilePage(key: ProfilePage.globalKey),
    ];
  }

  void goTo(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _buildPages()),
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          if (index == 0) {
            HomePage.globalKey.currentState?.refreshData();
          }

          if (index == 1) {
            DashboardPage.globalKey.currentState?.refreshData();
          }
          if (index == 2) {
            TransactionsScreen.globalKey.currentState?.refreshData();
          }
          if (index == 4) {
            ProfilePage.globalKey.currentState?.loadUser();
          }
        },
      ),
    );
  }
}

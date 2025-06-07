import 'package:flutter/material.dart';
import 'package:fintrack/screens/Dashboard/calendar_page.dart';
import 'package:fintrack/screens/dashboard.dart';

class DashboardTab extends StatefulWidget {
  const DashboardTab({super.key});

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  String? currentView;

  void openCalendar() {
    setState(() {
      currentView = 'calendar';
    });
  }

  void backToDashboard() {
    setState(() {
      currentView = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentView == 'calendar') {
      return CalendarPage(
        onBack: backToDashboard,
      ); 
    }

    return DashboardPage(onCalendarPressed: openCalendar);
  }
}

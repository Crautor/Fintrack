import 'package:fintrack/components/headers/default_header.dart';
import 'package:flutter/material.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00D09E),
      body: Column(
        children: [
          const DefaultHeader(title: "Calendar", isBackButtonVisible: true),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Text("This is the Calendar Page"),
            ),
          ),
        ],
      ),
    );
  }
}

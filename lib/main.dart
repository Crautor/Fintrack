import 'package:fintrack/components/headers/default_header.dart';
import 'package:flutter/material.dart';
import 'screens/splash.dart';
import 'screens/home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          DefaultHeader(
            title: "Bem vindo",
            subtitle: "Bom Dia",
            isBackButtonVisible: false,
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

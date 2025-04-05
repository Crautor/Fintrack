import 'package:fintrack/screens/Launch/pre_login.dart';
import 'package:flutter/material.dart';
import 'screens/Launch/splash.dart';
import 'screens/home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinTrack',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/prelogin': (context) => const PreLoginScreen(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}

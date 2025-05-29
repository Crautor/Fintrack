import 'package:flutter/material.dart';
import 'routes/app.routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinTrack',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.prelogin,
      routes: AppRoutes.routes,
    );
  }
}

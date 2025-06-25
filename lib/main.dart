import 'package:flutter/material.dart';
import 'routes/app.routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/push_notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCcAdu5KxY3PJDEupWgUSmDYuFOEWbuI0Y",
      authDomain: "fintrack-server.firebaseapp.com",
      projectId: "fintrack-server",
      storageBucket: "fintrack-server.firebasestorage.app",
      messagingSenderId: "132077694198",
      appId: "1:132077694198:web:bc9f35b9a98430a2dd10d7",
      measurementId: "G-9L3TS7FRCP",
    ),
  );
  await PushNotificationService.initialize();
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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt', 'BR')],
      locale: const Locale('pt', 'BR'),
    );
  }
}

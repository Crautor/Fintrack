import 'package:flutter/material.dart';
import '../screens/home.dart';


class AppRoutes {
  static const String home = '/';
  static const String profile = '/profile';
  static const String settings = '/settings';

  static final Map<String, WidgetBuilder> routes = {
    home: (context) => const HomePage(),
  };
}

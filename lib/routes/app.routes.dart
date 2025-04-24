import 'package:fintrack/screens/Auth/login.dart';
import '../screens/Auth/terms_and_conditions.dart';
import 'package:flutter/material.dart';
import '../screens/home.dart';
import '../screens/Launch/pre_login.dart';
import '../screens/Auth/register.dart';
import '../screens/Auth/forgot_password.dart';
import '../screens/Auth/verification_code.dart';
import '../screens/Auth/new_password.dart';
import '../screens/Auth/password_sucess.dart';
import '../screens/dashboard.dart';
import '../screens/transactions.dart';
import '../screens/profile.dart';
import '../screens/categories.dart';
import '../screens/notifications.dart';

class AppRoutes {
  static const String prelogin = '/prelogin';
  static const String home = '/home';
  static const String termsAndConditions = '/terms-and-conditions';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String verificationCode = '/verify';
  static const String newPassword = '/new-password';
  static const String passwordSuccess = '/password-success';
  static const String dashboard = '/dashboard';
  static const String transactions = '/transactions';
  static const String profile = '/profile';
  static const String categories = '/categories';
  static const String notifications = '/notifications';

  static final Map<String, WidgetBuilder> routes = {
    prelogin: (context) => const PreLoginScreen(),
    home: (context) => const HomePage(),
    termsAndConditions: (context) => const TermsAndConditionsScreen(),
    dashboard: (context) => const DashboardPage(),
    transactions: (context) => const TransactionsPage(),
    profile: (context) => const ProfilePage(),
    categories: (context) => const CategoriesPage(),
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    forgotPassword: (context) => const ForgotPasswordScreen(),
    verificationCode: (context) => const VerificationCodeScreen(),
    newPassword: (context) => const NewPasswordScreen(),
    passwordSuccess: (context) => const PasswordSuccessScreen(),
    notifications: (context) => const NotificationsPage(),
  };
}

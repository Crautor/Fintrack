import 'package:flutter/material.dart';
import '../screens/Launch/splash.dart';
import '../screens/Launch/pre_login.dart';
import '../screens/Auth/login.dart';
import '../screens/Auth/register.dart';
import '../screens/Auth/forgot_password.dart';
import '../screens/Auth/verification_code.dart';
import '../screens/Auth/new_password.dart';
import '../screens/Auth/password_sucess.dart';
import '../components/layout/main_screen.dart'; // importa a tela principal com o navbar fixo

class AppRoutes {
  static const String splash = '/';
  static const String prelogin = '/prelogin';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String verificationCode = '/verify';
  static const String newPassword = '/new-password';
  static const String passwordSuccess = '/password-success';
  static const String main = '/main'; // tela principal com o nav bar

  static final Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    prelogin: (context) => const PreLoginScreen(),
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    forgotPassword: (context) => const ForgotPasswordScreen(),
    verificationCode: (context) => const VerificationCodeScreen(),
    newPassword: (context) => const NewPasswordScreen(),
    passwordSuccess: (context) => const PasswordSuccessScreen(),
    main: (context) => const MainScreen(), // essa é a rota principal com nav fixo
  };
}

import 'package:fintrack/services/push_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:fintrack/components/texts/form_label.dart';
import 'package:fintrack/routes/app.routes.dart';
import '../../../components/headers/auth_header.dart';
import '../../../components/buttons/primary_button.dart';
import '../../../components/buttons/secondary_button.dart';
import '../../../services/request_service.dart';
import '../../models/Auth/auth_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  final storage = FlutterSecureStorage();

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Preencha todos os campos.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    final loginRequest = LoginRequest(email: email, password: password);

    try {
      final response = await RequestService.post<LoginResponse>(
        'auth/login',
        loginRequest,
        LoginResponse.fromJson,
      );

      if (response.isSuccess) {
        await storage.write(key: 'user-mail', value: email);
        await storage.read(key: 'user-mail');
        final setCookie = response.headers['set-cookie'];

        final authToken = RegExp(
          r'auth_token=([^;]+)',
        ).firstMatch(setCookie ?? '')?.group(1);

        final refreshToken = RegExp(
          r'refresh_token=([^;]+)',
        ).firstMatch(setCookie ?? '')?.group(1);

        if (authToken != null) {
          await storage.write(key: 'auth_token', value: authToken);
        }
        if (refreshToken != null) {
          await storage.write(key: 'refresh_token', value: refreshToken);
        }

        await PushNotificationService.initialize();

        Fluttertoast.showToast(
          msg: response.data.message ?? "Login realizado com sucesso!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        if (!mounted) return;
        Navigator.pushReplacementNamed(context, AppRoutes.termsAndConditions);
      } else {
        Fluttertoast.showToast(
          msg: response.data.message ?? 'Erro ao fazer login.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      final cleanMessage = e.toString().replaceFirst('Exception: ', '');
      Fluttertoast.showToast(
        msg: cleanMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1FFF3),
      body: Column(
        children: [
          const AuthHeader(title: 'Bem Vindo'),
          const SizedBox(height: 32),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const FormLabel("Email"),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'exemplo@exemplo.com',
                      filled: true,
                      fillColor: const Color(0xFFDFF7E2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const FormLabel("Senha"),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: '********',
                      filled: true,
                      fillColor: const Color(0xFFDFF7E2),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 0),
                  TextButton(
                    onPressed:
                        () => Navigator.pushNamed(
                          context,
                          AppRoutes.forgotPassword,
                        ),
                    child: const Text(
                      'Esqueceu a senha?',
                      style: TextStyle(
                        color: Color(0xFF00D09E),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  PrimaryButton(text: 'Entrar', onPressed: _login),
                  const SizedBox(height: 24),
                  SecondaryButton(
                    text: 'Registre-Se',
                    onPressed:
                        () => Navigator.pushNamed(context, AppRoutes.register),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: GestureDetector(
                      onTap:
                          () =>
                              Navigator.pushNamed(context, AppRoutes.register),
                      child: const Text.rich(
                        TextSpan(
                          text: 'Não possui uma conta? ',
                          children: [
                            TextSpan(
                              text: 'Registre-se',
                              style: TextStyle(
                                color: Color(0xFF00D09E),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

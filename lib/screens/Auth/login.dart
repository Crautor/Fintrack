import 'package:fintrack/components/texts/form_label.dart';
import 'package:fintrack/routes/app.routes.dart';
import 'package:flutter/material.dart';
import '../../../components/headers/auth_header.dart';
import '../../../components/buttons/primary_button.dart';
import '../../../components/buttons/secondary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;

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
                        () => Navigator.pushNamed(context, AppRoutes.forgotPassword),
                    child: const Text(
                      'Esqueceu a senha?',
                      style: TextStyle(
                        color: Color(0xFF00D09E),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 48),

                  PrimaryButton(text: 'Entrar', onPressed: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.home);
                  }),

                  const SizedBox(height: 24),
                  SecondaryButton(
                    text: 'Registre-Se',
                    onPressed:
                        () => Navigator.pushNamed(context, AppRoutes.register),
                  ),

                  const SizedBox(height: 24),
                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.pushNamed(context, AppRoutes.register),
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

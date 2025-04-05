import 'package:flutter/material.dart';
import '../../components/buttons/primary_button.dart';
import '../../components/buttons/secondary_button.dart';

class PreLoginScreen extends StatelessWidget {
  const PreLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1FFF3),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/logo-splash-cortado.png',
                  width: 400,
                  height: 300,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Gerencie suas finanças pessoais\nde forma simples e prática com o FinTrack.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
                ),
                const SizedBox(height: 32),
                PrimaryButton(
                  text: 'Entrar',
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                ),
                const SizedBox(height: 16),
                SecondaryButton(
                  text: 'Registrar-Se',
                  onPressed: () => Navigator.pushNamed(context, '/register'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed:
                      () => Navigator.pushNamed(context, '/forgot-password'),
                  child: const Text(
                    'Esqueceu a senha?',
                    style: TextStyle(color: Color(0xFF666666), fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../components/headers/auth_header.dart';
import '../../../components/inputs/custom_text_field.dart';
import '../../../components/buttons/primary_button.dart';
import '../../../components/buttons/secondary_button.dart';
import '../../../components/texts/form_label.dart';
import '../../../routes/app.routes.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1FFF3),
      body: Column(
        children: [
          const AuthHeader(title: 'Esqueci A Senha'),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Alterar A Senha?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF093030),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                     'Informe o e-mail associado à sua conta e enviaremos um link para você redefinir sua senha com segurança.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF0E3E3E),
                    ),
                  ),
                  const SizedBox(height: 24),

                  const FormLabel("Digite Seu Email"),
                  const CustomTextField(hintText: "example@example.com"),
                  const SizedBox(height: 24),

                  PrimaryButton(
                    text: 'Próximo Passo',
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.verificationCode)
                  ),
                  const SizedBox(height: 16),

                  SecondaryButton(
                    text: 'Registrar-Se',
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.register);
                    },
                  ),
                  const SizedBox(height: 32),

                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.pushNamed(context, AppRoutes.login),
                      child: const Text.rich(
                        TextSpan(
                          text: 'Já possui uma conta? ',
                          children: [
                            TextSpan(
                              text: 'Entrar',
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

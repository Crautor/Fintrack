import 'package:fintrack/routes/app.routes.dart';
import 'package:flutter/material.dart';
import '../../../components/headers/auth_header.dart';
import '../../../components/buttons/primary_button.dart';
import '../../../components/inputs/password_text_field.dart';
import '../../../components/texts/form_label.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _changePassword() {
    final newPassword = _passwordController.text;
    final confirmPassword = _confirmController.text;

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('As senhas não coincidem')));
      return;
    }

    // Aqui entraria a lógica para enviar a nova senha ao backend
    print('Nova senha definida: $newPassword');
    Navigator.pushReplacementNamed(context, AppRoutes.passwordSuccess);

    // Depois de sucesso, pode redirecionar ou mostrar uma mensagem
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1FFF3),
      body: Column(
        children: [
          const AuthHeader(title: 'Nova Senha'),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const FormLabel("Nova Senha"),
                  PasswordTextField(
                    hintText: "********",
                    controller: _passwordController,
                  ),
                  const SizedBox(height: 24),

                  const FormLabel("Confirmar Nova Senha"),
                  PasswordTextField(
                    hintText: "********",
                    controller: _confirmController,
                  ),
                  const SizedBox(height: 40),

                  PrimaryButton(
                    text: 'Alterar Senha',
                    onPressed: _changePassword,
                  ),

                  const SizedBox(height: 16),

                  Center(
                    child: GestureDetector(
                      onTap:
                          () => Navigator.pushNamed(context, AppRoutes.login),
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

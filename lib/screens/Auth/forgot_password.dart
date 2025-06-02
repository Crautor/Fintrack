import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../components/headers/auth_header.dart';
import '../../../components/inputs/custom_text_field.dart';
import '../../../components/buttons/primary_button.dart';
import '../../../components/buttons/secondary_button.dart';
import '../../../components/texts/form_label.dart';
import '../../../routes/app.routes.dart';
import '../../models/Auth/recuperar_senha_model.dart';
import '../../services/request_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  final storage = FlutterSecureStorage();

  Future<void> handleForgotPassword() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      Fluttertoast.showToast(
        msg: "Por favor, insira um e-mail válido.",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    final request = ForgotPasswordRequest(email: email);

    try {
      final response = await RequestService.post<ForgotPasswordResponse>(
        'auth/senha/solicitar',
        request,
        ForgotPasswordResponse.fromJson,
      );

      if (response.isSuccess) {
        await storage.write(key: 'recuperacao', value: email);
        Fluttertoast.showToast(
          msg: response.data.message,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );

        if (!mounted) return;
        Navigator.pushNamed(context, AppRoutes.verificationCode);
      } else {
        Fluttertoast.showToast(
          msg: response.data.message,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Erro ao conectar com o servidor.",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

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
                    'Alterar a Senha?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF093030),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Informe o e-mail associado à sua conta e enviaremos um link para você redefinir sua senha com segurança.',
                    style: TextStyle(fontSize: 14, color: Color(0xFF0E3E3E)),
                  ),
                  const SizedBox(height: 24),
                  const FormLabel("Digite Seu Email"),
                  CustomTextField(
                    hintText: "example@example.com",
                    controller: emailController,
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    text: 'Próximo Passo',
                    onPressed: handleForgotPassword,
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

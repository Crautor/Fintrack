import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../components/headers/auth_header.dart';
import '../../../components/inputs/password_text_field.dart';
import '../../../components/buttons/primary_button.dart';
import '../../../components/texts/form_label.dart';
import '../../../routes/app.routes.dart';
import '../../models/Auth/nova_senha_model.dart';
import '../../services/request_service.dart';
import 'dart:convert';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _storage = const FlutterSecureStorage();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    final newPassword = _passwordController.text.trim();
    final confirmPassword = _confirmController.text.trim();

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      Fluttertoast.showToast(
        msg: "Preencha todos os campos.",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    if (newPassword != confirmPassword) {
      Fluttertoast.showToast(
        msg: "As senhas não coincidem.",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    final raw = await _storage.read(key: 'recuperacao');
    if (raw == null) {
      Fluttertoast.showToast(
        msg: "Erro interno: dados não encontrados.",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    final decoded = jsonDecode(raw);
    final email = decoded['email'];
    final code = decoded['code'];
    if (email == null || code == null) {
      Fluttertoast.showToast(
        msg: "Erro interno: dados de verificação não encontrados.",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    final request = NovaSenhaRequest(
      email: email,
      codigo: code.toString(),
      novapassword: newPassword,
    );

    try {
      final response = await RequestService.post<NovaSenhaResponse>(
        'auth/senha/redefinir',
        request,
        NovaSenhaResponse.fromJson,
      );

      if (response.isSuccess) {
        Fluttertoast.showToast(
          msg: response.data.message,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, AppRoutes.passwordSuccess);
      } else {
        Fluttertoast.showToast(
          msg: response.data.message,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Erro ao redefinir a senha.",
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

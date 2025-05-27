import 'package:fintrack/components/inputs/date_picker_text_field.dart';
import 'package:fintrack/components/texts/form_label.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../components/headers/auth_header.dart';
import '../../../components/buttons/primary_button.dart';
import '../../../components/inputs/custom_text_field.dart';
import '../../../components/inputs/password_text_field.dart';
import '../../services/request_service.dart';
import '../../models/Cadastro/cadastro.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  DateTime? selectedDate;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (name.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Por favor, insira um nome.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    if (email.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Por favor, insira um email válido.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    if (password != confirmPassword) {
      Fluttertoast.showToast(
        msg: 'As senhas não coincidem.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    try {
      final request = CadastroRequest(
        name: name,
        email: email,
        password: password,
        phone: phone,
        birthdate: selectedDate!.toIso8601String().split("T").first,
      );

      final response = await RequestService.post<CadastroResponse>(
        'auth/cadastro',
        request,
        (json) => CadastroResponse.fromJson(json),
      );

      if (response.success) {
        Fluttertoast.showToast(
          msg: response.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(
          msg: response.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Erro: $e',
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
          const AuthHeader(title: 'Criar Conta'),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const FormLabel("Nome Completo"),
                  CustomTextField(
                    controller: nameController,
                    hintText: "João da Silva",
                  ),
                  const SizedBox(height: 16),

                  const FormLabel("Email"),
                  CustomTextField(
                    controller: emailController,
                    hintText: "example@example.com",
                  ),
                  const SizedBox(height: 16),

                  const FormLabel("Número De Telefone"),
                  CustomTextField(
                    controller: phoneController,
                    hintText: "(12) 3456-7890",
                  ),
                  const SizedBox(height: 16),

                  const FormLabel("Data De Nascimento"),
                  DatePickerField(
                    hintText: "DD / MM / AAAA",
                    initialDate: selectedDate,
                    onDateSelected: (date) {
                      setState(() {
                        selectedDate = date;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  const FormLabel("Senha"),
                  PasswordTextField(
                    controller: passwordController,
                    hintText: "********",
                  ),
                  const SizedBox(height: 16),

                  const FormLabel("Confirme A Senha"),
                  PasswordTextField(
                    controller: confirmPasswordController,
                    hintText: "********",
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Ao continuar, você concorda com os\nTermos de Uso e Política de Privacidade.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Color(0xFF0E3E3E)),
                  ),
                  const SizedBox(height: 24),

                  PrimaryButton(text: 'Registrar', onPressed: _handleRegister),
                  const SizedBox(height: 24),

                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
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

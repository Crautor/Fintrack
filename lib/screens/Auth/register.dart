import 'package:fintrack/components/inputs/date_picker_text_field.dart';
import 'package:fintrack/components/texts/form_label.dart';
import 'package:flutter/material.dart';
import '../../../components/headers/auth_header.dart';
import '../../../components/buttons/primary_button.dart';
import '../../../components/inputs/custom_text_field.dart';
import '../../../components/inputs/password_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  DateTime? selectedDate;

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
                  CustomTextField(hintText: "example@example.com"),
                  SizedBox(height: 16),

                  const FormLabel("Email"),
                  CustomTextField(hintText: "example@example.com"),
                  SizedBox(height: 16),

                  const FormLabel("Número De Telefone"),
                  CustomTextField(hintText: "(12) 3456-7890"),
                  SizedBox(height: 16),

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
                  PasswordTextField(hintText: "********"),
                  SizedBox(height: 16),

                  const FormLabel("Confirme A Senha"),
                  PasswordTextField(hintText: "********"),
                  SizedBox(height: 24),

                  Text(
                    'Ao continuar, você concorda com os\nTermos de Uso e Política de Privacidade.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Color(0xFF0E3E3E)),
                  ),
                  SizedBox(height: 24),

                  PrimaryButton(text: 'Registrar', onPressed: () {}),
                  SizedBox(height: 24),

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

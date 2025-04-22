import 'package:flutter/material.dart';
import '../../routes/app.routes.dart';
import '../../components/buttons/primary_button.dart';
import '../../components/headers/auth_header.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  State<TermsAndConditionsScreen> createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  bool _isAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1FFF3),
      body: Column(
        children: [
          AuthHeader(
            title: 'Termos de Uso',
            isBackButtonVisible: true,
            onBack: () {
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Bem-vindo ao FinTrack!',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Antes de continuar, por favor leia e aceite nossos Termos de Uso:',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            '- Você concorda em utilizar o aplicativo de maneira responsável.',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '- Seus dados estarão protegidos conforme nossa política de privacidade.',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '- Ao utilizar o app, você consente com o processamento de dados pessoais conforme descrito.',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          const SizedBox(height: 16),
                          const Text(
                            'Para continuar, marque a caixa abaixo para aceitar os termos.',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: _isAccepted,
                        onChanged: (value) {
                          setState(() {
                            _isAccepted = value ?? false;
                          });
                        },
                      ),
                      const Expanded(
                        child: Text('Eu aceito os termos de uso.'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    text: 'Continuar',
                    onPressed: () {
                      if (_isAccepted) {
                        Navigator.pushReplacementNamed(context, AppRoutes.home);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              'Você precisa aceitar os termos de uso para continuar.',
                            ),
                            duration: const Duration(seconds: 2),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
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

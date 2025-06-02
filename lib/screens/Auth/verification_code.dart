import 'dart:convert';
import 'package:fintrack/routes/app.routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../components/headers/auth_header.dart';
import '../../../components/buttons/primary_button.dart';
import '../../../components/buttons/secondary_button.dart';
import '../../models/Auth/code_model.dart';
import '../../models/Auth/recuperar_senha_model.dart';
import '../../services/request_service.dart';

class VerificationCodeScreen extends StatefulWidget {
  const VerificationCodeScreen({super.key});

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  final storage = const FlutterSecureStorage();
  String? email;
  bool canResend = false;
  Duration timeLeft = Duration.zero;

  @override
  void initState() {
    super.initState();
    _loadEmailAndTimer();
  }

  Future<void> _loadEmailAndTimer() async {
    final storedEmail = await storage.read(key: 'recuperacao');
    final storedTimestamp = await storage.read(key: 'recuperacao_timestamp');

    final now = DateTime.now();
    if (storedTimestamp != null) {
      final saved = DateTime.parse(storedTimestamp);
      final difference = now.difference(saved);

      if (difference.inMinutes >= 15) {
        canResend = true;
      } else {
        timeLeft = Duration(minutes: 15) - difference;
        _startCountdown();
      }
    } else {
      // Primeira entrada: salva o horário atual
      await storage.write(
        key: 'recuperacao_timestamp',
        value: now.toIso8601String(),
      );
      canResend = false;
      timeLeft = const Duration(minutes: 15);
      _startCountdown();
    }

    if (mounted) {
      setState(() {
        email = storedEmail;
      });
    }
  }

  void _startCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted || canResend) return;
      setState(() {
        timeLeft = timeLeft - const Duration(seconds: 1);
        if (timeLeft.inSeconds <= 0) {
          canResend = true;
        } else {
          _startCountdown();
        }
      });
    });
  }

  String get _code => _controllers.map((controller) => controller.text).join();

  Future<void> _verificarCodigo() async {
    if (email == null || _code.length != 6) {
      Fluttertoast.showToast(
        msg: "Preencha o código corretamente.",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    final request = ConfirmarCodigoRequest(email: email!, code: _code);

    try {
      final response = await RequestService.post<ConfirmarCodigoResponse>(
        'auth/usuario/validar',
        request,
        ConfirmarCodigoResponse.fromJson,
      );

      if (response.isSuccess) {
        await storage.write(
          key: 'recuperacao',
          value: jsonEncode({'email': email, 'code': _code}),
        );

        Fluttertoast.showToast(
          msg: response.data.message,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );

        if (!mounted) return;
        Navigator.pushNamed(context, AppRoutes.newPassword);
      } else {
        Fluttertoast.showToast(
          msg: response.data.message,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Erro ao verificar o código.',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<void> _reenviarCodigo() async {
    if (email == null) return;

    final request = ForgotPasswordRequest(email: email!);

    try {
      final response = await RequestService.post<ForgotPasswordResponse>(
        'auth/senha/solicitar',
        request,
        ForgotPasswordResponse.fromJson,
      );

      if (response.isSuccess) {
        Fluttertoast.showToast(
          msg: response.data.message,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );

        // Reinicia timer
        await storage.write(
          key: 'recuperacao_timestamp',
          value: DateTime.now().toIso8601String(),
        );
        setState(() {
          canResend = false;
          timeLeft = const Duration(minutes: 15);
        });
        _startCountdown();
      } else {
        Fluttertoast.showToast(
          msg: response.data.message,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Erro ao reenviar código.',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  void _onDigitChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = timeLeft.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = timeLeft.inSeconds.remainder(60).toString().padLeft(2, '0');

    return Scaffold(
      backgroundColor: const Color(0xFFF1FFF3),
      body: Column(
        children: [
          const AuthHeader(title: 'Código de Verificação'),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Insira o código enviado para seu e-mail.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Color(0xFF093030)),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) {
                      return SizedBox(
                        width: 40,
                        child: TextFormField(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          onChanged: (value) => _onDigitChanged(value, index),
                          decoration: const InputDecoration(
                            counterText: '',
                            filled: true,
                            fillColor: Color(0xFFDFF7E2),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 32),
                  PrimaryButton(text: 'Verificar', onPressed: _verificarCodigo),
                  const SizedBox(height: 16),
                  SecondaryButton(
                    text:
                        canResend
                            ? 'Reenviar Código'
                            : 'Reenviar $minutes:$seconds',
                    onPressed: () {
                      if (!canResend) return;
                      _reenviarCodigo();
                    },
                    // ← isso desativa o botão de verdade
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.login,
                          (route) => false,
                        );
                      },
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

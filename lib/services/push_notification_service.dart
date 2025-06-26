import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fintrack/services/request_service.dart';
import 'package:fintrack/models/Notifications/RegisterTokenRequest.dart';

class PushNotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> initialize() async {
    // Solicita permissão para receber notificações (necessário para iOS)
    await _messaging.requestPermission();

    // Obtém o token do dispositivo (pode ser enviado ao backend)
    final token = await _messaging.getToken();
    print('FCM Token: $token');
    if (token != null) {
      await registerTokenOnBackend(token);
    }

    // Listener correto para atualização de token
    _messaging.onTokenRefresh.listen((newToken) async {
      print('Novo FCM Token: $newToken');
      await registerTokenOnBackend(newToken);
    });

    // Manipula mensagens recebidas em foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Mensagem recebida em foreground: ${message.notification?.title}');
      // Aqui você pode exibir um dialog/toast/local notification
    });

    // Manipula mensagens quando o app é aberto por uma notificação
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('App aberto por notificação: ${message.notification?.title}');
      // Aqui você pode navegar para uma tela específica
    });
  }

  static Future<void> registerTokenOnBackend(String token) async {
    print('🔄 [PushService] Iniciando registro de token...');
    print('📲 Token recebido: $token');

    try {
      final storage = const FlutterSecureStorage();
      final userEmail = await storage.read(key: 'user-mail');

      if (userEmail == null) {
        print('⚠️ [PushService] user-mail não encontrado no storage.');
        return;
      }

      print('📧 user-mail recuperado: $userEmail');
      final payload = RegisterTokenRequest(token: token);
      print('📦 Corpo enviado: ${payload.toJson()}');

      final response = await RequestService.post<void>(
        'notifications/tokens/registrar?email=$userEmail',
        payload,
        (_) => null,
      );

      print('📡 Status da resposta: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('✅ Token registrado com sucesso no backend!');
      } else {
        print('⚠️ Falha ao registrar token no backend: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Erro ao enviar token: ${e.toString()}');
    }
  }
}

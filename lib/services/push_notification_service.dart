import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PushNotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> initialize() async {
    // Solicita permissão para receber notificações (necessário para iOS)
    await _messaging.requestPermission();

    // Obtém o token do dispositivo (pode ser enviado ao backend)
    final token = await _messaging.getToken();
    print('FCM Token: $token');
    if (token != null) {
      await _registerTokenOnBackend(token);
    }

    // Listener correto para atualização de token
    _messaging.onTokenRefresh.listen((newToken) async {
      print('Novo FCM Token: $newToken');
      await _registerTokenOnBackend(newToken);
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

  static Future<void> _registerTokenOnBackend(String token) async {
    try {
      // Busca o user-mail do storage seguro
      final storage = const FlutterSecureStorage();
      final userEmail = await storage.read(key: 'user-mail');
      if (userEmail == null) {
        print('⚠️ Usuário não autenticado, não foi possível registrar o token');
        return;
      }
      final url = Uri.parse('http://localhost:3000/api/notifications/tokens/registrar?email=$userEmail');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': token }),
      );
      if (response.statusCode == 200) {
        print('✅ Token registrado com sucesso no backend!');
      } else {
        print('⚠️ Erro ao registrar token: \\${response.statusCode} - \\${response.body}');
      }
    } catch (e) {
      print('❌ Erro ao enviar token: \\${e.toString()}');
    }
  }
}

import 'package:fintrack/models/User/User.dart';
import 'package:fintrack/services/request_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserService {
  static const _storage = FlutterSecureStorage();

  static Future<User?> getByEmail() async {
    final email = await _storage.read(key: 'user-mail');
    if (email == null) return null;

    final endpoint = 'auth/usuario/$email';

    final user = await RequestService.get<User>(
      endpoint,
      (json) => User.fromJson(json),
    );

    return user;
  }

  static Future<User?> putByEmail(User userToUpdate) async {
    final email = await _storage.read(key: 'user-mail');
    if (email == null) return null;

    final endpoint = 'auth/usuario/$email';

    final response = await RequestService.put<User>(
      endpoint,
      userToUpdate,
      (json) => User.fromJson(json),
    );

    return response.data;
  }
}

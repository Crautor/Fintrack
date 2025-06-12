import 'package:fintrack/models/Saving/saving.dart';
import 'package:fintrack/models/Api/api.dart';
import 'package:fintrack/services/request_service.dart';

class SavingService {
  static const String endpoint = 'savings';

  static Future<List<Saving>> getAll() async {
    final response = await RequestService.get<Map<String, dynamic>>(
      endpoint,
      (json) => json,
    );

    final items = response['items'] as List<dynamic>;
    return items.map((item) => Saving.fromJson(item)).toList();
  }

  static Future<Saving> getById(int id) async {
    final response = await RequestService.get<Map<String, dynamic>>(
      '$endpoint/$id',
      (json) => json,
    );

    return Saving.fromJson(response['item']);
  }

  static Future<ApiResponse<void>> create(Saving saving) async {
    return await RequestService.post<void>(endpoint, saving, (_) {});
  }

  static Future<ApiResponse<void>> update(int id, Saving saving) async {
    return await RequestService.put<void>('$endpoint/$id', saving, (_) {});
  }

  static Future<ApiResponse<void>> delete(int id) async {
    return await RequestService.delete<void>('$endpoint/$id', (_) {});
  }
}

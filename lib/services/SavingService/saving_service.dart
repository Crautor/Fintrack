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

  static Future<Saving> getById(int id, String email) async {
    final response = await RequestService.get<Map<String, dynamic>>(
      '$endpoint/$id?email=$email',
      (json) => json,
    );

    return Saving.fromJson(response);
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

  static Future<List<Saving>> getByFinancialGoal({
    required String email,
    required int financialGoalId,
  }) async {
    final response = await RequestService.get<Map<String, dynamic>>(
      '$endpoint/find/goal?email=$email&financialGoalId=$financialGoalId',
      (json) => json,
    );

    // Filtrar apenas chaves numéricas (0, 1, 2...) que representam savings
    final savings =
        response.entries
            .where((entry) => int.tryParse(entry.key) != null)
            .map((entry) => Saving.fromJson(entry.value))
            .toList();

    return savings;
  }
}

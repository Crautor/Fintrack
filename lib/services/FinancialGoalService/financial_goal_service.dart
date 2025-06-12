import 'package:fintrack/models/Financial_Goal/financial_goal.dart';
import 'package:fintrack/models/Api/api.dart';
import 'package:fintrack/services/request_service.dart';

class FinancialGoalService {
  static const String endpoint = 'financialGoals';

  static Future<List<FinancialGoal>> getAll(String email) async {
    final response = await RequestService.get<Map<String, dynamic>>(
      '$endpoint?email=$email',
      (json) => json,
    );

    final items = response['items'] as List<dynamic>;
    return items.map((item) => FinancialGoal.fromJson(item)).toList();
  }

  static Future<ApiResponse<void>> create(FinancialGoal goal) async {
    return await RequestService.post<void>(endpoint, goal, (_) {});
  }

  static Future<ApiResponse<void>> update(FinancialGoal goal) async {
    final id = goal.financialGoalId;
    return await RequestService.put<void>('$endpoint/$id', goal, (_) {});
  }

  static Future<ApiResponse<void>> delete(int id) async {
    return await RequestService.delete<void>('$endpoint/$id', (_) {});
  }

  static Future<FinancialGoal> getById(int id) async {
    return await RequestService.get<FinancialGoal>(
      '$endpoint/$id',
      FinancialGoal.fromJson,
    );
  }
}

import 'package:fintrack/models/Api/api.dart';
import 'package:fintrack/models/Transaction/transaction.dart';
import 'package:fintrack/services/request_service.dart';

class TransactionService {
  static const String _endpoint = 'transactions';
  static const String _findCategoryEndpoint = 'transactions/find/category';
  static const String _findDateEndpoint = 'transactions/find/date';
  static const String _findPeriodEndpoint = 'transactions/find/period';

  /// GET - Lista de transações
  static Future<List<TransactionItem>> getAll(String email) async {
    print('[DEBUG] Buscando todas as transações...');
    final result = await RequestService.get<List<TransactionItem>>(
      '$_endpoint?email=$email',
      (json) => TransactionItem.fromListResponse(json),
    );
    print('[DEBUG] Transações carregadas: ${result.length}');
    return result;
  }

  static Future<TransactionItem> getTransactionById(
    int id,
    String email,
  ) async {
    print('[DEBUG] Buscando transação com ID: $id para o email: $email');

    final result = await RequestService.get<TransactionItem>(
      '$_endpoint/$id?email=$email',
      (json) => TransactionItem.fromJson(json),
    );

    print('[DEBUG] Transação encontrada: ${result.transactionId}');
    return result;
  }

  /// POST - Criar nova transação
  static Future<ApiResponse<void>> createTransaction(
    TransactionItem transaction,
  ) async {
    print('[DEBUG] Criando transação: ${transaction.toJson()}');
    final response = await RequestService.post<void>(
      _endpoint,
      transaction,
      (_) {},
    );
    print('[DEBUG] Transação criada com sucesso');
    return response;
  }

  /// PUT - Atualizar transação
  static Future<ApiResponse<void>> updateTransaction(
    int id,
    TransactionItem transaction,
  ) async {
    print('[DEBUG] Atualizando transação ID $id: ${transaction.toJson()}');
    final response = await RequestService.put<void>(
      '$_endpoint/$id',
      transaction,
      (_) {},
    );
    print('[DEBUG] Transação atualizada');
    return response;
  }

  /// DELETE - Deletar transação
  static Future<ApiResponse<void>> deleteTransaction(int id) async {
    print('[DEBUG] Removendo transação com ID: $id');
    final response = await RequestService.delete<void>(
      '$_endpoint/$id',
      (_) {},
    );
    print('[DEBUG] Transação removida');
    return response;
  }

  /// GET - Filtrar transações pelo ID da categoria
  static Future<List<TransactionItem>> getTransactionsByCategoryId(
    String email,
    int categoryId,
  ) async {
    print(
      '[DEBUG] Buscando transações pelo ID da categoria: $categoryId para o email: $email',
    );
    final result = await RequestService.get<List<TransactionItem>>(
      '$_findCategoryEndpoint?email=$email&categoryId=$categoryId',
      (json) => TransactionItem.fromListResponse(json),
    );
    print('[DEBUG] Transações encontradas: ${result.length}');
    return result;
  }

  /// GET - Filtrar transações por data
  static Future<List<TransactionItem>> getTransactionsByDate(
    String email,
    String date,
  ) async {
    print('[DEBUG] Buscando transações por data: $date para o email: $email');
    final result = await RequestService.get<List<TransactionItem>>(
      '$_findDateEndpoint?email=$email&date=$date',
      (json) => TransactionItem.fromListResponse(json),
    );
    print('[DEBUG] Transações encontradas: ${result.length}');
    return result;
  }

  /// GET - Filtrar transações por período
  static Future<List<TransactionItem>> getTransactionsByPeriod(
    String email,
    String startDate,
    String endDate,
  ) async {
    print(
      '[DEBUG] Buscando transações entre $startDate e $endDate para o email: $email',
    );
    final result = await RequestService.get<List<TransactionItem>>(
      '$_findPeriodEndpoint?email=$email&startDate=$startDate&endDate=$endDate',
      (json) => TransactionItem.fromListResponse(json),
    );
    print('[DEBUG] Transações encontradas: ${result.length}');
    return result;
  }
}

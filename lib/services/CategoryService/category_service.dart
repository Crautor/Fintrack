import 'package:fintrack/models/Api/api.dart';
import 'package:fintrack/services/request_service.dart';
import 'package:fintrack/models/Category/category.dart';

class CategoryService {
  static const String _endpoint = 'category';

  /// GET - Lista de categorias por email
  static Future<List<Category>> getCategories(String email) async {
    final result = await RequestService.get<List<Category>>(
      '$_endpoint?email=$email',
      (json) => Category.fromListResponse(json),
    );
    return result;
  }

  /// GET - Categoria por ID e email
  static Future<Category?> getCategoryById(int id, String email) async {
    try {
      final result = await RequestService.get<Category>(
        '$_endpoint/$id?email=$email',
        (json) => Category.fromJson(json),
      );
      return result;
    } catch (e) {
      print('[ERROR] getCategoryById → $e');
      return null;
    }
  }

  /// POST - Criar nova categoria
  static Future<ApiResponse<void>> createCategory(Category category) async {
    final response = await RequestService.post<void>(
      _endpoint,
      category,
      (_) {},
    );

    return response;
  }

  /// PUT - Atualizar categoria
  static Future<ApiResponse<void>> updateCategory(
    int id,
    Category category,
  ) async {
    final response = await RequestService.put<void>(
      '$_endpoint/$id',
      category,
      (_) {},
    );

    return response;
  }

  /// DELETE - Deletar categoria
  static Future<ApiResponse<void>> deleteCategory(int id) async {
    final response = await RequestService.delete<void>(
      '$_endpoint/$id',
      (_) {},
    );
    return response;
  }
}

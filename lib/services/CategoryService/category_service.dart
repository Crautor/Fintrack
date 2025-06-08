import 'package:fintrack/models/Api/api.dart';
import 'package:fintrack/services/request_service.dart';
import 'package:fintrack/models/Category/category.dart';

class CategoryService {
  static const String _endpoint = 'category';

  /// GET - Lista de categorias
  static Future<List<Category>> getCategories() async {
    final result = await RequestService.get<List<Category>>(
      _endpoint,
      (json) => Category.fromListResponse(json),
    );
    return result;
  }

  /// GET - Categoria por ID
  static Future<Category> getCategoryById(int id) async {
    final result = await RequestService.get<Category>(
      '$_endpoint/$id',
      (json) => Category.fromJson(json),
    );
    return result;
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

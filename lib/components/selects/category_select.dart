import 'package:flutter/material.dart';
import 'package:fintrack/models/Category/category.dart';
import 'package:fintrack/services/CategoryService/category_service.dart';
import 'package:fintrack/components/selects/custom_select.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CategorySelect extends StatefulWidget {
  final Category? value;
  final void Function(Category?) onChanged;

  const CategorySelect({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<CategorySelect> createState() => _CategorySelectState();
}

class _CategorySelectState extends State<CategorySelect> {
  List<Category> categories = [];
  bool isLoading = true;
  final storage = const FlutterSecureStorage();


  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final storedEmail = await storage.read(key: 'user-mail');
      if (storedEmail == null) {
        return;
      }
      final result = await CategoryService.getCategories(storedEmail);
      setState(() {
        categories = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Você pode usar um toast se quiser aqui
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return CustomSelect<Category>(
      label: 'Categoria',
      hintText: 'Selecione uma categoria',
      items: categories,
      value: widget.value,
      onChanged: widget.onChanged,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fintrack/components/categoryItem/category_item.dart';
import 'package:fintrack/components/headers/default_header.dart';
import 'package:fintrack/components/overviews/general_overview.dart';
import 'package:fintrack/screens/Categories/category_modal.dart';
import 'package:fintrack/services/CategoryService/category_service.dart';
import 'package:fintrack/services/FinancialGoalService/financial_goal_service.dart';
import 'package:fintrack/models/Category/category.dart';
import 'package:fintrack/models/Financial_Goal/financial_goal.dart';
import 'package:fintrack/screens/Categories/financial_goal.dart';
import 'package:fintrack/utils/icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CategoriesPage extends StatefulWidget {
  final VoidCallback? onAddPressed;
  final void Function(Map<String, dynamic>)? onCategoryPressed;
  final void Function(Map<String, dynamic>)? onGoalPressed;

  const CategoriesPage({
    super.key,
    this.onAddPressed,
    this.onCategoryPressed,
    this.onGoalPressed,
  });

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage>
    with TickerProviderStateMixin {
  List<Category> userCategories = [];
  List<FinancialGoal> financialGoals = [];
  final storage = const FlutterSecureStorage();

  bool isLoadingCategories = true;
  bool isLoadingGoals = true;

  @override
  void initState() {
    super.initState();
    loadCategories();
    loadGoals();
  }

  Future<void> loadCategories() async {
    try {
      final storedEmail = await storage.read(key: 'user-mail');
      if (storedEmail == null) {
        return;
      }
      final categories = await CategoryService.getCategories(storedEmail);
      setState(() {
        userCategories = categories;
        isLoadingCategories = false;
      });
    } catch (e) {
      setState(() => isLoadingCategories = false);
      Fluttertoast.showToast(
        msg: 'Erro ao carregar categorias',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<void> loadGoals() async {
    try {
      final storedEmail = await storage.read(key: 'user-mail');
      if (storedEmail == null) {
        return;
      }
      final response = await FinancialGoalService.getAll(storedEmail);
      setState(() {
        financialGoals = response;
        isLoadingGoals = false;
      });
    } catch (e) {
      setState(() => isLoadingGoals = false);
      Fluttertoast.showToast(
        msg: 'Erro ao carregar metas financeiras',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  void handleCreateFinancialGoal(FinancialGoal goal) async {
    try {
      await FinancialGoalService.create(goal);
      await loadGoals();

      Fluttertoast.showToast(
        msg: 'Meta criada com sucesso!',
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Erro ao criar meta',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  void handleCreateCategory(String name, CategoryIcon icon) async {
    try {
      final storedEmail = await storage.read(key: 'user-mail');
      if (storedEmail == null) {
        return;
      }
      await CategoryService.createCategory(
        Category(name: name, icon: icon.id.toString(), email: storedEmail),
      );
      await loadCategories();
      Fluttertoast.showToast(
        msg: 'Categoria criada com sucesso!',
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Erro ao criar categoria',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFE9FFF9),
        body: Column(
          children: [
            const DefaultHeader(
              title: 'Categorias',
              subtitle: 'Gerencie suas despesas e metas.',
              isBackButtonVisible: false,
              child: GeneralOverview(
                balance: 7783.00,
                expense: 1187.40,
                goal: 20000.00,
                percentage: 0.3,
              ),
            ),
            const TabBar(
              labelColor: Color(0xFF00D09E),
              unselectedLabelColor: Colors.grey,
              indicatorColor: Color(0xFF00D09E),
              tabs: [Tab(text: 'Gastos'), Tab(text: 'Metas')],
            ),
            Expanded(
              child: TabBarView(
                children: [buildCategoryGrid(), buildGoalsGrid()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCategoryGrid() {
    return isLoadingCategories
        ? const Center(child: CircularProgressIndicator())
        : GridView.count(
          padding: const EdgeInsets.all(20),
          crossAxisCount: 3,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          childAspectRatio: 0.8,
          children: [
            ...userCategories.map((category) {
              final iconData =
                  getCategoryIconById(
                    int.tryParse(category.icon ?? '') ?? 0,
                  )?.icon ??
                  Icons.help_outline;

              return CategoryItem(
                icon: iconData,
                label: category.name,
                onTap:
                    () => widget.onCategoryPressed?.call({
                      "id": category.categoryId,
                    }),
              );
            }),
            CategoryItem(
              icon: Icons.add,
              label: "Criar",
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return CategoryModal(onSave: handleCreateCategory);
                  },
                );
              },
            ),
          ],
        );
  }

  Widget buildGoalsGrid() {
    return isLoadingGoals
        ? const Center(child: CircularProgressIndicator())
        : GridView.count(
          padding: const EdgeInsets.all(20),
          crossAxisCount: 3,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          childAspectRatio: 0.8,
          children: [
            ...financialGoals.map((goal) {
              final iconData =
                  goal.icon != null
                      ? getCategoryIconById(goal.icon!)?.icon
                      : Icons.flag;

              return CategoryItem(
                icon: iconData ?? Icons.flag,
                label: goal.title,
                onTap:
                    () => widget.onGoalPressed?.call({
                      "id": goal.financialGoalId,
                    }),
              );
            }),
            CategoryItem(
              icon: Icons.add,
              label: "Criar",
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return FinancialGoalModal(
                      onSave: handleCreateFinancialGoal,
                    );
                  },
                );
              },
            ),
          ],
        );
  }
}

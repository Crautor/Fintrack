import 'package:fintrack/models/Financial_Goal/financial_goal.dart';
import 'package:fintrack/models/Saving/saving.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fintrack/components/headers/form_header.dart';
import 'package:fintrack/services/FinancialGoalService/financial_goal_service.dart';
import 'package:fintrack/services/SavingService/saving_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fintrack/components/headers/goal_summary.dart';
import 'package:fintrack/components/graph/goal_progress.dart';
import 'package:fintrack/utils/icons.dart';

class FinancialGoalDetailPage extends StatefulWidget {
  final int goalId;
  final VoidCallback onBack;
  final void Function(int goalId)? onAddSaving;
  final void Function(int goalId, int savingId)? onEditSaving;

  const FinancialGoalDetailPage({
    super.key,
    required this.goalId,
    required this.onBack,
    this.onAddSaving,
    this.onEditSaving,
  });

  @override
  State<FinancialGoalDetailPage> createState() =>
      _FinancialGoalDetailPageState();
}

class _FinancialGoalDetailPageState extends State<FinancialGoalDetailPage> {
  final storage = const FlutterSecureStorage();
  bool _isLoadingGoal = false;
  FinancialGoal? goal;

  List<Saving> savings = [];
  bool isLoading = true;
  String userEmail = "";

  @override
  void initState() {
    super.initState();
    loadGoal();
    loadSavings();
  }

  Future<void> loadGoal() async {
    if (_isLoadingGoal || goal != null) return;

    _isLoadingGoal = true;
    try {
      final storedEmail = await storage.read(key: 'user-mail');
      if (!mounted || storedEmail == null) return;
      userEmail = storedEmail;

      final fetchedGoal = await FinancialGoalService.getById(
        widget.goalId,
        userEmail,
      );

      if (mounted) {
        setState(() => goal = fetchedGoal);
      }
    } catch (e, stack) {
      print('[ERROR loadGoal] $e\n$stack');
      Fluttertoast.showToast(
        msg: 'Erro ao carregar dados da meta',
        backgroundColor: Colors.red,
      );
    } finally {
      _isLoadingGoal = false;
    }
  }

  Future<void> loadSavings() async {
    try {
      final storedEmail = await storage.read(key: 'user-mail');
      if (!mounted || storedEmail == null) return;
      userEmail = storedEmail;

      final result = await SavingService.getByFinancialGoal(
        email: userEmail,
        financialGoalId: widget.goalId,
      );

      if (mounted) {
        setState(() {
          savings = result;
          isLoading = false;
        });
      }
    } catch (e) {
      print('[ERROR loadSavings] $e');
      Fluttertoast.showToast(
        msg: 'Erro ao carregar depósitos',
        backgroundColor: Colors.red,
      );
    }
  }

  double getTotalDeposited() {
    return savings.fold(0.0, (sum, t) => sum + t.value);
  }

  void _handleDeleteGoal() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Remover meta'),
            content: const Text('Tem certeza que deseja remover esta meta?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Remover',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (confirm != true) return;

    try {
      await FinancialGoalService.delete(widget.goalId);
      Fluttertoast.showToast(
        msg: 'Meta removida com sucesso!',
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      widget.onBack.call();
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Erro ao remover meta',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = getTotalDeposited();
    final goalValue = goal?.value ?? 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFF00D09E),
      body: SafeArea(
        child: Column(
          children: [
            FormHeader(title: goal?.title ?? "", onBack: widget.onBack),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GoalSummaryCard(
                      goalValue: goalValue,
                      amountSaved: total,
                      icon:
                          getCategoryIconById(goal?.icon ?? 0)?.icon ??
                          Icons.flag,
                    ),
                    const SizedBox(height: 16),
                    GoalProgressBar(amountSaved: total, goalValue: goalValue),
                    const SizedBox(height: 16),
                    const Text(
                      "Depósitos",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child:
                          isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : savings.isEmpty
                              ? const Center(
                                child: Text('Nenhum depósito ainda.'),
                              )
                              : ListView.builder(
                                itemCount: savings.length,
                                itemBuilder: (context, index) {
                                  final s = savings[index];
                                  return _buildDepositItem(s);
                                },
                              ),
                    ),
                    const SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00D09E),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed:
                              () => widget.onAddSaving?.call(widget.goalId),
                          child: const Text(
                            "Adicionar Depósito",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: _handleDeleteGoal,
                          child: const Text(
                            "Remover Meta",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDepositItem(Saving item) {
    final date = DateTime.tryParse(item.createdAt ?? '');
    final formattedDate =
        date != null
            ? "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}"
            : "Data inválida";

    return GestureDetector(
      onTap: () {
        if (item.savingId != null) {
          widget.onEditSaving?.call(widget.goalId, item.savingId!);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFFE1F3FF),
              child: Icon(Icons.attach_money, color: Color(0xFF00D09E)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formattedDate,
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                ],
              ),
            ),
            Text(
              "+R\$${item.value.toStringAsFixed(2)}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF00D084),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

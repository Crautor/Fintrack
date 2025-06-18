class FinancialGoal {
  final int? financialGoalId;
  final String? userId;
  final double value;
  final String? limitDate;
  final String? status;
  final String title;
  final String? description;
  final int? icon;
  final String? email;

  FinancialGoal({
    this.financialGoalId,
    this.userId,
    required this.value,
    this.limitDate,
    this.status,
    required this.title,
    this.description,
    this.icon,
    this.email,
  });

  factory FinancialGoal.fromJson(Map<String, dynamic> json) {
    return FinancialGoal(
      financialGoalId: json['financialGoalId'],
      email: json['email'],
      value: (json['value'] as num).toDouble(),
      limitDate: json['limitDate'],
      status: json['status'] ?? 'pending',
      title: json['title'],
      description: json['description'],
      icon: json['icon'] != null ? int.parse(json['icon'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'financialGoalId': financialGoalId,
      'email': email,
      'value': value,
      'limitDate': limitDate,
      'status': status,
      'title': title,
      'description': description,
      'icon': icon,
    };
  }

  static List<FinancialGoal> fromList(List<dynamic> jsonList) {
    return jsonList.map((json) => FinancialGoal.fromJson(json)).toList();
  }
}

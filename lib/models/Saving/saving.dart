class Saving {
  final int? savingId;
  final int? userId;
  final double value;
  final int financialGoalId;
  final String? description;
  final String title;
  final int iconId;

  Saving({
    this.savingId,
    this.userId,
    required this.value,
    required this.financialGoalId,
    this.description,
    required this.title,
    required this.iconId,
  });

  factory Saving.fromJson(Map<String, dynamic> json) {
    return Saving(
      savingId: json['savingId'],
      userId: json['userId'],
      value: (json['value'] as num).toDouble(),
      financialGoalId: json['financialGoalId'],
      description: json['description'],
      title: json['title'],
      iconId: json['iconId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'financialGoalId': financialGoalId,
      'description': description,
      'title': title,
      'iconId': iconId,
    };
  }
}

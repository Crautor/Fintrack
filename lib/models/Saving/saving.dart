class Saving {
  final int? savingId;
  final String? userId;
  final double value;
  final int financialGoalId;
  final String? description;
  final String title;
  final String? email;
  final String? createdAt;

  Saving({
    this.savingId,
    this.userId,
    required this.value,
    required this.financialGoalId,
    this.description,
    required this.title,
    this.email,
    this.createdAt,
  });

  factory Saving.fromJson(Map<String, dynamic> json) {
    return Saving(
      savingId: json['savingId'] as int?,
      userId: json['userId'] as String?,
      value: (json['value'] as num).toDouble(),
      financialGoalId: json['financialGoalId'] as int,
      description: json['description'] as String?,
      title: json['title'] as String,
      email: json['email'] as String?,
      createdAt: json['createdAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    if (email == null) {
      return {
        'value': value,
        'financialGoalId': financialGoalId,
        'description': description,
        'title': title,
        'createdAt': createdAt,
      };
    } else {
      return {
        'value': value,
        'financialGoalId': financialGoalId,
        'description': description,
        'title': title,
        'email': email,
        'createdAt': createdAt,
      };
    }
  }
}

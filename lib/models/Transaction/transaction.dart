class TransactionItem {
  final int? transactionId;
  final String? email;
  final double value;
  final int categoryId;
  final String transactionDate;
  final String? description;
  final bool? recurrence;
  final String type;

  TransactionItem({
    this.transactionId,
    this.email,
    required this.value,
    required this.categoryId,
    required this.transactionDate,
    this.description,
    this.recurrence,
    required this.type,
  });

  factory TransactionItem.fromJson(Map<String, dynamic> json) {
    return TransactionItem(
      transactionId: json['transactionId'],
      email: json['email'],
      value: (json['value'] as num).toDouble(),
      categoryId: json['categoryId'],
      transactionDate: json['transactionDate'],
      description: json['description'],
      recurrence: json['recurrence'],
      type: json['type'],
    );
  }

  static List<TransactionItem> fromListResponse(dynamic json) {
    final list = json['items'] as List;
    return list.map((item) => TransactionItem.fromJson(item)).toList();
  }

  Map<String, dynamic> toJson() {
    if (email == null) {
      return {
        'value': value,
        'categoryId': categoryId,
        'transactionDate': transactionDate,
        'description': description,
        'recurrence': recurrence,
        'type': type,
      };
    } else {
      return {
        'value': value,
        'categoryId': categoryId,
        'transactionDate': transactionDate,
        'description': description,
        'recurrence': recurrence,
        'type': type,
        'email': email,
      };
    }
  }
}

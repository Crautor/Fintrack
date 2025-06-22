class Category {
  final int? categoryId;
  final String name;
  final String? icon;
  final String? email;

  Category({this.categoryId, required this.name, this.icon, this.email});

  factory Category.fromJson(Map<String, dynamic> json) {
    try {
      return Category(
        categoryId:
            json['categoryId'] is int
                ? json['categoryId']
                : int.tryParse(json['categoryId'].toString()),
        name: json['name'] ?? 'Sem nome',
        icon: json['icon']?.toString(),
        email: json['email'],
      );
    } catch (e) {
      rethrow;
    }
  }

  static Category fromItemResponse(Map<String, dynamic> json) {
    return Category.fromJson(json['item']);
  }

  static List<Category> fromListResponse(Map<String, dynamic> json) {
    final items = json['items'] as List<dynamic>;
    return items.map((item) => Category.fromJson(item)).toList();
  }

  Map<String, dynamic> toJson() {
    if (email == null) {
      return {'name': name, 'icon': icon};
    } else {
      return {'name': name, 'icon': icon, 'email': email};
    }
  }

  @override
  String toString() => name;
}

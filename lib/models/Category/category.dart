class Category {
  final int? categoryId;
  final String name;
  final String? icon;

  Category({this.categoryId, required this.name, this.icon});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['categoryId'],
      name: json['name'],
      icon: json['icon'],
    );
  }

  static Category fromItemResponse(Map<String, dynamic> json) {
    return Category.fromJson(json['item']);
  }

  static List<Category> fromListResponse(Map<String, dynamic> json) {
    final items = json['items'] as List<dynamic>;
    return items.map((item) => Category.fromJson(item)).toList();
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'icon': icon};
  }
}

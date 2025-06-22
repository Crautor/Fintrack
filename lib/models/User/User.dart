class User {
  final int? id;
  final String name;
  final String email;
  final String? phone;

  User({this.id, required this.name, required this.email, this.phone});

  factory User.fromJson(Map<String, dynamic> json) => User(
    id:
        json['id'] is int
            ? json['id']
            : int.tryParse(json['id'].toString()) ?? 0,
    name: json['name'],
    email: json['email'],
    phone: json['phone'],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'phone': phone,
  };
}

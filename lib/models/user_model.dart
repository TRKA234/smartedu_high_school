class UserModel {
  int? id;
  String name;
  String email;
  String password;
  String role;
  String? createdAt;
  String? updatedAt;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      role: json['role'] ?? 'user',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'role': role,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

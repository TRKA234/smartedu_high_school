class Pegawai {
  int? id;
  String name;
  String position;
  String phone;
  String email;
  String address;
  String? createdAt;
  String? updatedAt;

  Pegawai({
    this.id,
    required this.name,
    required this.position,
    required this.phone,
    required this.email,
    required this.address,
    this.createdAt,
    this.updatedAt,
  });

  factory Pegawai.fromJson(Map<String, dynamic> json) {
    return Pegawai(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),
      name: json['name'] ?? '',
      position: json['position'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'position': position,
      'phone': phone,
      'email': email,
      'address': address,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

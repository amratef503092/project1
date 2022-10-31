class UserModel{
  String age;
  bool ban;
  String email;
  String id;
  bool online;
  String photo;
  String role;
  String name;
  String phone;

  UserModel({
    required this.age,
    required this.ban,
    required this.email,
    required this.id,
    required this.online,
    required this.photo,
    required this.role,
    required this.name,
    required this.phone,
  });

  Map<String, dynamic> toMap() {
    return {
      'age': this.age,
      'ban': this.ban,
      'email': this.email,
      'id': this.id,
      'online': this.online,
      'photo': this.photo,
      'role': this.role,
      'name': this.name,
      'phone': this.phone,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      age: map['age'] as String,
      ban: map['ban'] as bool,
      email: map['email'] as String,
      id: map['id'] as String,
      online: map['online'] as bool,
      photo: map['photo'] as String,
      role: map['role'] as String,
      name: map['name'] as String,
      phone: map['phone'] as String,
    );
  }
}
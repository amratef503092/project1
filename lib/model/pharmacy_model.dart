class PharmacyModel{
  String name;
  String email;
  String id;
  String phone;
  String photo;

  PharmacyModel({
    required this.name,
    required this.email,
    required this.id,
    required this.phone,
    required this.photo,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'email': this.email,
      'id': this.id,
      'phone': this.phone,
      'photo': this.photo,
    };
  }

  factory PharmacyModel.fromMap(Map<String, dynamic> map) {
    return PharmacyModel(
      name: map['name'] as String,
      email: map['email'] as String,
      id: map['id'] as String,
      phone: map['phone'] as String,
      photo: map['photo'] as String,
    );
  }
}
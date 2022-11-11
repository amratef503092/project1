class UserDataModel{
  String address;
  String bloodType;
  String chornic;

  UserDataModel({
    required this.address,
    required this.bloodType,
    required this.chornic,
  });

  Map<String, dynamic> toMap() {
    return {
      'address': this.address,
      'bloodType': this.bloodType,
      'chornic': this.chornic,
    };
  }

  factory UserDataModel.fromMap(Map<String, dynamic> map) {
    return UserDataModel(
      address: map['address'] as String,
      bloodType: map['bloodType'] as String,
      chornic: map['chornic'] as String,
    );
  }
}
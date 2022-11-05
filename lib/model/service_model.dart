class ServiceModel {
  final int cost;
  final String title;
  final String id;
  final String pharmacyID;

  ServiceModel({
    required this.cost,
    required this.title,
    required this.id,
    required this.pharmacyID,
  });

  factory ServiceModel.fromMap(Map<String, dynamic> map) {
    return ServiceModel(
      cost: map['cost'],
      title: map['title'],
      id: map['id'],
      pharmacyID: map['pharmacyID'],
    );
  }
}

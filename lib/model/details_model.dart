class DetailsModelPharmacy{
  final String dis;
  final String address;
  final bool approved;
  final String id;

  const DetailsModelPharmacy({
    required this.dis,
    required this.address,
    required this.approved,
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'dis': this.dis,
      'address': this.address,
      'approved': this.approved,
      'id': this.id,
    };
  }

  factory DetailsModelPharmacy.fromMap(Map<String, dynamic> map) {
    return DetailsModelPharmacy(
      dis: map['dis'] as String,
      address: map['address'] as String,
      approved: map['approved'] as bool,
      id: map['id'] as String,
    );
  }
}

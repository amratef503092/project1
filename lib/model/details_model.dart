class DetailsModelPharmacy{
  final String description;
  final String address;
  final bool approved;

  const DetailsModelPharmacy({
    required this.description,
    required this.address,
    required this.approved,
  });

  Map<String, dynamic> toMap() {
    return {
      'dis': this.description,
      'address': this.address,
      'approved': this.approved,
    };
  }

  factory DetailsModelPharmacy.fromMap(Map<String, dynamic> map) {
    return DetailsModelPharmacy(
      description: map['dis'] as String,
      address: map['address'] as String,
      approved: map['approved'] as bool,
    );
  }
}

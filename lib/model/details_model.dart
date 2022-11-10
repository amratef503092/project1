class DetailsModelPharmacy{

  final bool approved;
  final String id;

  const DetailsModelPharmacy({

    required this.approved,
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return {

      'approved': this.approved,
      'id': this.id,
    };
  }

  factory DetailsModelPharmacy.fromMap(Map<String, dynamic> map) {
    return DetailsModelPharmacy(

      approved: map['approved'] as bool,
      id: map['id'] as String,
    );
  }
}

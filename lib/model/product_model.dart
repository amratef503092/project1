class ProductModel{
  String description;
  String id;
  String image;
  String pharmacyID;
  int price;
  String title;
  String type;
  int quantity;

  ProductModel({
    required this.description,
    required this.id,
    required this.image,
    required this.pharmacyID,
    required this.price,
    required this.title,
    required this.type,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'description': this.description,
      'id': this.id,
      'image': this.image,
      'pharmacyID': this.pharmacyID,
      'price': this.price,
      'title': this.title,
      'type': this.type,
      'quantity': this.quantity,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      description: map['description'] as String,
      id: map['id'] as String,
      image: map['image'] as String,
      pharmacyID: map['pharmacyID'] as String,
      price: map['price'] as int,
      title: map['title'] as String,
      type: map['type'] as String,
      quantity: map['quantity'] as int,
    );
  }
}
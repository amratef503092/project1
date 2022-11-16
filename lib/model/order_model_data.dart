
class OrderModelData{

  String idProduct;
  int quantity;
  String pharmacyID;
  String image;

  OrderModelData({
    required this.idProduct,
    required this.quantity,
    required this.pharmacyID,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'idProduct': this.idProduct,
      'quantity': this.quantity,
      'pharmacyID': this.pharmacyID,
      'image': this.image,
    };
  }

  factory OrderModelData.fromMap(Map<String, dynamic> map) {
    return OrderModelData(
      idProduct: map['idProduct'] as String,
      quantity: map['quantity'] as int,
      pharmacyID: map['pharmacyID'] as String,
      image: map['image'] as String,
    );
  }
}
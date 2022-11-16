
class OrderModelData{
  String title;
  String idProduct;
  num price;
  String image;
  int quantity;
  String pharmacyID;

  OrderModelData({
    required this.title,
    required this.idProduct,
    required this.price,
    required this.image,
    required this.quantity,
    required this.pharmacyID,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': this.title,
      'idProduct': this.idProduct,
      'price': this.price,
      'image': this.image,
      'quantity': this.quantity,
      'pharmacyID': this.pharmacyID,
    };
  }

  factory OrderModelData.fromMap(Map<String, dynamic> map) {
    return OrderModelData(
      title: map['title'] as String,
      idProduct: map['idProduct'] as String,
      price: map['price'] as num,
      image: map['image'] as String,
      quantity: map['quantity'] as int,
      pharmacyID: map['pharmacyID'] as String,
    );
  }
}
class OrderModel
{
  var orderDate;
  String orderStatus;
  String pharmacyID;
  String productID;
  num quantity;
  num totalPrice;
  String userID;
  String id;
  String address;
  String title;

  OrderModel({
    required this.orderDate,
    required this.orderStatus,
    required this.pharmacyID,
    required this.productID,
    required this.quantity,
    required this.totalPrice,
    required this.userID,
    required this.id,
    required this.address,
    required this.title
  });

  Map<String, dynamic> toMap() {
    return {
      'orderDate': orderDate,
      'orderStatus': orderStatus,
      'pharmacyID': pharmacyID,
      'productID': this.productID,
      'quantity': this.quantity,
      'totalPrice': this.totalPrice,
      'userID': this.userID,
      'address':this.address,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      address: map['address'] ?? '',
      id: map['orderId'],
      orderDate: map['orderDate']  ??'' ,
      orderStatus: map['orderStatus'] as String,
      pharmacyID: map['PharmacyId'] as String,
      productID: map['product']['productID'] as String,
      quantity: map['product']['quantity'] as num,
      totalPrice: map['product']['totalPrice'] as num,
      userID: map['userId'] as String,
      title: map['product']['title']
    );
  }
}

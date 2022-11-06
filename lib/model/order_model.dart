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

  OrderModel({
    required this.orderDate,
    required this.orderStatus,
    required this.pharmacyID,
    required this.productID,
    required this.quantity,
    required this.totalPrice,
    required this.userID,
    required this.id,
    required this.address
  });

  Map<String, dynamic> toMap() {
    return {
      'orderDate': this.orderDate,
      'orderStatus': this.orderStatus,
      'pharmacyID': this.pharmacyID,
      'productID': this.productID,
      'quantity': this.quantity,
      'totalPrice': this.totalPrice,
      'userID': this.userID,
      'address':this.address,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      address: map['address'],
      id: map['id'],
      orderDate: map['orderDate'] ,
      orderStatus: map['orderStatus'] as String,
      pharmacyID: map['pharmacyID'] as String,
      productID: map['productID'] as String,
      quantity: map['quantity'] as num,
      totalPrice: map['totalPrice'] as num,
      userID: map['userID'] as String,
    );
  }
}

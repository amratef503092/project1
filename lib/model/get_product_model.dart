import 'package:graduation_project/model/product_model.dart';

class GetProductModel {
  String pharmacyID;
  String orderID;
  String ordeStatus;
  String image;
  String imagePharmacy;
  int quantity;
  String title;
  String userID;
  int price;
  String type;
  String productID;

  GetProductModel({
    required this.pharmacyID,
    required this.orderID,
    required this.ordeStatus,
    required this.price,
    required this.image,
    required this.imagePharmacy,
    required this.quantity,
    required this.title,
    required this.userID,
    required this.productID,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'pharmacyID': this.pharmacyID,
      'orderID': this.orderID,
      'ordeStatus': this.ordeStatus,
      'image': this.image,
      'imagePharmacy': this.imagePharmacy,
      'quantity': this.quantity,
      'title': this.title,
      'userID': this.userID,
      'type': this.type,
    };
  }

  factory GetProductModel.fromMap(Map<String, dynamic> map) {
    return GetProductModel(
      pharmacyID: map['PharmacyId'] as String,
      orderID: map['orderId'] as String,
      ordeStatus: map['orderStatus'] as String,
      image: map['product']['image'] as String,
      price: map['product']['price'] as int,
      imagePharmacy: map['product']['imagePharmacy'] as String,
      quantity: map['product']['quantity'] as int,
      title: map['product']['title'] as String,
      userID: map['userId'] as String,
      productID: map['product']['id'] as String,
      type: map['product']['type'] as String,
    );
  }
}

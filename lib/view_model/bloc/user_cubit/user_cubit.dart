import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/model/product_model.dart';
import 'package:graduation_project/view_model/database/local/cache_helper.dart';
import 'package:meta/meta.dart';

import '../../../model/order_model.dart';
import '../../../model/pharmacy_model.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  static UserCubit get(context) => BlocProvider.of<UserCubit>(context);
  List<ProductModel> productModel = [];
  List<ProductModel> productModelOrder = [];

  Future<void> getMedicine() async {
    productModel = [];
    emit(GetMedicineLoadingState());
    await FirebaseFirestore.instance.collection('product').get().then((value) {
      value.docs.forEach((element) {
        productModel.add(ProductModel.fromMap(element.data()));
      });
      emit(GetMedicineSuccessfulState());
    }).catchError((onError) {
      emit(GetMedicineErrorState(onError.toString()));
    });
  }

  List<PharmacyModel> pahrmacyModel = [];

  Future<void> getPharmacy() async {
    emit(GetPharmacyLoadingState());
    pahrmacyModel = [];

    FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: '2')
        .get()
        .then((value) {
      for (var element in value.docs) {
        pahrmacyModel.add(PharmacyModel.fromMap(element.data()));
      }
      emit(GetPharmacySuccessfulState());
    }).catchError((onError) {
      emit(GetPharmacyErrorState(onError.toString()));
    });
  }

  Future<void> buyProduct(
      {required ProductModel productModel,
      required int quantity,
      required String address}) async {
    int price = productModel.price * quantity;
    emit(BuyProductLoadingState());
    await FirebaseFirestore.instance
        .collection('product')
        .doc(productModel.id)
        .collection('orders')
        .add({
      'userID': CacheHelper.getDataString(key: 'id'),
      'pharmacyID': productModel.pharmacyID,
      'productID': productModel.id,
      'quantity': quantity,
      'totalPrice': price,
      'orderDate': DateTime.now(),
      'orderStatus': 'pending',
      'address': address,
    }).then((value) async {
      await FirebaseFirestore.instance
          .collection('product')
          .doc(productModel.id)
          .collection('orders')
          .doc(value.id)
          .update({
        'id': value.id,
      });
      emit(BuyProductSuccessfulState());
    }).catchError((onError) {
      emit(BuyProductErrorState(onError.toString()));
    });
  }

  List<OrderModel> myOrders = [];

  Future<void> getMyOrderProduct() async {
    emit(GetMyProductLoadingState());
    myOrders = [];
    productModelOrder = [];
    await FirebaseFirestore.instance.collection('product').get().then((value) {
      value.docs.forEach((element) async {
        await FirebaseFirestore.instance
            .collection('product')
            .doc(element.id)
            .collection('orders')
            .where('userID', isEqualTo: CacheHelper.getDataString(key: 'id'))
            .get()
            .then((value) async{
          for (var element in value.docs) {
            myOrders.add(OrderModel.fromMap(element.data()));
            print(element.data());
          }
          await getInfo();
        });
      });
      emit(GetMyProductSuccessfulState());


    }).catchError((onError) {
      emit(GetMyProductErrorState(onError.toString()));
    });
  }
  Future<void> getInfo() async {
     myOrders.forEach((element) async{
      await FirebaseFirestore.instance
          .collection('product')
          .doc(element.productID)
          .get()
          .then((value) {
        productModelOrder.add(ProductModel.fromMap(value.data()!));
      });
      emit(GetMyProductSuccessfulState());

     });

  }

}

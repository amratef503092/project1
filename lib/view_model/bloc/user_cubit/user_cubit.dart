import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/model/product_model.dart';
import 'package:graduation_project/view_model/database/local/cache_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'dart:io' as io;
import '../../../model/get_service_model.dart';
import '../../../model/order_model.dart';
import '../../../model/pharmacy_model.dart';
import '../../database/local/sql_lite.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  static UserCubit get(context) => BlocProvider.of<UserCubit>(context);
  List<ProductModel> productModel = [];
  List<ProductModel> search = [];
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
        .where('role', isEqualTo: '2').where('approved', isEqualTo: true)
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

  Future<void> getPharmacyAdmin() async {
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

  Future<void> buyProduct({required ProductModel productModel,
    required int quantity,
    required String address,
    required String title}) async {
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
      'title': title
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
  List<GetServiceModel> myServiceOrders = [];

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
            .then((value) async {
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
    myOrders.forEach((element) async {
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

  Future<void> getMyServiceOrder() async {
    emit(GetMyProductLoadingState());

    myServiceOrders = [];
    await FirebaseFirestore.instance.collection('services').get().then((value) {
      value.docs.forEach((element) async {
        await FirebaseFirestore.instance
            .collection('services')
            .doc(element.id)
            .collection('orders')
            .where('userID', isEqualTo: CacheHelper.getDataString(key: 'id'))
            .get()
            .then((value) async {
          for (var element in value.docs) {
            myServiceOrders.add(GetServiceModel.fromMap(element.data()));
          }
        }).whenComplete(() {
          emit(GetMyProductSuccessfulState());
        });
      });
    }).catchError((onError) {
      emit(GetMyProductErrorState(onError.toString()));
    });
  }

  XFile ?image;

  Future<void> pickImageFromCamera() async
  {
    emit(PickImageLoadingState());
    image = (await ImagePicker().pickImage(source: ImageSource.camera))!;
    if (image != null) {
      emit(PickImageSuccessfulState());
    }
  }

  Future<void> pickImageFromGallery() async
  {
    emit(PickImageLoadingState());
    image = (await ImagePicker().pickImage(source: ImageSource.gallery))!;
    if (image != null) {
      emit(PickImageSuccessfulState());
    }
  }

  String ? url;

  Future<void> uploadFile(BuildContext context , ProductModel productModel ,count) async {
    emit(UploadImageStateLoading());
    if (image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No file was selected'),
        ),
      );

      return;
    }

    UploadTask uploadTask;

    // Create a Reference to the file
    Reference ref = FirebaseStorage.instance.ref().child('/${image!.name}');

    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': image!.path},
    );

    if (kIsWeb) {
      uploadTask = ref.putData(await image!.readAsBytes(), metadata);
    } else {
      if (kDebugMode) {
        print('Amr2');
      }
      ref.putFile(io.File(image!.path), metadata).then((p0) =>
      {
        ref.getDownloadURL().then((value) {
          // here modify the profile pic
          SQLHelper.addCard(
            image: value,
            idProduct: productModel.id,
            pharmacyID: productModel.pharmacyID,
            quantity: count ,
          )
              .then((value) {
            Navigator.pop(context);
            debugPrint('Add Data in card Successful');
          });
          if (kDebugMode) {
            print(value);
          }
          emit(UploadImageSuccessfulState());
        })
      }).catchError((onError) {
        print(onError);
        emit(UploadImageErrorState(onError.toString())
        );
      });
    }
  }

}

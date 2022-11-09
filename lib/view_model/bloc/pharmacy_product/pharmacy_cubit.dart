import 'dart:io' as io;

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/view_model/database/local/cache_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

import '../../../code/constants_value.dart';
import '../../../model/order_model.dart';
import '../../../model/product_model.dart';
import '../../../model/user_model.dart';

part 'pharmacy_state.dart';

class PharmacyCubit extends Cubit<PharmacyState> {
  PharmacyCubit() : super(PharmacyInitial());

  static PharmacyCubit get(context) => BlocProvider.of<PharmacyCubit>(context);
  List<ProductModel> productsModel = [];

  Future<void> getPharmacyProduct() async {
    emit(GetProductLodaing());
    productsModel = [];
    await FirebaseFirestore.instance
        .collection('product')
        .where('pharmacyID', isEqualTo: userID)
        .get()
        .then((value) {
      print(value.docs.length);
      for (var element in value.docs) {
        productsModel.add(ProductModel.fromMap(element.data()));
      }
      print(productsModel.length);
      emit(GetProductSuccsseful('Successful'));
    }).catchError((onError) {
      print(onError);
      emit(GetProductError('onError'));
    });
  }

  Future<void> updateProduct({
    required String description,
    required int price,
    required String title,
    required String type,
    required int quantity,
    required String id,
  }) async {
    emit(UpdateProductLodaing());
    await FirebaseFirestore.instance.collection('product').doc(id).update({
      'title': title,
      'price': price,
      'quantity': quantity,
      'description': description,
      'type': type,
    }).then((value) {
      productsModel = [];
      getPharmacyProduct();
      emit(UpdateProductSuccsseful('Successful'));
    }).catchError((onError) {
      print(onError);
      emit(UpdateProductError('onError'));
    });
  }

  Future<void> editImageProduct(
      XFile? file, BuildContext context, String docId) async {
    emit(UploadImageLoadingState());
    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No file was selected'),
        ),
      );

      return;
    }

    UploadTask uploadTask;

    // Create a Reference to the file
    Reference ref = FirebaseStorage.instance.ref().child('/${file.name}');

    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': file.path},
    );

    if (kIsWeb) {
      uploadTask = ref.putData(await file.readAsBytes(), metadata);
    } else {
      print('Amr2');
      ref.putFile(io.File(file.path), metadata).then((p0) => {
            ref.getDownloadURL().then((value) async {
              await FirebaseFirestore.instance
                  .collection('product')
                  .doc(docId)
                  .update({'image': value}).then((value) {
                getPharmacyProduct();
                emit(UploadImageSuccessfulState('done'));
              });

              // here modify the profile pic
            })
          });
    }
  }

  Future<void> deleteProduct({required String id}) async {
    emit(DeleteProductLoading());
    await FirebaseFirestore.instance
        .collection('product')
        .doc(id)
        .delete()
        .then((value) {
      getPharmacyProduct();
      emit(DeleteProductSuccessful('Successful'));
    }).catchError((onError) {
      print(onError);
      emit(DeleteProductError('onError'));
    });
  }

  List<OrderModel> orders = [];
  List<ProductModel> productsOrder = [];

  Future<void> getOrders(String status) async {
    emit(GetOrderLoading());
    orders = [];
    await FirebaseFirestore.instance
        .collection('product')
        .where('pharmacyID', isEqualTo: CacheHelper.getDataString(key: 'id'))
        .get()
        .then((value) async {
      value.docs.forEach((element) async {
        await FirebaseFirestore.instance
            .collection('product')
            .doc(element.id)
            .collection('orders')
            .where('orderStatus', isEqualTo: status)
            .get()
            .then((value) {
          value.docs.forEach((element) {
            orders.add(OrderModel.fromMap(element.data()));
          });
        });
        for (var element in orders) {
          await FirebaseFirestore.instance
              .collection('product')
              .where(element.productID)
              .get()
              .then((value) {
            for (var element in value.docs) {
              productsOrder.add(ProductModel.fromMap(element.data()));
            }
          });
        }
        emit(GetOrderSuccessful('Successful'));
      });
    }).catchError((onError) {
      print(onError);
      emit(GetOrderError('Error'));
    });
  }

  Future<void> acceptOrder(
      {required String orderID, required String productID}) async {
    emit(AcceptOrderLoading());
    await FirebaseFirestore.instance
        .collection('product')
        .doc(productID)
        .update({
      'quantity': FieldValue.increment(-1),
    }).then((value) async {
      await FirebaseFirestore.instance
          .collection('product')
          .doc(productID)
          .collection('orders')
          .doc(orderID)
          .update({
        'orderStatus': 'Accepted',
      }).then((value) {
        getOrders('pending');
        emit(AcceptOrderSuccessful('Successful'));
      });
    }).catchError((onError) {
      emit(AcceptOrderError('Error'));
    });
  }

  Future<void> getPharmacySpecificProduct({required String pharmacyID}) async {
    emit(GetProductLodaing());
    productsModel = [];
    await FirebaseFirestore.instance
        .collection('product')
        .where('pharmacyID', isEqualTo: pharmacyID)
        .get()
        .then((value) {
      print(value.docs.length);
      for (var element in value.docs) {
        productsModel.add(ProductModel.fromMap(element.data()));
      }
      print(productsModel.length);
      emit(GetProductSuccsseful('Successful'));
    }).catchError((onError) {
      print(onError);
      emit(GetProductError('onError'));
    });
  }

  List<ProductModel> getProductByType = [];

  Future<void> getByTypes({required String type}) async {
    emit(GetProductLodaing());
    getProductByType = [];
    await FirebaseFirestore.instance
        .collection('product')
        .where('type', isEqualTo: type)
        .get()
        .then((value) {
      print(value.docs.length);
      for (var element in value.docs) {
        getProductByType.add(ProductModel.fromMap(element.data()));
      }
      print(getProductByType.length);
      emit(GetProductSuccsseful('Successful'));
    }).catchError((onError) {
      print(onError);
      emit(GetProductError('onError'));
    });
  }

  List<UserModel> usersMessage = [];

  Future<void> getMessage() async {
    emit(GetMessageLoading());
    await FirebaseFirestore.instance
        .collection('users')
        .doc(CacheHelper.getDataString(key: 'id'))
        .collection('message')
        .get()
        .then((value) {
      emit(GetMessageSuccessful('Successful'));
    }).catchError((onError) {
      print(onError);
      emit(GetMessageError('Error'));
    });
  }

  Future<void> getUsers() async {
    emit(GetUsersMessageLoading());
    usersMessage = [];
    await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: '3')
        .get()
        .then((value) {
      for (var element in value.docs) {
        print(element.data());
        usersMessage.add(UserModel.fromMap(element.data()));
      }
      emit(GetUsersMessageSuccessful('Successful'));
    }).catchError((error) {
      print(error);
      emit(GetUsersMessageError('Error'));
    });
  }

  num currentRate = 0.0;
  num userRate = 0.0;

  Future<void> postRateToPharmacy(
      {required String pharmacyId, required double rate}) async {
    emit(PostRateLoading());
    debugPrint('rate is $pharmacyId');
    if (userRate == 0) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(pharmacyId)
          .collection('rate')
          .add({
        'userID': CacheHelper.getDataString(key: 'id'),
        'rate': rate,

      }).then((value) async {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(pharmacyId)
            .collection('rate')
            .doc(value.id)
            .update({
          'id': value.id,
        }).then((value) {
          emit(PostRateSuccessful('Successful'));
        });
      }

      ).catchError((onError) {
        print(onError);
        emit(PostRateError('Error'));
      });
    }else{
      await FirebaseFirestore.instance
          .collection('users')
          .doc(pharmacyId)
          .collection('rate').where('userID',isEqualTo: CacheHelper.getDataString(key: 'id'))
          .get().then((value) {
            value.docs.forEach((element) {
              FirebaseFirestore.instance.collection('users').doc(pharmacyId).collection('rate').doc(element.id).update({
                'rate': rate,
              }).then((value) {
                emit(PostRateSuccessful('Successful'));
              });
            });

    });
    }
  }

  Future<void> getRatePharmacy({
    required String pharmacyId,
  }) async {
    emit(GetCurrentRateLoading('loading'));
    currentRate = 0.0;
    debugPrint('rate is $pharmacyId');
    await FirebaseFirestore.instance
        .collection('users')
        .doc(pharmacyId)
        .collection('rate')
        .get()
        .then((value) {
      if (value.docs.length == 0) {
        currentRate = 0.0;
      } else {
        for (var element in value.docs) {
          currentRate = currentRate + element.data()['rate'];
        }
        currentRate = currentRate / value.docs.length;
      }
      emit(GetCurrentRateSuccessful('loaing'));
    }).catchError((value) {
      emit(GetCurrentRateError('Error'));
    });
  }

  Future<void> getUserRate({
    required String pharmacyId,
  }) async {
    emit(GetUserRateLoading('loading'));
    userRate = 0.0;
    debugPrint('rate is $pharmacyId');
    await FirebaseFirestore.instance
        .collection('users')
        .doc(pharmacyId)
        .collection('rate')
        .where('userID', isEqualTo: CacheHelper.getDataString(key: 'id'))
        .get()
        .then((value) {
      for (var element in value.docs) {
        userRate = element.data()['rate'];
      }
      print(userRate);
      emit(GetUserRateSuccessful('loaing'));
    }).catchError((value) {
      emit(GetUserRateError('Error'));
    });
  }

}

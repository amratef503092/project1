import 'package:bloc/bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io' as io;
import '../../../code/constants_value.dart';
import '../../../model/pharmacy_model.dart';
import '../../../model/product_model.dart';

part 'pharmacy_state.dart';

class PharmacyCubit extends Cubit<PharmacyState> {
  PharmacyCubit() : super(PharmacyInitial());
  static PharmacyCubit get(context) => BlocProvider.of<PharmacyCubit>(context);
  List<ProductModel> productsModel = [];
  Future<void> getPharmacyProduct() async
  {
    productsModel = [];
    emit(GetProductLodaing());
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
  Future<void>updateProduct({
  required String description,
    required int price,
    required String title,
    required String type,
    required int quantity,
    required String id,

})
  async
  {

    emit(UpdateProductLodaing());
    await
    FirebaseFirestore.instance.collection('product').doc(id).update({
      'title':title,
      'price':price,
      'quantity':quantity,
      'description':description,
      'type' : type,
    }).then((value) {
      productsModel = [];
      getPharmacyProduct();
      emit(UpdateProductSuccsseful('Successful'));
    }).catchError((onError) {
      print(onError);
      emit(UpdateProductError('onError'));
    });
  }
  Future<void> editImageProduct(XFile? file, BuildContext context ,String docId) async {
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
          await FirebaseFirestore.instance.collection('product').doc(docId).update({'image': value}).then((value) {
            getPharmacyProduct();
            emit(UploadImageSuccessfulState('done'));

          });

          // here modify the profile pic
        })
      });
    }
  }

}

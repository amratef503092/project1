import 'dart:io' as io;

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/code/constants_value.dart';
import 'package:graduation_project/view_model/bloc/auth/auth_cubit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

import '../../../model/details_model.dart';
import '../../../model/pharmacy_model.dart';

part 'approve_state.dart';

class ApproveCubit extends Cubit<ApproveState> {
  ApproveCubit() : super(ApproveInitial());
  final ImagePicker _picker = ImagePicker();

  static ApproveCubit get(context) => BlocProvider.of<ApproveCubit>(context);
  List<DetailsModelPharmacy> detailsModelPharmacyAdminApproved = [];

  Future<void> getDataToApproved() async {
    detailsModelPharmacyAdminApproved = [];
    emit(GetDataToApprovedStateLoading('loading'));
    FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: '2')
        .get()
        .then((value) async {
      for (var element in value.docChanges) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(element.doc.id)
            .collection('details')
            .get()
            .then((value) {
          for (var element in value.docChanges) {
            print(element.doc.data()!['approved']);
            if (!element.doc.data()!['approved']) {
              detailsModelPharmacyAdminApproved
                  .add(DetailsModelPharmacy.fromMap(element.doc.data()!));
            }
          }
        });
      }
      getMoreInfoPharmacy();
    }).catchError((onError) {
      print(onError);
      emit(GetDataToApprovedStateError('onError'));
    });
  }

  List<PharmacyModel> pharmacyModel = [];

  Future<void> getMoreInfoPharmacy() async {
    emit(GetMoreInfoPharmacyStateLoading());
    pharmacyModel = [];
    try {
      for (var element in detailsModelPharmacyAdminApproved) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(element.id)
            .get()
            .then((value) {
          pharmacyModel.add(PharmacyModel.fromMap(value.data()!));
        });
      }
      print(pharmacyModel.length);
      emit(GetMoreInfoPharmacyStateSuccessful());
    } catch (onError) {
      emit(GetMoreInfoPharmacyStateError());
    }
  }

  Future<void> approvePharmacy(
      {required String userID, required int index}) async {
    emit(ApprovePharmacyStateLoading());
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('details')
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        FirebaseFirestore.instance
            .collection('users')
            .doc(userID)
            .collection('details')
            .doc(element.id)
            .update({'approved': true}).then((value) {
          pharmacyModel.removeAt(index);
          detailsModelPharmacyAdminApproved.removeAt(index);
          emit(ApprovePharmacyStateSuccessful());
        });
      });
    }).catchError((onError) {
      print(onError);
      emit(ApprovePharmacyStateError());
    });
  }

  Future<void> uploadFile(XFile? file, BuildContext context ,String docId) async {
    emit(UploadImageStateLoading());
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
                emit(UploadImageStateSuccessful());

              });

              // here modify the profile pic
            })
          });
    }
  }
   XFile? image;
  Future<void> pickImageGallary(BuildContext context) async {
   image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
    } else {
      print(image!.path);
      emit(pickImageGallaryStateSuccessful());
    }
  }
  Future<void> pickImageCamera(BuildContext context) async {
   image = await _picker.pickImage(source: ImageSource.camera);
    if (image == null) {
    } else {
      print(image!.path);
      emit(pickImageCameraStateSuccessful());
    }
  }
  Future<void> removeImage() async {
    image = null;
    emit(RemoveImageStateSuccessful());
  }
  Future<void> addProduct({
  required String title,
    required String description,
    required int price,
    required int quantity,
    required BuildContext context,
    required String type,

}) async{
    String ? docId;
    emit(AddProductStateLoading());
    await FirebaseFirestore.instance.collection('product').add({
      'title':title,
      'price':price,
      'image':quantity,
      'description':description,
      'pharmacyID':userID,
      'quantity':quantity,
      'type':type,
    }).then((value) async{
      docId = value.id;
      await FirebaseFirestore.instance.collection('product').doc(value.id).update({
        'id':value.id,
      }).then((value)
      {

        uploadFile(image, context,docId!);
        emit(AddProductSuccessfulState());
    }).catchError((onError){
      emit(AddProductStateError());
    });
  });

}
}

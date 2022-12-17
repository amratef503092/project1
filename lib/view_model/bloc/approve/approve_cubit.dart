import 'dart:io' as io;

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/view_model/database/local/cache_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

import '../../../model/details_model.dart';
import '../../../model/pharmacy_model.dart';
import '../pharmacy_product/pharmacy_cubit.dart';

part 'approve_state.dart';

class ApproveCubit extends Cubit<ApproveState> {
  ApproveCubit() : super(ApproveInitial());
  final ImagePicker _picker = ImagePicker();
  bool wait = false;

  static ApproveCubit get(context) => BlocProvider.of<ApproveCubit>(context);
  List<DetailsModelPharmacy> detailsModelPharmacyAdminApproved = [];

  //this function will do get all pharmacy from database to approve it
  Future<void> getDataToApproved() async {
    emit(GetDataToApprovedStateLoading('loading'));
    detailsModelPharmacyAdminApproved = [];
    // this is the path of data in database i determine it to get it
    await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: '2')
        .where('approved', isEqualTo: false)
        .get()
        .then((value) async {
          for (var element in value.docs) {
            print(value.docs.length);
            detailsModelPharmacyAdminApproved
                .add(DetailsModelPharmacy.fromMap(element.data()));
          }
          emit(GetDataToApprovedStateSuccessful('Done'));
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
          print(value.data());
          // pharmacyModel.add(PharmacyModel.fromMap(value.data()!));
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
        .update({'approved': true}).then((value) {
      detailsModelPharmacyAdminApproved.removeAt(index);
      emit(ApprovePharmacyStateSuccessful());
    }).catchError((onError) {
      print(onError);
      emit(ApprovePharmacyStateError());
    });
  }
  Future<void> rejectPharmacy(
      {required String userID, required int index}) async {
    emit(ApprovePharmacyStateLoading());
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .update({'ban': false ,'role':'4'}).then((value) {
      detailsModelPharmacyAdminApproved.removeAt(index);
      detailsModelPharmacyAdminApproved.removeAt(index);
      emit(ApprovePharmacyStateSuccessful());
    }).catchError((onError) {
      print(onError);
      emit(ApprovePharmacyStateError());
    });
  }
  bool uploadFileCheck = false;

  Future<void> uploadFile(
      XFile? file, BuildContext context, String docId) async {
    uploadFileCheck = false;
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
              await FirebaseFirestore.instance
                  .collection('product')
                  .doc(docId)
                  .update({'image': value}).then((value) async {
                print('amr');
                await PharmacyCubit.get(context).getPharmacyProduct();
                wait = false;
                emit(UploadImageStateSuccessful());
              }).catchError(() {
                wait = false;
                emit(UploadError());
              });

              // here modify the profile pic
            })
          });
    }
  }

  Future<void> uploadFileProduct(
      XFile? file, BuildContext context, String docId) async {
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
              await FirebaseFirestore.instance
                  .collection('product')
                  .doc(docId)
                  .update({'image': value}).then((value) {
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
    required bool needPrescription,
  }) async {
    String? docId;
    emit(AddProductStateLoading());
    await FirebaseFirestore.instance.collection('product').add({
      'title': title,
      'price': price,
      'image': quantity,
      'description': description,
      'pharmacyID': CacheHelper.getDataString(key: 'id'),
      'quantity': quantity,
      'type': type,
      'needPrescription' : needPrescription
    }).then((value) async {
      docId = value.id;
      await FirebaseFirestore.instance
          .collection('product')
          .doc(value.id)
          .update({
        'id': value.id,
      }).then((value) async
      {
        wait = true;
        await uploadFile(image, context, docId!).whenComplete(() async {});
        emit(AddProductSuccessfulState());
      }).catchError((onError) {
        emit(AddProductStateError());
      });
    });
  }

  Future<void> creteServices({required String title, required int cost}) async {
    emit(CreateServicesStateLoading('loading'));
    await FirebaseFirestore.instance.collection('services').add({
      'title': title,
      'cost': cost,
      'pharmacyID': CacheHelper.getDataString(key: 'id'),
    }).then((value) async {
      await FirebaseFirestore.instance
          .collection('services')
          .doc(value.id)
          .update({
            'id': value.id,
          })
          .then((value) => emit(CreateServicesStateSuccessful('successful')))
          .catchError((onError) {
            emit(CreateServicesStateError('Error'));
            print(onError.toString());
          });
    });
  }
}

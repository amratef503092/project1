import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../model/details_model.dart';
import '../../../model/pharmacy_model.dart';

part 'approve_state.dart';

class ApproveCubit extends Cubit<ApproveState> {
  ApproveCubit() : super(ApproveInitial());

  static ApproveCubit get(context) => BlocProvider.of<ApproveCubit>(context);
  List<DetailsModelPharmacy> detailsModelPharmacyAdminApproved = [];

  Future<void> getDataToApproved() async {
    detailsModelPharmacyAdminApproved = [];
    emit(GetDataToApprovedStateLoading('loading'));
    FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: '2')
        .get()
        .then((value) async{
      for (var element in value.docChanges) {
      await  FirebaseFirestore.instance
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
    pharmacyModel= [];
    try {
      for (var element in detailsModelPharmacyAdminApproved) {
      await  FirebaseFirestore.instance
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
}

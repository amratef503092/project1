import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/model/product_model.dart';
import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../model/pharmacy_model.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());
  static UserCubit get(context) => BlocProvider.of<UserCubit>(context);
  List<ProductModel>  productModel = [];
  Future<void>getMedicine()async
  {
    productModel =[];
    emit(GetMedicineLoadingState());
    await FirebaseFirestore.instance.collection('product').get().then((value) {
      value.docs.forEach((element) {
        productModel.add(ProductModel.fromMap(element.data()));
      });
      emit(GetMedicineSuccessfulState());
    }).catchError((onError){
      emit(GetMedicineErrorState(onError.toString()));
    });
  }
  List<PharmacyModel>pahrmacyModel = [];
  Future<void>getPharmacy()async{
    emit(GetPharmacyLoadingState());
    pahrmacyModel = [];

    FirebaseFirestore.instance.collection('users').where('role',isEqualTo: '2').get().then((value) {
      for (var element in value.docs) {
        pahrmacyModel.add(PharmacyModel.fromMap(element.data()));
      }
      emit(GetPharmacySuccessfulState());
    }).catchError((onError){
      emit(GetPharmacyErrorState(onError.toString()));
    });
  }
}
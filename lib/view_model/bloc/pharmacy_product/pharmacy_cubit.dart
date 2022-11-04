import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../code/constants_value.dart';
import '../../../model/pharmacy_model.dart';
import '../../../model/product_model.dart';

part 'pharmacy_state.dart';

class PharmacyCubit extends Cubit<PharmacyState> {
  PharmacyCubit() : super(PharmacyInitial());
  static PharmacyCubit get(context) => BlocProvider.of<PharmacyCubit>(context);
  List<ProductModel> productsModel = [];
  Future<void> getPharmacyProduct() async {
    emit(GetProductLodaing());
    await FirebaseFirestore.instance
        .collection('product')
        .where('pharmacyID', isEqualTo: userID)
        .get()
        .then((value) {
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

}

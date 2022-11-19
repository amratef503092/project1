import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/view/pages/pharmacy_pages/search_pharmacy.dart';
import 'package:graduation_project/view/pages/pharmacy_pages/show_all_service_order.dart';
import 'package:meta/meta.dart';


import '../../../model/pharmacy_model.dart';
import '../../../view/pages/pharmacy_pages/home_pharmacy.dart';
import '../../../view/pages/user/all_device_screen.dart';
import '../../../view/pages/user/all_pahrnacy_screen.dart';
import '../../../view/pages/user/medicalDevices.dart';
import '../../../view/pages/user/pharmacy_product.dart';
import '../../../view/pages/user/search_screen.dart';
import '../../../view/pages/user/show_service.dart';
import '../../../view/pages/user/user_home_screen.dart';

part 'layout__state.dart';

class LayoutCubit extends Cubit<LayoutState> {
  LayoutCubit() : super(LayoutInitial());
  static LayoutCubit get(context)=>BlocProvider.of<LayoutCubit>(context);
  int currentIndex = 0;
  int currentPharamcy = 0;

  List<Widget> screens = [
    HomeUserScreen(),
    AllMedicineScreen(),
    AllPharmacyScreen(),
    AllDeviceScreen(),
    SearchScreen(),

  ];
  PharmacyModel? pahrmacyModel;
  void x(PharmacyModel pharmacyModel){
    pahrmacyModel = pharmacyModel;
    emit(LayoutChangeBottomNavBarState());

  }
  List<Widget> screenUserPharmacy =
  [
    PharmacyProduct(),
    const ShowServicePharmacy()
  ];
  List<Widget> Pharmacy = [
    const HomePharmacyScreen(),
    const SearchPharmacy(),
  ];
  List<String> titles = [
    'Home',
    'Medicine',
    'Pharmacy',
    'Medical equipment',
    'Search',
  ];
  void changeBottomNavBarPharamcy(int index) {
    currentPharamcy = index;
    emit(LayoutChangeBottomNavBarState());
  }
  void changeBottomNavBar(int index) {
    currentIndex = index;
    emit(LayoutChangeBottomNavBarState());
  }


}

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../view/pages/user/all_device_screen.dart';
import '../../../view/pages/user/all_pahrnacy_screen.dart';
import '../../../view/pages/user/medicalDevices.dart';
import '../../../view/pages/user/user_home_screen.dart';

part 'layout__state.dart';

class LayoutCubit extends Cubit<LayoutState> {
  LayoutCubit() : super(LayoutInitial());
  static LayoutCubit get(context)=>BlocProvider.of<LayoutCubit>(context);
  int currentIndex = 0;
  List<Widget> screens = [
    HomeUserScreen(),
    AllMedicineScreen(),
  AllPharmacyScreen(),
    AllDeviceScreen(),

  ];
  List<String> titles = [
    'Home',
    'Medicine',
    'Pharmacy',
    'Medical equipment',
  ];

  void changeBottomNavBar(int index) {
    currentIndex = index;
    emit(LayoutChangeBottomNavBarState());
  }


}

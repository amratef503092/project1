import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graduation_project/view_model/bloc/layout/layout__cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../code/constants_value.dart';
import '../../../view_model/bloc/auth/auth_cubit.dart';
import '../../../view_model/database/local/cache_helper.dart';
import '../admin_screen/settings_screen.dart';
import '../auth/login_screen.dart';
import '../pharmacy_pages/show_all_service_order.dart';


class LayoutPharmacy extends StatefulWidget {
  const LayoutPharmacy({Key? key}) : super(key: key);

  @override
  State<LayoutPharmacy> createState() => _LayoutPharmacyState();
}

class _LayoutPharmacyState extends State<LayoutPharmacy> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit, LayoutState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        LayoutCubit cubit = LayoutCubit.get(context);
        return Scaffold(


          body:cubit.Pharmacy[cubit.currentPharamcy],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentPharamcy,
            type: BottomNavigationBarType.fixed,
            onTap: (index){
              cubit.changeBottomNavBarPharamcy(index);
            },
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home'
              ),

              BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.search),
                  label: 'search'
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/model/pharmacy_model.dart';
import 'package:graduation_project/view_model/bloc/layout/layout__cubit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LayOutUserPharmacy extends StatefulWidget {
  LayOutUserPharmacy({Key? key, this.pahrmacyModel}) : super(key: key);
  PharmacyModel? pahrmacyModel;

  @override
  State<LayOutUserPharmacy> createState() => _LayOutUserPharmacyState();
}

class _LayOutUserPharmacyState extends State<LayOutUserPharmacy> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit, LayoutState>(listener: (context, state) {
      // TODO: implement listener
    }, builder: (context, state) {
      return Scaffold(

        body: LayoutCubit.get(context)
            .screenUserPharmacy[LayoutCubit.get(context).currentPharamcy],
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            LayoutCubit.get(context).changeBottomNavBarPharamcy(index);
          },
          currentIndex: LayoutCubit.get(context).currentPharamcy,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.production_quantity_limits), label: 'Product'),
            BottomNavigationBarItem(
                icon: Icon(Icons.home_repair_service), label: 'Services'),
          ],
        ),
      );
    });
  }
}

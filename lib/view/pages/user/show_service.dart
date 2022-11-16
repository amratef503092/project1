import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/view/components/custom_button.dart';
import 'package:graduation_project/view/components/custom_text_field.dart';

import '../../../code/resource/string_manager.dart';
import '../../../view_model/bloc/layout/layout__cubit.dart';
import '../../../view_model/bloc/pharmacy_product/pharmacy_cubit.dart';

class ShowServicePharmacy extends StatefulWidget {
  const ShowServicePharmacy({Key? key}) : super(key: key);

  @override
  State<ShowServicePharmacy> createState() => _ShowServicePharmacyState();
}

class _ShowServicePharmacyState extends State<ShowServicePharmacy> {
  @override
  TextEditingController address = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    PharmacyCubit.get(context).getPharmacySpecificService(
        pharmacyID: LayoutCubit.get(context).pahrmacyModel!.id.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: BlocConsumer<PharmacyCubit, PharmacyState>(
          listener: (context, state) {},
          builder: (context, state) {
            return (state is GetServiceLoading)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : (PharmacyCubit.get(context).allservices.isEmpty)
                    ? const Center(
                        child: Text('No Service'),
                      )
                    : RefreshIndicator(
              onRefresh: () async {
              await  PharmacyCubit.get(context).getPharmacySpecificService(
                  pharmacyID: LayoutCubit.get(context).pahrmacyModel!.id.toString());
              },
                      child: ListView.builder(
                          itemCount:
                              PharmacyCubit.get(context).allservices.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                child: ListTile(
                                  title: Text(
                                      "Service Name : ${PharmacyCubit.get(context).allservices[index].title}"),
                                  subtitle: Text(
                                      "Cost : ${PharmacyCubit.get(context).allservices[index].cost.toString()}"),
                                  trailing: CustomButton(
                                    function: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(
                                                "Are you sure you want to Buy ${PharmacyCubit.get(context).allservices[index].title}"),
                                            content: Form(
                                              key: formKey,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                      "Cost : ${PharmacyCubit.get(context).allservices[index].cost.toString()}"),
                                                  CustomTextField(controller: address, hint: 'Enter Address', fieldValidator: (String ? value){
                                                    if(value!.isEmpty){
                                                      return "please enter your address";
                                                    }
                                                  })
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              CustomButton(
                                                function: ()
                                                {
                                                  if(formKey.currentState!.validate()){
                                                    PharmacyCubit.get(context).buyService(
                                                      cost: PharmacyCubit.get(context).allservices[index].cost,
                                                      title: PharmacyCubit.get(context).allservices[index].title,
                                                      address: address.text,
                                                      serviceID: PharmacyCubit.get(context).allservices[index].id.toString(),
                                                      pharmacyID: LayoutCubit.get(context).pahrmacyModel!.id.toString(),
                                                    ).then((value) {
                                                      Navigator.pop(context);
                                                    });
                                                  }
                                                },
                                                widget: const Text("Yes"),
                                                radius: 10.r,
                                                disable: true,
                                                size: Size(100.w, 40.h),
                                              ),
                                              CustomButton(
                                                function: () {
                                                  Navigator.pop(context);
                                                },
                                                widget: const Text("No"),
                                                radius: 10.r,
                                                color: Colors.red,
                                                disable: true,
                                                size: Size(100.w, 40.h),
                                              )
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    widget: const Text(ADD_TO_CARD),
                                    radius: 10.r,
                                    disable: true,
                                    size: Size(100.w, 40.h),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                    );
          },
        ));
  }
}

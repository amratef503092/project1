import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/code/constants_value.dart';
import 'package:graduation_project/view/components/custom_button.dart';
import 'package:graduation_project/view/components/custom_text_field.dart';
import 'package:graduation_project/view_model/bloc/auth/auth_cubit.dart';

class HomePharmacyScreen extends StatefulWidget {
  const HomePharmacyScreen({Key? key}) : super(key: key);

  @override
  State<HomePharmacyScreen> createState() => _HomePharmacyScreenState();
}

class _HomePharmacyScreenState extends State<HomePharmacyScreen> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    context.read<AuthCubit>().getPharmacyDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Home Pharmacy'),
          ),
          body: (AuthCubit.get(context).detailsModelPharmacy == null)
              ? SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height,
                  child: Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: (state is AddPharmacyDetailsStateSuccessful)
                          ? Center(
                              child: Text("send request Successful"),
                            )
                          : Column(
                              children: [
                                CustomTextField(
                                    controller: descriptionController,
                                    maxLine: 10,
                                    iconData: Icons.description,
                                    hint: 'dis',
                                    fieldValidator: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'please enter description';
                                      }
                                    }),
                                SizedBox(
                                  height: 20.h,
                                ),
                                CustomTextField(
                                    controller: addressController,
                                    maxLine: 1,
                                    iconData: Icons.location_city,
                                    hint: 'dis',
                                    fieldValidator: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'please enter description';
                                      }
                                    }),
                                SizedBox(
                                  height: 20.h,
                                ),
                                CustomButton(
                                  widget: Text("Send To Admin To Approve"),
                                  function: () {
                                    if (formKey.currentState!.validate()) {
                                      AuthCubit.get(context).addPharmacyDetails(
                                        dis: descriptionController.text,
                                        address: addressController.text,
                                      );
                                    }
                                    setState(() {
                                      descriptionController.text = '';
                                      addressController.text = '';
                                      AuthCubit.get(context)
                                          .getPharmacyDetails();
                                    });
                                  },
                                  disable: true,
                                  size: Size(200, 10),
                                  radius: 10.r,
                                  color: buttonColor,
                                )
                              ],
                            ),
                    ),
                  ),
                )
              : (AuthCubit.get(context).detailsModelPharmacy!.approved)
                  ? SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        children: const [
                          Text('Home Pharmacy'),
                        ],
                      ),
                    )
                  : Center(
                      child: Text('Waiting For Admin To Approve'),
                    ),
        );
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/view_model/bloc/auth/auth_cubit.dart';

import '../../../code/constants_value.dart';
import '../../components/custom_button.dart';
import '../../components/custom_text_field.dart';

class RequestData extends StatefulWidget {
  const RequestData({Key? key}) : super(key: key);

  @override
  State<RequestData> createState() => _RequestDataState();
}

class _RequestDataState extends State<RequestData> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(title: Text("Information")),
            body:
            (state is GetPharmacyDetailsStateSuccessful)?Form(
              key: formKey,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 100.r,
                    backgroundImage: NetworkImage((AuthCubit
                        .get(context)
                        .userModel!
                        .photo ==
                        '')
                        ? 'https://firebasestorage.googleapis.com/v0/b/pharmacy-f7702.appspot.com/o/images.jpg?alt=media&token=0aa2b534-e0cf-4ccc-814f-28c57a12d383'
                        : AuthCubit
                        .get(context)
                        .userModel!
                        .photo),
                  ),
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceAround,
                    children: [
                      (state is UploadImageStateLoading)
                          ? const Center(
                        child:
                        CircularProgressIndicator(),
                      )
                          : CustomButton(
                        disable: true,
                        size: Size(170.w, 40.h),
                        widget: const Text(
                            "Select from gallery"),
                        function: () {
                          AuthCubit.get(context)
                              .pickImageGallary(
                              context);
                        },
                      ),
                      (state is UploadImageStateLoading)
                          ? const Center(
                        child:
                        CircularProgressIndicator(),
                      )
                          : CustomButton(
                        size: Size(170.w, 40.h),
                        disable: true,
                        widget: const Text(
                            "Select from camera"),
                        function: () {
                          AuthCubit.get(context)
                              .pickImageCamera(
                              context);
                        },
                      ),
                    ],
                  ),
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
                      hint: 'location',
                      fieldValidator: (String? value) {
                        if (value!.isEmpty) {
                          return 'location';
                        }
                      }),
                  SizedBox(
                    height: 20.h,
                  ),
                  CustomButton(
                    widget: const Text(
                        "Send To Admin To Approve"),
                    function: () {
                      if (formKey.currentState!
                          .validate()) {
                        AuthCubit.get(context)
                            .addPharmacyDetails(
                          dis: descriptionController.text,
                          address: addressController.text,
                        )
                            .whenComplete(() {
                          Future.delayed(
                            const Duration(seconds: 2),
                                () {
                              setState(() {
                                descriptionController.text =
                                '';
                                addressController.text = '';
                              });
                            },
                          );
                        });
                      }
                    },
                    disable: true,
                    size: Size(200, 10),
                    radius: 10.r,
                    color: buttonColor,
                  )
                ],
              ),
            ) :Text("Waiting admin Approve")


        );
      },
    );
  }
}

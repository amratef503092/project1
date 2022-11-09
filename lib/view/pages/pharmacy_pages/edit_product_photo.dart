import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/view_model/bloc/approve/approve_cubit.dart';
import 'dart:io' as io;

import '../../../view_model/bloc/pharmacy_product/pharmacy_cubit.dart';
import '../../components/custom_button.dart';

class EditImage extends StatefulWidget {
  int index;

  EditImage({Key? key, required this.index}) : super(key: key);

  @override
  State<EditImage> createState() => _EditImageState();
}

class _EditImageState extends State<EditImage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PharmacyCubit, PharmacyState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return BlocConsumer<ApproveCubit, ApproveState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            var approveCubit = ApproveCubit.get(context);
            return Scaffold(
              appBar: AppBar(
                title: const Text('Edit Image'),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    (approveCubit.image == null) ? Stack(
                      children: [
                        Image.network(
                          PharmacyCubit
                              .get(context)
                              .productsModel[widget.index]
                              .image,
                          height: 200.h,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ) : Image.file(
                      io.File(approveCubit.image!.path), height: 200.h,
                      width: 200,
                      fit: BoxFit.cover,),
                    const SizedBox(
                      height: 20,
                    ),

                    Column(
                      children: [
                        CustomButton(
                          size: const Size(200, 59),
                          disable: true,
                          widget: const Text("Select from gallery"),
                          function: () {
                            ApproveCubit.get(context).pickImageGallary(context);
                          },
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        CustomButton(
                          disable: true,
                          size: Size(200, 59),

                          widget: const Text("Select from camera"),
                          function: () {
                            ApproveCubit.get(context).pickImageCamera(context);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                      size: const Size(200, 59),
                      disable: true,
                      widget: const Text("Done"),
                      function: () {
                        PharmacyCubit.get(context).editImageProduct(
                            approveCubit.image, context, PharmacyCubit
                            .get(context)
                            .productsModel[widget.index].id);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

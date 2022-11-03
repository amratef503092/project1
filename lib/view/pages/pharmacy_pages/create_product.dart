import 'dart:io' as io;

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../view_model/bloc/approve/approve_cubit.dart';
import '../../components/custom_button.dart';
import '../../components/custom_text_field.dart';

class CreateProduct extends StatefulWidget {
  const CreateProduct({Key? key}) : super(key: key);

  @override
  State<CreateProduct> createState() => _CreateProductState();
}


TextEditingController titleController = TextEditingController();

TextEditingController descriptionController = TextEditingController();

TextEditingController costController = TextEditingController();

TextEditingController quantityController = TextEditingController();

bool showPassword = false;
final List<String> items = [
  'medicine',
  'Medical equipment',
];
String? selectedValue;

class _CreateProductState extends State<CreateProduct> {
GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ApproveCubit, ApproveState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var approveCubit = ApproveCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Create Product'),
          ),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    (approveCubit.image == null)
                        ? const SizedBox(
                            height: 200,
                            width: 200,
                            child: Center(
                              child: Text('No Image Selected'),
                            ),
                          )
                        : Stack(
                            children: [
                              Image.file(
                                io.File(approveCubit.image!.path),
                                height: 200,
                                width: 200,
                                fit: BoxFit.cover,
                              ),
                              IconButton(
                                  onPressed: () {
                                    approveCubit.removeImage();
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                    size: 40,
                                  )),
                            ],
                          ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CustomButton(
                          disable: true,
                          size: Size(170.w, 40.h),
                          widget: Text("Select from gallery"),
                          function: () {
                            ApproveCubit.get(context).pickImageGallary(context);
                          },
                        ),
                        CustomButton(
                          size: Size(170.w, 40.h),
                          disable: true,
                          widget: Text("Select from camera"),
                          function: () {
                            ApproveCubit.get(context).pickImageCamera(context);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomTextField(
                            controller: titleController,
                            fieldValidator: (String ?value) {
                              if (value!.isEmpty) {
                                return 'Title is required';
                              }
                            },
                            hint: 'Title',
                            iconData: Icons.title,
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Row(
                            children: [
                              const Text("Type : "),
                              SizedBox(
                                width: 20.w,
                              ),
                              SizedBox(
                                width: 300.w,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2(
                                    hint: Text(
                                      'Select Item',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context).hintColor,
                                      ),
                                    ),
                                    items: items
                                        .map((item) => DropdownMenuItem<String>(
                                              value: item,
                                              child: Text(
                                                item,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                    value: selectedValue,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedValue = value as String;
                                      });
                                    },
                                    buttonHeight: 40,
                                    buttonWidth: 140,
                                    itemHeight: 40,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          CustomTextField(
                            controller: descriptionController,
                            fieldValidator: (String ? value) {
                              if (value!.isEmpty) {
                                return "cost is required";
                              }
                            },
                            hint: 'Description',
                            iconData: Icons.description,
                            maxLine: 5,
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          CustomTextField(
                            textInputType: TextInputType.number,
                            controller: costController,
                            fieldValidator: (String?value) {
                              if (value!.isEmpty) {
                                return "cost is required";
                              }
                            },
                            hint: 'Const',
                            iconData: Icons.price_change,
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          CustomTextField(
                            textInputType: TextInputType.number,
                            controller: quantityController,
                            fieldValidator: (String value) {
                              if (value.isEmpty) {
                                return "quantity is required";
                              }
                            },
                            hint: 'quantity',
                            iconData: Icons.production_quantity_limits,
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          CustomButton(
                            function: () {
                              if (formKey.currentState!.validate()) {
                                // AuthCubit.get(context).update(
                                //     email: emailController.text,
                                //     phone: phoneController.text,
                                //     age: ageController.text,
                                //     name: nameController.text);
                              }
                            },
                            widget: Text("Post Product"),
                            size: Size(300.w, 50.h),
                            radius: 20.r,
                            disable: true,
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
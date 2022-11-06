import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../code/resource/validator.dart';
import '../../../view_model/bloc/auth/auth_cubit.dart';
import '../../components/custom_button.dart';
import '../../components/custom_text_field.dart';
class EditUserInfo extends StatefulWidget {
  const EditUserInfo({Key? key}) : super(key: key);

  @override
  State<EditUserInfo> createState() => _EditUserInfoState();
}
GlobalKey<FormState> formKey = GlobalKey<FormState>();

TextEditingController emailController = TextEditingController();

TextEditingController passwordController = TextEditingController();

TextEditingController nameController = TextEditingController();

TextEditingController ageController = TextEditingController();

TextEditingController phoneController = TextEditingController();
bool showPassword = false;
bool enable = false;

class _EditUserInfoState extends State<EditUserInfo> {
  void initState() {
    // TODO: implement initState
    context.read<AuthCubit>().getUserData();
    nameController.text = AuthCubit.get(context).userModel!.name;
    phoneController.text = AuthCubit.get(context).userModel!.phone;
    ageController.text = AuthCubit.get(context).userModel!.age;
    emailController.text = AuthCubit.get(context).userModel!.email;

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var authCubit = AuthCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: Text('Edit User Info'),
          ),
          body: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: (state is GetUserDataLoadingState)
                ? Center(
              child: CircularProgressIndicator(),
            )
                : Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 100.r,
                      backgroundImage: NetworkImage((authCubit
                          .userModel!.photo ==
                          '')
                          ? 'https://firebasestorage.googleapis.com/v0/b/pharmacy-f7702.appspot.com/o/images.jpg?alt=media&token=0aa2b534-e0cf-4ccc-814f-28c57a12d383'
                          : authCubit.userModel!.photo),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround
                      ,children: [
                      (state is UploadImageStateLoading)
                          ? const Center(
                        child: CircularProgressIndicator(),
                      )
                          : CustomButton(
                        disable: true,
                        size: Size(170.w,40.h),
                        widget: Text("Select from gallery"),
                        function: () {
                          AuthCubit.get(context)
                              .pickImageGallary(context);
                        },
                      ),

                      (state is UploadImageStateLoading)
                          ? const Center(
                        child: CircularProgressIndicator(),
                      )
                          :  CustomButton(
                        size: Size(170.w,40.h),

                        disable: true,
                        widget: Text("Select from camera"),
                        function: () {
                          AuthCubit.get(context)
                              .pickImageCamera(context);
                        },
                      ),

                    ],),
                    Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomTextField(
                            controller: emailController,
                            fieldValidator: emailValidator,
                            hint: 'email',
                            iconData: Icons.email,
                            enable: enable,
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          CustomTextField(
                            controller: nameController,
                            fieldValidator: (String value) {
                              if (value.trim().isEmpty || value == ' ') {
                                return 'This field is required';
                              }
                              if (!RegExp(r'^[a-zA-Z]+(\s[a-zA-Z]+)?$')
                                  .hasMatch(value)) {
                                return 'please enter only two names with one space';
                              }
                              if (value.length < 3 || value.length > 32) {
                                return 'First name must be between 2 and 32 characters';
                              }
                            },
                            hint: 'name',
                            iconData: Icons.perm_identity,
                            enable: enable,
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          CustomTextField(
                            textInputType: TextInputType.number,
                            controller: ageController,
                            fieldValidator: (String value) {
                              if (value.isEmpty) {
                                return "age is required";
                              }
                            },
                            hint: 'age',
                            iconData: Icons.date_range,
                            enable: enable,
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          CustomTextField(
                            textInputType: TextInputType.phone,
                            controller: phoneController,
                            fieldValidator: phoneValidator,
                            hint: 'phone',
                            iconData: Icons.phone,
                            enable: enable,
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          (state is RegisterLoadingState)
                              ? const Center(
                            child: CircularProgressIndicator(),
                          )
                              : CustomButton(
                            function: () {
                              setState(() {
                                enable = !enable;
                              });
                            },
                            widget: Text("Start Edit"),
                            size: Size(300.w, 50.h),
                            radius: 20.r,
                            disable: true,
                          ),
                          (state is UpdateDataLoadingState)
                              ? const Center(
                            child: CircularProgressIndicator(),
                          )
                              : CustomButton(
                            function: () {
                              if (formKey.currentState!.validate()) {
                                AuthCubit.get(context).update(
                                    email: emailController.text,
                                    phone: phoneController.text,
                                    age: ageController.text,
                                    name: nameController.text);
                              }
                            },
                            widget: Text("confirm Update"),
                            size: Size(300.w, 50.h),
                            radius: 20.r,
                            disable: enable,
                          ),

                        ],
                      ),
                    )
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
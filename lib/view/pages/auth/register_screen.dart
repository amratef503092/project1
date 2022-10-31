import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/view_model/bloc/auth/auth_cubit.dart';

import '../../../code/resource/validator.dart';
import '../../components/custom_button.dart';
import '../../components/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController nameController = TextEditingController();

  TextEditingController ageController = TextEditingController();

  TextEditingController phoneController = TextEditingController();
  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var authCubit = AuthCubit.get(context);
        return Scaffold(
          body: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextField(
                    controller: emailController,
                    fieldValidator: emailValidator,
                    hint: 'email',
                    iconData: Icons.email,
                  ),
                  CustomTextField(
                    controller: passwordController,
                    fieldValidator: passwordValidator,
                    hint: 'Password',
                    iconData: Icons.lock,
                    password: showPassword,
                    passwordTwo: true,
                    function: (){
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
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
                  ),
                  CustomTextField(
                    textInputType: TextInputType.phone,
                    controller: phoneController,
                    fieldValidator: phoneValidator,
                    hint: 'phone',
                    iconData: Icons.phone,
                  ),
                  (state is RegisterLoadingState)
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : CustomButton(
                          function: () {
                            if (formKey.currentState!.validate()) {
                              authCubit.register(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  phone: phoneController.text,
                                  name: nameController.text,
                                  age: ageController.text,
                                role: '3'// will change
                              );
                            }
                          },
                          color: Colors.black,
                          widget: Text("Register"),
                          size: Size(300.w, 50.h),
                          radius: 20.r,
                          disable: true,
                        )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

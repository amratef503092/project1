import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../code/resource/validator.dart';
import '../../../view_model/bloc/auth/auth_cubit.dart';
import '../../components/custom_button.dart';
import '../../components/custom_text_field.dart';
class CreateAdmin extends StatefulWidget {
  const CreateAdmin({Key? key}) : super(key: key);

  @override
  State<CreateAdmin> createState() => _CreateAdminState();
}

class _CreateAdminState extends State<CreateAdmin> {
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

                  Image(
                    image: AssetImage('assets/images/logo.png'),
                    height: 100.h,
                  ),
                  SizedBox(
                    height: 50.h,
                  ),
                  Text("Create New Admin",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w900),),
                  CustomTextField(
                    controller: emailController,
                    fieldValidator: emailValidator,
                    hint: 'email',
                    iconData: Icons.email,
                  ),
                  SizedBox(
                    height: 20.h,
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
                  ),
                  SizedBox(
                    height: 20.h,
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
                          role: '1'
                        );
                      }
                    },
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

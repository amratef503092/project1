import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/view/pages/admin_screen/home_admin_screen.dart';
import 'package:graduation_project/view_model/bloc/auth/auth_cubit.dart';

import '../../../code/resource/validator.dart';
import '../../components/custom_button.dart';
import '../../components/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LoginSuccessfulState) {
          if (state.role == '1') {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminHomeScreen(),
                ),
                (route) => false);
          } else if (state.role == '2') {
            print('Amr 2');
          } else {
            print('Amr 3');
          }
        }
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
                    function: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                  ),
                  (state is LoginLoadingState)
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : CustomButton(
                          function: () {
                            if (formKey.currentState!.validate()) {
                              authCubit.login(
                                email: emailController.text,
                                password: passwordController.text,
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

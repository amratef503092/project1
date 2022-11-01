import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/view_model/bloc/auth/auth_cubit.dart';

import '../../../code/resource/validator.dart';
import '../../components/custom_button.dart';
import '../../components/custom_text_field.dart';
import '../../components/custom_texts.dart';

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
  int selectedValue = 1;
  String dropdownvalue = 'User';

// List of items in our dropdown menu
  var items = [
    'User',
    'Pharmacy',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is RegisterSuccessfulState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Create Account Successful"),
            backgroundColor: Colors.green,
          ));

          Navigator.pop(context);
        } else if (state is RegisterErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Some thing Error"),
            backgroundColor: Colors.red,
          ));
        }
      },
      builder: (context, state) {
        var authCubit = AuthCubit.get(context);
        return Scaffold(
          body: SafeArea(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage('assets/images/logo.png'),
                          height: 100.h,
                        ),
                        SizedBox(
                          height: 30.h,
                        ),

                        Text(
                          "Register",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w900),
                        ),
                        text(text: 'Email'),
                        CustomTextField(
                          controller: emailController,
                          fieldValidator: emailValidator,
                          hint: 'email',
                          iconData: Icons.email,
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        text(text: 'password'),
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
                        SizedBox(
                          height: 20,
                        ),

                        text(text: 'Name'),
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
                          height: 20,
                        ),

                        text(text: 'Age'),
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
                          height: 20,
                        ),

                        text(text: 'Phone'),

                        CustomTextField(
                          textInputType: TextInputType.phone,
                          controller: phoneController,
                          fieldValidator: phoneValidator,
                          hint: 'phone',
                          iconData: Icons.phone,
                        ),
                        // creat drop down button
                        DropdownButton(
                          // Initial Value
                          value: dropdownvalue,

                          // Down Arrow Icon
                          icon: const Icon(Icons.keyboard_arrow_down),

                          // Array list of items
                          items: items.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          // After selecting the desired option,it will
                          // change button value to selected value
                          onChanged: (String? newValue) {
                            print(newValue);
                            setState(() {
                              dropdownvalue = newValue!;
                            });
                          },
                        ),
                        SizedBox(
                          height: 20,
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
                                      role: dropdownvalue == 'User'
                                          ? '3'
                                          : '2', // will change
                                    );
                                  }
                                },
                                color: Color(0xff1A81F7),
                                widget: Text("Register"),
                                size: Size(300.w, 50.h),
                                radius: 20.r,
                                disable: true,
                              )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

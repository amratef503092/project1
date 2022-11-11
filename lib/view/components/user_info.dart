import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../code/resource/validator.dart';
import '../../view_model/bloc/auth/auth_cubit.dart';
import '../pages/admin_screen/settings_screen.dart';
import 'custom_button.dart';
import 'custom_text_field.dart';
import 'custom_texts.dart';

class UserIfo extends StatefulWidget {
  const UserIfo({Key? key}) : super(key: key);

  @override
  State<UserIfo> createState() => _UserIfoState();
}
GlobalKey<FormState> formKey = GlobalKey<FormState>();

TextEditingController emailController = TextEditingController();

TextEditingController passwordController = TextEditingController();

TextEditingController nameController = TextEditingController();

TextEditingController ageController = TextEditingController();
TextEditingController descriptionController = TextEditingController();
TextEditingController phoneController = TextEditingController();
TextEditingController chronicDiseases = TextEditingController();
TextEditingController address = TextEditingController();

bool showPassword = true;
int selectedValue = 1;
String dropdownvalue = 'User';
String bloodTypeSelected = 'O+';

RegExp regExp = RegExp(r"^[0-9]{2}$", caseSensitive: false);

// List of items in our dropdown menu
var items = [
  'User',
  'Pharmacy',
];
List<String> bloodType = ['O+', 'O-', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-'];
class _UserIfoState extends State<UserIfo> {
  @override
  void dispose() {
    // TODO: implement dispose
    emailController.text = '';
    passwordController.text  = '';
    nameController.text = '';
    ageController.text = '';
    descriptionController.text = '';
    phoneController.text = '';
    chronicDiseases.text = '';
    address.text = '';

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AuthCubit.get(context);
        return Form(
          key: formKey,
          child: Column(
            children: [
              text(text: 'Email'),
              CustomTextField(
                controller: emailController,
                fieldValidator: emailValidator,
                hint: 'email',
                iconData: Icons.email,
              ),
              const SizedBox(
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
              text(text: 'BLoad Type'),
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    FaIcon(FontAwesomeIcons.vial, color: Colors.grey),
                    SizedBox(
                      width: 30,
                    ),
                    SizedBox(
                      width: 300.w,
                      child: DropdownButton(
                        // Initial Value
                        isExpanded: true,
                        value: bloodTypeSelected,
                        // Down Arrow Icon
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                        ),
                        // Array list of items
                        items: bloodType.map((String items) {
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
                    )
                  ],
                ),
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
                  if (!RegExp(r'^[a-zA-Z]+(\s[a-zA-Z]+)?$').hasMatch(value)) {
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
                  } else if (regExp.hasMatch(value) == false) {
                    return "number only";
                  } else if (int.parse(value) < 0 && int.parse(value) < 100) {
                    return "please enter valid age";
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
              SizedBox(
                height: 20,
              ),
              // creat drop down button
              text(text: 'chronic-diseases'),
              CustomTextField(
                controller: chronicDiseases,
                fieldValidator: (String value) {
                  if (value.trim().isEmpty || value == ' ') {
                    return 'This field is required';
                  }
                },
                hint: 'chronic-diseases',
                maxLine: 3,
                iconData: Icons.perm_identity,
              ),
              SizedBox(
                height: 20,
              ),
              text(text: 'Address'),
              CustomTextField(
                controller: address,
                fieldValidator: (String value) {
                  if (value.trim().isEmpty || value == ' ') {
                    return 'This field is required';
                  }
                },
                hint: 'Address',
                iconData: Icons.perm_identity,
              ),
              SizedBox(
                height: 20,
              ),
              (state is RegisterLoadingState)
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : CustomButton(
                function: () {
                  // i validate if user Enter all data and then
                  // send data to BackEnd
                  if (formKey.currentState!.validate()) {
                    cubit.registerUser(
                        email: emailController.text.trim(),
                        password: passwordController.text,
                        phone: phoneController.text,
                        name: nameController.text,
                        age: ageController.text,
                        role: '3',
                        // will change
                        address: address.text,
                        boldType: bloodTypeSelected,
                        chornic: chronicDiseases.text);
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
        );
      },
    );
  }
}

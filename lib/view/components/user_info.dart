import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

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
String dropdownvalue = 'Customer';
String bloodTypeSelected = 'O+';
String ?  valueGender = 'Male';

RegExp regExp = RegExp(r"^[0-9]{2}$", caseSensitive: false);

// List of items in our dropdown menu
var items = [
  'Customer',
  'Pharmacy',
];
List<String> bloodType = ['O+', 'O-', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-'];
List<String> gender = ['Male' , 'Female'];
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
  List<String> items =['ALS (Lou Gehrig\'s Disease)','Alzheimer\'s Disease and other Dementias','Arthritis','Asthma','Autism','Cancer','Cerebral Palsy','Chronic Obstructive Pulmonary Disease (COPD)','Crohn\'s Disease','Diabetes','Epilepsy','Fibromyalgia','Heart Disease','Huntington\'s Disease','Inflammatory Bowel Disease (IBD)','Kidney Disease','Liver Disease','Lupus','Multiple Sclerosis (MS)','Muscular Dystrophy','Myasthenia Gravis','Neurofibromatosis','Parkinson\'s Disease','Rheumatoid Arthritis','Sickle Cell Disease','Stroke','Tourette Syndrome','Traumatic Brain Injury (TBI)','Other'];
List<String> _selecteditems = [];
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
                            bloodTypeSelected = newValue!;
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
              Row(
                children: [
                  FaIcon(FontAwesomeIcons.marsAndVenus , color: Colors.grey,),
                  SizedBox(width: 20.w,),
                  SizedBox(
                    width: 320.w,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        hint: Text(
                          'Select Item',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme
                                .of(context)
                                .hintColor,
                          ),
                        ),
                        items: gender
                            .map((item) =>
                            DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ))
                            .toList(),
                        value: valueGender,
                        onChanged: (value) {
                          setState(() {
                            valueGender = value as String ;
                          });
                        },
                        buttonHeight: 40,
                        buttonWidth: 140,
                        itemHeight: 40,
                      ),
                    ),
                  )
                ],
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
              text(text: 'chronic-diseases'),
              MultiSelectDialogField(
                items: items.map((e) => MultiSelectItem(e, e)).toList(),
                listType: MultiSelectListType.CHIP,

                onConfirm: (values) {
                  setState(() {
                    _selecteditems = values;
                  });

                  print(_selecteditems);
                },
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
                        gender:valueGender!,
                        email: emailController.text.trim(),
                        password: passwordController.text,
                        phone: phoneController.text,
                        name: nameController.text,
                        age: ageController.text,
                        role: '3',
                        // will change
                        address: address.text,
                        boldType: bloodTypeSelected,
                        chornic: _selecteditems);
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

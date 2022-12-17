import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/view_model/bloc/auth/auth_cubit.dart';

import '../../components/pharmacy_info.dart';
import '../../components/user_info.dart';
class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  var items = [
    'Customer',
    'Pharmacy',
  ];
  String dropdownvalue = 'Customer';
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is RegisterSuccessfulState) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Create Account Successful"),
            backgroundColor: Colors.green,
          ));

          Navigator.maybePop(context);
        } else if (state is RegisterErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
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
                      (dropdownvalue == 'Customer') ? const UserIfo() : const PharmacyInfo(),
                    ],
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

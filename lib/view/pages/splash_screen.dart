import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/view/pages/admin_screen/home_admin_screen.dart';
import 'package:graduation_project/view/pages/admin_screen/layout_admin.dart';
import 'package:graduation_project/view/pages/auth/login_screen.dart';
import 'package:graduation_project/view/pages/pharmacy_pages/home_pharmacy.dart';
import 'package:graduation_project/view/pages/user/layout_screen.dart';
import 'package:graduation_project/view/pages/user/user_home_screen.dart';
import 'package:graduation_project/view_model/bloc/auth/auth_cubit.dart';

import '../../code/constants_value.dart';
import '../../view_model/database/local/cache_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3)).then((value) async {
      String? token =  CacheHelper.getDataString(key: 'id');

      if (token != null) {
      await  FirebaseFirestore.instance
            .collection('users')
            .doc(token)
            .get()
            .then((value) {
              if(role=='1')
              {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
                  return LayOutScreenAdmin();
                },), (route) => false);
              }else if(role=='2'){

                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
                  return HomePharmacyScreen();
                },), (route) => false);
              }else{
                // user
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
                  return LayoutScreen();
                },), (route) => false);
              }
        });
      } else {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: (context) {
            return LoginScreen();
          },
        ), (route) => false);
      }
    });
  }

  // get data firebase
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/splash-bg.png'),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Center(
                  child: Image(
                    image: AssetImage(
                      'assets/images/logo.png',
                    ),
                    height: 100,
                  )),
              Center(child: CircularProgressIndicator())
            ],)
          )),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graduation_project/view_model/bloc/layout/layout__cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../code/constants_value.dart';
import '../../../view_model/bloc/auth/auth_cubit.dart';
import '../../../view_model/database/local/cache_helper.dart';
import '../auth/login_screen.dart';
import 'EditUserInfo.dart';
import 'orderUser.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({Key? key}) : super(key: key);

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit, LayoutState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        LayoutCubit cubit = LayoutCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title:  Text(cubit.titles[cubit.currentIndex]),
          ),
          drawer: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {},
            builder: (context, state) {
              var authCubit = AuthCubit.get(context);
              return (AuthCubit.get(context).userModel == null)
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : Drawer(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 100.h,
                      ),
                      CircleAvatar(
                        radius: 80.r,
                        backgroundImage: NetworkImage(authCubit.userModel!.photo),
                      ),
                      SizedBox(
                        height: 50.h,
                      ),

                      ListTile(
                        leading: const Icon(Icons.settings),
                        title: const Text("Settings"),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EditUserInfo(),
                              ));
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.shopping_cart),
                        title: const Text("My order"),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MyOrder(),
                              ));
                        },
                      ),
                      // ),
                      // ListTile(
                      // leading: const Icon(Icons.design_services_sharp),
                      // title: const Text("Show all Service"),
                      // onTap: () {
                      // Navigator.push(
                      // context,
                      // MaterialPageRoute(
                      // builder: (context) => const GetPharmacyServices(),
                      // ));
                      // },
                      // ),
                      //
                      // ListTile(
                      // leading: const Icon(Icons.shopify),
                      // title: const Text("Show all Orders"),
                      // onTap: () {
                      // Navigator.push(
                      // context,
                      // MaterialPageRoute(
                      // builder: (context) => const ShowOrders(),
                      // ));
                      // },
                      // ),
                      // ListTile(
                      // leading: const Icon(Icons.logout),
                      // title: const Text("Logout"),
                      // onTap: () async {
                      // await FirebaseFirestore.instance
                      //     .collection('users')
                      //     .doc(userID)
                      //     .update({
                      // 'online': 'false',
                      // }).then((value) async {
                      // userID = null;
                      // await CacheHelper.removeData(key: 'id');
                      // FirebaseAuth.instance.signOut();
                      // }).then((value) {
                      // Navigator.pushAndRemoveUntil(
                      // context,
                      // MaterialPageRoute(
                      // builder: (context) => LoginScreen(),
                      // ),
                      // (route) => false);
                      // });
                      // },
                      // ),

                      ListTile(
                        leading: const Icon(Icons.logout),
                        title: const Text("Logout"),
                        onTap: () async {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(CacheHelper.getDataString(key: 'id'))
                              .update({
                            'online': false,
                          }).then((value) async {
                            userID = null;
                            await CacheHelper.removeData(key: 'id');

                            await  FirebaseAuth.instance.signOut();
                          }).then((value) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                                    (route) => false);
                          });
                        },
                      ),

                    ],
                  ));
            },
          ),
          body:cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            type: BottomNavigationBarType.fixed,
            onTap: (index){
              cubit.changeBottomNavBar(index);
            },
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home'
              ),
              BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.capsules),
                  label: 'Medicine'
              ),
              BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.houseMedical),
                  label: 'Pharmacy'
              ),
              BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.stethoscope),
                  label: 'Device'
              ),
            ],
          ),
        );
      },
    );
  }
}

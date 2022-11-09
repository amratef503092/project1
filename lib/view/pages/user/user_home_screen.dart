import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/view/pages/user/orderUser.dart';
import 'package:graduation_project/view/pages/user/pharmacy_product.dart';
import 'package:graduation_project/view_model/bloc/auth/auth_cubit.dart';
import 'package:graduation_project/view_model/bloc/user_cubit/user_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../code/constants_value.dart';
import '../../../view_model/database/local/cache_helper.dart';
import '../auth/login_screen.dart';
import 'EditUserInfo.dart';
import 'MedicineDetailsScreen.dart';
import 'medicalDevices.dart';

class HomeUserScreen extends StatefulWidget {
  const HomeUserScreen({Key? key}) : super(key: key);

  @override
  State<HomeUserScreen> createState() => _HomeUserScreenState();
}

class _HomeUserScreenState extends State<HomeUserScreen> {
  @override
  void initState() {
    // TODO: implement initState

    AuthCubit.get(context).getUserData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome"),
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
                            .doc(userID)
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
      body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {},
          builder: (context, state) {
            return (AuthCubit.get(context).userModel == null)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          BlocBuilder<UserCubit, UserState>(
                            buildWhen: (previous, current) {
                              if (current is GetMedicineSuccessfulState) {
                                return true;
                              } else {
                                return false;
                              }
                            },
                            builder: (context, state) {
                              var cubit = UserCubit.get(context);
                              return (state is GetMedicineSuccessfulState)
                                  ? (cubit.productModel.length ==0)? Center(child: Text("No Product"),): CarouselSlider.builder(
                                      options: CarouselOptions(
                                        height: 200.0,
                                        aspectRatio: 16 / 9,
                                        viewportFraction: 0.8,
                                        initialPage: 0,
                                        enableInfiniteScroll: true,
                                        reverse: false,
                                        autoPlay: true,
                                        autoPlayInterval:
                                            const Duration(seconds: 3),
                                        autoPlayAnimationDuration:
                                            const Duration(milliseconds: 800),
                                        autoPlayCurve: Curves.fastOutSlowIn,
                                        enlargeCenterPage: true,
                                        scrollDirection: Axis.horizontal,
                                      ),
                                      itemCount: cubit.productModel.length,
                                      itemBuilder: (BuildContext context,
                                              int itemIndex, int pageViewIndex) =>
                                          InkWell(
                                            onTap: (){
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MedicineDetailsScreen(
                                                            productModel:
                                                            cubit.productModel[
                                                            itemIndex],
                                                          )));
                                            },
                                            child: Container(
                                                child: Stack(
                                        children: [
                                            Image.network(
                                              cubit.productModel[itemIndex].image,
                                              fit: BoxFit.cover,
                                              width: 1000.0,
                                            ),
                                            Align(
                                                alignment: Alignment.bottomCenter,
                                                child: Container(
                                                  width: double.infinity,
                                                  height: 30,
                                                  color: Colors.black45,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        "Title : ${cubit.productModel[itemIndex].title}",
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.w900),
                                                      ),
                                                      SizedBox(
                                                        width: 20,
                                                      ),
                                                      Text(
                                                        "price : ${cubit.productModel[itemIndex].price}",
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.w900),
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                        ],
                                      )),
                                          ),
                                    )
                                  : const Center(
                                      child: CircularProgressIndicator(),
                                    );
                            },
                          ),
                          SizedBox(
                            height: 50.h,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Pharmacy",
                              style: TextStyle(
                                fontSize: 30.sp,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 50.h,
                          ),

                          SizedBox(
                            height: 20.h,
                          ),
                          BlocBuilder<UserCubit, UserState>(
                            buildWhen: (previous, current) {
                              if (current is GetPharmacySuccessfulState) {
                                return true;
                              } else {
                                return false;
                              }
                            },
                            builder: (context, state) {
                              var cubit = UserCubit.get(context);
                              return (state is GetPharmacySuccessfulState)
                                  ? Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20.w),
                                      child: SizedBox(
                                        height: 200.h,
                                        width: double.infinity,
                                        child: ListView.separated(
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) =>
                                              SizedBox(
                                            width: 200.w,
                                            height: 200.h,
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            PharmacyProduct(
                                                              pahrmacyModel: cubit
                                                                      .pahrmacyModel[
                                                                  index],
                                                            )));
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.r)),
                                                child: Stack(
                                                  children: [
                                                    Image.network(
                                                      cubit.pahrmacyModel[index]
                                                          .photo,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Align(
                                                        alignment: Alignment
                                                            .bottomCenter,
                                                        child: Container(
                                                          width: double.infinity,
                                                          color: Colors.black45,
                                                          height: 90.h,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                " ${cubit.pahrmacyModel[index].name}",
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize: 20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w900),
                                                              ),
                                                              const SizedBox(
                                                                width: 20,
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          separatorBuilder: (context, index) =>
                                              SizedBox(
                                            width: 39.w,
                                          ),
                                          itemCount: UserCubit.get(context)
                                              .pahrmacyModel
                                              .length,
                                        ),
                                      ),
                                    )
                                  : Center(
                                      child: CircularProgressIndicator(),
                                    );
                            },
                          ),
                          SizedBox(
                            height: 50.h,
                          ),
                          // BlocBuilder<UserCubit, UserState>(builder: (context, state) {
                          //   return Text("Amr");
                          // },),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Types",
                              style: TextStyle(
                                fontSize: 30.sp,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 50.h,
                          ),
                          Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                            SizedBox(
                              width: 150.w,
                              height: 150.h,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MedicalDevices(
                                                type: "medicine",
                                              )));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(
                                          15.r)),
                                  child: Stack(
                                    children: [
                                      Image.network(
                                        'https://th.bing.com/th/id/R.d6e6c4f76e96eade3728d86a687a0ae4?rik=tD3lzcR%2bLpVKIw&riu=http%3a%2f%2fcdn.ppcorn.com%2fwp-content%2fuploads%2fsites%2f14%2f2016%2f03%2fThe-L-Dopamine-ppcorn-1520x1000.jpg&ehk=VzC1ZrDIfQrJCtm6cDh0CCs7qgW5h3o3C3%2f58U3huxs%3d&risl=&pid=ImgRaw&r=0'
                                        , fit: BoxFit.cover,
                                      ),
                                      Align(
                                          alignment: Alignment
                                              .bottomCenter,
                                          child: Container(
                                            width: double.infinity,
                                            color: Colors.black45,
                                            height: 40.h,
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .center,
                                              children: [
                                                Text(
                                                  "Medicine",
                                                  style: const TextStyle(
                                                      color: Colors
                                                          .white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                      FontWeight
                                                          .w900),
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                              ],
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10,),
                            SizedBox(
                              width: 150.w,
                              height: 150.h,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MedicalDevices(
                                                type: "Medical equipment",
                                              )));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(
                                          15.r)),
                                  child: Stack(
                                    children: [
                                      Image.network(
                                        'https://www.regdesk.co/wp-content/uploads/2022/08/Medical-Device-Translation-Services.jpeg'
                                        , fit: BoxFit.cover,
                                      ),
                                      Align(
                                          alignment: Alignment
                                              .bottomCenter,
                                          child: Container(
                                            width: double.infinity,
                                            color: Colors.black45,
                                            height: 40.h,
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .center,
                                              children: const [
                                                Text(
                                                  "Medical Devices",
                                                  style:  TextStyle(
                                                      color: Colors
                                                          .white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                      FontWeight
                                                          .w900),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                              ],
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],),
                          SizedBox(height: 20,),

                          BlocBuilder<UserCubit, UserState>(
                            buildWhen: (previous, current) {
                              if (current is GetMedicineSuccessfulState) {
                                return true;
                              } else {
                                return false;
                              }
                            },
                            builder: (context, state) {
                              var cubit = UserCubit.get(context);
                              return (state is GetMedicineSuccessfulState)
                                  ? SizedBox(
                                      width: double.infinity,
                                      child: Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: GridView.builder(
                                            gridDelegate:
                                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                                    maxCrossAxisExtent: 200,
                                                    crossAxisSpacing: 20,
                                                    childAspectRatio: 3 / 4,
                                                    mainAxisSpacing: 20),
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: cubit.productModel.length,
                                            itemBuilder: (context, index) {
                                              return InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              MedicineDetailsScreen(
                                                                productModel:
                                                                    cubit.productModel[
                                                                        index],
                                                              )));
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.r)),
                                                  child: Stack(
                                                    children: [
                                                      Image.network(
                                                        cubit.productModel[index]
                                                            .image,
                                                        fit: BoxFit.cover,
                                                      ),
                                                      Align(
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          child: Container(
                                                            width:
                                                                double.infinity,
                                                            color: Colors.black45,
                                                            height: 90.h,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  "Title : ${cubit.productModel[index].title}",
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w900),
                                                                ),
                                                                const SizedBox(
                                                                  width: 20,
                                                                ),
                                                                Text(
                                                                  "price : ${cubit.productModel[index].price} ",
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w900),
                                                                ),
                                                              ],
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }),
                                      ),
                                    )
                                  : const Center(
                                      child: CircularProgressIndicator(),
                                    );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
          }),
    );
  }
}

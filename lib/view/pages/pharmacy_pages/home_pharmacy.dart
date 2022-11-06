import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/code/constants_value.dart';
import 'package:graduation_project/view/components/custom_button.dart';
import 'package:graduation_project/view/components/custom_text_field.dart';
import 'package:graduation_project/view/pages/pharmacy_pages/get_pharmacy_services.dart';
import 'package:graduation_project/view/pages/pharmacy_pages/show_orders.dart';
import 'package:graduation_project/view_model/bloc/auth/auth_cubit.dart';

import '../../../view_model/bloc/pharmacy_product/pharmacy_cubit.dart';
import '../../../view_model/database/local/cache_helper.dart';
import '../auth/login_screen.dart';
import 'Edit_Product_Screen.dart';
import 'add_service_screen.dart';
import 'create_product.dart';
import 'edit_pharmacy_info.dart';
import 'messageScreen.dart';

class HomePharmacyScreen extends StatefulWidget {
  const HomePharmacyScreen({Key? key}) : super(key: key);

  @override
  State<HomePharmacyScreen> createState() => _HomePharmacyScreenState();
}

class _HomePharmacyScreenState extends State<HomePharmacyScreen> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  PharmacyCubit pharmacyCubit = PharmacyCubit();
  @override
  void initState() {
    // TODO: implement initState
    context.read<AuthCubit>().getUserData();
    context.read<AuthCubit>().getPharmacyDetails();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var authCubit = AuthCubit.get(context);
        return Scaffold(
            appBar: AppBar(
              title: const Text('Home Pharmacy'),
              actions: [
                IconButton(
                    onPressed: () {
                      pharmacyCubit.getPharmacyProduct();
                    },
                    icon: const Icon(Icons.refresh))
              ],
            ),
            drawer: (AuthCubit.get(context).userModel == null)
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
                          backgroundImage:
                              NetworkImage(authCubit.userModel!.photo),
                        ),
                        SizedBox(
                          height: 50.h,
                        ),
                        ListTile(
                          leading: const Icon(Icons.perm_identity),
                          title: const Text("Create Product"),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return const CreateProduct();
                              },
                            ));
                          },
                        ),

                        ListTile(
                          leading: const Icon(Icons.settings),
                          title: const Text("Settings"),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const EditPharamcyScreen(),
                                ));
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.home_repair_service),
                          title: const Text("service"),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AddServiceScreen(),
                                ));
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.design_services_sharp),
                          title: const Text("Show all Service"),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const GetPharmacyServices(),
                                ));
                          },
                        ),

                        ListTile(
                          leading: const Icon(Icons.shopify),
                          title: const Text("Show all Orders"),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ShowOrders(),
                                ));
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.shopify),
                          title: const Text("messages"),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MessageScreen(),
                                ));
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.logout),
                          title: const Text("Logout"),
                          onTap: () async {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(CacheHelper.getDataString(key: 'id'))
                                .update({
                              'online': 'false',
                            }).then((value) async {
                              await CacheHelper.removeData(key: 'id');
                              FirebaseAuth.instance.signOut();
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

                        // ListTile(
                        //   leading: const Icon(Icons.logout),
                        //   title: const Text("Logout"),
                        //   onTap: () async {
                        //     await FirebaseFirestore.instance
                        //         .collection('users')
                        //         .doc(userID)
                        //         .update({
                        //       'online': 'false',
                        //     }).then((value) async {
                        //       userID = null;
                        //       await CacheHelper.removeData(key: 'id');
                        //       FirebaseAuth.instance.signOut();
                        //     }).then((value) {
                        //       Navigator.pushAndRemoveUntil(
                        //           context,
                        //           MaterialPageRoute(
                        //             builder: (context) => LoginScreen(),
                        //           ),
                        //               (route) => false);
                        //     });
                        //   },
                        // ),
                      ],
                    ),
                  ),
            body: (state is GetPharmacyDetailsStateLoading)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : (AuthCubit.get(context).detailsModelPharmacy == null)
                    ? Form(
                        key: formKey,
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 100.r,
                              backgroundImage: NetworkImage((AuthCubit.get(
                                              context)
                                          .userModel!
                                          .photo ==
                                      '')
                                  ? 'https://firebasestorage.googleapis.com/v0/b/pharmacy-f7702.appspot.com/o/images.jpg?alt=media&token=0aa2b534-e0cf-4ccc-814f-28c57a12d383'
                                  : AuthCubit.get(context).userModel!.photo),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                (state is UploadImageStateLoading)
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : CustomButton(
                                        disable: true,
                                        size: Size(170.w, 40.h),
                                        widget:
                                            const Text("Select from gallery"),
                                        function: () {
                                          AuthCubit.get(context)
                                              .pickImageGallary(context);
                                        },
                                      ),
                                (state is UploadImageStateLoading)
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : CustomButton(
                                        size: Size(170.w, 40.h),
                                        disable: true,
                                        widget:
                                            const Text("Select from camera"),
                                        function: () {
                                          AuthCubit.get(context)
                                              .pickImageCamera(context);
                                        },
                                      ),
                              ],
                            ),
                            CustomTextField(
                                controller: descriptionController,
                                maxLine: 10,
                                iconData: Icons.description,
                                hint: 'dis',
                                fieldValidator: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'please enter description';
                                  }
                                }),
                            SizedBox(
                              height: 20.h,
                            ),
                            CustomTextField(
                                controller: addressController,
                                maxLine: 1,
                                iconData: Icons.location_city,
                                hint: 'dis',
                                fieldValidator: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'please enter description';
                                  }
                                }),
                            SizedBox(
                              height: 20.h,
                            ),
                            CustomButton(
                              widget: const Text("Send To Admin To Approve"),
                              function: () {
                                if (formKey.currentState!.validate()) {
                                  AuthCubit.get(context)
                                      .addPharmacyDetails(
                                    dis: descriptionController.text,
                                    address: addressController.text,
                                  )
                                      .whenComplete(() {
                                    Future.delayed(
                                      const Duration(seconds: 2),
                                      () {
                                        setState(() {
                                          descriptionController.text = '';
                                          addressController.text = '';
                                        });
                                      },
                                    );
                                  });
                                }
                              },
                              disable: true,
                              size: Size(200, 10),
                              radius: 10.r,
                              color: buttonColor,
                            )
                          ],
                        ),
                      )
                    : (AuthCubit.get(context).detailsModelPharmacy!.approved)
                        ? BlocProvider(
                            create: (context) =>
                            pharmacyCubit..getPharmacyProduct(),
                            child: BlocConsumer<PharmacyCubit, PharmacyState>(
                              builder: (context, state) {
                                if (PharmacyCubit.get(context).productsModel !=
                                    null) {
                                  return Padding(
                                    padding: EdgeInsets.all(20),
                                    child: GridView.builder(
                                      gridDelegate:
                                          const SliverGridDelegateWithMaxCrossAxisExtent(
                                              maxCrossAxisExtent: 200,
                                              crossAxisSpacing: 20,
                                              childAspectRatio: 3 / 4,
                                              mainAxisSpacing: 20),
                                      itemCount: PharmacyCubit.get(context)
                                          .productsModel
                                          !.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          width: 200,
                                          height: 300,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20.r),
                                            border: Border.all(
                                              color: Colors.black,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: 200,
                                                  height: 100,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.r),
                                                      border: Border.all(
                                                        color: Colors.black,
                                                      ),
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                            PharmacyCubit.get(
                                                                    context)
                                                                .productsModel![
                                                                    index]
                                                                .image),
                                                        fit: BoxFit.cover,
                                                      )),
                                                ),
                                                Text(
                                                  'Title : ${PharmacyCubit.get(context).productsModel![index].title}',
                                                  style: TextStyle(
                                                      fontSize: 24.sp),
                                                ),
                                                Text(
                                                  'price : ${PharmacyCubit.get(context).productsModel![index].price}',
                                                  style: TextStyle(
                                                      fontSize: 24.sp),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    IconButton(
                                                      onPressed: () {
                                                        PharmacyCubit.get(
                                                                context)
                                                            .deleteProduct(id:  PharmacyCubit
                                                            .get(
                                                            context)
                                                            .productsModel[
                                                        index]
                                                            .id);
                                                      },
                                                      icon: const Icon(
                                                        Icons.delete,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                    IconButton(
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    BlocProvider
                                                                        .value(
                                                                      value:
                                                                      pharmacyCubit,
                                                                      child:
                                                                          EditProductScreen(
                                                                        index:
                                                                            index,
                                                                              pharmacyCubit: pharmacyCubit,
                                                                      ),
                                                                    )));
                                                      },
                                                      icon: const Icon(
                                                        Icons.edit,
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                } else {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                              listener: (context, state) {},
                            ),
                          )
                        : Center(child: Text("witting to admin approve")));
      },
    );
  }
}

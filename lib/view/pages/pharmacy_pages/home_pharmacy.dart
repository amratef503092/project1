import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/view/pages/admin_screen/settings_screen.dart';
import 'package:graduation_project/view/pages/pharmacy_pages/get_pharmacy_services.dart';
import 'package:graduation_project/view/pages/pharmacy_pages/show_all_service_order.dart';
import 'package:graduation_project/view/pages/pharmacy_pages/show_orders.dart';
import 'package:graduation_project/view_model/bloc/auth/auth_cubit.dart';

import '../../../view_model/bloc/pharmacy_product/pharmacy_cubit.dart';
import '../../../view_model/database/local/cache_helper.dart';
import '../../components/custom_button.dart';
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
  @override
  void initState() {
    // TODO: implement initState

    AuthCubit.get(context).getPharmacyDetails();
    PharmacyCubit.get(context).getPharmacyProduct();

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
                BlocConsumer<PharmacyCubit, PharmacyState>(
                  listener: (context, state) {
                    // TODO: implement listener
                  },
                  builder: (context, state) {
                    return (state is GetProductLodaing)
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : IconButton(
                            onPressed: () {
                              PharmacyCubit.get(context).getPharmacyProduct();
                            },
                            icon: const Icon(Icons.refresh));
                  },
                )
              ],
            ),
            drawer: (AuthCubit.get(context).userModel == null)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Drawer(
                    child: SingleChildScrollView(
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
                                    builder: (context) =>
                                        const EditPharamcyScreen(),
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
                                    builder: (context) =>
                                        const AddServiceScreen(),
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
                                    builder: (context) =>
                                        const GetPharmacyServices(),
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
                            leading: const Icon(Icons.chat),
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
                            leading: const Icon(Icons.medical_information),
                            title: const Text("Show All Order Service"),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ShowAllServiceOrder(),
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
                                'online': false,
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
                        ],
                      ),
                    ),
                  ),
            body: (AuthCubit.get(context).userModel == null)
                ? const Center(child: CircularProgressIndicator())
                : BlocConsumer<PharmacyCubit, PharmacyState>(
                    buildWhen: (previous, current) {
                      if (current is GetProductSuccsseful) {
                        return true;
                      } else if (current is GetProductError) {
                        return true;
                      } else {
                        return false;
                      }
                    },
                    builder: (context, state) {
                      if (state is GetProductSuccsseful) {
                        if (PharmacyCubit.get(context).productsModel.isEmpty) {
                          return const Center(
                            child: Text("No Products"),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.all(20),
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 3,
                                mainAxisSpacing: 3,
                                mainAxisExtent: 450.h,
                              ),
                              itemCount: PharmacyCubit.get(context)
                                  .productsModel
                                  .length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20.r),
                                          child: Image(
                                              image: NetworkImage(
                                                  PharmacyCubit.get(context)
                                                      .productsModel[index]
                                                      .image),
                                              width: 200.w,
                                              height: 200.h),
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Text(
                                          PharmacyCubit.get(context)
                                              .productsModel[index]
                                              .title,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontSize: 24.sp,
                                              fontWeight: FontWeight.w900),
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Text(
                                          "${PharmacyCubit.get(context).productsModel[index].price.toString()} SAR ",
                                          style: TextStyle(fontSize: 24.sp),
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            CustomButton(
                                              disable: true,
                                              color: Colors.red,
                                              radius: 0,
                                              size: const Size(200, 20),
                                              function: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      content: const Text(
                                                          "Are You Sure To Delete This Product"),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () {
                                                              PharmacyCubit.get(
                                                                      context)
                                                                  .deleteProduct(
                                                                      id: PharmacyCubit.get(
                                                                              context)
                                                                          .productsModel[
                                                                              index]
                                                                          .id)
                                                                  .then(
                                                                      (value) {
                                                                Navigator.pop(
                                                                    context);
                                                              });
                                                            },
                                                            child:
                                                                Text("Sure")),
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child:
                                                                Text("Cancel"))
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              widget: SizedBox(
                                                height: 40.h,
                                                width: 200,
                                                child: Center(
                                                    child: Text("Delete")),
                                              ),
                                            ),
                                            CustomButton(
                                              disable: true,
                                              radius: 0,
                                              color: Colors.blueAccent,
                                              size: const Size(200, 20),
                                              function: () {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                  builder: (context) {
                                                    return EditProductScreen(
                                                        index: index,
                                                        pharmacyCubit:
                                                            PharmacyCubit.get(
                                                                context));
                                                  },
                                                ));
                                              },
                                              widget: SizedBox(
                                                height: 40.h,
                                                width: 200.w,
                                                child:
                                                    Center(child: Text("Edit")),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                    listener: (context, state) {},
                  ));
      },
    );
  }
}

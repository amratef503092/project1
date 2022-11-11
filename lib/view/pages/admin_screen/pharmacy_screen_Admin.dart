import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../view_model/bloc/auth/auth_cubit.dart';
class PharmacyScreenAdmin extends StatefulWidget {
  const PharmacyScreenAdmin({Key? key}) : super(key: key);

  @override
  State<PharmacyScreenAdmin> createState() => _PharmacyScreenAdminState();
}

class _PharmacyScreenAdminState extends State<PharmacyScreenAdmin> {
  @override
  void initState() {
    // TODO: implement initState
    AuthCubit.get(context).getAllPharmacy();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        // print(userID.toString()+ "from sql");

        var authCubit = AuthCubit.get(context);
        return Scaffold(

          body: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: (AuthCubit.get(context).userModel == null)
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : (authCubit.adminData.isEmpty)
                  ? const Center(
                child: Text("No Admin Found"),
              )
                  : Column(
                children: [
                  Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () {
                          authCubit.getAllPharmacy();
                        },
                        icon: const Icon(Icons.refresh),

                      )),
                  Expanded(
                    child: ListView.builder(
                        itemCount: authCubit.getAllPharmacyList.length,
                        itemBuilder: (context, index) {
                          if(!authCubit.getAllPharmacyList[index].ban){
                            return Card(
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(authCubit
                                        .getAllPharmacyList[index].photo
                                        .toString()),
                                    radius: 40,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "Name : ${authCubit.getAllPharmacyList[index].name}"),
                                      Text(
                                          "Phone : ${authCubit.getAllPharmacyList[index].phone}"),
                                      authCubit.getAllPharmacyList[index].online
                                          ? Row(
                                        children: const [
                                          Text("Status : "),
                                          Text(
                                            "online",
                                            style: TextStyle(
                                                color: Colors.green),
                                          )
                                        ],
                                      )
                                          : Row(
                                        children: const [
                                          Text("Status : "),
                                          Text(
                                            "offline",
                                            style: TextStyle(
                                                color: Colors.red),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: const Text(
                                                "You want Delete Account ?"),
                                            content: Column(
                                              mainAxisSize:
                                              MainAxisSize.min,
                                              children: const [
                                                Text(
                                                    "If You click ok you will Ban this Account")
                                              ],
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(ctx).pop();
                                                },
                                                child: Container(
                                                  padding:
                                                  const EdgeInsets.all(
                                                      14),
                                                  child:
                                                  const Text("Cancel"),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  FirebaseFirestore.instance
                                                      .collection('users')
                                                      .doc(AuthCubit.get(
                                                      context)
                                                      .getAllPharmacyList[index]
                                                      .id)
                                                      .update({
                                                    'ban': true
                                                  }).then((value) {

                                                    Navigator.of(ctx).pop();
                                                    AuthCubit.get(context).getAllPharmacy();
                                                    setState(() {});
                                                  });
                                                },
                                                child: Container(
                                                  padding:
                                                  const EdgeInsets.all(
                                                      14),
                                                  child: const Text("Ok"),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.edit))
                                ],
                              ),
                            );
                          }else{
                            return Card(
                              child: Stack(
                                children: [

                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: NetworkImage(authCubit
                                            .getAllPharmacyList[index].photo
                                            .toString()),
                                        radius: 40,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              "Name : ${authCubit.getAllPharmacyList[index].name}"),
                                          Text(
                                              "Phone : ${authCubit.getAllPharmacyList[index].phone}"),
                                          authCubit.getAllPharmacyList[index].online
                                              ? Row(
                                            children: const [
                                              Text("Status : "),
                                              Text(
                                                "online",
                                                style: TextStyle(
                                                    color: Colors.green),
                                              )
                                            ],
                                          )
                                              : Row(
                                            children: const [
                                              Text("Status : "),
                                              Text(
                                                "offline",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      // TextButton(
                                      //   onPressed: () {
                                      //     FirebaseFirestore.instance
                                      //         .collection('users')
                                      //         .doc(AuthCubit.get(
                                      //         context)
                                      //         .adminData[index]
                                      //         .id)
                                      //         .update({
                                      //       'ban': true
                                      //     }).then((value) {
                                      //
                                      //       Navigator.of(context).pop();
                                      //       AuthCubit.get(context).getAdmin();
                                      //       setState(() {});
                                      //     });
                                      //   },
                                      //   child: Container(
                                      //     padding:
                                      //     const EdgeInsets.all(
                                      //         14),
                                      //     child: const Text("Ok"),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                  InkWell(
                                    onTap: ()
                                    {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: const Text(
                                              "You want Remove Ban Account ?"),
                                          content: Column(
                                            mainAxisSize:
                                            MainAxisSize.min,
                                            children: const [
                                              Text(
                                                  "If You click ok you will Remove Ban From this Account ? ")
                                            ],
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(ctx).pop();
                                              },
                                              child: Container(
                                                padding:
                                                const EdgeInsets.all(
                                                    14),
                                                child:
                                                const Text("Cancel"),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                FirebaseFirestore.instance
                                                    .collection('users')
                                                    .doc(AuthCubit.get(
                                                    context)
                                                    .getAllPharmacyList[index]
                                                    .id)
                                                    .update({
                                                  'ban': false
                                                }).then((value) {

                                                  Navigator.of(context).pop();
                                                  AuthCubit.get(context).getAllPharmacy();

                                                });
                                              },
                                              child: Container(
                                                padding:
                                                const EdgeInsets.all(
                                                    14),
                                                child: const Text("Ok"),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 100.h,
                                      color: Colors.black.withOpacity(0.5),
                                      child: Center(
                                        child: Text(
                                          "Banned",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 30.sp),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                        }),
                  ),
                ],
              )),
        );
      },
    );
  }
}

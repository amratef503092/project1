import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/code/constants_value.dart';
import 'package:graduation_project/view/pages/ChatScreen.dart';
import 'package:graduation_project/view/pages/admin_screen/settings_screen.dart';
import 'package:graduation_project/view/pages/auth/login_screen.dart';
import 'package:graduation_project/view_model/bloc/auth/auth_cubit.dart';
import 'package:graduation_project/view_model/database/local/cache_helper.dart';

import 'approve_screen.dart';
import 'create_admin.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  void initState() {
    // TODO: implement initState


    AuthCubit.get(context).getAdmin();
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
        print(authCubit.adminData.length);
        return Scaffold(
          appBar: AppBar(title: const Text("Admin Panel "), centerTitle: true),
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
                        title: const Text("Create Admin"),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return const CreateAdmin();
                            },
                          ));
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.work),
                        title: const Text("Approve Pharmacy"),
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ApproveScreen(),
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
                                builder: (context) => const SettingsScreen(),
                              ));
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.logout),
                        title: const Text("Logout"),
                        onTap: () async {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(userID)
                              .update({
                            'online': 'false',
                          }).then((value) async {
                            await FirebaseAuth.instance.signOut();


                          }).then((value) async {
                            await CacheHelper.removeData(key: 'id');
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
          body: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: (AuthCubit.get(context).userModel == null)
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : (authCubit.adminData.isEmpty)?const Center(child: Text("No Admin Found"),):ListView.builder(
                      itemCount: authCubit.adminData.length,
                      itemBuilder: (context, index) {
                      return Card(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(authCubit
                                      .adminData[index].photo
                                      .toString()),
                                  radius: 40,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Name : ${authCubit.adminData[index].name}"),
                                    Text(
                                        "Phone : ${authCubit.adminData[index].phone}"),
                                    authCubit.adminData[index].online
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
                                Column(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title: const Text(
                                                  "You want Delete Account ?"),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
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
                                                    child: const Text("Cancel"),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    FirebaseFirestore.instance
                                                        .collection('users')
                                                        .doc(AuthCubit.get(
                                                                context)
                                                            .adminData[index]
                                                            .id)
                                                        .update({
                                                      'ban': true
                                                    }).then((value) {
                                                      AuthCubit.get(context)
                                                          .adminData
                                                          .removeAt(index);
                                                      Navigator.of(ctx).pop();

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
                                        icon: const Icon(Icons.edit)),
                                  ],
                                )
                              ],
                            ),
                          );
                        }
                      )),
        );
      },
    );
  }
}

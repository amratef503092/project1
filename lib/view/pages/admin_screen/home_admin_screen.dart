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
    if (AuthCubit.get(context).userModel == null) {
      context.read<AuthCubit>().getUserData();
    }

    context.read<AuthCubit>().getAdmin();
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
          appBar: AppBar(title: Text("Admin Panel "), centerTitle: true),
          drawer: (AuthCubit.get(context).userModel == null)
              ? Center(
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
                        leading: Icon(Icons.perm_identity),
                        title: Text("Create Admin"),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return CreateAdmin();
                            },
                          ));
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.work),
                        title: Text("Approve company"),
                      ),

                      ListTile(
                        leading: Icon(Icons.settings),
                        title: Text("Settings"),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SettingsScreen(),
                              ));
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.logout),
                        title: Text("Logout"),
                        onTap: () async {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(userID)
                              .update({
                            'online': 'false',
                          }).then((value) async {
                            userID = null;
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
          body: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: (AuthCubit.get(context).userModel == null)
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: authCubit.adminData.length,
                      itemBuilder: (context, index) {
                        if (authCubit.adminData[index].id ==
                                authCubit.userModel!.id ||
                            authCubit.adminData[index].ban) {
                          return Container();
                        } else {
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
                                            children: [
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
                                          // chat screen
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                            builder: (context) {
                                              return ChatScreen(
                                                index: index,
                                              );
                                            },
                                          ));
                                        },
                                        icon: Icon(Icons.chat)),
                                    IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title: const Text(
                                                  "You want Delete Account ?"),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
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
                                        icon: Icon(Icons.edit)),
                                  ],
                                )
                              ],
                            ),
                          );
                        }
                      })),
        );
      },
    );
  }
}

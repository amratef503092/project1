import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/view/pages/admin_screen/settings_screen.dart';
import 'package:graduation_project/view_model/bloc/auth/auth_cubit.dart';

import '../../../code/constants_value.dart';
import 'create_admin.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {

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
      appBar: AppBar(title: Text("Admin Panel ${authCubit.userModel!.name}"), centerTitle: true),
      drawer: Drawer(
        child: Column(
          children: [
            SizedBox(height: 100.h,),
            CircleAvatar(
              radius: 80.r,
                backgroundImage: NetworkImage(
                    'https://firebasestorage.googleapis.com/v0/b/pharmacy-f7702.appspot.com/o/images.jpg?alt=media&token=0aa2b534-e0cf-4ccc-814f-28c57a12d383')),
            SizedBox(height: 50.h,),
            ListTile(
              leading: Icon(Icons.perm_identity),
              title: Text("Create Admin"),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder:(context) {
                  return CreateAdmin();
                },));
              },
            ),
            ListTile(
              leading: Icon(Icons.work),
              title: Text("Approve company"),
            ),
            ListTile(
              leading: Icon(Icons.chat),
              title: Text("Messages"),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen(),));
            },
            ),
          ],
        ),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [],
        ),
      ),
    );
  },
);
  }
}

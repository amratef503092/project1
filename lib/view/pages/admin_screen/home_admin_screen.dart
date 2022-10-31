import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/view/pages/ChatScreen.dart';
import 'package:graduation_project/view/pages/admin_screen/settings_screen.dart';
import 'package:graduation_project/view_model/bloc/auth/auth_cubit.dart';

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
          appBar: AppBar(
              title: Text("Admin Panel ${authCubit.userModel!.name}"),
              centerTitle: true),
          drawer: Drawer(
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
                  leading: Icon(Icons.chat),
                  title: Text("Messages"),
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
              ],
            ),
          ),
          body: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: (state is GetAdminsStateLoading)
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: authCubit.adminData.length,
                      itemBuilder: (context, index) {
                         if(authCubit.adminData[index].id == authCubit.userModel!.id){
                         return  Container();
                      }else {
                           return   Card(
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
                                     Text("Phone : " +
                                         authCubit.adminData[index].phone),
                                     authCubit.adminData[index].online
                                         ? Row(
                                       children: [
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
                                           style:
                                           TextStyle(color: Colors.red),
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

                                         }, icon: Icon(Icons.edit)),
                                   ],
                                 )
                               ],
                             ),
                           );
                         }
    }
                    )),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/view/pages/pharmacy_pages/pharmactMessage.dart';
import 'package:graduation_project/view_model/bloc/pharmacy_product/pharmacy_cubit.dart';

import '../ChatScreen.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  void initState() {
    // TODO: implement initState
    PharmacyCubit.get(context).getUsers();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Message'),
      ),
      body: BlocConsumer<PharmacyCubit, PharmacyState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          var cubit = PharmacyCubit.get(context);
          return   (state is GetUsersMessageLoading )? Center(child: CircularProgressIndicator(),):
          ListView.builder(itemCount: cubit.usersMessage.length,itemBuilder: (context, index) {
            return InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>PharmacyMessage(pahrmacyModel: cubit.usersMessage[index],)));
              },
              child: ListTile(

                leading: CircleAvatar(
                  backgroundImage: NetworkImage(cubit.usersMessage[index].photo),
                ),
                title: Text(cubit.usersMessage[index].name),
                subtitle: Text(cubit.usersMessage[index].email),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            );
          },);

        },
      ),
    );
  }
}

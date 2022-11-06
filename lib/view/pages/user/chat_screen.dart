import 'dart:io' as io;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/code/constants_value.dart';
import 'package:graduation_project/view_model/bloc/auth/auth_cubit.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import '../../../model/pharmacy_model.dart';

class ChatUserScreen extends StatefulWidget {
  ChatUserScreen({Key? key, required this.pahrmacyModel});

  PharmacyModel? pahrmacyModel;

  @override
  State<ChatUserScreen> createState() => _ChatUserScreenState();
}

class _ChatUserScreenState extends State<ChatUserScreen> {
  final fireStore = FirebaseFirestore.instance;
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AuthCubit.get(context);
        return Scaffold(
          appBar: AppBar(),
          body:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(userID)
                  .collection('messages')
                  .orderBy('time')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Text("no message");
                } else {
                  final messages = snapshot.data!.docs.reversed;
                  List<MessageLine> messageWidgets = [];

                  for (var message in messages) {
                    final messageText = message.get('message');
                    final sender = message.get('senderName');

                      messageWidgets.add(MessageLine(
                          type: message['type'],
                          sender: sender,
                          messageText: messageText,
                          isMe: message['receiverID'] == userID));
                    }


                  return Expanded(
                    child: ListView(
                      reverse: true,
                      children: messageWidgets,
                    ),
                  );
                }
              },
            ),
            // (cubit.messageList.length>0)? Expanded(
            //   child: ListView.separated(itemBuilder: (context , index){
            //     var message  = cubit.messageList[index];
            //
            //    return MessageLine(sender: message.senderId,messageText: message.text,isMe:message.senderId == CacheHelper.getDataString(key: 'currentUser') );
            //
            //
            //   } ,itemCount: cubit.messageList.length,separatorBuilder: (context , index){
            //     return SizedBox(
            //       height: 15,
            //     );
            //   }, ),
            // ): Center(
            //   child: CircularProgressIndicator(),
            // ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: messageController,
                      decoration: InputDecoration(
                        labelText: "Enter Email",
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: Colors.blue,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                CircleAvatar(
                    backgroundColor: buttonColor,
                    radius: 25,
                    child: IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        cubit.sendMessage(
                            userid: userID.toString(),
                            message: messageController.text,
                            senderID: userID.toString(),
                            senderName: cubit.userModel!.name,
                            receiverId: widget.pahrmacyModel!.id,
                            receiverName: widget.pahrmacyModel!.name,
                            type: 'text');
                        // cubit.sendMessage(text: cubit.messageController.text , time:DateTime.now().toString() );
                        //
                        messageController.clear();
                      },
                    )),
                CircleAvatar(
                    backgroundColor: buttonColor,
                    radius: 25,
                    child: IconButton(
                      icon: const Icon(
                        Icons.file_copy,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        cubit.pickFileMessage(   userid: userID.toString(),
                            senderID: userID.toString(),
                            senderName: cubit.userModel!.name,
                            receiverId:widget.pahrmacyModel!.id
                            , receiverName:widget.pahrmacyModel!.name,
                            type: 'pdf');

                        //   const oneMegabyte = 1024 * 1024;
                        //   final Uint8List? data = await islandRef.getData(oneMegabyte);
                        //   // Data for "images/island.jpg" is returned, use this as needed.
                        // } on FirebaseException catch (e) {
                        //   // Handle any errors.
                        // }


                        // cubit.sendMessage(text: cubit.messageController.text , time:DateTime.now().toString() );
                        //
                        // cubit.messageController.clear();
                      },
                    ))
              ],
            ),
          ]),
        );
      },
    );
  }
}

Future openFile({required String url, required String fileName}) async {
  final file =await downloadFile(url, fileName);
  if(file==null){
    return;
  }
  OpenFilex.open(file.path);

}

Future<io.File?> downloadFile(String url, String filName) async {
  final appStorage = await getApplicationDocumentsDirectory();
  final filePath = io.File('${appStorage.path}/$filName');
  final response = await Dio().get(url,
      options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: 0));
  final ref = filePath.openSync(mode: io.FileMode.write);
  ref.writeFromSync(response.data);
  await ref.close();
  print("Amr");
  return filePath;
}

class MessageLine extends StatelessWidget {
  MessageLine({
    this.messageText,
    this.sender,
    this.isMe,
    this.type
  });
  String ?type;
  String? messageText;
  String? sender;
  bool? isMe;

  @override
  Widget build(BuildContext context) {
    return (isMe!)
        ? (type=='pdf')?InkWell(onTap: (){
      openFile(url: messageText!, fileName: '${messageText!.substring(90, messageText!.length)}.pdf');

    },child: Column(children: [
      Text('$sender'),
      Material(
        elevation: 2,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Text('$messageText',
              style: TextStyle(color: Colors.black, fontSize: 14)),
        ),
      ),
    ],),):Padding(
            padding: EdgeInsets.all(22),
            child: Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('$sender'),

                  Material(
                    elevation: 2,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                      topLeft: Radius.circular(30),
                    ),
                    color: Colors.white,
                    child:  Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon((Icons.download)),
                        SizedBox(
                          width: 10,
                        ),
                        Text('${messageText!.substring(90, messageText!.length)}.pdf',
                            style: TextStyle(color: Colors.white, fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        : (type=='pdf')?InkWell(onTap: (){
      openFile(url: messageText!, fileName: '${messageText!.substring(90, messageText!.length)}.pdf');
    },child: Column(children: [
      Text('$sender'),
      Material(
        elevation: 2,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
            topRight: Radius.circular(30)),
        color: Color(0xffAAACAE),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon((Icons.download)),
              SizedBox(
                width: 10,
              ),
              Text('${messageText!.substring(90, messageText!.length)}.pdf',
                  style: TextStyle(color: Colors.white, fontSize: 14)),
            ],
          )
        ),
      ),
    ],),):Padding(
            padding: EdgeInsets.all(22),
            child: Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$sender'),
                  Material(
                    elevation: 2,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                        topRight: Radius.circular(30)),
                    color: Color(0xffAAACAE),
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Text(
                        '$messageText',
                        style: TextStyle(
                          color: Color(0xff1A1D21),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
class PdfLine extends StatelessWidget {
  PdfLine({
    this.messageText,
    this.sender,
    this.isMe,
  });

  String? messageText;
  String? sender;
  bool? isMe;

  @override
  Widget build(BuildContext context) {
    return (isMe!)
        ? Padding(
      padding: EdgeInsets.all(22),
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('$sender'),
            Material(
              elevation: 2,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
                topLeft: Radius.circular(30),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Text('$messageText',
                    style: TextStyle(color: Colors.black, fontSize: 14)),
              ),
            ),
          ],
        ),
      ),
    )
        : Padding(
      padding: EdgeInsets.all(22),
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$sender'),
            Material(
              elevation: 2,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                  topRight: Radius.circular(30)),
              color: Color(0xffAAACAE),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Text(
                  '$messageText',
                  style: TextStyle(
                    color: Color(0xff1A1D21),
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

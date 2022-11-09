import 'package:flutter/material.dart';

import '../pages/pharmacy_pages/pharmactMessage.dart';
class MessageLine extends StatelessWidget {
  MessageLine({this.messageText, this.sender, this.isMe, this.type ,this.baseName});

  String? type;
  String? messageText;
  String? sender;
  bool? isMe;
  String? baseName;

  @override
  Widget build(BuildContext context) {
    return (isMe!)
        ? (type == 'pdf')
        ? Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
      onTap: () {
          openFile(
              url: messageText!,
              fileName:
             "$baseName");
      },
      child: Align(
        alignment: Alignment.topRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
            children: [
              Text('$sender'),
              Material(
                elevation: 2,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                ),
                color: Colors.white,
                child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon((Icons.download)),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                            '$baseName',
                            style: TextStyle(
                                color: Colors.black, fontSize: 14)),
                      ],
                    )
                ),
              ),
            ],
        ),
      ),
    ),
        )
        : Padding(
      padding: EdgeInsets.all(22),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('$sender'),
            Material(
              elevation: 2,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
                topLeft: Radius.circular(30),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Text(
                  '$messageText',
                  style: const TextStyle(
                    color: Color(0xff1A1D21),
                    fontSize: 14,
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    )
        : (type == 'pdf')
        ? Padding(
      padding: const EdgeInsets.all(15.0),
      child: InkWell(
        onTap: () {
          openFile(
              url: messageText!,
              fileName:
              "$baseName");
        },
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$sender'),
              Material(
                elevation: 2,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                    topRight: Radius.circular(30)),
                color: Color(0xffAAACAE),
                child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon((Icons.download)),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                            '$baseName',
                            style: TextStyle(
                                color: Colors.black, fontSize: 14)),
                      ],
                    )
                ),
              ),
            ],
          ),
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


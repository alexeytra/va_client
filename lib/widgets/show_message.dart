import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:va_client/models/message/message_model.dart';

class ShowMessage extends StatelessWidget {
  final bool isMe;
  final Message message;
  final typing;

  ShowMessage(
      {@required this.isMe, @required this.message, @required this.typing});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: isMe
          ? EdgeInsets.only(top: 8.0, bottom: 8.0, left: 80.0)
          : EdgeInsets.only(top: 8.0, bottom: 8.0, right: 80.0),
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      decoration: BoxDecoration(
          color: isMe
              ? Theme.of(context).backgroundColor
              : Theme.of(context).accentColor,
          borderRadius: isMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(15), bottomLeft: Radius.circular(15))
              : BorderRadius.only(
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                  topLeft: Radius.circular(15))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!(typing && message.iconTyping != null)) Text(
                  message.message,
                  style: TextStyle(
                      color: Colors.black,
                      height: 1.4,
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal),
                ) else Container(
            width: 50,
                  child: SpinKitThreeBounce(
                    color: Colors.black,
                    size: 18.0,
                  ),
                )
        ],
      ),
    );
  }
}

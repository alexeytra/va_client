import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:va_client/models/message_model.dart';
import 'package:va_client/redux/app_state.dart';

class ShowMessage extends StatelessWidget {

  final bool isMe;
  final Message message;

  ShowMessage({@required this.isMe, @required this.message});

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
          StoreConnector<AppState, bool>(
            distinct: true,
            converter: (store) => store.state.typing,
            builder: (context, typing) {
              return !(typing && message.iconTyping != '')
                  ? Text(message.message, style: TextStyle(color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal),)
                  : Image.asset(
                message.iconTyping,
                width: 50.0,
                height: 20.0,
              );
            },
          ),
        ],
      ),
    );
  }

}
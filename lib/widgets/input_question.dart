import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:va_client/models/message_model.dart';
import 'package:va_client/models/view_model.dart';
import 'package:va_client/redux/actions.dart';
import 'package:va_client/redux/app_state.dart';

class InputQuestion extends StatelessWidget {
  final textFieldController;
  final ViewModel viewModel;

  InputQuestion({@required this.textFieldController, @required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(bottom: 20.0, left: 15.0, right: 15),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black54, blurRadius: 5.0, offset: Offset(0.0, 1)),
          ],
          color: Colors.white,
        ),
        height: 100.0,
        child: viewModel.visibilityInput
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.mic),
                      onPressed: () {
                        viewModel.changeVisibilityFloating(true);
                        viewModel.changeVisibilityInput(false);
                      },
                      color: Theme.of(context).primaryColor,
                    ),
                    Expanded(
                        child: TextField(
                      controller: textFieldController,
                      decoration: InputDecoration(hintText: 'Введите вопрос'),
                    )),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        viewModel.addMessage(Message(
                            message: textFieldController.text, sender: 'USER'));
                        // TODO: Нужно менять через стейт? наверно лучше переместить в стор
                        textFieldController.text = '';
                        // _getAnswer();
                      },
                      color: Theme.of(context).primaryColor,
                    )
                  ],
                )
              : Row(
                  children: [
                    Visibility(
                      visible: !viewModel.listening,
                      child: IconButton(
                        icon: Icon(Icons.keyboard),
                        onPressed: () {
                          viewModel.changeVisibilityInput(true);
                          viewModel.changeVisibilityFloating(false);
                        },
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
        );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:va_client/models/view_model.dart';

class InputQuestion extends StatelessWidget {
  final _textFieldController = TextEditingController();
  final ViewModel viewModel;

  InputQuestion({@required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 20.0, left: 5.0, right: 5.0),
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
                    viewModel.changeInputType(false, true);
                  },
                  color: Theme.of(context).primaryColor,
                ),
                Expanded(
                    child: TextField(
                        controller: _textFieldController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 2,
                        decoration: InputDecoration(
                            hintText: 'Введите вопрос',
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0))))),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    viewModel.sendMessage(_textFieldController.text);
                    _textFieldController.text = '';
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
                      viewModel.changeInputType(true, false);
                    },
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
    );
  }
}

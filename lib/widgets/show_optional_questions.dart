import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:va_client/models/message_model.dart';
import 'package:va_client/redux/actions.dart';
import 'package:va_client/redux/app_state.dart';

class ShowOptionalQuestions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          child: StoreConnector<AppState, _ViewModel>(
              distinct: true,
              converter: (store) => _ViewModel.create(store),
              builder: (context, _ViewModel viewModel) =>
                  Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: viewModel.optionalQuestions == null
                  ? <Widget>[]
                  : viewModel.optionalQuestions
                      .map((optionalQuestion) => Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: FilterChip(
                            label: Text(optionalQuestion,
                                style: TextStyle(fontSize: 16)),
                            onSelected: (question) {
                              viewModel.changeAreOptionalQuestions(false);
                              viewModel.addMessage(Message(
                                  message: optionalQuestion, sender: 'USER'));
                              // textFieldController.text = '';
                              // _getAnswer();
                            },
                          )))
                      .toList(),
            ),
          )
          ),
    );
  }
}

class _ViewModel {
  final List<String> optionalQuestions;

  final Function(Message) addMessage;
  final Function(bool) changeAreOptionalQuestions;

  _ViewModel({
    this.optionalQuestions,
    this.addMessage,
    this.changeAreOptionalQuestions
  });

  factory _ViewModel.create(Store<AppState> store) {
    _onAddMessage(Message message) {
      store.dispatch(AddMessageAction(message));
    }

    _onChangeAreOptionalQuestions(bool areOptionalQuestions) {
      store.dispatch(ChangeAreOptionsQuestionsAction(areOptionalQuestions));
    }

    return _ViewModel(
      optionalQuestions: store.state.optionalQuestions,
      addMessage: _onAddMessage,
      changeAreOptionalQuestions: _onChangeAreOptionalQuestions,
    );
  }
}

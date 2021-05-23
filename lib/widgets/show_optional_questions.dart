import 'package:flutter/material.dart';
import 'package:va_client/models/view_model.dart';

class ShowOptionalQuestions extends StatelessWidget {
  final ViewModel viewModel;

  ShowOptionalQuestions({@required this.viewModel});

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
        child: Row(
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
                          if (optionalQuestion != '👎' &&
                              optionalQuestion != '👍') {
                            viewModel.sendMessage(optionalQuestion, viewModel.loginResponse);
                          } else if (optionalQuestion == '👍') {
                            viewModel.sendMessage('👍', viewModel.loginResponse);
                          } else {
                            var dialog = viewModel.messages
                                .getRange(viewModel.messages.length - 2,
                                    viewModel.messages.length)
                                .toList();
                            viewModel.sendWrongAnswer(dialog, '👎', '5263');
                          }
                        },
                      )))
                  .toList(),
        ),
      ),
    );
  }
}

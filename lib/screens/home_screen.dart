import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:va_client/models/message_model.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:va_client/redux/actions.dart';
import 'package:va_client/redux/app_state.dart';
import 'package:va_client/utils/APIManager.dart';
import 'package:va_client/widgets/input_question.dart';
import 'package:va_client/widgets/show_message.dart';
import 'package:va_client/widgets/show_optional_questions.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

// Главный вью
class _HomeScreenState extends State<HomeScreen> {
  stt.SpeechToText _speechToText;
  String _text = '';
  final textFieldController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  AudioPlayer _audioPlayer;
  AudioCache _audioCache;

  @override
  void initState() {
    super.initState();
    _speechToText = stt.SpeechToText();
    _getAudioIntro();
  }

  _getAudioIntro() async {
    _audioPlayer = AudioPlayer();
    _audioCache = AudioCache(fixedPlayer: _audioPlayer);
    _audioCache.load('intro.mp3');
    _audioCache.play('intro.mp3');
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: (store) => _ViewModel.create(store),
      builder: (context, _ViewModel viewModel) => Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
            title: Text(
              "Виртуальный ассистент",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            elevation: 0,
            actions: [IconButton(icon: Icon(Icons.settings), onPressed: () {})],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Visibility(
            visible: viewModel.visibilityFloating,
            child: FloatingActionButton(
              elevation: 0,
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () {
                _listen(viewModel);
              },
              child: Icon(viewModel.listening ? Icons.mic : Icons.mic_none),
            ),
          ),
          body: StoreConnector<AppState, List<Message>>(
            distinct: true,
            converter: (store) => store.state.messages,
            builder: (context, messages) {
              return Column(
                children: [
                  Expanded(
                    child: Container(
                      height: 500.0,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(245, 245, 245, 1),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                          )),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30.0),
                          topLeft: Radius.circular(30.0),
                        ),
                        child: ListView.builder(
                            padding: EdgeInsets.only(
                              top: 15.0,
                            ),
                            shrinkWrap: true,
                            controller: _scrollController,
                            itemCount: messages.length,
                            itemBuilder: (BuildContext context, int index) {
                              final bool isMe =
                                  messages[index].sender == 'USER';
                              return isMe
                                  ? ShowMessage(
                                      isMe: isMe, message: messages[index])
                                  : Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CircleAvatar(
                                            backgroundColor: Colors.red[50],
                                            child: Text('ВА'),
                                          ),
                                        ),
                                        Expanded(
                                            child: ShowMessage(
                                                message: messages[index],
                                                isMe: isMe)),
                                      ],
                                    );
                            }),
                      ),
                    ),
                  ),
                  Visibility(
                      visible: viewModel.listening, child: _showUserQuestion()),
                  Visibility(
                      visible: viewModel.areOptionalQuestions,
                      child: ShowOptionalQuestions()),
                  InputQuestion(textFieldController: this.textFieldController)
                ],
              );
            },
          )),
    );
  }

  // Распознанный Вопрос пользователя
  Widget _showUserQuestion() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
            child: Text(
          _text,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        )),
      ),
    );
  }

  // Слушаем голос
  void _listen(_ViewModel viewModel) async {
    if (viewModel.listening) {
      viewModel.changeListening(false);
      if (_text != '') {
        viewModel.addMessage(Message(message: _text, sender: 'USER'));
      }
      setState(() {
        _text = '';
      });
      _speechToText.stop();
      getAnswer(viewModel);
      return;
    }
    if (!viewModel.listening) {
      bool available = await _speechToText.initialize(
        onStatus: (val) {
          if (val == 'notListening') {
            viewModel.changeListening(false);
            setState(() {
              _text = '';
            });
          }
        },
        onError: (val) => print('onError: $val'),
      );

      if (available) {
        viewModel.changeListening(true);
        _speechToText.listen(
          localeId: 'ru-RU',
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
          }),
        );
      } else {
        viewModel.changeListening(false);
        viewModel.addMessage(Message(message: _text, sender: 'USER'));
        _speechToText.stop();
      }
    }
  }

  // Получаем ответ
  void getAnswer(_ViewModel viewModel) async {
    Map<String, dynamic> answer = Map();
    if (viewModel.messages.last.sender == 'USER') {
      var question = viewModel.messages.last.message.split("\s+");
      viewModel
          .addMessage(Message(iconTyping: 'assets/typing.gif', sender: 'VA'));
      viewModel.changeTyping(true);

      APIManager apiManager = APIManager();
      apiManager.postAPICall("http://127.0.0.1:5000/va/api/v1/question/text",
          {'question': question.take(10).join(" ")}).then((value) {
        var statusCode = value["status"];
        if (statusCode == 200) {
          answer = value["response"];
          Future.delayed(const Duration(seconds: 1), () {
            viewModel.changeTyping(false);
            viewModel.removeLastMessage();
            viewModel
                .addMessage(Message(message: answer['answer'], sender: 'VA'));

            List<String> optQues =
                new List<String>.from(answer['optionalQuestions']);
            if (optQues.length > 0) {
              viewModel.clearOptionalQuestions();
              viewModel.addOptionalQuestions(optQues);
              viewModel.changeAreOptionalQuestions(true);
            }
          });
          Future.delayed(const Duration(seconds: 1), () {
            if (answer['audioAnswer'] != '') {
              _getAudioAnswer(answer['audioAnswer']);
            }
          });
        } else if (statusCode == 500) {
          viewModel.changeTyping(false);
          viewModel.removeLastMessage();
          viewModel.addMessage(Message(
              message: 'Что-то пошло не так, как я хотел 😁', sender: 'VA'));
          return;
        }
      }, onError: (error) {
        print(error);
        viewModel.changeTyping(false);
        viewModel.removeLastMessage();
        viewModel.addMessage(
            Message(message: 'Нет связи с сервером 😁', sender: 'VA'));
        return;
      });
    }
  }

  void _getAudioAnswer(String url) async {
    AudioPlayer player = AudioPlayer();
    player.play(url);
  }

  _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }
}

class _ViewModel {
  final bool listening;
  final bool areOptionalQuestions;
  final bool visibilityFloating;
  final List<Message> messages;
  final bool typing;

  final Function(bool) changeListening;
  final Function(Message) addMessage;
  final Function(bool) changeTyping;
  final Function() removeLastMessage;
  final Function() clearOptionalQuestions;
  final Function(List<String>) addOptionalQuestions;
  final Function(bool) changeAreOptionalQuestions;

  _ViewModel({
      this.clearOptionalQuestions, this.addOptionalQuestions, this.changeAreOptionalQuestions,
      this.listening,
      this.visibilityFloating,
      this.areOptionalQuestions,
      this.messages,
      this.typing,
      this.changeListening,
      this.addMessage,
      this.changeTyping,
      this.removeLastMessage
      });

  factory _ViewModel.create(Store<AppState> store) {
    _onChangeListening(bool listening) {
      store.dispatch(ChangeListeningAction(listening));
    }

    _onAddMessage(Message message) {
      store.dispatch(AddMessageAction(message));
    }

    _onChangeTyping(bool typing) {
      store.dispatch(ProcessTypingAction(typing));
    }

    _onRemoveLastMessage() {
      store.dispatch(RemoveLastMessageAction());
    }

    _onClearOptionalQuestions() {
      store.dispatch(ClearOptionalQuestionsAction());
    }

    _onAddOptionalQuestions(List<String> optQuestions) {
      store.dispatch(AddOptionalQuestionsAction(optQuestions));
    }

    _onChangeAreOptionalQuestions(bool areOptQuestions) {
      store.dispatch(ChangeAreOptionalQuestionsAction(areOptQuestions));
    }

    return _ViewModel(
      listening: store.state.listening,
      messages: store.state.messages,
      changeListening: _onChangeListening,
      addMessage: _onAddMessage,
      changeTyping: _onChangeTyping,
      removeLastMessage: _onRemoveLastMessage,
      clearOptionalQuestions: _onClearOptionalQuestions,
      addOptionalQuestions: _onAddOptionalQuestions,
      changeAreOptionalQuestions: _onChangeAreOptionalQuestions
    );
  }
}

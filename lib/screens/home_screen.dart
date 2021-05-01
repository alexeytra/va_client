import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:va_client/models/message_model.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:va_client/models/view_model.dart';
import 'package:va_client/redux/app_state.dart';
import 'package:va_client/widgets/input_question.dart';
import 'package:va_client/widgets/show_message.dart';
import 'package:va_client/widgets/show_optional_questions.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  stt.SpeechToText _speechToText;
  String _text = '';
  final textFieldController = TextEditingController();
  final _scrollController = ScrollController();

  AudioPlayer _audioPlayer;
  AudioCache _audioCache;

  @override
  void initState() {
    super.initState();
    _speechToText = stt.SpeechToText();
    _getAudioIntro();
  }

  void _getAudioIntro() async {
    _audioPlayer = AudioPlayer();
    _audioCache = AudioCache(fixedPlayer: _audioPlayer);
    await _audioCache.load('intro.mp3');
    await _audioCache.play('intro.mp3');
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      distinct: true,
      onDidChange: (_) => WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom()),
      converter: (store) => ViewModel.create(store),
      builder: (context, ViewModel viewModel) => Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
            title: Text(
              'Виртуальный ассистент',
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
          body: Column(
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
                            itemCount: viewModel.messages.length,
                            itemBuilder: (BuildContext context, int index) {
                              final isMe = viewModel.messages[index].sender == 'USER';
                              return isMe
                                  ? ShowMessage(
                                      isMe: isMe, message: viewModel.messages[index], typing: viewModel.typing)
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
                                                message: viewModel.messages[index],
                                                isMe: isMe, typing: viewModel.typing)),
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
                      child: ShowOptionalQuestions(viewModel: viewModel,)),
                  InputQuestion(textFieldController: textFieldController, viewModel: viewModel)
                ],
              ),
          ),
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
  void _listen(ViewModel viewModel) async {
    if (viewModel.listening) {
      viewModel.changeListening(false);
      if (_text != '') {
        viewModel.addMessage(Message(message: _text, sender: 'USER'));
        viewModel.sendMessage(_text);
      }
      setState(() {
        _text = '';
      });
      await _speechToText.stop();
      return;
    }
    if (!viewModel.listening) {
      var available = await _speechToText.initialize(
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
        await _speechToText.listen(
          localeId: 'ru-RU',
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
          }),
        );
      } else {
        viewModel.changeListening(false);
        viewModel.addMessage(Message(message: _text, sender: 'USER'));
        await _speechToText.stop();
      }
    }
  }

  void _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }
}
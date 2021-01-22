import 'dart:convert';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:va_client/message_model.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  stt.SpeechToText _speechToText;
  bool _listening = false;
  String _text = '';
  bool _visibilityFloatingAction = true;
  bool _visibilityInput = false;
  final textFieldController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  AudioPlayer _audioPlayer;
  AudioCache _audioCache;

  List<Message> _dialogue;

  @override
  void initState() {
    super.initState();
    _dialogue = [Message(sender: 'VA', message: "Привет! Чем могу помочь?")];
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
    return Scaffold(
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Visibility(
        visible: _visibilityFloatingAction,
        child: FloatingActionButton(
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: _listen,
          child: Icon(_listening ? Icons.mic : Icons.mic_none),
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
                    itemCount: _dialogue.length,
                    itemBuilder: (BuildContext context, int index) {
                      final bool isMe = _dialogue[index].sender == 'USER';
                      return isMe
                          ? _buildMessage(_dialogue[index].message, isMe)
                          : Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.red[50],
                                  child: Text('ВА'),),
                                _buildMessage(_dialogue[index].message, isMe),
                              ],
                            );
                    }),
              ),
            ),
          ),
          Visibility(visible: _listening, child: _showUserQuestion()),
          _buildInputQuestion()
        ],
      ),
    );
  }

  Widget _buildMessage(String message, bool isMe) {
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
                  bottomRight: Radius.circular(15))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }

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

  Widget _buildInputQuestion() {
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
      child: _visibilityInput
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.mic),
                  onPressed: () {
                    setState(() {
                      _visibilityFloatingAction = true;
                      _visibilityInput = false;
                    });
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
                    setState(() {
                      _dialogue.add(Message(
                          message: textFieldController.text, sender: 'USER'));
                      textFieldController.text = '';
                    });
                    _getAnswer();
                  },
                  color: Theme.of(context).primaryColor,
                )
              ],
            )
          : Row(
              children: [
                Visibility(
                  visible: !_listening,
                  child: IconButton(
                    icon: Icon(Icons.keyboard),
                    onPressed: () {
                      setState(() {
                        _visibilityInput = true;
                        _visibilityFloatingAction = false;
                      });
                    },
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
    );
  }

  void _listen() async {
    if (_listening) {
      setState(() {
        _listening = false;
        _dialogue.add(Message(message: _text, sender: 'USER'));
        _text = '';
      });
      _speechToText.stop();
      _getAnswer();
      return;
    }
    if (!_listening) {
      bool available = await _speechToText.initialize(
        onStatus: (val) {
          if (val == 'notListening') {
            setState(() {
              _listening = false;
              _text = '';
            });
          }
        },
        onError: (val) => print('onError: $val'),
      );

      if (available) {
        setState(() {
          _listening = true;
        });

        _speechToText.listen(
          localeId: 'ru-RU',
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
          }),
        );
      } else {
        setState(() {
          _listening = false;
          _dialogue.add(Message(message: _text, sender: 'USER'));
          _text = '';
        });
        _speechToText.stop();
        _getAnswer();
      }
    }
  }

  void _getAnswer() async {
    Map<String, dynamic> answer = Map();

    setState(() {
      _dialogue
          .add(Message(message: 'Нет связи с мозгом 😁😁😁', sender: 'VA'));
    });
    var question = _dialogue.last.message.split("\s+");
    final http.Response response = await http.post(
      'http://127.0.0.1:5000/va/api/v1/question/text',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'question': question.take(10).join(" "),
      }),
    );

    if (response.statusCode == 200) {
      answer = jsonDecode(response.body);
      setState(() {
        _dialogue.add(Message(message: answer['answer'], sender: 'VA'));
      });
      _getAudioAnswer(answer['audio_answer']);
    } else {
      setState(() {
        _dialogue
            .add(Message(message: 'Нет связи с мозгом 😁😁😁', sender: 'VA'));
      });
      throw Exception('Failed to get answer');
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

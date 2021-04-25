import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:va_client/message_model.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:va_client/utils/APIManager.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

// Главный вью
class _HomeScreenState extends State<HomeScreen> {
  stt.SpeechToText _speechToText;
  bool _listening = false;
  String _text = '';
  bool _visibilityFloatingAction = true;
  bool _visibilityInput = false;
  bool _typing = false;
  bool _optionalQuestions = true;
  final textFieldController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  AudioPlayer _audioPlayer;
  AudioCache _audioCache;

  List<Message> _dialogue;

  @override
  void initState() {
    super.initState();
    _dialogue = [
      Message(
          sender: 'VA',
          message: "Привет! Я - Виртуальный ассистент, Ваш верный помощник. "
              "Чем могу помочь?")
    ];
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
                          ? _buildMessage(_dialogue[index], isMe)
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
                                    child:
                                        _buildMessage(_dialogue[index], isMe)),
                              ],
                            );
                    }),
              ),
            ),
          ),
          Visibility(visible: _listening, child: _showUserQuestion()),
          Visibility(
              visible: _optionalQuestions, child: _showOptionalQuestions()),
          _buildInputQuestion()
        ],
      ),
    );
  }

  // Соосбщения
  Widget _buildMessage(Message message, bool isMe) {
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
          !(_typing && message.iconTyping != '')
              ? Text(
                  message.message,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal),
                )
              : Image.asset(
                  message.iconTyping,
                  width: 50.0,
                  height: 20.0,
                ),
        ],
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

  Widget _showOptionalQuestions() {
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
          children: [
            Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: FilterChip(
                  label: Text("Номер телефона профкома",
                      style: TextStyle(fontSize: 16)),
                  onSelected: (text) {},
                )
            ),
            Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: FilterChip(
                  label: Text("Номер телефона профкома",
                      style: TextStyle(fontSize: 16)),
                  onSelected: (text) {},
                )
            ),
            Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: FilterChip(
                  label: Text("Номер телефона профкома",
                      style: TextStyle(fontSize: 16)),
                  onSelected: (text) {},
                )
            ),
            Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: FilterChip(
                  label: Text("Номер телефона профкома",
                      style: TextStyle(fontSize: 16)),
                  onSelected: (text) {},
                )
            ),
          ],
        ),
      ),
    );
  }

  // Ввод вопроса
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

  // Слушаем голос
  void _listen() async {
    if (_listening) {
      setState(() {
        _listening = false;
        if (_text != '') {
          _dialogue.add(Message(message: _text, sender: 'USER'));
        }
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
      }
    }
  }

  // Получаем ответ
  void _getAnswer() async {
    Map<String, dynamic> answer = Map();
    if (_dialogue.last.sender == 'USER') {
      var question = _dialogue.last.message.split("\s+");
      setState(() {
        _dialogue.add(Message(iconTyping: 'assets/typing.gif', sender: 'VA'));
        _typing = true;
      });

      APIManager apiManager = APIManager();
      apiManager.postAPICall("http://127.0.0.1:5000/va/api/v1/question/text",
          {'question': question.take(10).join(" ")}).then((value) {
        var statusCode = value["status"];
        if (statusCode == 200) {
          answer = value["response"];
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              _typing = false;
              _dialogue.removeLast();
              _dialogue.add(Message(message: answer['answer'], sender: 'VA'));
            });
          });
          Future.delayed(const Duration(seconds: 1), () {
            if (answer['audioAnswer'] != '') {
              _getAudioAnswer(answer['audioAnswer']);
            }
          });
        } else if (statusCode == 500) {
          setState(() {
            _typing = false;
            _dialogue.removeLast();
            _dialogue.add(Message(
                message: 'Что-то пошло не так, как я хотел 😁', sender: 'VA'));
          });
          return;
        }
      }, onError: (error) {
        print(error);
        setState(() {
          _typing = false;
          _dialogue.removeLast();
          _dialogue
              .add(Message(message: 'Нет связи с сервером 😁', sender: 'VA'));
        });
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

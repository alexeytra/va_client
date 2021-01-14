import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  stt.SpeechToText _speechToText;
  bool _listening = false;
  String _text = 'Press button';
  bool _visibilityFloatingAction = true;
  bool _visibilityInput = false;
  List<String> _dialogue;

  @override
  void initState() {
    super.initState();
    _dialogue = ['Привет! Чем могу помочь'];
    _speechToText = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
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
              child: Text(
                _text,
                style: TextStyle(fontSize: 30, color: Colors.black),
              ),
            ),
          ),
          _buildInputQuestion()
        ],
      ),
    );
  }

  _buildInputQuestion() {
    return Container(
      padding: EdgeInsets.only(bottom: 20.0, left: 15.0, right: 15),
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(
            color: Colors.black54,
            blurRadius: 5.0,
            offset: Offset(0.0, 1)
        ),],
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
                  decoration: InputDecoration(hintText: 'Введите вопрос'),
                )),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {},
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
        _speechToText.stop();
      });
      return;
    }
    if (!_listening) {
      bool available = await _speechToText.initialize(
        onStatus: (val) => print('onStatus $val'),
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
        });
        _speechToText.stop();
      }
    }
  }
}

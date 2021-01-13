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


  @override
  void initState() {
    super.initState();
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
        actions: [
          IconButton(icon: Icon(Icons.settings), onPressed: () {})
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _listen,
        child: Icon(_listening ? Icons.mic: Icons.mic_none),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              height: 500.0,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  )),
              child: Text(_text, style: TextStyle(
                fontSize: 30,
                color: Colors.black
              ),),
            ),
          ),
        ],
      ),
    );
  }

  void _listen() async {
    print('pressed');
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

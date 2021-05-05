import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  var isVoice = true;
  var isGenerateAnswer = true;

  @override
  void initState()  {
    _getSharedPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Настройки',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: Text('Использовать голос')),
                Switch(
                    value: isVoice,
                    activeColor: Colors.orangeAccent,
                    onChanged: (value) {
                      setState(() {
                        isVoice = value;
                      });
                    })
              ],
            ),
            Row(
              children: [
                Expanded(child: Text('Генерация ответа')),
                Switch(
                    value: isGenerateAnswer,
                    activeColor: Colors.orangeAccent,
                    onChanged: (value) {
                      setState(() {
                        isGenerateAnswer = value;
                      });
                    })
              ],
            ),
            // Text()
            TextButton(onPressed: () {}, child: Text('Авторизация')),
            TextButton(
              onPressed: () {},
              child: Text('Отправить отзыв'),
            ),
            TextButton(onPressed: () {}, child: Text('О приложении')),
          ],
        ),
      ),
    );
  }

  @override
  Future<void> deactivate() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('voice', isVoice);
    await prefs.setBool('generateAnswer', isGenerateAnswer);
    super.deactivate();
  }

  Future<Null> _getSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isVoice = prefs.getBool('voice') ?? true;
      isGenerateAnswer = prefs.getBool('generateAnswer') ?? true;
    });
  }
}
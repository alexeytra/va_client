import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:va_client/models/navigation.dart';
import 'package:va_client/models/view_model.dart';
import 'package:va_client/redux/app_state.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  var isVoice = true;
  var isGenerateAnswer = true;

  @override
  void initState() {
    _getSharedPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      distinct: true,
      converter: (store) => ViewModel.create(store),
      builder: (context, ViewModel viewModel) => Scaffold(
        appBar: AppBar(
          title: Text('Настройки',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          centerTitle: true,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Text(
                    'Использовать голос',
                    style: TextStyle(fontSize: 16),
                  )),
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
                  Expanded(
                      child: Text(
                    'Генерация ответа',
                    style: TextStyle(fontSize: 16),
                  )),
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
              SizedBox(height: 50.0),
              // Text()
              Visibility(
                visible: !viewModel.isLogin,
                child: TextButton(
                    onPressed: () {
                      Keys.navKey.currentState.pushNamed(Routes.authScreen);
                    },
                    child: Text('Авторизация', style: TextStyle(fontSize: 16))),
              ),
              TextButton(
                onPressed: () {
                  Keys.navKey.currentState.pushNamed(Routes.reviewScreen);
                },
                child: Text('Отправить отзыв', style: TextStyle(fontSize: 16)),
              ),
              TextButton(
                  onPressed: () {
                    _showAboutApp();
                  },
                  child: Text('О приложении', style: TextStyle(fontSize: 16))),
            ],
          ),
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

  Future<void> _showAboutApp() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('О приложении'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Виртуальный ассистент'),
                Text('Версия 1.0.2'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Настройки', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text('Использовать голос')),
              Switch(value: true, onChanged: null)
            ],
          ),
          Row(
            children: [
              Expanded(child: Text('Генерация ответа')),
              Switch(value: true, onChanged: null)
            ],
          ),
          Text('Отправить отзыв'),
          // Text()
        ],
      ),
    );
  }
}

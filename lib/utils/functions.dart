import 'dart:math';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:va_client/models/auth_data.dart';
import 'package:va_client/models/login_response.dart';
import 'package:va_client/models/message_model.dart';
import 'package:va_client/models/message_response.dart';
import 'package:va_client/models/settings_model.dart';

void getAudioAnswer(String url) async {
  if (url != '') {
    var player = AudioPlayer();
    await player.play(url);
    await player.monitorNotificationStateChanges(audioPlayerHandler);
  }
}

void getAudioIntro() async {
  var player = AudioPlayer();
  var audioCache = AudioCache(fixedPlayer: player);
  await audioCache.load('intro.mp3');
  await audioCache.play('intro.mp3');
  await player.monitorNotificationStateChanges(audioPlayerHandler);
}

void audioPlayerHandler(AudioPlayerState value) => null;

MessageResponse getMessageResponseObject(int statusCode, dynamic response) {
  if (statusCode == 200) {
    return MessageResponse.fromJson(response);
  } else {
    return MessageResponse(
        message: Message(
            message: 'Что-то пошло не так 😁 Попробуйте позже', sender: 'VA'),
        optionalQuestions: []);
  }
}

LoginResponse getLoginResponseObject(int statusCode, dynamic response) {
  if (statusCode == 200) {
    return LoginResponse.fromJson(response);
  } else {
    return null;
  }
}

T getRandomElement<T>(List<T> list) {
  final random = Random();
  var i = random.nextInt(list.length);
  return list[i];
}

Future<Settings> getSettingsFromSharedPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  final voice = prefs.getBool('voice') ?? true;
  final generateAnswer = prefs.getBool('generateAnswer') ?? true;

  return Settings(voice, generateAnswer);
}

void saveAuthData(String login, String password) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('login', login);
  await prefs.setString('password', password);
}

Future<AuthData> getAuthData() async {
  final prefs = await SharedPreferences.getInstance();
  final login = prefs.getString('login') ?? '';
  final password = prefs.getString('password') ?? '';
  if (password == '' && login == '') {
    return null;
  }
  return AuthData(login, password);
}

Future<void> clearAuthData() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('login', '');
  await prefs.setString('password', '');
}

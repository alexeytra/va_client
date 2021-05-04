import 'dart:math';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:va_client/models/message_model.dart';
import 'package:va_client/models/message_response.dart';

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

MessageResponse getResponseObject(int statusCode, dynamic response) {
  if (statusCode == 200) {
    return MessageResponse.fromJson(response);
  } else {
    return MessageResponse(
        message: Message(
            message: 'Что-то пошло не так 😁 Попробуйте позже', sender: 'VA'),
        optionalQuestions: []);
  }
}

T getRandomElement<T>(List<T> list) {
  final random = Random();
  var i = random.nextInt(list.length);
  return list[i];
}
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

void getAudioAnswer(String url) async {
  var player = AudioPlayer();
  await player.play(url);
  await player.monitorNotificationStateChanges(audioPlayerHandler);
}

void getAudioIntro() async {
  var player = AudioPlayer();
  var audioCache = AudioCache(fixedPlayer: player);
  await audioCache.load('intro.mp3');
  await audioCache.play('intro.mp3');
  await player.monitorNotificationStateChanges(audioPlayerHandler);
}

void audioPlayerHandler(AudioPlayerState value) => null;
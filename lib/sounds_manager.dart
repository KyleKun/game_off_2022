import 'dart:async';
import 'package:flame_audio/flame_audio.dart';

class SoundsManager {
  static Future initialize() async {
    FlameAudio.bgm.initialize();
  }

  static void cocorico() {
    FlameAudio.play('cocorico.wav');
  }

  static void coin() {
    FlameAudio.play('coin.wav');
  }

  static void stopBgm() async {
    await FlameAudio.bgm.stop();
  }

  static void playBgm() async {
    FlameAudio.bgm.play('bgm.mp3');
  }

  static void playMenu() async {
    FlameAudio.bgm.play('menu.wav');
  }

  static void pauseBgm() {
    FlameAudio.bgm.pause();
  }

  static void resumeBgm() {
    FlameAudio.bgm.resume();
  }
}

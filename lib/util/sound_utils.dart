import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:soundpool/soundpool.dart';
import 'package:sports/logic/service/config_service.dart';
import 'package:sports/util/utils.dart';

class SoundUtils {
  static Soundpool pool = Soundpool.fromOptions(
      options: SoundpoolOptions(
          streamType: StreamType.music,
          iosOptions: SoundpoolOptionsIos(
              audioSessionCategory: AudioSessionCategory.ambient)));

  static play(String sound) async {
    int soundId = await rootBundle
        .load(Utils.getSoundPath(sound))
        .then((ByteData soundData) {
      return pool.load(soundData);
    });
    int streamId = await pool.play(soundId);
  }

  static playSoccerGoal(bool home) async {
    final config = Get.find<ConfigService>();
    int sound = home
        ? config.soccerConfig.soccerInAppAlert3
        : config.soccerConfig.soccerInAppAlert4;
    play(config.soccerSound[sound]);
  }

  static playRedCard() async {
    play('shaozi');
  }

  static playBasketGoal() async {
    play('qiuchang');
  }
}

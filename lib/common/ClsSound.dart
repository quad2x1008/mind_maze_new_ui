import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mind_maze/common/Key.dart';
import 'package:soundpool/soundpool.dart';
import '../main.dart';

enum SOUNDTYPE { Tap, Complate , START , Hint , TikTik , Correct , TimesUp , Wrong }

Map<SOUNDTYPE, int> audioPLayer = {};
Soundpool? pool;

AudioPlayer backPlayer = AudioPlayer();
AudioPlayer tikTik = AudioPlayer();

List<String> tapSound = ['tap.mp3'];
List<String> sucessSound = ['complete2.mp3'];
List<String> levelStart = ['start1.mp3'];

class ClsSound {
  static init() async {
    if(pool!=null){
      pool!.release();
    }
    pool = Soundpool.fromOptions(options: SoundpoolOptions(streamType: StreamType.music));
    audioPLayer[SOUNDTYPE.Tap] = await pool!.load(await rootBundle.load("assets/sound/"+tapSound[session.read(KEY.KEY_TAPSOUND)??0]));
    audioPLayer[SOUNDTYPE.Complate] = await pool!.load(await rootBundle.load("assets/sound/${sucessSound[session.read(KEY.KEY_SucessSOUND)??0]}"));
    audioPLayer[SOUNDTYPE.START] = await pool!.load(await rootBundle.load("assets/sound/${levelStart[session.read(KEY.KEY_StartSOUND)??0]}"));
    audioPLayer[SOUNDTYPE.TikTik] = await pool!.load(await rootBundle.load("assets/sound/ticktock.wav"));
    audioPLayer[SOUNDTYPE.Correct] = await pool!.load(await rootBundle.load("assets/sound/se_correct.ogg"));
    audioPLayer[SOUNDTYPE.TimesUp] = await pool!.load(await rootBundle.load("assets/sound/se_timeup.ogg"));
    audioPLayer[SOUNDTYPE.Wrong] = await pool!.load(await rootBundle.load("assets/sound/puzzle-error-47187.mp3"));
  }

  static playSound(SOUNDTYPE name) async {
    var playsound = session.read(KEY.KEY_Sound) ?? true;
    print("12345:---$playsound");
    if(playsound){
      pool?.play(audioPLayer[name]!);
    }
  }

  static playMusic() async {
    var playMusic = session.read(KEY.KEY_Music) ?? true;
    print("67890:---$playMusic");
    if(playMusic) {
      await backPlayer.setAsset('assets/sound/puzzle_music.mp3');
      backPlayer.setLoopMode(LoopMode.all);
      backPlayer.play();
    }else{
      backPlayer?.stop();
    }
  }

  static playTikTik() async {
    if(session.read(KEY.KEY_Sound)??true) {
      await tikTik.setAsset('assets/sound/ticktock.wav');
      tikTik.setLoopMode(LoopMode.all);
      tikTik.play();
    }else{
      tikTik?.stop();
    }
  }

  static stopTikTik() async {
    tikTik?.stop();
  }

  static pauseMusic() async {
    backPlayer.pause();
  }
}

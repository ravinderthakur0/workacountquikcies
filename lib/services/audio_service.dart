import 'package:audio_service/audio_service.dart';

class AudioServiceHandler {
  static Future<void> init() async {
    await AudioService.init(
      builder: () => MyAudioHandler(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.ryanheise.myapp.channel.audio',
        androidNotificationChannelName: 'Audio playback',
        androidNotificationOngoing: true,
      ),
    );
  }
}

class MyAudioHandler extends BaseAudioHandler {}

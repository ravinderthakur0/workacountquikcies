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

class MyAudioHandler extends BaseAudioHandler {
  MyAudioHandler() {
    playbackState.add(playbackState.value.copyWith(
      controls: [
        MediaControl.pause,
        MediaControl.stop,
      ],
      processingState: AudioProcessingState.ready,
      playing: true,
    ));
    mediaItem.add(_mediaItem);
  }

  final _mediaItem = MediaItem(
    id: 'https://example.com/audio.mp3',
    album: 'Science Friday',
    title: 'A Salute To Head-Scratching Science',
    artist: 'Science Friday and WNYC Studios',
    duration: const Duration(milliseconds: 5739820),
    artUri: Uri.parse(
        'https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg'),
  );

  @override
  Future<void> play() async {
    playbackState.add(playbackState.value.copyWith(
      playing: true,
      controls: [MediaControl.pause, MediaControl.stop],
    ));
  }

  @override
  Future<void> pause() async {
    playbackState.add(playbackState.value.copyWith(
      playing: false,
      controls: [MediaControl.play, MediaControl.stop],
    ));
  }

  @override
  Future<void> stop() async {
    playbackState.add(playbackState.value.copyWith(
      playing: false,
    ));
    await playbackState.firstWhere((state) => !state.playing);
    // Close the app or stop the service
  }
}

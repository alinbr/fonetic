import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonetic/application/play_controller.dart';
import 'package:just_audio/just_audio.dart';

final postProductionProvider =
    StateNotifierProvider<PostProductionController, PostProductionState>((ref) {
  ref.watch(currentPlayIdProvider);
  return PostProductionController(ref.read);
});

class PostProductionController extends StateNotifier<PostProductionState> {
  final Reader _read;

  late final AudioPlayer _player;

  PostProductionController(this._read) : super(PostProductionState.empty()) {
    initPlayer();
  }

  void initPlayer() async {
    final playId = _read(currentPlayIdProvider).state;

    var snapshot =
        await FirebaseStorage.instance.ref().child('$playId').listAll();

    List<AudioSource> audioSources = [];

    for (var item in snapshot.items) {
      String url = await item.getDownloadURL();

      var audioSource = ProgressiveAudioSource(Uri.parse(url));

      audioSources.add(audioSource);
    }

    print(audioSources.length);

    _player = AudioPlayer();

    _player.setAudioSource(LoopingAudioSource(
      count: 1,
      child: ConcatenatingAudioSource(children: audioSources),
    ));

    await _player.load();

    _player.playerStateStream.listen((event) {
      print(event.processingState);
    });

    _player.createPositionStream().forEach((element) {
      print(element.inMilliseconds.toString());
    });

    state = state.copyWith(
        status: PostProductionStatus.INITIALISED,
        duration: _player.duration,
        player: _player);

    print("initalized audio player");

    
  }

  void play() {
    state.player.play();
    state = state.copyWith(status: PostProductionStatus.PLAYING);
  }

  void pause() {
    state.player.pause();
    state = state.copyWith(status: PostProductionStatus.INITIALISED);
  }
}

enum PostProductionStatus { LOADING, INITIALISED, PLAYING }

class PostProductionState {
  final PostProductionStatus status;
  final AudioPlayer player;
  final Duration duration;

  PostProductionState(
      {required this.status, required this.player, required this.duration});

  PostProductionState copyWith({status, player, duration}) {
    return PostProductionState(
        status: status ?? this.status,
        player: player ?? this.player,
        duration: duration ?? this.duration);
  }

  String getDurationFormatted() {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return twoDigits(duration.inMinutes) +
        ":" +
        twoDigits(duration.inSeconds.remainder(60));
  }

  factory PostProductionState.empty() {
    return PostProductionState(
        status: PostProductionStatus.LOADING,
        player: AudioPlayer(),
        duration: Duration(seconds: 0));
  }
}

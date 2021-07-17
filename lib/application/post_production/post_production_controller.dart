import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:fonetic/application/play_controller.dart';
import 'package:fonetic/application/recording/recorded_lines_controller.dart';
import 'package:just_audio/just_audio.dart';

final postProductionProvider =
    StateNotifierProvider<PostProductionController, PostProductionState>((ref) {
  ref.watch(currentPlayIdProvider);
  return PostProductionController(ref.read);
});

class PostProductionController extends StateNotifier<PostProductionState> {
  final Reader _read;

  late final AudioPlayer _player;

  final _scrollController = new ScrollController();

  var durationsOffset = [];

  bool dragging = false;

  PostProductionController(this._read) : super(PostProductionState.empty()) {
    initPlayer();

    final lines = _read(recordedLinesProvider)
      ..sort((a, b) => a.order.compareTo(b.order));
    int currentDuration = 0;
    durationsOffset.add(currentDuration);
    for (var line in lines) {
      print("line order: ${line.order}");
      currentDuration += line.durationInMiliseconds;
      durationsOffset.add(currentDuration);
    }
    _scrollController.addListener(() {
      // print("offset = ${_scrollController.offset}");
    });
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

    print(
        "Number of audios downloaded from the server: ${audioSources.length}");

    _player = AudioPlayer();

    _player.setAudioSource(ConcatenatingAudioSource(children: audioSources),
        preload: true);

    await _player.load();

    _player.playerStateStream.listen((event) {
      print("event.processingState : ${event.processingState}");
      if (event.processingState == ProcessingState.completed) {
        _player.stop();

        state = state.copyWith(
            status: PostProductionStatus.INITIALISED, player: _player);
      }
    });

    _player
        .createPositionStream(
      minPeriod: Duration(milliseconds: 100),
      maxPeriod: Duration(milliseconds: 100),
    )
        .forEach((element) {
      if (dragging) return;

      if (_player.processingState == ProcessingState.ready)
        _scrollController.animateTo(
            (element.inMilliseconds / 10) +
                durationsOffset[_player.currentIndex!] / 10,
            duration: Duration(milliseconds: 100),
            curve: Curves.linear);
      print(
          "${_player.currentIndex}: element.inMilliseconds : ${element.inMilliseconds.toString()}");
    });

    _player.durationStream.listen((element) {
      print("duration: ${element!.inSeconds.toString()}");
    });

    _player.currentIndexStream.listen((event) {
      state = state.copyWith(currentIndex: event);
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

  void draggingStart() {
    pause();
    dragging = true;
  }

  Future<void> draggingStop() async {
    print("dragging stop event START");

    print(durationsOffset);
    print("offset = ${_scrollController.offset}");
    double newDurationInMiliseconds = _scrollController.offset * 10;
    int newIndex = 0;
    while (newDurationInMiliseconds > durationsOffset[newIndex] ||
        newIndex > durationsOffset.length) newIndex++;
    newIndex--;
    print(newIndex);
    await _player.seek(
        Duration(
            milliseconds:
                (newDurationInMiliseconds - durationsOffset[newIndex]).floor()),
        index: newIndex);

    print("dragging stop event END");
    // play();

    dragging = false;
  }

  ScrollController getSCrollControler() {
    return _scrollController;
  }
}

enum PostProductionStatus { LOADING, INITIALISED, PLAYING }

class PostProductionState {
  final PostProductionStatus status;
  final AudioPlayer player;
  final int currentIndex;

  PostProductionState(
      {required this.status, required this.player, required this.currentIndex});

  PostProductionState copyWith({status, player, duration, currentIndex}) {
    return PostProductionState(
      status: status ?? this.status,
      player: player ?? this.player,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  String getDurationFormatted(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return twoDigits(duration.inMinutes) +
        ":" +
        twoDigits(duration.inSeconds.remainder(60));
  }

  factory PostProductionState.empty() {
    return PostProductionState(
      status: PostProductionStatus.LOADING,
      player: AudioPlayer(),
      currentIndex: 0,
    );
  }
}

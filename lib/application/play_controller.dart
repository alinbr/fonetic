import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonetic/application/current_user.dart';
import 'package:fonetic/application/lines_controller.dart';
import 'package:fonetic/application/recording/displaying_lines_controller.dart';
import 'package:fonetic/application/recording/recorded_lines_controller.dart';
import 'package:fonetic/infrastructure/dtos/character.dart';
import 'package:fonetic/infrastructure/dtos/play.dart';
import 'package:fonetic/infrastructure/dtos/recorded_line.dart';
import 'package:fonetic/infrastructure/repositories/play_repository.dart';

import 'recording/line_recorder_controller.dart';

final currentPlayIdProvider = StateProvider<String?>((ref) => null);

final currentScriptIdProvider = Provider<String?>((ref) {
  return ref
      .watch(playProvider)
      .maybeMap(data: (data) => data.value.scriptId, orElse: () {});
});

final playProvider =
    StateNotifierProvider<PlayController, AsyncValue<Play>>((ref) {
  final playId = ref.watch(currentPlayIdProvider).state!;
  final repository = ref.watch(playRepository);
  final currentUser = ref.watch(currentUserProvider);

  return PlayController(ref.read, repository, playId, currentUser);
});

class PlayController extends StateNotifier<AsyncValue<Play>> {
  BasePlayRepository _repository;

  final String _playId;

  final String _currentUser;

  final Reader _read;

  PlayController(this._read, this._repository, this._playId, this._currentUser)
      : super(AsyncValue.loading()) {
    retrievePlay();
  }

  void retrievePlay() async {
    state = AsyncLoading();

    try {
      final item = await _repository.retrievePlay(_playId);
      state = AsyncValue.data(item);
    } on Exception catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deletePlay() async {
    await _repository.deletePlay(_playId);
  }

  Future<void> assignCharacter(String character, String userId) async {
    final play = state.data!.value;

    final newCharacter = play.characters
        .where((element) => element.character == character)
        .first
        .copyWith(userId: userId);
    var newCharacters = List<Character>.from(play.characters);
    newCharacters.removeWhere((element) => element.character == character);
    newCharacters.add(newCharacter);
    newCharacters.sort((c1, c2) => c1.character.compareTo(c2.character));

    final newPlay = play.copyWith(characters: newCharacters);

    await _repository.updatePlay(newPlay);

    state = AsyncValue.data(newPlay);
  }

  List<String> getUserCharacters() {
    if (state.data != null) {
      return state.data!.value.characters
          .where((element) => element.userId == _currentUser)
          .map((e) => e.character)
          .toList();
    }
    return List.empty();
  }

  bool isRecordable(Play play) {
    return !play.characters
            .where((element) => element.userId == null)
            .isNotEmpty &&
        play.playStatus == PlayStatus.IN_PROGRESS;
  }

  Future<void> changePlayStatus(PlayStatus newStatus) async {
    print("changePlayStatus :: start");
    final newPlay = state.data!.value.copyWith(playStatus: newStatus);
    await _repository.updatePlay(newPlay);
    state = AsyncValue.data(newPlay);
    print("changePlayStatus :: end");
  }

  Future<void> sendRecordedLine() async {
    final lineOrder = _read(displayingLinesProvider(state.data!.value.scriptId))
        .maybeMap(data: (data) => data.value.currentLine!.order, orElse: () {});

    String fileUrl = await _read(lineRecorderProvider.notifier)
        .uploadFile(_playId, lineOrder);

    await _read(recordedLinesProvider.notifier)
        .addRecordedLine(RecordedLine(order: lineOrder!, audioLink: fileUrl));

    _read(lineRecorderProvider.notifier).resetState();

    state.whenData((playData) {
      String scriptId = playData.scriptId;

      final script = _read(linesProvider(scriptId));

      script.whenData((scriptData) {
        final scriptLines = scriptData.length;
        final recordedLines = _read(recordedLinesProvider).length;

        if (scriptLines == recordedLines &&
            playData.playStatus == PlayStatus.IN_PROGRESS) {
          changePlayStatus(PlayStatus.POST_PRODUCTION);
        }
      });
    });
  }
}

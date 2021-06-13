import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonetic/infrastructure/dtos/character.dart';
import 'package:fonetic/infrastructure/dtos/play.dart';
import 'package:fonetic/infrastructure/repositories/play_repository.dart';

final playProvider =
    StateNotifierProvider.family<PlayController, AsyncValue<Play>, String>(
        (ref, playId) {
  final repository = ref.watch(playRepository);

  return PlayController(repository, playId);
});

class PlayController extends StateNotifier<AsyncValue<Play>> {
  BasePlayRepository _repository;

  final String _playId;

  PlayController(this._repository, this._playId) : super(AsyncValue.loading()) {
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

    final newPlay = play.copyWith(characters: newCharacters);

    await _repository.updatePlay(newPlay);

    state = AsyncValue.data(newPlay);
  }

  bool isRecordable(Play play) {
    return !play.characters
        .where((element) => element.userId == null)
        .isNotEmpty;
  }
}

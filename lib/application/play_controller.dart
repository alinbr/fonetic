import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonetic/application/current_user.dart';
import 'package:fonetic/infrastructure/dtos/character.dart';
import 'package:fonetic/infrastructure/dtos/play.dart';
import 'package:fonetic/infrastructure/repositories/play_repository.dart';

final currentPlayIdProvider = StateProvider<String?>((ref) => null);

final playProvider =
    StateNotifierProvider<PlayController, AsyncValue<Play>>((ref) {
  final playId = ref.watch(currentPlayIdProvider).state!;
  final repository = ref.watch(playRepository);
  final currentUser = ref.watch(currentUserProvider);

  return PlayController(repository, playId, currentUser);
});

class PlayController extends StateNotifier<AsyncValue<Play>> {
  BasePlayRepository _repository;

  final String _playId;

  final String _currentUser;

  PlayController(this._repository, this._playId, this._currentUser)
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
        .isNotEmpty;
  }
}

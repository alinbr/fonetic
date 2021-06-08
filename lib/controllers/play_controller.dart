import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonetic/controllers/script_template_controller.dart';
import 'package:fonetic/models/play.dart';
import 'package:fonetic/models/script_template.dart';
import 'package:fonetic/repositories/play_repository.dart';

final playProvider =
    StateNotifierProvider.family<PlayController, AsyncValue<Play>, String>(
        (ref, playId) {
  final repository = ref.watch(playRepository);
  return PlayController(repository, ref.read, playId);
});

class PlayController extends StateNotifier<AsyncValue<Play>> {
  BasePlayRepository _repository;

  final String _playId;

  late Play play;

  final Reader _read;

  late ScriptTemplate script;

  PlayController(this._repository, this._read, this._playId)
      : super(AsyncValue.loading()) {
    print("sss");
    retrievePlay();
  }

  void retrievePlay() async {
    state = AsyncLoading();

    try {
      final item = await _repository.retrievePlay(_playId);
      script = await _read(scriptTemplateProvider.notifier)
          .getScriptTemplate(item.scriptTemplateId);
      play = item;
      state = AsyncValue.data(item);
    } on Exception catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deletePlay() async {
    await _repository.deletePlay(play.id!);
  }

  Future<void> assignCharacter(String character, String userId) async {
    final newCharacter = play.characters
        .where((element) => element.character == character)
        .first
        .copyWith(userId: userId);
    var newCharacters = List<Character>.from(play.characters);
    newCharacters.removeWhere((element) => element.character == character);
    newCharacters.add(newCharacter);

    play = play.copyWith(characters: newCharacters);

    await _repository.updatePlay(play);

    state = AsyncValue.data(play);
  }
}

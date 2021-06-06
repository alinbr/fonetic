import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonetic/controllers/script_template_controller.dart';
import 'package:fonetic/models/play.dart';
import 'package:fonetic/repositories/play_repository.dart';

final playProvider = StateNotifierProvider.family<PlayController,
    AsyncValue<List<Play>>, String>((ref, userId) {
  final repository = ref.watch(playRepository);
  return PlayController(repository, ref.read, userId);
});

class PlayController extends StateNotifier<AsyncValue<List<Play>>> {
  BasePlayRepository _repository;

  final Reader _read;

  final String _userId;

  PlayController(this._repository, this._read, this._userId)
      : super(AsyncValue.loading()) {
    retrievePlays(_userId);
  }

  Future<void> retrievePlays(String userId) async {
    state = AsyncValue.loading();

    try {
      final items = await _repository.retrievePlays(userId);
      state = AsyncValue.data(items);
    } on Exception catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void addPlay(String scriptTemplateId) async {
    Play play = Play(
        producerId: '1',
        scriptTemplateId: scriptTemplateId,
        playStatus: PlayStatus.IN_PROGRESS,
        characters: await getCharacters(scriptTemplateId));
    _repository.addPlay(play);

    retrievePlays(_userId);
  }

  Future<List<Character>> getCharacters(String scriptTemplateId) async {
    final script = await _read(scriptTemplateProvider.notifier)
        .getScriptTemplate(scriptTemplateId);
    return script.characters.map((e) => Character(null, e)).toList();
  }
}

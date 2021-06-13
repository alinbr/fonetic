import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonetic/application/script_template_controller.dart';
import 'package:fonetic/infrastructure/dtos/character_dto.dart';
import 'package:fonetic/infrastructure/dtos/play_dto.dart';
import 'package:fonetic/infrastructure/repositories/play_repository.dart';

final myPlaysProvider = StateNotifierProvider.family<MyPlaysController,
    AsyncValue<List<PlayDto>>, String>((ref, userId) {
  final repository = ref.watch(playRepository);

  return MyPlaysController(repository, ref.read, userId);
});

class MyPlaysController extends StateNotifier<AsyncValue<List<PlayDto>>> {
  BasePlayRepository _repository;

  final Reader _read;

  final String _userId;

  MyPlaysController(this._repository, this._read, this._userId)
      : super(AsyncValue.loading()) {
    retrievePlays();
    print('retrieve plays');
  }

  Future<void> retrievePlays() async {
    state = AsyncValue.loading();

    try {
      final items = await _repository.retrievePlays(_userId);
      state = AsyncValue.data(items);
    } on Exception catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void addPlay(String scriptTemplateId) async {
    PlayDto play = PlayDto(
        producerId: '1',
        scriptTemplateId: scriptTemplateId,
        playStatus: PlayStatus.IN_PROGRESS,
        characters: await getCharacters(scriptTemplateId));
    _repository.addPlay(play);

    retrievePlays();
  }

  Future<List<Character>> getCharacters(String scriptTemplateId) async {
    final script = await _read(scriptTemplateProvider.notifier)
        .getScriptTemplate(scriptTemplateId);
    return script.characters.map((e) => Character(null, e)).toList();
  }

  Future<PlayDto> retrievePlay(String playId) async {
    return _repository.retrievePlay(playId);
  }
}

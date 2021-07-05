import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonetic/infrastructure/dtos/character.dart';
import 'package:fonetic/infrastructure/dtos/play.dart';
import 'package:fonetic/infrastructure/dtos/script.dart';
import 'package:fonetic/infrastructure/repositories/play_repository.dart';

final myPlaysProvider = StateNotifierProvider.family<MyPlaysController,
    AsyncValue<List<Play>>, String>((ref, userId) {
  final repository = ref.watch(playRepository);

  return MyPlaysController(repository, userId);
});

class MyPlaysController extends StateNotifier<AsyncValue<List<Play>>> {
  BasePlayRepository _repository;

  final String _userId;

  MyPlaysController(this._repository, this._userId)
      : super(AsyncValue.loading()) {
    retrievePlays();
    print('retrieve plays');
  }

  Future<void> retrievePlays() async {
    state = AsyncValue.loading();

    try {
      final plays = await _repository.retrievePlays(_userId);
      state = AsyncValue.data(plays);
    } on Exception catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void addPlay(Script script) async {
    var characters =
        script.characters.map((e) => Character(character: e)).toList();
    characters.sort((c1, c2) => c1.character.compareTo(c2.character));

    Play play = Play(
        producerId: '1',
        scriptId: script.id!,
        playStatus: PlayStatus.IN_PROGRESS,
        characters: characters,
        cover: script.cover,
        roles: script.roles,
        duration: script.duration,
        name: script.name,
        description: script.description);

    _repository.addPlay(play);

    retrievePlays();
  }

  Future<Play> retrievePlay(String playId) async {
    return _repository.retrievePlay(playId);
  }
}

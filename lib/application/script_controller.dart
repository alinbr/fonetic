import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonetic/infrastructure/dtos/script.dart';
import 'package:fonetic/infrastructure/repositories/script_repository.dart';

final scriptProvider =
    StateNotifierProvider<ScriptController, AsyncValue<List<Script>>>((ref) {
  final repository = ref.watch(scriptRepository);
  return ScriptController(repository);
});

class ScriptController extends StateNotifier<AsyncValue<List<Script>>> {
  BaseScriptRepository _repository;

  ScriptController(this._repository) : super(AsyncValue.loading()) {
    retrieveItems();
  }

  Future<void> retrieveItems() async {
    state = AsyncValue.loading();

    try {
      final items = await _repository.retrieveScripts();
      state = AsyncValue.data(items);
    } on Exception catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<Script> getScript(String scriptId) async {
    final script = await _repository.retrieveScript(scriptId);
    return script;
  }
}

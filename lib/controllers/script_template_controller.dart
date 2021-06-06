import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonetic/models/script_template.dart';
import 'package:fonetic/repositories/script_template_repository.dart';

final scriptTemplateProvider = StateNotifierProvider<ScriptTemplateController,
    AsyncValue<List<ScriptTemplate>>>((ref) {
  final repository = ref.watch(scriptTemplateRepository);
  return ScriptTemplateController(repository);
});

class ScriptTemplateController
    extends StateNotifier<AsyncValue<List<ScriptTemplate>>> {
  BaseScriptTemplateRepository _repository;

  ScriptTemplateController(this._repository) : super(AsyncValue.loading()) {
    retrieveItems();
  }

  Future<void> retrieveItems() async {
    state = AsyncValue.loading();

    try {
      final items = await _repository.retrieveScriptTemplates();
      state = AsyncValue.data(items);
    } on Exception catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<ScriptTemplate> getScriptTemplate(String scriptTemplateId) async {
    final script = await _repository.retrieveScriptTemplate(scriptTemplateId);
    return script;
  }
}

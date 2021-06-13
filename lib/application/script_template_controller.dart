import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonetic/infrastructure/dtos/script_template_dto.dart';
import 'package:fonetic/infrastructure/repositories/script_template_repository.dart';

final scriptTemplateProvider = StateNotifierProvider<ScriptTemplateController,
    AsyncValue<List<ScriptTemplateDto>>>((ref) {
  final repository = ref.watch(scriptTemplateRepository);
  return ScriptTemplateController(repository);
});

class ScriptTemplateController
    extends StateNotifier<AsyncValue<List<ScriptTemplateDto>>> {
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

  Future<ScriptTemplateDto> getScriptTemplate(String scriptTemplateId) async {
    final script = await _repository.retrieveScriptTemplate(scriptTemplateId);
    return script;
  }
}

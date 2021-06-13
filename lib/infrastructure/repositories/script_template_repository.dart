import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonetic/infrastructure/dtos/script_template_dto.dart';

final scriptTemplateRepository = Provider<ScriptTemplateRepository>((ref) {
  return ScriptTemplateRepository();
});

abstract class BaseScriptTemplateRepository {
  Future<List<ScriptTemplateDto>> retrieveScriptTemplates();
  Future<ScriptTemplateDto> retrieveScriptTemplate(String id);
}

class ScriptTemplateRepository implements BaseScriptTemplateRepository {
  final _service = FirebaseFirestore.instance;

  @override
  Future<List<ScriptTemplateDto>> retrieveScriptTemplates() async {
    try {
      final snap = await _service.collection('scriptTemplates').get();

      return snap.docs
          .map((e) => ScriptTemplateDto.fromJson(e.id, e.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception("Could not retrieve plays: ${e.message}");
    }
  }

  @override
  Future<ScriptTemplateDto> retrieveScriptTemplate(String id) async {
    try {
      final snap = await _service.collection('scriptTemplates').doc(id).get();
      return ScriptTemplateDto.fromJson(id, snap.data()!);
    } on FirebaseException catch (e) {
      throw Exception("Could not retrieve plays: ${e.message}");
    }
  }
}

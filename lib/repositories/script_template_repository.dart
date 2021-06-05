import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonetic/models/script_template.dart';

abstract class BaseScriptTemplateRepository {
  Future<List<ScriptTemplate>> retrieveScriptTemplates();
}

final scriptTemplateRepository = Provider<ScriptTemplateRepository>((ref) {
  return ScriptTemplateRepository();
});

class ScriptTemplateRepository implements BaseScriptTemplateRepository {
  final _service = FirebaseFirestore.instance;

  @override
  Future<List<ScriptTemplate>> retrieveScriptTemplates() async {
    try {
      final snap = await _service.collection('scriptTemplates').get();

      return snap.docs.map((e) => ScriptTemplate.fromJson(e.data())).toList();
    } on FirebaseException catch (e) {
      throw Exception("Could not retrieve plays: ${e.message}");
    }
  }
}

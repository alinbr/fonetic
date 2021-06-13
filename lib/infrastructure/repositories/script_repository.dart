import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonetic/infrastructure/dtos/script.dart';

final scriptRepository = Provider<ScriptRepository>((ref) {
  return ScriptRepository();
});

abstract class BaseScriptRepository {
  Future<List<Script>> retrieveScripts();
  Future<Script> retrieveScript(String id);
}

class ScriptRepository implements BaseScriptRepository {
  final _service = FirebaseFirestore.instance;

  @override
  Future<List<Script>> retrieveScripts() async {
    try {
      final snap = await _service.collection('scriptTemplates').get();

      return snap.docs.map((e) => Script.fromJson(e.id, e.data())).toList();
    } on FirebaseException catch (e) {
      throw Exception("Could not retrieve plays: ${e.message}");
    }
  }

  @override
  Future<Script> retrieveScript(String id) async {
    try {
      final snap = await _service.collection('scriptTemplates').doc(id).get();
      return Script.fromJson(id, snap.data()!);
    } on FirebaseException catch (e) {
      throw Exception("Could not retrieve plays: ${e.message}");
    }
  }
}

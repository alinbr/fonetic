import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonetic/models/line.dart';

abstract class BaseLineRepository {
  Future<List<Line>> retrieveLines(String scriptTemplateId);
}

final lineRepository = Provider<LineRepository>((ref) {
  return LineRepository();
});

class LineRepository implements BaseLineRepository {
  final _service = FirebaseFirestore.instance;

  @override
  Future<List<Line>> retrieveLines(String scriptTemplateId) async {
    try {
      final snap = await _service
          .collection('scriptTemplates')
          .doc(scriptTemplateId)
          .collection('lines')
          .get();

      return snap.docs.map((e) => Line.fromJson(e.data())).toList();
    } on FirebaseException catch (e) {
      throw Exception("Could not retrieve lines: ${e.message}");
    }
  }
}

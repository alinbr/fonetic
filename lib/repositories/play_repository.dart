import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonetic/models/play.dart';

abstract class BasePlayRepository {
  Future<void> addPlay(Play play);
  Future<List<Play>> retrievePlays(String producerId);
}

final playRepository = Provider<PlayRepository>((ref) {
  return PlayRepository();
});

class PlayRepository implements BasePlayRepository {
  final _service = FirebaseFirestore.instance.collection('plays').withConverter(
        fromFirestore: (snapshot, _) => Play.fromJson(snapshot.data()!),
        toFirestore: (play, _) => play.toJson(),
      );

  @override
  Future<void> addPlay(Play play) async {
    try {
      _service.add(play);
    } on FirebaseException catch (e) {
      throw Exception("Could not retrieve lines: ${e.message}");
    }
  }

  @override
  Future<List<Play>> retrievePlays(String producerId) async {
    try {
      final snap =
          await _service.where("producerId", isEqualTo: producerId).get();

      return snap.docs.map((e) => e.data()).toList();
    } on FirebaseException catch (e) {
      throw Exception("Could not retrieve lines: ${e.message}");
    }
  }
}

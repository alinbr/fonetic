import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonetic/models/play.dart';

abstract class BasePlayRepository {
  Future<void> addPlay(Play play);
  Future<List<Play>> retrievePlays(String producerId);
  Future<Play> retrievePlay(String producerId);
  Future<void> updatePlay(Play newPlay);
  Future<void> deletePlay(String playId);
}

final playRepository = Provider<PlayRepository>((ref) {
  return PlayRepository();
});

class PlayRepository implements BasePlayRepository {
  final _service = FirebaseFirestore.instance.collection('plays').withConverter(
        fromFirestore: (snapshot, _) =>
            Play.fromJson(snapshot.data()!, snapshot.id),
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

  @override
  Future<Play> retrievePlay(String playId) async {
    try {
      final snap = await _service.doc(playId).get();

      return snap.data()!;
    } on FirebaseException catch (e) {
      throw Exception("Could not retrieve lines: ${e.message}");
    }
  }

  @override
  Future<void> updatePlay(Play play) async {
    try {
      await _service.doc(play.id).update(play.toJson());
    } on FirebaseException catch (e) {
      throw Exception("Could not retrieve lines: ${e.message}");
    }
  }

  @override
  Future<void> deletePlay(String playId) async {
    try {
      await _service.doc(playId).delete();
    } on FirebaseException catch (e) {
      throw Exception("Could not retrieve lines: ${e.message}");
    }
  }
}

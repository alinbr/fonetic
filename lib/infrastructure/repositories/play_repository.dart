import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonetic/infrastructure/dtos/play_dto.dart';

final playRepository = Provider<PlayRepository>((ref) {
  return PlayRepository();
});

abstract class BasePlayRepository {
  Future<void> addPlay(PlayDto play);
  Future<List<PlayDto>> retrievePlays(String producerId);
  Future<PlayDto> retrievePlay(String producerId);
  Future<void> updatePlay(PlayDto newPlay);
  Future<void> deletePlay(String playId);
}

class PlayRepository implements BasePlayRepository {
  final _service = FirebaseFirestore.instance.collection('plays').withConverter(
        fromFirestore: (snapshot, _) =>
            PlayDto.fromJson(snapshot.data()!, snapshot.id),
        toFirestore: (play, _) => play.toJson(),
      );

  @override
  Future<void> addPlay(PlayDto play) async {
    try {
      _service.add(play);
    } on FirebaseException catch (e) {
      throw Exception("Could not retrieve lines: ${e.message}");
    }
  }

  @override
  Future<List<PlayDto>> retrievePlays(String producerId) async {
    try {
      final snap =
          await _service.where("producerId", isEqualTo: producerId).get();

      return snap.docs.map((e) => e.data()).toList();
    } on FirebaseException catch (e) {
      throw Exception("Could not retrieve lines: ${e.message}");
    }
  }

  @override
  Future<PlayDto> retrievePlay(String playId) async {
    try {
      final snap = await _service.doc(playId).get();

      return snap.data()!;
    } on FirebaseException catch (e) {
      throw Exception("Could not retrieve lines: ${e.message}");
    }
  }

  @override
  Future<void> updatePlay(PlayDto play) async {
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

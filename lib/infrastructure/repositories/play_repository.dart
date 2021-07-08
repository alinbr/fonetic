import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonetic/infrastructure/dtos/play.dart';
import 'package:fonetic/infrastructure/dtos/recorded_line.dart';

final playRepository = Provider<PlayRepository>((ref) {
  return PlayRepository();
});

abstract class BasePlayRepository {
  Future<void> addPlay(Play play);
  Future<List<Play>> retrievePlays(String producerId);
  Future<Play> retrievePlay(String producerId);
  Future<void> updatePlay(Play newPlay);
  Future<void> deletePlay(String playId);
  Future<void> addRecordedLine(String playId, RecordedLine line);
  Future<List<RecordedLine>> getRecordedLine(String playId);
}

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
      print(playId);
      final snap = await _service.doc(playId).get();
      print(snap.data());
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
      final recordedLinesRef =
          await _service.doc(playId).collection('recordedLines').get();
      recordedLinesRef.docs.forEach((element) {
        print(element.id);
        _service
            .doc(playId)
            .collection('recordedLines')
            .doc(element.id)
            .delete();
        final data = RecordedLine.fromJson(element.data());
        FirebaseStorage.instance.ref().child('$playId/${data.order}').delete();
      });
    } on FirebaseException catch (e) {
      throw Exception("Could not retrieve lines: ${e.message}");
    }
  }

  @override
  Future<void> addRecordedLine(String playId, RecordedLine recordedLine) async {
    try {
      await _service
          .doc(playId)
          .collection('recordedLines')
          .add(recordedLine.toJson());
    } on FirebaseException catch (e) {
      throw Exception("Could not add recorded line: ${e.message}");
    }
  }

  @override
  Future<List<RecordedLine>> getRecordedLine(String playId) async {
    try {
      final lines =
          await _service.doc(playId).collection('recordedLines').get();
      return lines.docs.map((e) => RecordedLine.fromJson(e.data())).toList();
    } on FirebaseException catch (e) {
      throw Exception("Could not add recorded line: ${e.message}");
    }
  }
}

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonetic/infrastructure/dtos/recorded_line.dart';

import 'package:fonetic/infrastructure/repositories/play_repository.dart';
import 'package:path_provider/path_provider.dart';

final recordedLinesProvider = StateNotifierProvider.family<
    RecordedLinesController, List<RecordedLine>, String>((ref, String playId) {
  final repository = ref.watch(playRepository);
  return RecordedLinesController(repository, playId);
});

class RecordedLinesController extends StateNotifier<List<RecordedLine>> {
  BasePlayRepository _repository;
  String _playId;

  RecordedLinesController(this._repository, this._playId)
      : super(List.empty()) {
    getRecordedLines();
  }

  Future<void> addRecordedLine(RecordedLine line) async {
    Directory tempDir = await getTemporaryDirectory();
    File outputFile = File('${tempDir.path}/flutter_sound-tmp.aac');

    var snapshot = await FirebaseStorage.instance
        .ref()
        .child('${_playId}/${line.order}')
        .putFile(outputFile, SettableMetadata(contentType: "audio/aac"));

    print(await snapshot.ref.getDownloadURL());
    await _repository.addRecordedLine(_playId, line);
    getRecordedLines();
  }

  Future<void> getRecordedLines() async {
    state = await _repository.getRecordedLine(_playId);
  }
}

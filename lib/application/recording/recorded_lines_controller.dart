import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonetic/application/play_controller.dart';
import 'package:fonetic/infrastructure/dtos/recorded_line.dart';
import 'package:fonetic/infrastructure/repositories/play_repository.dart';

final recordedLinesOrdersProvider = Provider<List<int>>((ref) {
  final recordedLines = ref.watch(recordedLinesProvider);
  return recordedLines.map((e) => e.order).toList();
});

final recordedLinesProvider =
    StateNotifierProvider<RecordedLinesController, List<RecordedLine>>((ref) {
  final repository = ref.watch(playRepository);
  final playId = ref.watch(currentPlayIdProvider).state!;
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
    print("add recording line");
    await _repository.addRecordedLine(_playId, line);
    await getRecordedLines();
  }

  Future<void> getRecordedLines() async {
    print("refreshing recorded lines");
    state = await _repository.getRecordedLine(_playId);
    print("refreshed recorded lines");
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonetic/infrastructure/dtos/line.dart';

import 'package:fonetic/infrastructure/repositories/line_repository.dart';

final linesProvider = StateNotifierProvider.family<LinesController,
    AsyncValue<List<Line>>, String>((ref, String scriptId) {
  final repository = ref.watch(lineRepository);
  return LinesController(repository, scriptId);
});

class LinesController extends StateNotifier<AsyncValue<List<Line>>> {
  BaseLineRepository _repository;
  String _scriptId;

  LinesController(this._repository, this._scriptId)
      : super(AsyncValue.loading()) {
    retrieveLines(this._scriptId);
  }

  Future<void> retrieveLines(String id) async {
    state = AsyncValue.loading();

    try {
      final lines = await _repository.retrieveLines(id);
      state = AsyncValue.data(lines);
    } on Exception catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

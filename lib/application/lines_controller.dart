import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonetic/infrastructure/dtos/line_dto.dart';
import 'package:fonetic/infrastructure/repositories/line_repository.dart';

final linesProvider = StateNotifierProvider.family<LinesController,
    AsyncValue<List<LineDto>>, String>((ref, String id) {
  final repository = ref.watch(lineRepository);
  return LinesController(repository, id);
});

class LinesController extends StateNotifier<AsyncValue<List<LineDto>>> {
  BaseLineRepository _repository;
  String _templateId;

  LinesController(this._repository, this._templateId)
      : super(AsyncValue.loading()) {
    retrieveLines(this._templateId);
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

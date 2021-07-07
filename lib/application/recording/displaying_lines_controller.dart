import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonetic/application/lines_controller.dart';
import 'package:fonetic/application/play_controller.dart';
import 'package:fonetic/application/recording/recorded_lines_controller.dart';
import 'package:fonetic/infrastructure/dtos/line.dart';
import 'package:collection/collection.dart';

final displayingLinesProvider = StateNotifierProvider.family<
    DisplayingLinesController,
    AsyncValue<DisplayingLines>,
    String?>((ref, scriptId) {
  final lines = ref
      .watch(linesProvider(scriptId!))
      .maybeMap(data: (data) => data.value, orElse: () => List<Line>.empty());
  final recordedLinesOrders = ref.watch(recordedLinesOrdersProvider);
  return DisplayingLinesController(ref.read, lines, recordedLinesOrders);
});

class DisplayingLinesController
    extends StateNotifier<AsyncValue<DisplayingLines>> {
  final Reader _read;

  final List<Line> _lines;
  final List<int> _recordedLinesOrders;

  DisplayingLinesController(this._read, this._lines, this._recordedLinesOrders)
      : super(AsyncValue.loading()) {
    getDisplayingLines();
  }

  void getDisplayingLines() {
    state = AsyncValue.loading();

    final userCharacters = _read(playProvider.notifier).getUserCharacters();

    final currentLine = _lines.firstWhereOrNull((element) =>
        userCharacters.contains(element.character) &&
        !_recordedLinesOrders.contains(element.order));
    if (currentLine == null)
      state = AsyncValue.data(DisplayingLines());
    else {
      final previousLine = _lines.firstWhereOrNull(
          (element) => element.order == currentLine.order - 1);
      final nextLine = _lines.firstWhereOrNull(
          (element) => element.order == currentLine.order + 1);

      state = AsyncValue.data(DisplayingLines(
        previousLine: previousLine,
        currentLine: currentLine,
        nextLine: nextLine,
      ));
    }
  }
}

class DisplayingLines {
  final Line? previousLine;
  final Line? currentLine;
  final Line? nextLine;

  DisplayingLines({
    this.previousLine,
    this.currentLine,
    this.nextLine,
  });
}

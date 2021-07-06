import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonetic/application/lines_controller.dart';
import 'package:fonetic/application/play_controller.dart';
import 'package:fonetic/application/recording/recorded_lines_controller.dart';
import 'package:fonetic/infrastructure/dtos/line.dart';
import 'package:collection/collection.dart';

final displayingLinesProvider =
    StateProvider<AsyncValue<DisplayingLines>>((ref) {
  final scriptId = ref.watch(playProvider).data?.value.scriptId;
  print("Scriptid: $scriptId");
  final recordedLinesOrders = ref.watch(recordedLinesOrdersProvider);

  final userCharacters = ref.watch(playProvider.notifier).getUserCharacters();

  final lines = ref.watch(linesProvider(scriptId!));

  print(lines);

  return lines.when(
      data: (data) {
        final currentLine = data.firstWhereOrNull((element) =>
            userCharacters.contains(element.character) &&
            !recordedLinesOrders.contains(element.order));
        if (currentLine == null) return AsyncValue.data(DisplayingLines());

        final previousLine = data.firstWhereOrNull(
            (element) => element.order == currentLine.order - 1);
        final nextLine = data.firstWhereOrNull(
            (element) => element.order == currentLine.order + 1);

        return AsyncValue.data(DisplayingLines(
          previousLine: previousLine,
          currentLine: currentLine,
          nextLine: nextLine,
        ));
      },
      loading: () => AsyncValue.loading(),
      error: (e, st) => AsyncValue.error(e, st));
});

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

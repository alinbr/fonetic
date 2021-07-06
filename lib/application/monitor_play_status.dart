import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonetic/application/lines_controller.dart';
import 'package:fonetic/application/play_controller.dart';
import 'package:fonetic/application/recording/recorded_lines_controller.dart';
import 'package:fonetic/infrastructure/dtos/play.dart';

final monitorPlayStatusProvider = Provider<void>((ref) {
  final play = ref.watch(playProvider);

  play.whenData((playData) {
    String scriptId = playData.scriptId;
    print("monitorPlayStatusProvider :: playId=${scriptId}");

    final script = ref.watch(linesProvider(scriptId));

    script.whenData((scriptData) {
      final scriptLines = scriptData.length;
      final recordedLines = ref.watch(recordedLinesProvider).length;

      if (scriptLines == recordedLines &&
          playData.playStatus == PlayStatus.IN_PROGRESS) {
        ref
            .watch(playProvider.notifier)
            .changePlayStatus(PlayStatus.POST_PRODUCTION);
      }
    });
  });
});

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonetic/application/line_recorder_controller.dart';
import 'package:fonetic/application/lines_controller.dart';
import 'package:fonetic/application/play_controller.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fonetic/application/recorded_lines_controller.dart';
import 'package:fonetic/infrastructure/dtos/line.dart';
import 'package:fonetic/infrastructure/dtos/play.dart';
import 'package:fonetic/infrastructure/dtos/recorded_line.dart';
import 'package:fonetic/presentation/widgets/core/loading_center.dart';
import 'package:collection/collection.dart';
import 'package:fonetic/presentation/widgets/record/header.dart';
import 'package:fonetic/presentation/widgets/record/out_of_focus_line.dart';
import 'package:fonetic/presentation/widgets/record/play_button.dart';
import 'package:fonetic/presentation/widgets/record/record_button.dart';
import 'package:fonetic/presentation/widgets/record/send_button.dart';
import 'package:fonetic/presentation/widgets/record/stop_play_button.dart';
import 'package:fonetic/presentation/widgets/record/stop_recording_button%20copy.dart';

class RecordScreen extends ConsumerWidget {
  final String playId;

  const RecordScreen({Key? key, required this.playId}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final play = watch(playProvider(playId));

    return Scaffold(
      appBar: AppBar(
        title: Text('Record play'),
      ),
      body: play.when(
          data: (playData) => Column(
                children: [Header(play: playData), _LineWidget(playData)],
              ),
          loading: () => LoadingCenter(),
          error: (_, __) => Container()),
      floatingActionButton: Controls(playId),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class Controls extends ConsumerWidget {
  final String playId;

  Controls(this.playId);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    RecordingState currentRecordingState = watch(lineRecorderProvider);

    List<Widget> controlsWidget;
    switch (currentRecordingState) {
      case RecordingState.READY_TO_RECORD:
        controlsWidget = [
          RecordButton(callBack: () {
            context.read(lineRecorderProvider.notifier).startRecording();
          })
        ];
        break;
      case RecordingState.RECORDING:
        controlsWidget = [
          StopRecordingButton(callBack: () {
            context.read(lineRecorderProvider.notifier).stopRecording();
          })
        ];
        break;
      case RecordingState.RECORDED:
        controlsWidget = [
          PlayButton(callBack: () {
            context.read(lineRecorderProvider.notifier).playRecorded();
          }),
          SendButton(
            callBack: () async {
              String fileUrl = await context
                  .read(lineRecorderProvider.notifier)
                  .uploadFile(playId);
              await context
                  .read(recordedLinesProvider(playId).notifier)
                  .addRecordedLine(RecordedLine(
                      order:
                          watch(lineRecorderProvider.notifier).getLineOrder(),
                      audioLink: fileUrl));
              context.read(lineRecorderProvider.notifier).resetState();
            },
          ),
        ];
        break;
      case RecordingState.PLAYING:
        controlsWidget = [
          StopPlayButton(callBack: () {
            context.read(lineRecorderProvider.notifier).stopPlayer();
          }),
          SendButton(
            callBack: () async {
              String fileUrl = await context
                  .read(lineRecorderProvider.notifier)
                  .uploadFile(playId);
              await context
                  .read(recordedLinesProvider(playId).notifier)
                  .addRecordedLine(RecordedLine(
                      order:
                          watch(lineRecorderProvider.notifier).getLineOrder(),
                      audioLink: fileUrl));
              context.read(lineRecorderProvider.notifier).resetState();
            },
          ),
        ];
        break;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: controlsWidget,
    );
  }
}

class _LineWidget extends ConsumerWidget {
  final Play play;

  _LineWidget(this.play);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final linesListener = watch(linesProvider(play.scriptId));

    final recordedLinesListener = watch(recordedLinesProvider(play.id!));

    final recordedLinesOrders =
        recordedLinesListener.map((e) => e.order).toList();

    final userCharacters = play.characters
        .where((element) => element.userId == '1')
        .map((e) => e.character)
        .toList();

    return linesListener.when(data: (lines) {
      lines.sort((a, b) => a.order.compareTo(b.order));

      final currentLine = lines.firstWhereOrNull(
        (element) =>
            userCharacters.contains(element.character) &&
            !recordedLinesOrders.contains(element.order),
      );

      if (currentLine != null) {
        watch(lineRecorderProvider.notifier).setLineOrder(currentLine.order);

        final previousLine = lines.firstWhereOrNull(
            (element) => element.order == currentLine.order - 1);
        final nextLine = lines.firstWhereOrNull(
            (element) => element.order == currentLine.order + 1);
        return Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (previousLine != null)
                      OutOfFocusLine(line: previousLine),
                    SizedBox(
                      height: 4.h,
                    ),
                    Container(
                      child: Text(
                        '${currentLine.character}: ${currentLine.text}',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    if (nextLine != null) OutOfFocusLine(line: nextLine),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      return Container(child: Text('No next line'));
    }, loading: () {
      return Container(
        color: Theme.of(context).primaryColor,
        height: 200,
        child: LoadingCenter(),
      );
    }, error: (e, st) {
      return Container();
    });
  }
}

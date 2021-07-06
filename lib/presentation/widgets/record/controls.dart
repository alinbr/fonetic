import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonetic/application/recording/displaying_lines_controller.dart';
import 'package:fonetic/application/recording/line_recorder_controller.dart';
import 'package:fonetic/application/recording/recorded_lines_controller.dart';
import 'package:fonetic/infrastructure/dtos/recorded_line.dart';
import 'package:fonetic/presentation/widgets/record/play_button.dart';
import 'package:fonetic/presentation/widgets/record/record_type_button.dart';
import 'package:fonetic/presentation/widgets/record/send_button.dart';
import 'package:fonetic/presentation/widgets/record/stop_play_button.dart';

class Controls extends ConsumerWidget {
  final String playId;

  Controls(this.playId);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    RecordingState currentRecordingState = watch(lineRecorderProvider);

    var _recordButton = RecordTypeButton(
        icon: Icon(
          Icons.fiber_manual_record,
          color: Colors.red,
        ),
        text: "RECORD",
        callBack: () =>
            context.read(lineRecorderProvider.notifier).startRecording());

    var _stopRecordButton = RecordTypeButton(
        icon: Icon(
          Icons.stop,
          color: Colors.red,
        ),
        text: 'STOP',
        callBack: () {
          context.read(lineRecorderProvider.notifier).stopRecording();
        });

    var _playRecordingButton = PlayButton(callBack: () {
      context.read(lineRecorderProvider.notifier).playRecorded();
    });

    var _stopPlayingButton = StopPlayButton(callBack: () {
      context.read(lineRecorderProvider.notifier).stopPlayer();
    });

    var _sendRecordingButton = SendButton(
      callBack: () async {
        final lineOrder = context
            .read(displayingLinesProvider)
            .state
            .data!
            .value
            .currentLine!
            .order;

        String fileUrl = await context
            .read(lineRecorderProvider.notifier)
            .uploadFile(playId, lineOrder);

        await context.read(recordedLinesProvider.notifier).addRecordedLine(
            RecordedLine(order: lineOrder, audioLink: fileUrl));
        context.read(lineRecorderProvider.notifier).resetState();
      },
    );

    List<Widget> controlsWidget;
    switch (currentRecordingState) {
      case RecordingState.READY_TO_RECORD:
        controlsWidget = [_recordButton];
        break;
      case RecordingState.RECORDING:
        controlsWidget = [_stopRecordButton];
        break;
      case RecordingState.RECORDED:
        controlsWidget = [
          _playRecordingButton,
          _sendRecordingButton,
        ];
        break;
      case RecordingState.PLAYING:
        controlsWidget = [_stopPlayingButton, _sendRecordingButton];
        break;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: controlsWidget,
    );
  }
}

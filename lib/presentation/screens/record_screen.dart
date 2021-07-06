import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonetic/application/monitor_play_status.dart';
import 'package:fonetic/application/play_controller.dart';
import 'package:fonetic/infrastructure/dtos/play.dart';

import 'package:fonetic/presentation/widgets/core/loading_center.dart';
import 'package:fonetic/presentation/widgets/record/controls.dart';
import 'package:fonetic/presentation/widgets/core/header.dart';
import 'package:fonetic/presentation/widgets/record/recording_lines.dart';

class RecordScreen extends ConsumerWidget {
  final String playId;

  const RecordScreen({Key? key, required this.playId}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final play = watch(playProvider);

    watch(monitorPlayStatusProvider);

    return play.when(
      data: (playData) {
        if (playData.playStatus == PlayStatus.IN_PROGRESS)
          return Scaffold(
            appBar: AppBar(
              title: Text('Record play'),
            ),
            body: Column(
              children: [
                Header(play: playData),
                RecordingLines(playData),
              ],
            ),
            floatingActionButton: Controls(playId),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
        if (playData.playStatus == PlayStatus.POST_PRODUCTION)
          return Scaffold(
            appBar: AppBar(
              title: Text('Post production'),
            ),
            body: Text("Your play is ready for post production"),
          );

        return Container();
      },
      loading: () => LoadingCenter(),
      error: (_, __) => Container(),
    );
  }
}

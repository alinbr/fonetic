import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonetic/application/play_controller.dart';
import 'package:fonetic/infrastructure/dtos/play.dart';
import 'package:fonetic/presentation/screens/post_production_screen.dart';

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

    return play.when(
      data: (playData) {
        print(playData.playStatus);
        if (playData.playStatus == PlayStatus.IN_PROGRESS)
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).accentColor,
              shadowColor: Colors.transparent,
              centerTitle: true,
              title: Text(
                "Record",
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            body: Column(
              children: [
                Header(
                  play: playData,
                  includePhoto: false,
                ),
                RecordingLines(playData),
              ],
            ),
            floatingActionButton: Controls(playId),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
        if (playData.playStatus == PlayStatus.POST_PRODUCTION) {
          return PostProductionScreen();
        }
        return LoadingCenter();
      },
      loading: () => LoadingCenter(),
      error: (_, __) => Container(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonetic/application/play_controller.dart';

import 'package:fonetic/presentation/widgets/core/loading_center.dart';
import 'package:fonetic/presentation/widgets/record/controls.dart';
import 'package:fonetic/presentation/widgets/record/header.dart';
import 'package:fonetic/presentation/widgets/record/line.dart';

class RecordScreen extends ConsumerWidget {
  final String playId;

  const RecordScreen({Key? key, required this.playId}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final play = watch(playProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Record play'),
      ),
      body: play.when(
          data: (playData) => Column(
                children: [
                  Header(play: playData),
                  RecordingLines(playData),
                ],
              ),
          loading: () => LoadingCenter(),
          error: (_, __) => Container()),
      floatingActionButton: Controls(playId),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sinusoidals/flutter_sinusoidals.dart';
import 'package:fonetic/application/lines_controller.dart';
import 'package:fonetic/application/play_controller.dart';
import 'package:fonetic/application/post_production/custom_scrolling.dart';
import 'package:fonetic/application/post_production/post_production_controller.dart';
import 'package:fonetic/application/recording/recorded_lines_controller.dart';
import 'package:fonetic/infrastructure/dtos/line.dart';
import 'package:fonetic/presentation/widgets/core/header.dart';
import 'package:fonetic/presentation/widgets/core/loading_center.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostProductionScreen extends ConsumerWidget {
  final colors = [Colors.red, Colors.blue, Colors.green, Colors.green];

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    print("building post production screen");

    final productionState = watch(postProductionProvider);

    final play = watch(playProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        shadowColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          "Post production",
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: play.when(
        data: (playData) {
          return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Header(play: playData),
            productionState.status == PostProductionStatus.LOADING
                ? LoadingCenter()
                : _buildPlayControls(context, watch, playData.scriptId),
            Expanded(
              child: Container(),
            ),
          ]);
        },
        loading: () => LoadingCenter(),
        error: (_, __) => Container(),
      ),
    );
  }

  Widget _buildPlayControls(
      BuildContext context, ScopedReader watch, String scriptId) {
    final productionState = watch(postProductionProvider);

    final recordedLines = watch(recordedLinesProvider)
      ..sort((a, b) => a.order.compareTo(b.order));
    print(recordedLines.length);

    List<Line> lines = watch(linesProvider(scriptId))
        .maybeMap(data: (data) => data.value, orElse: () => []);

    return Container(
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 120.h,
                child: Listener(
                  onPointerDown: (event) {
                    context
                        .read(postProductionProvider.notifier)
                        .draggingStart();
                  },
                  onPointerUp: (event) async {
                    await context
                        .read(postProductionProvider.notifier)
                        .draggingStop();
                  },
                  child: ListView.builder(
                    controller: watch(postProductionProvider.notifier)
                        .getSCrollControler(),
                    physics: CustomScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Center(
                              child: Container(
                                margin: index == 0
                                    ? EdgeInsets.only(
                                        left: ScreenUtil().screenWidth / 2 + 3)
                                    : index == recordedLines.length - 1
                                        ? EdgeInsets.only(
                                            right: ScreenUtil().screenWidth)
                                        : EdgeInsets.only(left: 3),
                                height: 80.h,
                                width:
                                    recordedLines[index].durationInMiliseconds /
                                            10 -
                                        6,
                                child: CombinedWave(
                                  models: const [
                                    SinusoidalModel(
                                      amplitude: 25,
                                      waves: 2,
                                      translate: 2.5,
                                      frequency: 1,
                                    ),
                                    SinusoidalModel(
                                      amplitude: 5,
                                      waves: 3,
                                      translate: 3.5,
                                      frequency: 1.5,
                                    ),
                                  ],
                                  child: Container(
                                    color: Colors.black.withOpacity(0.7),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: colors[recordedLines[index].order %
                                            (colors.length - 1)]
                                        .withOpacity(
                                            productionState.currentIndex ==
                                                    index
                                                ? 0.8
                                                : 0.3),
                                    width: 6),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              margin: index == 0
                                  ? EdgeInsets.only(
                                      left: ScreenUtil().screenWidth / 2)
                                  : EdgeInsets.zero,
                              height: 80.h,
                              width:
                                  recordedLines[index].durationInMiliseconds /
                                      10,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      lines
                                          .firstWhere((element) =>
                                              element.order ==
                                              recordedLines[index].order)
                                          .character,
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                    Expanded(child: Container()),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          watch(postProductionProvider)
                                              .getDurationFormatted(Duration(
                                                  milliseconds: recordedLines[
                                                          index]
                                                      .durationInMiliseconds)),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    itemCount: productionState.player.sequence!.length,
                  ),
                ),
              ),
              SizedBox(
                height: 16.h,
              ),
              IconButton(
                onPressed: () {
                  productionState.status == PostProductionStatus.PLAYING
                      ? context.read(postProductionProvider.notifier).pause()
                      : context.read(postProductionProvider.notifier).play();
                },
                icon: productionState.status == PostProductionStatus.PLAYING
                    ? Icon(
                        Icons.pause,
                        size: 36,
                      )
                    : Icon(
                        Icons.play_arrow,
                        size: 36,
                      ),
              ),
            ],
          ),
          Center(
            child: Container(
              height: 120.h,
              width: 2,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

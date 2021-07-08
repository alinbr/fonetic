import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonetic/application/play_controller.dart';
import 'package:fonetic/application/post_production/post_production_controller.dart';
import 'package:fonetic/presentation/widgets/core/loading_center.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostProductionScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    print("building post production screen");

    final productionState = watch(postProductionProvider);

    final play = watch(playProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Post production'),
      ),
      body: play.when(
        data: (playData) {
          return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 100.h,
                  width: 100.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: NetworkImage(playData.cover),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
              child: Row(
                children: [
                  Text("0:00"),
                  SizedBox(
                    width: 12.w,
                  ),
                  Expanded(
                    child: Container(
                      height: 2.h,
                      width: double.infinity,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 12.w,
                  ),
                  Text(productionState.getDurationFormatted()),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                productionState.status == PostProductionStatus.PLAYING
                    ? context.read(postProductionProvider.notifier).pause()
                    : context.read(postProductionProvider.notifier).play();
              },
              icon: productionState.status == PostProductionStatus.PLAYING
                  ? Icon(Icons.pause)
                  : Icon(Icons.play_arrow),
            ),
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
}

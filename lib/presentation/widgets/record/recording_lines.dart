import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonetic/application/recording/displaying_lines_controller.dart';
import 'package:fonetic/infrastructure/dtos/play.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fonetic/presentation/widgets/core/loading_center.dart';
import 'package:fonetic/presentation/widgets/record/out_of_focus_line.dart';

class RecordingLines extends ConsumerWidget {
  final Play play;

  RecordingLines(this.play);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final displayLines = watch(displayingLinesProvider).state;

    return displayLines.when(data: (data) {
      if (data.currentLine == null) return LoadingCenter();
      return Expanded(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.h),
            child: Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OutOfFocusLine(line: data.previousLine),
                  SizedBox(
                    height: 4.h,
                  ),
                  Container(
                    child: Text(
                      '${data.currentLine!.character}: ${data.currentLine!.text}',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontSize: 18.sp),
                    ),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  OutOfFocusLine(line: data.nextLine),
                ],
              ),
            ),
          ),
        ),
      );
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

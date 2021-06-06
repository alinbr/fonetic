import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fonetic/controllers/lines_controller.dart';

class LinesPreview extends ConsumerWidget {
  final String templateId;

  LinesPreview({required this.templateId});

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final linesListener = watch(linesProvider(templateId));

    return linesListener.when(data: (data) {
      data.sort((a, b) => a.order.compareTo(b.order));

      return Column(
          children: data.map((e) {
        final note = e.note != "" ? '(${e.note})' : '';
        return Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: Text(
                    '${e.character}',
                    style: Theme.of(context)
                        .textTheme
                        .headline3!
                        .copyWith(fontSize: 16.sp),
                  ),
                ),
                Text(
                  note,
                  style: Theme.of(context)
                      .textTheme
                      .headline3!
                      .copyWith(fontSize: 16.sp),
                ),
                Text(
                  ' : ',
                  style: Theme.of(context)
                      .textTheme
                      .headline3!
                      .copyWith(fontSize: 16.sp),
                ),
              ],
            ),
            Row(children: [
              Flexible(
                child: Text(
                  '${e.text}',
                  style: Theme.of(context)
                      .textTheme
                      .headline3!
                      .copyWith(fontSize: 20.sp, color: Colors.white),
                ),
              )
            ]),
            SizedBox(
              height: 24.h,
            ),
          ],
        );
      }).toList());
    }, loading: () {
      return Container(
          color: Theme.of(context).primaryColor,
          height: 200,
          child: Center(child: CircularProgressIndicator()));
    }, error: (e, st) {
      return Container();
    });
  }
}

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
                  child: Text('${e.character}',
                      style: Theme.of(context).textTheme.bodyText1),
                ),
                Text(note, style: Theme.of(context).textTheme.bodyText2),
                Text(' : ', style: Theme.of(context).textTheme.bodyText2),
              ],
            ),
            Row(children: [
              Flexible(
                child: Text('${e.text}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontWeight: FontWeight.w400)),
              )
            ]),
            SizedBox(
              height: 16.h,
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

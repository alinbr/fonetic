import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fonetic/application/lines_controller.dart';

import '../core/loading_center.dart';

class LinesPreview extends ConsumerWidget {
  final String scriptId;

  LinesPreview({required this.scriptId});

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final linesListener = watch(linesProvider(scriptId));

    return linesListener.when(data: (data) {
      data.sort((a, b) => a.order.compareTo(b.order));

      return SingleChildScrollView(
        child: Column(
            children: data.map((e) {
          return Column(
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text('${e.character}',
                        style: Theme.of(context).textTheme.bodyText1),
                  ),
                  Text(' : ', style: Theme.of(context).textTheme.bodyText1),
                ],
              ),
              Row(children: [
                Flexible(
                  child: Text('${e.text}',
                      style: Theme.of(context).textTheme.bodyText1),
                )
              ]),
              SizedBox(
                height: 24.h,
              ),
            ],
          );
        }).toList()),
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

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonetic/controllers/play_controller.dart';
import 'package:fonetic/controllers/script_template_controller.dart';
import 'package:fonetic/models/play.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fonetic/models/script_template.dart';

class MyPlayCard extends ConsumerWidget {
  final Play play;
  final bool first;

  const MyPlayCard({Key? key, required this.play, required this.first})
      : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final scriptTemplate = watch(scriptTemplateProvider.notifier)
        .getScriptTemplate(play.scriptTemplateId);

    return FutureBuilder<ScriptTemplate>(
        future: scriptTemplate,
        builder: (ctx, data) {
          if (data.connectionState == ConnectionState.done) {
            return Container(
                width: 150.h,
                margin: EdgeInsets.only(right: 16.w, left: first ? 16.w : 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: const Color(0xFF242526),
                        image: DecorationImage(
                          image: NetworkImage(data.data!.cover),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Text(
                      data.data!.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText1,
                    )
                  ],
                ));
          } else {
            return Container();
          }
        });
  }
}

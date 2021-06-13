import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonetic/application/script_template_controller.dart';
import 'package:fonetic/infrastructure/dtos/play_dto.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fonetic/infrastructure/dtos/script_template_dto.dart';
import 'package:fonetic/presentation/screens/play_screen.dart';

class MyPlayCard extends ConsumerWidget {
  final PlayDto play;
  final bool first;

  const MyPlayCard({Key? key, required this.play, required this.first})
      : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final scriptTemplate = watch(scriptTemplateProvider.notifier)
        .getScriptTemplate(play.scriptTemplateId);

    return FutureBuilder<ScriptTemplateDto>(
        future: scriptTemplate,
        builder: (ctx, data) {
          if (data.connectionState == ConnectionState.done) {
            return GestureDetector(
              onTap: () => {
                Navigator.of(context).push(MaterialPageRoute<void>(
                  builder: (BuildContext context) {
                    return PlayScreen(play.id!);
                  },
                ))
              },
              child: Container(
                  width: 150.h,
                  margin: EdgeInsets.only(right: 16.w, left: first ? 16.w : 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 150.h,
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
                        height: 12.h,
                      ),
                      Text(
                        data.data!.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText1,
                      )
                    ],
                  )),
            );
          } else {
            return Container();
          }
        });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonetic/controllers/play_controller.dart';
import 'package:fonetic/controllers/script_template_controller.dart';
import 'package:fonetic/models/script_template.dart';
import 'package:fonetic/widgets/loading_center.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecordScreen extends ConsumerWidget {
  final String playId;

  const RecordScreen({Key? key, required this.playId}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final play = watch(playProvider(playId));

    return Scaffold(
        appBar: AppBar(
          title: Text('Record play'),
        ),
        body: play.when(
            data: (playData) {
              return FutureBuilder<ScriptTemplate>(
                future: context
                    .read(scriptTemplateProvider.notifier)
                    .getScriptTemplate(playData.scriptTemplateId),
                builder: (context, scriptTemplate) {
                  if (scriptTemplate.connectionState == ConnectionState.done) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Image(
                                image: NetworkImage(scriptTemplate.data!.cover),
                                width: 125.h,
                                height: 125.h,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(
                                width: 4.w,
                              ),
                              Expanded(
                                child: Text(
                                  scriptTemplate.data!.name,
                                  style: Theme.of(context).textTheme.headline5,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              )
                            ],
                          ),
                        ),
                        _LineWidget(scriptTemplate.data!.id!)
                      ],
                    );
                  } else
                    return Container();
                },
              );
            },
            loading: () => LoadingCenter(),
            error: (_, __) => Container()));
  }
}

class _LineWidget extends ConsumerWidget {
  final String scriptId;

  _LineWidget(this.scriptId);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Container(
      child: Text('lines'),
    );
  }
}

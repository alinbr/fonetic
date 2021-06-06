import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fonetic/controllers/lines_controller.dart';
import 'package:fonetic/models/script_template.dart';

class ScreenTemplateDetails extends StatelessWidget {
  final ScriptTemplate template;

  const ScreenTemplateDetails({Key? key, required this.template})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: ClampingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 250.h,
            stretch: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                template.name,
                style: Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(fontSize: 20.sp),
              ),
              collapseMode: CollapseMode.parallax,
              background: Opacity(
                  opacity: 0.4,
                  child: Image(
                      image: NetworkImage(template.cover), fit: BoxFit.cover)),
              centerTitle: true,
            ),
          ),
          _DetailsList(template: template)
        ],
      ),
      floatingActionButton: ElevatedButton(
        child: Text('PRODUCE'),
        onPressed: () {},
      ),
    );
  }
}

class _DetailsList extends StatelessWidget {
  final ScriptTemplate template;

  const _DetailsList({Key? key, required this.template}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Container(
            height: 16.h,
            color: Theme.of(context).primaryColor,
          ),
          Container(
            padding: EdgeInsets.all(8.h),
            color: Theme.of(context).primaryColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Description',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                SizedBox(
                  height: 8.h,
                ),
                Text(
                  template.description,
                  style: Theme.of(context).textTheme.bodyText2,
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.h),
            color: Theme.of(context).primaryColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Characters',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                SizedBox(
                  height: 8.h,
                ),
                Text(
                  template.characters
                      .reduce((value, element) => value + ", " + element),
                  style: Theme.of(context).textTheme.bodyText2,
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.h),
            color: Theme.of(context).primaryColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Duration',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                SizedBox(
                  height: 8.h,
                ),
                Text(
                  '${template.duration} min',
                  style: Theme.of(context).textTheme.bodyText2,
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.h),
            color: Theme.of(context).primaryColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lines',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                SizedBox(
                  height: 8.h,
                ),
                _Lines(templateId: template.id ?? ''),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Lines extends ConsumerWidget {
  final String templateId;

  _Lines({required this.templateId});

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

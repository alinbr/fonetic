import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fonetic/controllers/play_controller.dart';
import 'package:fonetic/models/script_template.dart';
import 'package:fonetic/screens/my_plays_screen.dart';
import 'package:fonetic/widgets/lines_preview.dart';
import 'package:fonetic/widgets/screen_template_group_display.dart';

class ScreenTemplateDetails extends ConsumerWidget {
  final ScriptTemplate template;

  const ScreenTemplateDetails({Key? key, required this.template})
      : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Scaffold(
      body: CustomScrollView(
        physics: ClampingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 250.h,
            stretch: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: SafeArea(
                child: Text(
                  template.name,
                  style: Theme.of(context).textTheme.headline6,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 4,
                ),
              ),
              collapseMode: CollapseMode.parallax,
              background: Opacity(
                opacity: 0.4,
                child: Image(
                    image: NetworkImage(template.cover), fit: BoxFit.cover),
              ),
            ),
          ),
          _DetailsList(template: template)
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.teal),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          )),
        ),
        child: Text(
          'PRODUCE',
          style: Theme.of(context).textTheme.button,
        ),
        onPressed: () {
          watch(playProvider('1').notifier).addPlay(template.id ?? '');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute<void>(
              builder: (BuildContext context) {
                return MyPlaysScreen();
              },
            ),
          );
        },
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
            color: Theme.of(context).backgroundColor,
          ),
          ScreenTemplateGroupDisplay(
            title: 'Description',
            content: template.description,
          ),
          ScreenTemplateGroupDisplay(
            title: 'Characters',
            content: template.characters
                .reduce((value, element) => value + ", " + element),
          ),
          ScreenTemplateGroupDisplay(
            title: 'Duration',
            content: '${template.duration} min',
          ),
          Container(
            padding: EdgeInsets.all(8.h),
            color: Theme.of(context).backgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lines',
                  style: Theme.of(context).textTheme.headline5,
                ),
                SizedBox(
                  height: 8.h,
                ),
                LinesPreview(templateId: template.id ?? ''),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

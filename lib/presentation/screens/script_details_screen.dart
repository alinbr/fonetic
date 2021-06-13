import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fonetic/application/my_plays_controller.dart';
import 'package:fonetic/infrastructure/dtos/script.dart';
import 'package:fonetic/presentation/screens/my_plays_screen.dart';
import 'package:fonetic/presentation/widgets/lines_preview.dart';
import 'package:fonetic/presentation/widgets/script_group_display.dart';

class ScriptDetailsScreen extends ConsumerWidget {
  final Script script;

  const ScriptDetailsScreen({Key? key, required this.script}) : super(key: key);

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
                  script.name,
                  style: Theme.of(context).textTheme.headline6,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 4,
                ),
              ),
              collapseMode: CollapseMode.parallax,
              background: Opacity(
                opacity: 0.4,
                child:
                    Image(image: NetworkImage(script.cover), fit: BoxFit.cover),
              ),
            ),
          ),
          _DetailsList(script: script)
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
          watch(myPlaysProvider('1').notifier).addPlay(script);
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
  final Script script;

  const _DetailsList({Key? key, required this.script}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Container(
            height: 16.h,
            color: Theme.of(context).backgroundColor,
          ),
          ScriptGroupDisplay(
            title: 'Description',
            content: script.description,
          ),
          ScriptGroupDisplay(
            title: 'Characters',
            content: script.characters
                .reduce((value, element) => value + ", " + element),
          ),
          ScriptGroupDisplay(
            title: 'Duration',
            content: '${script.duration} min',
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
                LinesPreview(scriptId: script.id ?? ''),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonetic/application/play_controller.dart';
import 'package:fonetic/infrastructure/dtos/play.dart';
import 'package:fonetic/presentation/screens/record_screen.dart';
import 'package:fonetic/presentation/widgets/delete_play_dialog.dart';
import 'package:fonetic/presentation/widgets/core/loading_center.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlayScreen extends ConsumerWidget {
  PlayScreen();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final play = watch(playProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context, builder: (context) => DeletePlayDialog());
              },
              icon: Icon(Icons.delete))
        ],
      ),
      body: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: play.when(
              data: (play) {
                return Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TransparentAppBarHeader(),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 8.h),
                        child: Text(
                          '${play.name}',
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(color: Colors.white),
                          maxLines: 2,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        width: double.infinity,
                        child: Text(
                            'Status: ${playStatusToDisplayText(play.playStatus)}'),
                      ),
                      Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Characters:',
                                style: Theme.of(context).textTheme.headline5,
                              ),
                              ListView.builder(
                                padding: EdgeInsets.all(0),
                                shrinkWrap: true,
                                itemBuilder: (ctx, index) {
                                  return Container(
                                    height: 42.h,
                                    width: double.infinity,
                                    child: Row(
                                      children: [
                                        Text(
                                          play.characters[index].character,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                        SizedBox(
                                          width: 8.w,
                                        ),
                                        play.characters[index].userId != null
                                            ? Text(
                                                '${play.characters[index].userId}')
                                            : OutlinedButton(
                                                onPressed: () async {
                                                  context
                                                      .read(
                                                          playProvider.notifier)
                                                      .assignCharacter(
                                                          play.characters[index]
                                                              .character,
                                                          '1');
                                                },
                                                child: Text('ASSIGN TO ME'))
                                      ],
                                    ),
                                  );
                                },
                                itemCount: play.characters.length,
                              ),
                            ],
                          )),
                      Center(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.teal),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0),
                            )),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 16.h, horizontal: 18.h),
                            child: Text(
                              'Record Lines',
                              style: Theme.of(context).textTheme.button,
                            ),
                          ),
                          onPressed: context
                                  .read(playProvider.notifier)
                                  .isRecordable(play)
                              ? () {
                                  Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute<void>(
                                    builder: (BuildContext context) {
                                      return RecordScreen(playId: play.id!);
                                    },
                                  ));
                                }
                              : null,
                        ),
                      ),
                    ],
                  ),
                );
              },
              loading: () => LoadingCenter(),
              error: (e, st) => Container())),
    );
  }

  String playStatusToDisplayText(PlayStatus playStatus) {
    switch (playStatus) {
      case PlayStatus.IN_PROGRESS:
        return 'In progress';
      case PlayStatus.POST_PRODUCTION:
        return 'Ready for post production';
      case PlayStatus.FINISHED:
        return 'Finished';
    }
  }
}

class TransparentAppBarHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Scaffold.of(context).appBarMaxHeight,
      width: double.infinity,
    );
  }
}

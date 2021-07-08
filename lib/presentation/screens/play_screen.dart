import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonetic/application/play_controller.dart';
import 'package:fonetic/infrastructure/utils.dart';
import 'package:fonetic/presentation/screens/record_screen.dart';
import 'package:fonetic/presentation/widgets/core/header.dart';
import 'package:fonetic/presentation/widgets/delete_play_dialog.dart';
import 'package:fonetic/presentation/widgets/core/loading_center.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fonetic/presentation/widgets/play_details/assign_dialog.dart';

class PlayScreen extends ConsumerWidget {
  PlayScreen();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final play = watch(playProvider);

    print("rebuild play screen");

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: Text("Play details"),
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
                        padding: EdgeInsets.all(16.h),
                        child: Header(play: play),
                      ),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.h),
                          child: Chip(
                              backgroundColor:
                                  fromStatusToColor(play.playStatus),
                              label: Text(
                                fromStatusToText(play.playStatus),
                                style: Theme.of(context).textTheme.subtitle2,
                              ))),
                      Container(
                          margin: EdgeInsets.all(16.h),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Theme.of(context).backgroundColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  spreadRadius: 4,
                                  blurRadius: 6,
                                  offset: Offset(
                                      1, 6), // changes position of shadow
                                ),
                              ]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.h, vertical: 16.h),
                                child: Text(
                                  "Recording",
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Characters',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1),
                                    Text(
                                      "Tap on a character to assing",
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 4.h,
                              ),
                              Container(
                                  height: (ScreenUtil().screenWidth / 3) *
                                          (play.characters.length / 3) +
                                      36.h,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.h),
                                  child: GridView.count(
                                    physics: ClampingScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    mainAxisSpacing: 8.h,
                                    crossAxisSpacing: 8.h,
                                    shrinkWrap: true,
                                    crossAxisCount: 3,
                                    children: List.generate(
                                        play.characters.length,
                                        (index) => GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AssignDialog(
                                                        character: play
                                                            .characters[index]);
                                                  },
                                                );
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    color: play
                                                                .characters[
                                                                    index]
                                                                .userId !=
                                                            null
                                                        ? Colors.green
                                                            .withOpacity(0.8)
                                                        : Colors.black
                                                            .withOpacity(0.4)),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      play.characters[index]
                                                          .character,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .subtitle2,
                                                      maxLines: 2,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )),
                                  )),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.h, vertical: 8.h),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: context
                                            .read(playProvider.notifier)
                                            .isRecordable(play)
                                        ? MaterialStateProperty.all<Color>(
                                            Colors.tealAccent[700]!)
                                        : MaterialStateProperty.all<Color>(
                                            Colors.grey),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 16.h, horizontal: 4.h),
                                    child: Text(
                                      'Record Lines',
                                      style: Theme.of(context)
                                          .textTheme
                                          .button!
                                          .copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  onPressed: context
                                          .read(playProvider.notifier)
                                          .isRecordable(play)
                                      ? () {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute<void>(
                                            builder: (BuildContext context) {
                                              return RecordScreen(
                                                  playId: play.id!);
                                            },
                                          ));
                                        }
                                      : null,
                                ),
                              ),
                              SizedBox(
                                height: 16.h,
                              )
                            ],
                          )),
                      Container(
                        margin: EdgeInsets.all(16.h),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Theme.of(context).backgroundColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                spreadRadius: 4,
                                blurRadius: 6,
                                offset:
                                    Offset(1, 6), // changes position of shadow
                              ),
                            ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.h, vertical: 16.h),
                              child: Text(
                                "Post Production",
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute<void>(
                                    builder: (BuildContext context) {
                                      return RecordScreen(playId: play.id!);
                                    },
                                  ));
                                },
                                child: Text("go to post production"))
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              loading: () => Container(height: 400.h, child: LoadingCenter()),
              error: (e, st) => Container())),
    );
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

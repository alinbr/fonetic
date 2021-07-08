import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonetic/application/my_plays_controller.dart';
import 'package:fonetic/application/play_controller.dart';
import 'package:fonetic/infrastructure/utils.dart';
import 'package:fonetic/presentation/screens/play_screen.dart';
import 'package:fonetic/presentation/widgets/core/loading_center.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyPlaysScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final myPlays = watch(myPlaysProvider('1'));

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            'My plays',
          ),
        ),
        body: myPlays.when(
            data: (data) {
              return ListView.builder(
                itemBuilder: (ctx, i) {
                  return GestureDetector(
                    onTap: () {
                      context.read(currentPlayIdProvider).state = data[i].id;
                      Navigator.of(context)
                          .pushReplacement(MaterialPageRoute<void>(
                        builder: (BuildContext context) {
                          return PlayScreen();
                        },
                      ));
                    },
                    child: Container(
                      height: 96,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 4,
                            blurRadius: 6,
                            offset: Offset(1, 6), // changes position of shadow
                          ),
                        ],
                        color: Theme.of(context).backgroundColor,
                      ),
                      margin:
                          EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.h),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 16.w,
                          ),
                          Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: NetworkImage(data[i].cover),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              width: 72,
                              height: 72,
                              child: Container()),
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 8.h, left: 16.h, right: 16.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      data[i].name,
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Chip(
                                      backgroundColor:
                                          fromStatusToColor(data[i].playStatus),
                                      label: Text(
                                        fromStatusToText(data[i].playStatus),
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2,
                                      ))
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
                itemCount: data.length,
              );
            },
            loading: () => LoadingCenter(),
            error: (error, _) => Container()));
  }
}

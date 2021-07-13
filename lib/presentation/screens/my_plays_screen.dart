import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonetic/application/my_plays_controller.dart';
import 'package:fonetic/application/play_controller.dart';
import 'package:fonetic/infrastructure/utils.dart';
import 'package:fonetic/presentation/screens/play_screen.dart';
import 'package:fonetic/presentation/widgets/core/default_card_decoration.dart';
import 'package:fonetic/presentation/widgets/core/loading_center.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyPlaysScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final myPlays = watch(myPlaysProvider('1'));

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).accentColor,
          centerTitle: true,
          title: Text(
            'Your plays',
            style: Theme.of(context).textTheme.headline6,
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
                      decoration: defaultCardDecoration(context),
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    child: Text(
                                      data[i].name,
                                      style:
                                          Theme.of(context).textTheme.subtitle2,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Chip(
                                      backgroundColor:
                                          fromStatusToColor(data[i].playStatus),
                                      label: Text(
                                        fromStatusToText(data[i].playStatus),
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

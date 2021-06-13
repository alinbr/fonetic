import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fonetic/application/my_plays_controller.dart';
import 'package:fonetic/application/script_controller.dart';
import 'package:fonetic/presentation/widgets/home/discover_plays.dart';
import 'package:fonetic/presentation/widgets/home/header.dart';
import 'package:fonetic/presentation/widgets/home/my_plays.dart';
import 'package:fonetic/presentation/widgets/core/loading_center.dart';

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final scripts = watch(scriptProvider);
    final myPlays = watch(myPlaysProvider("1"));

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Theme.of(context).accentColor, Colors.transparent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomCenter,
                  stops: [0, 0.35]),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Header(),
                  scripts.when(
                      data: (data) => DiscoverPlays(scripts: data),
                      loading: () => LoadingCenter(),
                      error: (_, __) => Container()),
                  SizedBox(
                    height: 16.h,
                  ),
                  myPlays.when(
                    data: (data) => MyPlays(plays: data),
                    loading: () => LoadingCenter(),
                    error: (_, __) => Container(),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

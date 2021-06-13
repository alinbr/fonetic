import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fonetic/application/my_plays_controller.dart';
import 'package:fonetic/application/script_controller.dart';
import 'package:fonetic/presentation/widgets/discover_play_card.dart';
import 'package:fonetic/presentation/widgets/loading_center.dart';
import 'package:fonetic/presentation/widgets/my_play_card.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Colors.teal.withOpacity(0.45),
                    Colors.teal.withOpacity(0)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomCenter,
                  stops: [0, 0.35]),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _Header(),
                  _DiscoverPlays(),
                  SizedBox(
                    height: 16.h,
                  ),
                  _MyPlays(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'fonetic',
            style: Theme.of(context)
                .textTheme
                .headline2!
                .copyWith(color: Colors.white),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.settings),
          )
        ],
      ),
    );
  }
}

class _DiscoverPlays extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final scripts = watch(scriptProvider);

    return Column(children: [
      Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        width: double.infinity,
        child: Text(
          'Discover plays',
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
      Container(
          height: 300.h,
          width: double.infinity,
          child: scripts.when(
              data: (data) {
                return ListView.builder(
                    itemCount: data.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (ctx, index) {
                      return DiscoverPlayCard(
                          script: data[index], first: index == 0);
                    });
              },
              loading: () => LoadingCenter(),
              error: (e, st) {
                return Container();
              }))
    ]);
  }
}

class _MyPlays extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final myPlays = watch(myPlaysProvider("1"));

    return Column(children: [
      Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        width: double.infinity,
        child: Text(
          'My plays',
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
      Container(
          height: 200.h,
          width: double.infinity,
          child: myPlays.when(
              data: (data) {
                return ListView.builder(
                    itemCount: data.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (ctx, index) {
                      return MyPlayCard(
                        play: data[index],
                        first: index == 0,
                      );
                    });
              },
              loading: () => LoadingCenter(),
              error: (e, st) {
                return Container();
              }))
    ]);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fonetic/controllers/play_controller.dart';
import 'package:fonetic/controllers/script_template_controller.dart';
import 'package:fonetic/widgets/discover_play_card.dart';
import 'package:fonetic/widgets/my_play_card.dart';

import 'my_plays_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _Header(),
                _DiscoverPlays(),
                SizedBox(
                  height: 24.h,
                ),
                _MyPlays(),
              ],
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
                .copyWith(color: Colors.teal),
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
    final scriptTemplates = watch(scriptTemplateProvider);

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
          height: 350.h,
          width: double.infinity,
          child: scriptTemplates.when(data: (data) {
            return ListView.builder(
                itemCount: data.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (ctx, index) {
                  return DiscoverPlayCard(
                      template: data[index], first: index == 0);
                });
          }, loading: () {
            return Center(
              child: CircularProgressIndicator(),
            );
          }, error: (e, st) {
            return Container();
          }))
    ]);
  }
}

class _MyPlays extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final myPlays = watch(playProvider("1"));

    return Column(children: [
      Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'My plays',
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.headline2,
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) {
                      return MyPlaysScreen();
                    },
                  ),
                );
              },
              child:
                  Text('SEE MORE', style: Theme.of(context).textTheme.button!),
            )
          ],
        ),
      ),
      Container(
          height: 200.h,
          width: double.infinity,
          child: myPlays.when(data: (data) {
            return ListView.builder(
                itemCount: data.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (ctx, index) {
                  return MyPlayCard(
                    play: data[index],
                    first: index == 0,
                  );
                });
          }, loading: () {
            return Center(
              child: CircularProgressIndicator(),
            );
          }, error: (e, st) {
            return Container();
          }))
    ]);
  }
}

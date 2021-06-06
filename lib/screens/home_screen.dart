import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fonetic/controllers/script_template_controller.dart';
import 'package:fonetic/widgets/discover_play_card.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [_Header(), _DiscoverPlays()],
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
      padding: EdgeInsets.symmetric(horizontal: 8.w),
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
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
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

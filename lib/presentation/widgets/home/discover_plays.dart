import 'package:flutter/material.dart';
import 'package:fonetic/infrastructure/dtos/script.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fonetic/presentation/widgets/home/discover_play_card.dart';

class DiscoverPlays extends StatelessWidget {
  final List<Script> scripts;

  const DiscoverPlays({Key? key, required this.scripts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 8,
      ),
      Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        width: double.infinity,
        child: Text('Discover scripts',
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.headline5),
      ),
      Container(
          height: 420.h,
          width: double.infinity,
          child: ListView.builder(
              itemCount: scripts.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (ctx, index) {
                return DiscoverPlayCard(
                    script: scripts[index], first: index == 0);
              }))
    ]);
  }
}

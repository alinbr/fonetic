import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fonetic/infrastructure/dtos/play.dart';
import 'package:fonetic/presentation/widgets/home/my_play_card.dart';

class MyPlays extends StatelessWidget {
  final List<Play> plays;

  const MyPlays({Key? key, required this.plays}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        padding: EdgeInsets.only(bottom: 16.h, left: 16.h, right: 16.h),
        width: double.infinity,
        child: Text(
          'My plays',
          textAlign: TextAlign.start,
          style: Theme.of(context)
              .textTheme
              .headline5!
              .copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      Container(
        height: 250.h,
        width: double.infinity,
        child: ListView.builder(
            itemCount: plays.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (ctx, index) {
              return MyPlayCard(
                play: plays[index],
                first: index == 0,
              );
            }),
      )
    ]);
  }
}

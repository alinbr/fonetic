import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fonetic/infrastructure/dtos/play.dart';
import 'package:fonetic/presentation/screens/my_plays_screen.dart';
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
      plays.length > 0
          ? Container(
              height: 250.h,
              width: double.infinity,
              child: ListView.builder(
                  itemCount: plays.length + 1,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (ctx, index) {
                    if (index == plays.length) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute<void>(
                            builder: (BuildContext context) {
                              return MyPlaysScreen();
                            },
                          ));
                        },
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Theme.of(context).backgroundColor,
                              ),
                              height: 168.h,
                              width: 168.h,
                              child: Center(
                                child: Text(
                                  "View all",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return MyPlayCard(
                      play: plays[index],
                      first: index == 0,
                    );
                  }))
          : Container(
              height: 100.h,
              child: Opacity(
                opacity: 0.25,
                child: Center(
                    child: Text(
                  "No plays yet 😢",
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(fontWeight: FontWeight.bold),
                )),
              ),
            )
    ]);
  }
}

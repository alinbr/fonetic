import 'package:flutter/material.dart';
import 'package:fonetic/application/play_controller.dart';
import 'package:fonetic/infrastructure/dtos/play.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fonetic/presentation/screens/play_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyPlayCard extends StatelessWidget {
  final Play play;
  final bool first;

  const MyPlayCard({Key? key, required this.play, required this.first})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read(currentPlayIdProvider).state = play.id;
        Navigator.of(context).push(MaterialPageRoute<void>(
          builder: (BuildContext context) {
            return PlayScreen();
          },
        ));
      },
      child: Container(
          width: 168.h,
          margin: EdgeInsets.only(right: 16.w, left: first ? 16.w : 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 168.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(play.cover),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 4,
                      blurRadius: 6,
                      offset: Offset(1, 6), // changes position of shadow
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16.h,
              ),
              Text(
                play.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyText1,
              )
            ],
          )),
    );
  }
}

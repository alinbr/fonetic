import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fonetic/infrastructure/dtos/play.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fonetic/presentation/screens/play_screen.dart';

class MyPlayCard extends StatelessWidget {
  final Play play;
  final bool first;

  const MyPlayCard({Key? key, required this.play, required this.first})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.of(context).push(MaterialPageRoute<void>(
          builder: (BuildContext context) {
            return PlayScreen(play.id!);
          },
        ))
      },
      child: Container(
          width: 150.h,
          margin: EdgeInsets.only(right: 16.w, left: first ? 16.w : 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 150.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: NetworkImage(play.cover),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                height: 12.h,
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

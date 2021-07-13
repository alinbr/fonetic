import 'package:flutter/material.dart';
import 'package:fonetic/infrastructure/dtos/play.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Header extends StatelessWidget {
  final Play play;

  const Header({Key? key, required this.play}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              Theme.of(context).accentColor,
              Theme.of(context).scaffoldBackgroundColor
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0, 1]),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 16.h),
            child: Container(
              height: 98.h,
              width: 98.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: NetworkImage(play.cover),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              play.name,
              style: Theme.of(context).textTheme.headline5,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}

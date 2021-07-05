import 'package:flutter/material.dart';
import 'package:fonetic/infrastructure/dtos/play.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Header extends StatelessWidget {
  final Play play;

  const Header({Key? key, required this.play}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 100.h,
                width: 100.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: NetworkImage(play.cover),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),
        Flexible(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                play.name,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontSize: 18.sp),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

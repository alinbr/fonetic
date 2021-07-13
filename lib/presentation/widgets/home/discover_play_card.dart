import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fonetic/infrastructure/dtos/script.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fonetic/presentation/screens/script_details_screen.dart';
import 'package:fonetic/presentation/widgets/core/default_card_decoration.dart';

class DiscoverPlayCard extends StatelessWidget {
  final Script script;
  final bool first;

  const DiscoverPlayCard({Key? key, required this.script, required this.first})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 8.h,
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  return ScriptDetailsScreen(script: script);
                },
              ),
            );
          },
          child: Container(
            decoration: defaultCardDecoration(context),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
            width: 320.w,
            height: 364.h,
            margin: EdgeInsets.only(right: 24.w, left: first ? 16.w : 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Hero(
                  tag: '${script.id}',
                  child: Container(
                    height: 164.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                            image: NetworkImage(script.cover),
                            fit: BoxFit.cover)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(script.name,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText1),
                ),
                Text(script.description,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
                    style: Theme.of(context).textTheme.bodyText2),
                Expanded(child: Container()),
                Row(
                  children: [
                    _PlayData(
                        icon: Icons.schedule, text: '${script.duration} min'),
                    SizedBox(
                      width: 16.w,
                    ),
                    _PlayData(icon: Icons.people, text: '${script.roles}'),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PlayData extends StatelessWidget {
  final IconData icon;
  final String text;

  const _PlayData({Key? key, required this.icon, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: Color(0xFFA0A0A0),
          size: 16.sp,
        ),
        SizedBox(
          width: 4.w,
        ),
        Text(text, style: Theme.of(context).textTheme.bodyText2)
      ],
    );
  }
}

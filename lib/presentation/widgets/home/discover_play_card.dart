import 'package:flutter/material.dart';
import 'package:fonetic/infrastructure/dtos/script.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fonetic/presentation/screens/script_details_screen.dart';

class DiscoverPlayCard extends StatelessWidget {
  final Script script;
  final bool first;

  const DiscoverPlayCard({Key? key, required this.script, required this.first})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 4,
                  blurRadius: 6,
                  offset: Offset(1, 6), // changes position of shadow
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
            width: 256.w,
            height: 336.h,
            margin: EdgeInsets.only(right: 24.w, left: first ? 16.w : 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: '${script.id}',
                  child: Container(
                    width: 224.w,
                    height: 150.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        image: DecorationImage(
                            image: NetworkImage(script.cover),
                            fit: BoxFit.cover)),
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                Text(script.name,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyText1),
                SizedBox(
                  height: 8.h,
                ),
                Text(script.description,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: Theme.of(context).textTheme.bodyText2),
                SizedBox(
                  height: 16.h,
                ),
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
          color: Color(0xFFc7c1c5),
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

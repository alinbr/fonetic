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
    return GestureDetector(
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
        width: 200.h,
        margin: EdgeInsets.only(right: 16.w, left: first ? 16.w : 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: '${script.id}',
              child: Container(
                width: double.infinity,
                height: 200.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                        image: NetworkImage(script.cover), fit: BoxFit.cover)),
              ),
            ),
            SizedBox(
              height: 12.h,
            ),
            Hero(
              tag: '${script.name}',
              child: Text(
                script.name,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Hero(
              tag: '${script.description.substring(0, 10)}',
              child: Text(script.description,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: Color(0xFFc7c1c5), fontWeight: FontWeight.w400)),
            ),
            SizedBox(
              height: 4.h,
            ),
            Row(
              children: [
                _PlayData(icon: Icons.schedule, text: '${script.duration} min'),
                SizedBox(
                  width: 8.w,
                ),
                _PlayData(icon: Icons.people, text: '${script.roles}'),
              ],
            )
          ],
        ),
      ),
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
        Text(text,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                color: Color(0xFFc7c1c5), fontWeight: FontWeight.w400))
      ],
    );
  }
}

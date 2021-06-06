import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:fonetic/models/script_template.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fonetic/screens/screen_template_details.dart';

class DiscoverPlayCard extends StatelessWidget {
  final ScriptTemplate template;
  final bool first;

  const DiscoverPlayCard(
      {Key? key, required this.template, required this.first})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final closedContainer = Container(
      width: 250.w,
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFF181818),
      ),
      margin: EdgeInsets.only(right: 16.w, left: first ? 16.w : 0),
      child: Container(
          child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.orangeAccent,
              borderRadius: BorderRadius.circular(50),
              image: DecorationImage(
                  image: NetworkImage(template.cover), fit: BoxFit.cover),
            ),
            width: 100.h,
            height: 100.h,
          ),
          SizedBox(
            height: 4.h,
          ),
          Container(
            height: 35.h,
            child: Center(
              child: Text(
                template.name,
                style: Theme.of(context).textTheme.subtitle1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ),
          SizedBox(
            height: 4.h,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.h),
              child: Text(
                template.description,
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                maxLines: 9,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _PlayData(
                    icon: Icons.schedule, text: '${template.duration} min'),
                SizedBox(
                  width: 16.w,
                ),
                _PlayData(icon: Icons.people, text: template.roles.toString())
              ],
            ),
          )
        ],
      )),
    );

    return OpenContainer(
        transitionType: ContainerTransitionType.fadeThrough,
        closedColor: Theme.of(context).primaryColor,
        closedBuilder: (ctx, action) {
          return closedContainer;
        },
        openBuilder: (ctx, action) {
          return ScreenTemplateDetails(template: template);
        });
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
          color: const Color(0xFFBFBFBF),
        ),
        SizedBox(
          width: 4.w,
        ),
        Text(
          text,
          style: Theme.of(context).textTheme.caption!.copyWith(
                color: const Color(0xFFBFBFBF),
              ),
        )
      ],
    );
  }
}

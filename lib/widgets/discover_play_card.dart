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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFF2a2a2a),
      ),
      margin: EdgeInsets.only(right: 16.w, left: first ? 16.w : 0),
      child: Container(
          child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.orangeAccent,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              image: DecorationImage(
                  image: NetworkImage(template.cover), fit: BoxFit.cover),
            ),
            width: double.infinity,
            height: 100.h,
          ),
          SizedBox(
            height: 8.h,
          ),
          Container(
            padding: EdgeInsets.only(left: 8.h),
            width: double.infinity,
            child: Text(
              template.name,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
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
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: Color(0xFFc7c1c5),
                    ),
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                maxLines: 10,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 8.h),
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
          color: Color(0xFFc7c1c5),
        ),
        SizedBox(
          width: 4.w,
        ),
        Text(
          text,
          style: Theme.of(context).textTheme.caption!.copyWith(
                color: const Color(0xFFc7c1c5),
              ),
        )
      ],
    );
  }
}

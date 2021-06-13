import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:fonetic/infrastructure/dtos/script_template_dto.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fonetic/presentation/screens/screen_template_details.dart';

class DiscoverPlayCard extends StatelessWidget {
  final ScriptTemplateDto template;
  final bool first;

  const DiscoverPlayCard(
      {Key? key, required this.template, required this.first})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final closedContainer = Container(
      width: 200.h,
      margin: EdgeInsets.only(right: 16.w, left: first ? 16.w : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 200.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                    image: NetworkImage(template.cover), fit: BoxFit.cover)),
          ),
          SizedBox(
            height: 12.h,
          ),
          Text(
            template.name,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          Text(template.description,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: Color(0xFFc7c1c5), fontWeight: FontWeight.w400)),
          SizedBox(
            height: 4.h,
          ),
          Row(
            children: [
              _PlayData(icon: Icons.schedule, text: '${template.duration} min'),
              SizedBox(
                width: 8.w,
              ),
              _PlayData(icon: Icons.people, text: '${template.roles}'),
            ],
          )
        ],
      ),
    );

    return OpenContainer(
        transitionType: ContainerTransitionType.fade,
        closedColor: Colors.transparent,
        closedElevation: 0,
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

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenTemplateGroupDisplay extends StatelessWidget {
  final String title;
  final String content;

  const ScreenTemplateGroupDisplay(
      {Key? key, required this.title, required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.h),
      color: Theme.of(context).primaryColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          SizedBox(
            height: 8.h,
          ),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyText2,
          )
        ],
      ),
    );
  }
}

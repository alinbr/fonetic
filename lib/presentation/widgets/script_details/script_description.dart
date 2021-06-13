import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScriptDescription extends StatelessWidget {
  final String title;
  final String content;

  const ScriptDescription(
      {Key? key, required this.title, required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.headline6),
          SizedBox(
            height: 4.h,
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

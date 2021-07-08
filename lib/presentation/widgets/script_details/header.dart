import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fonetic/infrastructure/dtos/script.dart';
import 'package:fonetic/presentation/widgets/script_details/script_description.dart';

class Header extends StatelessWidget {
  final Script script;

  const Header({Key? key, required this.script}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              Theme.of(context).accentColor,
              Theme.of(context).scaffoldBackgroundColor
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0, 0.5]),
      ),
      child: Column(
        children: [
          SizedBox(
            height: Scaffold.of(context).appBarMaxHeight! * 0.7,
            width: double.infinity,
          ),
          Container(
            width: 256.w,
            child: Hero(
              tag: '${script.id}',
              child: Container(
                height: 256.w,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: NetworkImage(script.cover),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(16.h),
            child: Text(
              script.name,
              style: Theme.of(context).textTheme.headline6,
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
            ),
          ),
          Container(
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
            margin: EdgeInsets.all(16.h),
            padding: EdgeInsets.all(16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Description',
                    style: Theme.of(context).textTheme.headline6),
                SizedBox(
                  height: 8.h,
                ),
                Text(
                  script.description,
                  style: Theme.of(context).textTheme.bodyText2,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

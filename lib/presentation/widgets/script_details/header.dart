import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fonetic/application/my_plays_controller.dart';
import 'package:fonetic/infrastructure/dtos/script.dart';
import 'package:fonetic/presentation/screens/my_plays_screen.dart';
import 'package:fonetic/presentation/widgets/script_details/produce_button.dart';
import 'package:fonetic/presentation/widgets/script_details/script_actions.dart';

class Header extends ConsumerWidget {
  final Script script;

  const Header({required this.script});

  @override
  Widget build(BuildContext context, ScopedReader watch) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: Scaffold.of(context).appBarMaxHeight! * 0.7,
            width: double.infinity,
          ),
          Center(
            child: Container(
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
          ),
          Container(
            margin: EdgeInsets.all(16.h),
            child: Text(
              script.name,
              style: Theme.of(context).textTheme.headline6,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.h),
            child: ProduceButton(
              callBack: () => _produceButtonCallBack(context, watch),
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
                ),
                ScriptActions(script: script),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _produceButtonCallBack(BuildContext context, ScopedReader watch) {
    watch(myPlaysProvider('1').notifier).addPlay(script);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return MyPlaysScreen();
        },
      ),
    );
  }
}

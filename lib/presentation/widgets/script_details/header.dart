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
            colors: [Colors.teal, Theme.of(context).backgroundColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0, 0.5]),
      ),
      child: Column(
        children: [
          SizedBox(
            height: Scaffold.of(context).appBarMaxHeight,
            width: double.infinity,
          ),
          Row(
            children: [
              Flexible(
                child: Container(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Hero(
                      tag: '${script.id}',
                      child: Container(
                        height: 180.h,
                        width: 180.h,
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
              ),
              Flexible(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      script.name,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontSize: 18.sp),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ScriptDescription(
              title: 'Description',
              content: script.description,
            ),
          ),
        ],
      ),
    );
  }
}

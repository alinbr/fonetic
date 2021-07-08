import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonetic/infrastructure/dtos/script.dart';
import 'package:fonetic/presentation/widgets/script_details/header.dart';
import 'package:fonetic/presentation/widgets/script_details/script_actions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScriptDetailsScreen extends ConsumerWidget {
  final Script script;

  const ScriptDetailsScreen({Key? key, required this.script}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Header(script: script),
                SizedBox(
                  height: 24.h,
                )
              ],
            ),
          )),
    );
  }
}

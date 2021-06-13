import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonetic/application/my_plays_controller.dart';
import 'package:fonetic/infrastructure/dtos/script.dart';
import 'package:fonetic/presentation/screens/my_plays_screen.dart';
import 'package:fonetic/presentation/widgets/script_details/header.dart';
import 'package:fonetic/presentation/widgets/script_details/produce_button.dart';
import 'package:fonetic/presentation/widgets/script_details/script_actions.dart';

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
              children: [
                Header(script: script),
                ScriptActions(script: script),
              ],
            ),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ProduceButton(
        callBack: () => _produceButtonCallBack(context, watch),
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

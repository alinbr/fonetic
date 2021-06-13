import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fonetic/application/my_plays_controller.dart';
import 'package:fonetic/infrastructure/dtos/script.dart';
import 'package:fonetic/presentation/screens/my_plays_screen.dart';
import 'package:fonetic/presentation/widgets/lines_preview.dart';
import 'package:fonetic/presentation/widgets/my_outlined_button.dart';
import 'package:fonetic/presentation/widgets/script_description.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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
                  _Header(script: script),
                  _ScriptActions(script: script),
                ],
              ),
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: ProduceButton(script));
  }
}

class _Header extends StatelessWidget {
  final Script script;

  const _Header({Key? key, required this.script}) : super(key: key);

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
            child: ScriptGroupDisplay(
              title: 'Description',
              content: script.description,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScriptActions extends StatelessWidget {
  final Script script;

  const _ScriptActions({Key? key, required this.script}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(24.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MyOutlinedButton(
                text: 'Characters',
                callBack: () => _showCharacters(context, script.characters),
              ),
              MyOutlinedButton(
                text: 'Script',
                callBack: () => _showScript(context, script.id!),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showScript(BuildContext context, String scriptId) {
    showBarModalBottomSheet(
        context: context,
        isDismissible: true,
        barrierColor: Colors.black,
        builder: (context) => Padding(
              padding: const EdgeInsets.all(24.0),
              child: LinesPreview(scriptId: scriptId),
            ));
  }

  void _showCharacters(BuildContext context, List<String> characters) {
    showBarModalBottomSheet(
        context: context,
        isDismissible: true,
        barrierColor: Colors.black,
        builder: (context) => Container(
              padding: EdgeInsets.only(left: 24, top: 24),
              color: Theme.of(context).backgroundColor,
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    characters[index],
                    textAlign: TextAlign.left,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                itemCount: characters.length,
              ),
            ));
  }
}

class ProduceButton extends ConsumerWidget {
  final Script script;

  ProduceButton(this.script);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.teal),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        )),
      ),
      child: Container(
        width: 96.w,
        height: 50.h,
        child: Center(
          child: Text(
            'Produce',
            style: Theme.of(context).textTheme.button,
          ),
        ),
      ),
      onPressed: () {
        watch(myPlaysProvider('1').notifier).addPlay(script);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (BuildContext context) {
              return MyPlaysScreen();
            },
          ),
        );
      },
    );
  }
}
